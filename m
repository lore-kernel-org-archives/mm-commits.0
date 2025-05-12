Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DF1C2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011112; cv=none; b=VTP4XmQ48mPb6tuAhVeQxK32gnHVhnmdDOwVYDxcuTVUdnj/4jcSOvLum5zSIGx75+0Xkz/WNoH5HE/G9o8osAqtGXyzxnmQVwpyQseNRGNOJ17YOigvX3BqKOKFYTA1fIBfICZHu2pxIceQ6cwU7qbv4iT1EK9StGf2S6cp0Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011112; c=relaxed/simple;
	bh=IpjR/zvpgvkoXOCPw2A5EK9r/3yYjxISJn/GV8rZz0o=;
	h=Date:To:From:Subject:Message-Id; b=ahXYdir1E/z3mS+RlxoxyuL0yquma2ypQoUXbuEmCzpT9HiyQ7dOTSwitEdMdcwDS2RtFMiQyf6JJUbj3k/Bol4WRMaD/VOfyBRzMdCCpuLouhfeyfrKNaXgvO1kXH9VGA294AnYw2kWz1wSiYPQlaCfH5fWUSYw94YS2EBE8PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xw12PapJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xw12PapJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCF8C4CEE4;
	Mon, 12 May 2025 00:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011112;
	bh=IpjR/zvpgvkoXOCPw2A5EK9r/3yYjxISJn/GV8rZz0o=;
	h=Date:To:From:Subject:From;
	b=xw12PapJ1K/fU9j5fMUJZfulINkft+/soiZXfydCvoypRTltxanGqh/bnVIUU0HLv
	 FJBKMGwYlSVhG/CiNNjMGQj3aHHiEcvnoQEq593tPyyUWn35kPl1SoALlFAvNc2Eho
	 WRPhmPbgTx6jmapDN3z/LF1NxTRf8OKdK5nmnIMI=
Date: Sun, 11 May 2025 17:51:51 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-batch-tlb-flushes-for-madv_free.patch removed from -mm tree
Message-Id: <20250512005151.DDCF8C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: batch tlb flushes for MADV_FREE
has been removed from the -mm tree.  Its filename was
     mm-madvise-batch-tlb-flushes-for-madv_free.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/madvise: batch tlb flushes for MADV_FREE
Date: Wed, 9 Apr 2025 17:00:20 -0700

MADV_FREE handling for [process_]madvise() flushes tlb for each vma of
each address range.  Update the logic to do tlb flushes in a batched way. 
Initialize an mmu_gather object from do_madvise() and vector_madvise(),
which are the entry level functions for [process_]madvise(), respectively.
And pass those objects to the function for per-vma work, via
madvise_behavior struct.  Make the per-vma logic not flushes tlb on their
own but just saves the tlb entries to the received mmu_gather object. 
Finally, the entry level functions flush the tlb entries that gathered for
the entire user request, at once.

Link: https://lkml.kernel.org/r/20250410000022.1901-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   57 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 46 insertions(+), 11 deletions(-)

--- a/mm/madvise.c~mm-madvise-batch-tlb-flushes-for-madv_free
+++ a/mm/madvise.c
@@ -799,12 +799,13 @@ static const struct mm_walk_ops madvise_
 	.walk_lock		= PGWALK_RDLOCK,
 };
 
-static int madvise_free_single_vma(struct vm_area_struct *vma,
+static int madvise_free_single_vma(struct madvise_behavior *madv_behavior,
+			struct vm_area_struct *vma,
 			unsigned long start_addr, unsigned long end_addr)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct mmu_notifier_range range;
-	struct mmu_gather tlb;
+	struct mmu_gather *tlb = madv_behavior->tlb;
 
 	/* MADV_FREE works for only anon vma at the moment */
 	if (!vma_is_anonymous(vma))
@@ -820,17 +821,14 @@ static int madvise_free_single_vma(struc
 				range.start, range.end);
 
 	lru_add_drain();
-	tlb_gather_mmu(&tlb, mm);
 	update_hiwater_rss(mm);
 
 	mmu_notifier_invalidate_range_start(&range);
-	tlb_start_vma(&tlb, vma);
+	tlb_start_vma(tlb, vma);
 	walk_page_range(vma->vm_mm, range.start, range.end,
-			&madvise_free_walk_ops, &tlb);
-	tlb_end_vma(&tlb, vma);
+			&madvise_free_walk_ops, tlb);
+	tlb_end_vma(tlb, vma);
 	mmu_notifier_invalidate_range_end(&range);
-	tlb_finish_mmu(&tlb);
-
 	return 0;
 }
 
@@ -954,7 +952,7 @@ static long madvise_dontneed_free(struct
 	if (behavior == MADV_DONTNEED || behavior == MADV_DONTNEED_LOCKED)
 		return madvise_dontneed_single_vma(vma, start, end);
 	else if (behavior == MADV_FREE)
-		return madvise_free_single_vma(vma, start, end);
+		return madvise_free_single_vma(madv_behavior, vma, start, end);
 	else
 		return -EINVAL;
 }
@@ -1627,6 +1625,29 @@ static void madvise_unlock(struct mm_str
 		mmap_read_unlock(mm);
 }
 
+static bool madvise_batch_tlb_flush(int behavior)
+{
+	switch (behavior) {
+	case MADV_FREE:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static void madvise_init_tlb(struct madvise_behavior *madv_behavior,
+		struct mm_struct *mm)
+{
+	if (madvise_batch_tlb_flush(madv_behavior->behavior))
+		tlb_gather_mmu(madv_behavior->tlb, mm);
+}
+
+static void madvise_finish_tlb(struct madvise_behavior *madv_behavior)
+{
+	if (madvise_batch_tlb_flush(madv_behavior->behavior))
+		tlb_finish_mmu(madv_behavior->tlb);
+}
+
 static bool is_valid_madvise(unsigned long start, size_t len_in, int behavior)
 {
 	size_t len;
@@ -1783,14 +1804,20 @@ static int madvise_do_behavior(struct mm
 int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in, int behavior)
 {
 	int error;
-	struct madvise_behavior madv_behavior = {.behavior = behavior};
+	struct mmu_gather tlb;
+	struct madvise_behavior madv_behavior = {
+		.behavior = behavior,
+		.tlb = &tlb,
+	};
 
 	if (madvise_should_skip(start, len_in, behavior, &error))
 		return error;
 	error = madvise_lock(mm, behavior);
 	if (error)
 		return error;
+	madvise_init_tlb(&madv_behavior, mm);
 	error = madvise_do_behavior(mm, start, len_in, &madv_behavior);
+	madvise_finish_tlb(&madv_behavior);
 	madvise_unlock(mm, behavior);
 
 	return error;
@@ -1807,13 +1834,18 @@ static ssize_t vector_madvise(struct mm_
 {
 	ssize_t ret = 0;
 	size_t total_len;
-	struct madvise_behavior madv_behavior = {.behavior = behavior};
+	struct mmu_gather tlb;
+	struct madvise_behavior madv_behavior = {
+		.behavior = behavior,
+		.tlb = &tlb,
+	};
 
 	total_len = iov_iter_count(iter);
 
 	ret = madvise_lock(mm, behavior);
 	if (ret)
 		return ret;
+	madvise_init_tlb(&madv_behavior, mm);
 
 	while (iov_iter_count(iter)) {
 		unsigned long start = (unsigned long)iter_iov_addr(iter);
@@ -1842,14 +1874,17 @@ static ssize_t vector_madvise(struct mm_
 			}
 
 			/* Drop and reacquire lock to unwind race. */
+			madvise_finish_tlb(&madv_behavior);
 			madvise_unlock(mm, behavior);
 			madvise_lock(mm, behavior);
+			madvise_init_tlb(&madv_behavior, mm);
 			continue;
 		}
 		if (ret < 0)
 			break;
 		iov_iter_advance(iter, iter_iov_len(iter));
 	}
+	madvise_finish_tlb(&madv_behavior);
 	madvise_unlock(mm, behavior);
 
 	ret = (total_len - iov_iter_count(iter)) ? : ret;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damos-quota-goal-metrics-for-memory-node-utilization.patch
mm-damon-sysfs-schemes-implement-file-for-quota-goal-nid-parameter.patch
mm-damon-sysfs-schemes-connect-damos_quota_goal-nid-with-core-layer.patch
docs-mm-damon-design-document-node_mem_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-nid-file.patch
docs-abi-damon-document-nid-file.patch
samples-damon-implement-a-damon-module-for-memory-tiering.patch

