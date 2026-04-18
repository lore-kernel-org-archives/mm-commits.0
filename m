Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2679236EAA4
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499023; cv=none; b=ZmKh1FJfV6npW+aOgoKgERQECT9o35EMhLMku3es7o34zYohuE2ItRfFkl6+Enh4chjmgqAFpvEkCiLySzlKLtm+vRgqA5xODr22IGcirZFCDI2e//s2wm5TvxUz0n1jt/VB9+G+27AdCkEB3fT46ZsTRHEua7KIe3ZZmI3tOFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499023; c=relaxed/simple;
	bh=+1qqWRlq5+6b1IA5N/9iqdS4a2Iebdq7FD3cpssowKs=;
	h=Date:To:From:Subject:Message-Id; b=IxFgsD/0NBAZ9IJ1y7pNVDSO9nDpTzs/pAZ1xJVJeiZq6OBf13mZsQShAo4sFjEB/FEIsVwC8uGFJdk8SSNK1GQtZegnuMSIUryc+J0/TKv2xe+2k85uYBWdTm+S0rwsawbMMSsm5JUvFOxKKAwiszDLNYi7vLmVzlPRk1UNC6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lTV6oH4X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lTV6oH4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9A7C19424;
	Sat, 18 Apr 2026 07:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776499023;
	bh=+1qqWRlq5+6b1IA5N/9iqdS4a2Iebdq7FD3cpssowKs=;
	h=Date:To:From:Subject:From;
	b=lTV6oH4Xlntl3NyJniW638PlOAdScoUfot0vK6eVhyUwAaXvWQr0vSSUj9MenhKRz
	 LCk6UIvSxst3+ltMyzg9gVC9/H6auQ/iNPtgcMOL8g4gJApdeX26V3auuvFi/WBjt0
	 v6DNmiZL/G8twKphp7E0xBg/si/ev32rFgtIqMbI=
Date: Sat, 18 Apr 2026 00:56:58 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,seanjc@google.com,peterx@redhat.com,pbonzini@redhat.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,kalyazin@amazon.com,jthoughton@google.com,hughd@google.com,harry.yoo@oracle.com,harry@kernel.org,devnexen@gmail.com,david@kernel.org,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,aarcange@redhat.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy.patch removed from -mm tree
Message-Id: <20260418075701.CD9A7C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: retry copying with locks dropped in mfill_atomic_pte_copy()
has been removed from the -mm tree.  Its filename was
     userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: userfaultfd: retry copying with locks dropped in mfill_atomic_pte_copy()
Date: Thu, 2 Apr 2026 07:11:46 +0300

Implementation of UFFDIO_COPY for anonymous memory might fail to copy data
from userspace buffer when the destination VMA is locked (either with
mm_lock or with per-VMA lock).

In that case, mfill_atomic() releases the locks, retries copying the data
with locks dropped and then re-locks the destination VMA and
re-establishes PMD.

Since this retry-reget dance is only relevant for UFFDIO_COPY and it never
happens for other UFFDIO_ operations, make it a part of
mfill_atomic_pte_copy() that actually implements UFFDIO_COPY for anonymous
memory.

As a temporal safety measure to avoid breaking biscection
mfill_atomic_pte_copy() makes sure to never return -ENOENT so that the
loop in mfill_atomic() won't retry copiyng outside of mmap_lock.  This is
removed later when shmem implementation will be updated later and the loop
in mfill_atomic() will be adjusted.

[akpm@linux-foundation.org: update mfill_copy_folio_retry()]
  Link: https://lore.kernel.org/20260316173829.1126728-1-avagin@google.com
Link: https://lore.kernel.org/20260306171815.3160826-6-rppt@kernel.org
Link: https://lore.kernel.org/20260402041156.1377214-6-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nikita Kalyazin <kalyazin@amazon.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Carlier <devnexen@gmail.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   79 ++++++++++++++++++++++++++++++---------------
 1 file changed, 53 insertions(+), 26 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy
+++ a/mm/userfaultfd.c
@@ -405,35 +405,63 @@ static int mfill_copy_folio_locked(struc
 	return ret;
 }
 
+static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio)
+{
+	unsigned long src_addr = state->src_addr;
+	void *kaddr;
+	int err;
+
+	/* retry copying with mm_lock dropped */
+	mfill_put_vma(state);
+
+	kaddr = kmap_local_folio(folio, 0);
+	err = copy_from_user(kaddr, (const void __user *) src_addr, PAGE_SIZE);
+	kunmap_local(kaddr);
+	if (unlikely(err))
+		return -EFAULT;
+
+	flush_dcache_folio(folio);
+
+	/* reget VMA and PMD, they could change underneath us */
+	err = mfill_get_vma(state);
+	if (err)
+		return err;
+
+	err = mfill_establish_pmd(state);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 static int mfill_atomic_pte_copy(struct mfill_state *state)
 {
-	struct vm_area_struct *dst_vma = state->vma;
 	unsigned long dst_addr = state->dst_addr;
 	unsigned long src_addr = state->src_addr;
 	uffd_flags_t flags = state->flags;
-	pmd_t *dst_pmd = state->pmd;
 	struct folio *folio;
 	int ret;
 
-	if (!state->folio) {
-		ret = -ENOMEM;
-		folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, dst_vma,
-					dst_addr);
-		if (!folio)
-			goto out;
-
-		ret = mfill_copy_folio_locked(folio, src_addr);
-
-		/* fallback to copy_from_user outside mmap_lock */
-		if (unlikely(ret)) {
-			ret = -ENOENT;
-			state->folio = folio;
-			/* don't free the page */
-			goto out;
-		}
-	} else {
-		folio = state->folio;
-		state->folio = NULL;
+	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, state->vma, dst_addr);
+	if (!folio)
+		return -ENOMEM;
+
+	ret = -ENOMEM;
+	if (mem_cgroup_charge(folio, state->vma->vm_mm, GFP_KERNEL))
+		goto out_release;
+
+	ret = mfill_copy_folio_locked(folio, src_addr);
+	if (unlikely(ret)) {
+		/*
+		 * Fallback to copy_from_user outside mmap_lock.
+		 * If retry is successful, mfill_copy_folio_locked() returns
+		 * with locks retaken by mfill_get_vma().
+		 * If there was an error, we must mfill_put_vma() anyway and it
+		 * will take care of unlocking if needed.
+		 */
+		ret = mfill_copy_folio_retry(state, folio);
+		if (ret)
+			goto out_release;
 	}
 
 	/*
@@ -443,17 +471,16 @@ static int mfill_atomic_pte_copy(struct
 	 */
 	__folio_mark_uptodate(folio);
 
-	ret = -ENOMEM;
-	if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
-		goto out_release;
-
-	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
+	ret = mfill_atomic_install_pte(state->pmd, state->vma, dst_addr,
 				       &folio->page, true, flags);
 	if (ret)
 		goto out_release;
 out:
 	return ret;
 out_release:
+	/* Don't return -ENOENT so that our caller won't retry */
+	if (ret == -ENOENT)
+		ret = -EFAULT;
 	folio_put(folio);
 	goto out;
 }
_

Patches currently in -mm which might be from rppt@kernel.org are


