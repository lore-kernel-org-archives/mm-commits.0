Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A180C677F0
	for <mm-commits@archiver.kernel.org>; Sat,  7 Jan 2023 00:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235773AbjAGAj1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Jan 2023 19:39:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236991AbjAGAjK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jan 2023 19:39:10 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90AB540C06
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 16:39:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D3AB6CE1ECE
        for <mm-commits@vger.kernel.org>; Sat,  7 Jan 2023 00:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D40C433F0;
        Sat,  7 Jan 2023 00:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673051938;
        bh=BuyLYut66x9OOiByegq/Z4lm3pxP71erW3K91cDT47k=;
        h=Date:To:From:Subject:From;
        b=YC3rrh0V6aSU6294iUri4ammez+kZJACd7Wff6ylNYpyXuUQsrkX15RLVo/7aCYfi
         nvPhmvw3IMvOSJlZi4HFfx28r7IWSM6emFBVtogdrKqZsjS2odKHz74WiswyP8HVMg
         BbgYQXwn0nUhCDfIYle5DXOQEu5195RaRjUStebU=
Date:   Fri, 06 Jan 2023 16:38:57 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        muchun.song@linux.dev, mike.kravetz@oracle.com, david@redhat.com,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-update-mmap_sem-comments-to-refer-to-mmap_lock.patch added to mm-hotfixes-unstable branch
Message-Id: <20230107003857.F2D40C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: update mmap_sem comments to refer to mmap_lock
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-update-mmap_sem-comments-to-refer-to-mmap_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-update-mmap_sem-comments-to-refer-to-mmap_lock.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm: update mmap_sem comments to refer to mmap_lock
Date: Sat, 7 Jan 2023 00:00:05 +0000

The rename from mm->mmap_sem to mm->mmap_lock was performed in commit
da1c55f1b272 ("mmap locking API: rename mmap_sem to mmap_lock") and commit
c1e8d7c6a7a6 ("map locking API: convert mmap_sem comments"), however some
incorrect comments remain.

This patch simply corrects those comments which are obviously incorrect
within mm itself.

Link: https://lkml.kernel.org/r/33fba04389ab63fc4980e7ba5442f521df6dc657.1673048927.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    2 +-
 include/linux/page_ref.h |    2 +-
 mm/hugetlb.c             |    4 ++--
 mm/madvise.c             |    2 +-
 mm/mmap.c                |    4 ++--
 5 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/mm_types.h~mm-update-mmap_sem-comments-to-refer-to-mmap_lock
+++ a/include/linux/mm_types.h
@@ -581,7 +581,7 @@ struct vm_area_struct {
 	/*
 	 * For private and shared anonymous mappings, a pointer to a null
 	 * terminated string containing the name given to the vma, or NULL if
-	 * unnamed. Serialized by mmap_sem. Use anon_vma_name to access.
+	 * unnamed. Serialized by mmap_lock. Use anon_vma_name to access.
 	 */
 	struct anon_vma_name *anon_name;
 #endif
--- a/include/linux/page_ref.h~mm-update-mmap_sem-comments-to-refer-to-mmap_lock
+++ a/include/linux/page_ref.h
@@ -301,7 +301,7 @@ static inline bool folio_ref_try_add_rcu
  *
  * You can also use this function if you're holding a lock that prevents
  * pages being frozen & removed; eg the i_pages lock for the page cache
- * or the mmap_sem or page table lock for page tables.  In this case,
+ * or the mmap_lock or page table lock for page tables.  In this case,
  * it will always succeed, and you could have used a plain folio_get(),
  * but it's sometimes more convenient to have a common function called
  * from both locked and RCU-protected contexts.
--- a/mm/hugetlb.c~mm-update-mmap_sem-comments-to-refer-to-mmap_lock
+++ a/mm/hugetlb.c
@@ -1183,7 +1183,7 @@ void hugetlb_dup_vma_private(struct vm_a
 
 /*
  * Reset and decrement one ref on hugepage private reservation.
- * Called with mm->mmap_sem writer semaphore held.
+ * Called with mm->mmap_lock writer semaphore held.
  * This function should be only used by move_vma() and operate on
  * same sized vma. It should never come here with last ref on the
  * reservation.
@@ -5152,7 +5152,7 @@ static void move_huge_pte(struct vm_area
 
 	/*
 	 * We don't have to worry about the ordering of src and dst ptlocks
-	 * because exclusive mmap_sem (or the i_mmap_lock) prevents deadlock.
+	 * because exclusive mmap_lock (or the i_mmap_lock) prevents deadlock.
 	 */
 	if (src_ptl != dst_ptl)
 		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
--- a/mm/madvise.c~mm-update-mmap_sem-comments-to-refer-to-mmap_lock
+++ a/mm/madvise.c
@@ -130,7 +130,7 @@ static int replace_anon_vma_name(struct
 #endif /* CONFIG_ANON_VMA_NAME */
 /*
  * Update the vm_flags on region of a vma, splitting it or merging it as
- * necessary.  Must be called with mmap_sem held for writing;
+ * necessary.  Must be called with mmap_lock held for writing;
  * Caller should ensure anon_name stability by raising its refcount even when
  * anon_name belongs to a valid vma because this function might free that vma.
  */
--- a/mm/mmap.c~mm-update-mmap_sem-comments-to-refer-to-mmap_lock
+++ a/mm/mmap.c
@@ -2294,7 +2294,7 @@ static inline int munmap_sidetree(struct
  * @start: The aligned start address to munmap.
  * @end: The aligned end address to munmap.
  * @uf: The userfaultfd list_head
- * @downgrade: Set to true to attempt a write downgrade of the mmap_sem
+ * @downgrade: Set to true to attempt a write downgrade of the mmap_lock
  *
  * If @downgrade is true, check return code for potential release of the lock.
  */
@@ -2469,7 +2469,7 @@ map_count_exceeded:
  * @len: The length of the range to munmap
  * @uf: The userfaultfd list_head
  * @downgrade: set to true if the user wants to attempt to write_downgrade the
- * mmap_sem
+ * mmap_lock
  *
  * This function takes a @mas that is either pointing to the previous VMA or set
  * to MA_START and sets it up to remove the mapping(s).  The @len will be
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-update-mmap_sem-comments-to-refer-to-mmap_lock.patch
mm-vmalloc-correct-use-of-__gfp_nowarn-mask-in-__vmalloc_area_node.patch
mm-pagevec-add-folio_batch_reinit.patch
mm-mlock-use-folios-and-a-folio-batch-internally.patch
m68k-mm-motorola-specify-pmd_page-type.patch
mm-mlock-update-the-interface-to-use-folios.patch
documentation-mm-update-references-to-__mlock_page-to-_folio.patch
selftest-vm-add-mremap-expand-merge-offset-test.patch

