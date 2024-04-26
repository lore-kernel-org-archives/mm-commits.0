Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1225BE47
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 18:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714156473; cv=none; b=FgaRUFLBvEBZDlWS4/80Fy3EQj/ZmDOAl10i53ZGqUYSwSaOXp3TU5rEbMW2dcdHUM3bUCcS34c6SB+qLBaibLu+e2+70BueIwnsIbTK/0w9f79f8HqzMBecx8fozsX3VktVxxJOOFE7WNxq8xHC68/BGO+xp3Mk06Q04t+vIPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714156473; c=relaxed/simple;
	bh=pzcis/3cBxGhqtG2WGTf7EGtvxXwuUIdZ5N14Y4PvyE=;
	h=Date:To:From:Subject:Message-Id; b=KWiBy7SpUctlueKU8iudDAEugUC6ORaG4uB7nGt7+d+3WOhHyvD4+z5SJonWn4yC3xsnoc8bF7XvRB8pcP2LT8CM9Y1W6ZdJ/0nyEFzjmf9qLpshtU3dMaklyCXt/H8cJkYG/nwqeZai6TRvCK1V7XDoxz6LMbN/yKu1Ro66GmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kb8amc4f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kb8amc4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38057C113CE;
	Fri, 26 Apr 2024 18:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714156473;
	bh=pzcis/3cBxGhqtG2WGTf7EGtvxXwuUIdZ5N14Y4PvyE=;
	h=Date:To:From:Subject:From;
	b=kb8amc4fg+LUw6+n8k7iI5fawVfOka9Ho8PbaLNxWEJZ5H6UZypTztGsFcX+sQatW
	 Tmyl94WMPTwPxl0Oga7ICG5nKYKxe9IuwGZ7CFibVQ7XlgH387vUbaQ3fDpKarRyIz
	 LG+mvwzjCDhlIs/kNxo3igLzhFAvnlUZmaDPLuYU=
Date: Fri, 26 Apr 2024 11:34:32 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,jannh@google.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-some-minor-per-vma-lock-issues-in-userfaultfd.patch added to mm-unstable branch
Message-Id: <20240426183433.38057C113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix some minor per-VMA lock issues in userfaultfd
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-some-minor-per-vma-lock-issues-in-userfaultfd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-some-minor-per-vma-lock-issues-in-userfaultfd.patch

This patch will later appear in the mm-unstable branch at
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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: fix some minor per-VMA lock issues in userfaultfd
Date: Fri, 26 Apr 2024 15:45:02 +0100

Rename lock_vma() to uffd_lock_vma() because it really is uffd specific. 
Remove comment referencing unlock_vma() which doesn't exist.  Fix the
comment about lock_vma_under_rcu() which I just made incorrect.

Link: https://lkml.kernel.org/r/20240426144506.1290619-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/mm/userfaultfd.c~mm-fix-some-minor-per-vma-lock-issues-in-userfaultfd
+++ a/mm/userfaultfd.c
@@ -56,17 +56,16 @@ struct vm_area_struct *find_vma_and_prep
 
 #ifdef CONFIG_PER_VMA_LOCK
 /*
- * lock_vma() - Lookup and lock vma corresponding to @address.
+ * uffd_lock_vma() - Lookup and lock vma corresponding to @address.
  * @mm: mm to search vma in.
  * @address: address that the vma should contain.
  *
- * Should be called without holding mmap_lock. vma should be unlocked after use
- * with unlock_vma().
+ * Should be called without holding mmap_lock.
  *
  * Return: A locked vma containing @address, -ENOENT if no vma is found, or
  * -ENOMEM if anon_vma couldn't be allocated.
  */
-static struct vm_area_struct *lock_vma(struct mm_struct *mm,
+static struct vm_area_struct *uffd_lock_vma(struct mm_struct *mm,
 				       unsigned long address)
 {
 	struct vm_area_struct *vma;
@@ -74,9 +73,8 @@ static struct vm_area_struct *lock_vma(s
 	vma = lock_vma_under_rcu(mm, address);
 	if (vma) {
 		/*
-		 * lock_vma_under_rcu() only checks anon_vma for private
-		 * anonymous mappings. But we need to ensure it is assigned in
-		 * private file-backed vmas as well.
+		 * We know we're going to need to use anon_vma, so check
+		 * that early.
 		 */
 		if (!(vma->vm_flags & VM_SHARED) && unlikely(!vma->anon_vma))
 			vma_end_read(vma);
@@ -107,7 +105,7 @@ static struct vm_area_struct *uffd_mfill
 {
 	struct vm_area_struct *dst_vma;
 
-	dst_vma = lock_vma(dst_mm, dst_start);
+	dst_vma = uffd_lock_vma(dst_mm, dst_start);
 	if (IS_ERR(dst_vma) || validate_dst_vma(dst_vma, dst_start + len))
 		return dst_vma;
 
@@ -1401,7 +1399,7 @@ static int uffd_move_lock(struct mm_stru
 	struct vm_area_struct *vma;
 	int err;
 
-	vma = lock_vma(mm, dst_start);
+	vma = uffd_lock_vma(mm, dst_start);
 	if (IS_ERR(vma))
 		return PTR_ERR(vma);
 
@@ -1416,7 +1414,7 @@ static int uffd_move_lock(struct mm_stru
 	}
 
 	/*
-	 * Using lock_vma() to get src_vma can lead to following deadlock:
+	 * Using uffd_lock_vma() to get src_vma can lead to following deadlock:
 	 *
 	 * Thread1				Thread2
 	 * -------				-------
@@ -1438,7 +1436,7 @@ static int uffd_move_lock(struct mm_stru
 	err = find_vmas_mm_locked(mm, dst_start, src_start, dst_vmap, src_vmap);
 	if (!err) {
 		/*
-		 * See comment in lock_vma() as to why not using
+		 * See comment in uffd_lock_vma() as to why not using
 		 * vma_start_read() here.
 		 */
 		down_read(&(*dst_vmap)->vm_lock->lock);
_

Patches currently in -mm which might be from willy@infradead.org are

doc-improve-the-description-of-__folio_mark_dirty.patch
buffer-add-kernel-doc-for-block_dirty_folio.patch
buffer-add-kernel-doc-for-try_to_free_buffers.patch
buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch
buffer-add-kernel-doc-for-brelse-and-__brelse.patch
buffer-add-kernel-doc-for-bforget-and-__bforget.patch
buffer-improve-bdev_getblk-documentation.patch
doc-split-bufferrst-out-of-api-summaryrst.patch
doc-split-bufferrst-out-of-api-summaryrst-fix.patch
mm-memory-failure-remove-fsdax_pgoff-argument-from-__add_to_kill.patch
mm-memory-failure-pass-addr-to-__add_to_kill.patch
mm-return-the-address-from-page_mapped_in_vma.patch
mm-make-page_mapped_in_vma-conditional-on-config_memory_failure.patch
mm-memory-failure-convert-shake_page-to-shake_folio.patch
mm-convert-hugetlb_page_mapping_lock_write-to-folio.patch
mm-memory-failure-convert-memory_failure-to-use-a-folio.patch
mm-memory-failure-convert-hwpoison_user_mappings-to-take-a-folio.patch
mm-memory-failure-add-some-folio-conversions-to-unpoison_memory.patch
mm-memory-failure-use-folio-functions-throughout-collect_procs.patch
mm-memory-failure-pass-the-folio-to-collect_procs_ksm.patch
fscrypt-convert-bh_get_inode_and_lblk_num-to-use-a-folio.patch
f2fs-convert-f2fs_clear_page_cache_dirty_tag-to-use-a-folio.patch
memory-failure-remove-calls-to-page_mapping.patch
migrate-expand-the-use-of-folio-in-__migrate_device_pages.patch
userfault-expand-folio-use-in-mfill_atomic_install_pte.patch
mm-remove-page_mapping.patch
mm-remove-page_cache_alloc.patch
mm-remove-put_devmap_managed_page.patch
mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch
mm-remove-page_ref_sub_return.patch
gup-use-folios-for-gup_devmap.patch
mm-add-kernel-doc-for-folio_mark_accessed.patch
mm-remove-pagereferenced.patch
mm-simplify-thp_vma_allowable_order.patch
mm-assert-the-mmap_lock-is-held-in-__anon_vma_prepare.patch
mm-delay-the-check-for-a-null-anon_vma.patch
mm-fix-some-minor-per-vma-lock-issues-in-userfaultfd.patch
mm-optimise-vmf_anon_prepare-for-vmas-without-an-anon_vma.patch

