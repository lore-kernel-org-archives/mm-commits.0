Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C057715990C
	for <mm-commits@vger.kernel.org>; Fri,  4 Apr 2025 23:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743807893; cv=none; b=dKQD4h0vdr6ZzUoxhMz7Zpk5K2LsKoJEfoDsHQ1l59J78fzBkrp8EptZXfFBkZ7iNpPgm0bGBs7ei5+0W4cO9COrNLVVhSoku64x1GM5lPmBoUfYOLCjV59TYE2oZ0KgLLg1YwZqUDWztLWa5JxDPDUQtBKNH2lh4DPSMthbCSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743807893; c=relaxed/simple;
	bh=iuENWZj/gkL1/RoML+Z23JSbDwNQEY9hG6a2eh8Emdw=;
	h=Date:To:From:Subject:Message-Id; b=k2neJnZLzkpA26ZrRIr+W+4VBxSnc4sdlpsfuVLvP8aNqNXs3t92ei9Y1rdaiZt1A6YlpJayekl4+NfVXDrzmRvlSI2ojJtKiBsZS7EB3yEjVV4E014mxLgBjYwx/RC/xARSLFFN/bj+97M92h0pfaFXXUNtIWUpKzNeaJvUxkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qZJHNete; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qZJHNete"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74FD1C4CEDD;
	Fri,  4 Apr 2025 23:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743807893;
	bh=iuENWZj/gkL1/RoML+Z23JSbDwNQEY9hG6a2eh8Emdw=;
	h=Date:To:From:Subject:From;
	b=qZJHNete7BJpJcCQivUt96/l62FV3M3guuoiRBlRX3UqXciRZ8yfwfZTXue4lREx7
	 IBibeX9R+qaZEGcFxBHiCVGk/E3o5NKUbE6v8dZDtu4j6nkANqwrPusK9hm2YYqEt9
	 srjJ0KFjTO6ta+4/wIaRME47GdRiHeMEnGCrsW9Q=
Date: Fri, 04 Apr 2025 16:04:52 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,riel@surriel.com,lorenzo.stoakes@oracle.com,howlett@gmail.com,david@redhat.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-batch-tlb-flushes-for-madv_free.patch added to mm-new branch
Message-Id: <20250404230453.74FD1C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: batch tlb flushes for MADV_FREE
has been added to the -mm mm-new branch.  Its filename is
     mm-madvise-batch-tlb-flushes-for-madv_free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-batch-tlb-flushes-for-madv_free.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/madvise: batch tlb flushes for MADV_FREE
Date: Fri, 4 Apr 2025 14:06:58 -0700

MADV_FREE handling for [process_]madvise() flushes tlb for each vma of
each address range.  Update the logic to do tlb flushes in a batched
way.  Initialize an mmu_gather object from do_madvise() and
vector_madvise(), which are the entry level functions for
[process_]madvise(), respectively.  And pass those objects to the
function for per-vma work, via madvise_behavior struct.  Make the
per-vma logic not flushes tlb on their own but just saves the tlb
entries to the received mmu_gather object.  Finally, the entry level
functions flush the tlb entries that gathered for the entire user
request, at once.

Link: https://lkml.kernel.org/r/20250404210700.2156-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam R. Howlett <howlett@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   59 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 47 insertions(+), 12 deletions(-)

--- a/mm/madvise.c~mm-madvise-batch-tlb-flushes-for-madv_free
+++ a/mm/madvise.c
@@ -799,12 +799,13 @@ static const struct mm_walk_ops madvise_
 	.walk_lock		= PGWALK_RDLOCK,
 };
 
-static int madvise_free_single_vma(struct vm_area_struct *vma,
-			unsigned long start_addr, unsigned long end_addr)
+static int madvise_free_single_vma(
+		struct madvise_behavior *behavior, struct vm_area_struct *vma,
+		unsigned long start_addr, unsigned long end_addr)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct mmu_notifier_range range;
-	struct mmu_gather tlb;
+	struct mmu_gather *tlb = behavior->tlb;
 
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
 
@@ -953,7 +951,7 @@ static long madvise_dontneed_free(struct
 	if (action == MADV_DONTNEED || action == MADV_DONTNEED_LOCKED)
 		return madvise_dontneed_single_vma(vma, start, end);
 	else if (action == MADV_FREE)
-		return madvise_free_single_vma(vma, start, end);
+		return madvise_free_single_vma(behavior, vma, start, end);
 	else
 		return -EINVAL;
 }
@@ -1626,6 +1624,29 @@ static void madvise_unlock(struct mm_str
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
@@ -1782,14 +1803,20 @@ static int madvise_do_behavior(struct mm
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
@@ -1806,13 +1833,18 @@ static ssize_t vector_madvise(struct mm_
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
@@ -1841,14 +1873,17 @@ static ssize_t vector_madvise(struct mm_
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

mm-madvise-define-and-use-madvise_behavior-struct-for-madvise_do_behavior.patch
mm-madvise-batch-tlb-flushes-for-madv_free.patch
mm-memory-split-non-tlb-flushing-part-from-zap_page_range_single.patch
mm-madvise-batch-tlb-flushes-for-madv_dontneed.patch

