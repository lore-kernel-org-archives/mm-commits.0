Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A04DC7EE43
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbjFIX3L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbjFIX2H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:28:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC64030FC
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7103361AE1
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4717C433EF;
        Fri,  9 Jun 2023 23:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353273;
        bh=VPdofUz08TQdb50iIDAA2iV+0Ycr2oswxB8/ri3JLKM=;
        h=Date:To:From:Subject:From;
        b=Q6YCWoWf33u5pGZYCHTgrR5Fb5YKBeZ5N7B3iD89n1oS6pcfZROKo8KKcJUczdmH1
         dmNUzKRZP4/DlBCU1ToqtEH/pIsHHa4violCGpMdbOykh8C9pHhbE3mbMDH9nK3T2C
         +U2v0YyJ8CUXQWDVm5LiEsyGfylfa12LiZvRUWhQ=
Date:   Fri, 09 Jun 2023 16:27:53 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, seanjc@google.com,
        sakari.ailus@linux.intel.com, jgg@nvidia.com, jarkko@kernel.org,
        hch@lst.de, gregkh@linuxfoundation.org, frankja@linux.ibm.com,
        dennis.dalessandro@cornelisnetworks.com, david@redhat.com,
        christian.koenig@amd.com, catalin.marinas@arm.com, axboe@kernel.dk,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-remove-unused-vmas-parameter-from-get_user_pages.patch removed from -mm tree
Message-Id: <20230609232753.C4717C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: remove unused vmas parameter from get_user_pages()
has been removed from the -mm tree.  Its filename was
     mm-gup-remove-unused-vmas-parameter-from-get_user_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm/gup: remove unused vmas parameter from get_user_pages()
Date: Wed, 17 May 2023 20:25:33 +0100

Patch series "remove the vmas parameter from GUP APIs", v6.

(pin_/get)_user_pages[_remote]() each provide an optional output parameter
for an array of VMA objects associated with each page in the input range.

These provide the means for VMAs to be returned, as long as mm->mmap_lock
is never released during the GUP operation (i.e.  the internal flag
FOLL_UNLOCKABLE is not specified).

In addition, these VMAs can only be accessed with the mmap_lock held and
become invalidated the moment it is released.

The vast majority of invocations do not use this functionality and of
those that do, all but one case retrieve a single VMA to perform checks
upon.

It is not egregious in the single VMA cases to simply replace the
operation with a vma_lookup().  In these cases we duplicate the (fast)
lookup on a slow path already under the mmap_lock, abstracted to a new
get_user_page_vma_remote() inline helper function which also performs
error checking and reference count maintenance.

The special case is io_uring, where io_pin_pages() specifically needs to
assert that the VMAs underlying the range do not result in broken
long-term GUP file-backed mappings.

As GUP now internally asserts that FOLL_LONGTERM mappings are not
file-backed in a broken fashion (i.e.  requiring dirty tracking) - as
implemented in "mm/gup: disallow FOLL_LONGTERM GUP-nonfast writing to
file-backed mappings" - this logic is no longer required and so we can
simply remove it altogether from io_uring.

Eliminating the vmas parameter eliminates an entire class of danging
pointer errors that might have occured should the lock have been
incorrectly released.

In addition, the API is simplified and now clearly expresses what it is
intended for - applying the specified GUP flags and (if pinning) returning
pinned pages.

This change additionally opens the door to further potential improvements
in GUP and the possible marrying of disparate code paths.

I have run this series against gup_test with no issues.

Thanks to Matthew Wilcox for suggesting this refactoring!


This patch (of 6):

No invocation of get_user_pages() use the vmas parameter, so remove it.

The GUP API is confusing and caveated.  Recent changes have done much to
improve that, however there is more we can do.  Exporting vmas is a prime
target as the caller has to be extremely careful to preclude their use
after the mmap_lock has expired or otherwise be left with dangling
pointers.

Removing the vmas parameter focuses the GUP functions upon their primary
purpose - pinning (and outputting) pages as well as performing the actions
implied by the input flags.

This is part of a patch series aiming to remove the vmas parameter
altogether.

Link: https://lkml.kernel.org/r/cover.1684350871.git.lstoakes@gmail.com
Link: https://lkml.kernel.org/r/589e0c64794668ffc799651e8d85e703262b1e9d.1684350871.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Christian König <christian.koenig@amd.com> (for radeon parts)
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Sean Christopherson <seanjc@google.com> (KVM)
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/sgx/ioctl.c     |    2 +-
 drivers/gpu/drm/radeon/radeon_ttm.c |    2 +-
 drivers/misc/sgi-gru/grufault.c     |    2 +-
 include/linux/mm.h                  |    3 +--
 mm/gup.c                            |    9 +++------
 mm/gup_test.c                       |    5 ++---
 virt/kvm/kvm_main.c                 |    2 +-
 7 files changed, 10 insertions(+), 15 deletions(-)

--- a/arch/x86/kernel/cpu/sgx/ioctl.c~mm-gup-remove-unused-vmas-parameter-from-get_user_pages
+++ a/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -214,7 +214,7 @@ static int __sgx_encl_add_page(struct sg
 	if (!(vma->vm_flags & VM_MAYEXEC))
 		return -EACCES;
 
-	ret = get_user_pages(src, 1, 0, &src_page, NULL);
+	ret = get_user_pages(src, 1, 0, &src_page);
 	if (ret < 1)
 		return -EFAULT;
 
--- a/drivers/gpu/drm/radeon/radeon_ttm.c~mm-gup-remove-unused-vmas-parameter-from-get_user_pages
+++ a/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -359,7 +359,7 @@ static int radeon_ttm_tt_pin_userptr(str
 		struct page **pages = ttm->pages + pinned;
 
 		r = get_user_pages(userptr, num_pages, write ? FOLL_WRITE : 0,
-				   pages, NULL);
+				   pages);
 		if (r < 0)
 			goto release_pages;
 
--- a/drivers/misc/sgi-gru/grufault.c~mm-gup-remove-unused-vmas-parameter-from-get_user_pages
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -185,7 +185,7 @@ static int non_atomic_pte_lookup(struct
 #else
 	*pageshift = PAGE_SHIFT;
 #endif
-	if (get_user_pages(vaddr, 1, write ? FOLL_WRITE : 0, &page, NULL) <= 0)
+	if (get_user_pages(vaddr, 1, write ? FOLL_WRITE : 0, &page) <= 0)
 		return -EFAULT;
 	*paddr = page_to_phys(page);
 	put_page(page);
--- a/include/linux/mm.h~mm-gup-remove-unused-vmas-parameter-from-get_user_pages
+++ a/include/linux/mm.h
@@ -2369,8 +2369,7 @@ long pin_user_pages_remote(struct mm_str
 			   unsigned int gup_flags, struct page **pages,
 			   struct vm_area_struct **vmas, int *locked);
 long get_user_pages(unsigned long start, unsigned long nr_pages,
-			    unsigned int gup_flags, struct page **pages,
-			    struct vm_area_struct **vmas);
+		    unsigned int gup_flags, struct page **pages);
 long pin_user_pages(unsigned long start, unsigned long nr_pages,
 		    unsigned int gup_flags, struct page **pages,
 		    struct vm_area_struct **vmas);
--- a/mm/gup.c~mm-gup-remove-unused-vmas-parameter-from-get_user_pages
+++ a/mm/gup.c
@@ -2251,8 +2251,6 @@ long get_user_pages_remote(struct mm_str
  * @pages:      array that receives pointers to the pages pinned.
  *              Should be at least nr_pages long. Or NULL, if caller
  *              only intends to ensure the pages are faulted in.
- * @vmas:       array of pointers to vmas corresponding to each page.
- *              Or NULL if the caller does not require them.
  *
  * This is the same as get_user_pages_remote(), just with a less-flexible
  * calling convention where we assume that the mm being operated on belongs to
@@ -2260,16 +2258,15 @@ long get_user_pages_remote(struct mm_str
  * obviously don't pass FOLL_REMOTE in here.
  */
 long get_user_pages(unsigned long start, unsigned long nr_pages,
-		unsigned int gup_flags, struct page **pages,
-		struct vm_area_struct **vmas)
+		    unsigned int gup_flags, struct page **pages)
 {
 	int locked = 1;
 
-	if (!is_valid_gup_args(pages, vmas, NULL, &gup_flags, FOLL_TOUCH))
+	if (!is_valid_gup_args(pages, NULL, NULL, &gup_flags, FOLL_TOUCH))
 		return -EINVAL;
 
 	return __get_user_pages_locked(current->mm, start, nr_pages, pages,
-				       vmas, &locked, gup_flags);
+				       NULL, &locked, gup_flags);
 }
 EXPORT_SYMBOL(get_user_pages);
 
--- a/mm/gup_test.c~mm-gup-remove-unused-vmas-parameter-from-get_user_pages
+++ a/mm/gup_test.c
@@ -139,8 +139,7 @@ static int __gup_test_ioctl(unsigned int
 						 pages + i);
 			break;
 		case GUP_BASIC_TEST:
-			nr = get_user_pages(addr, nr, gup->gup_flags, pages + i,
-					    NULL);
+			nr = get_user_pages(addr, nr, gup->gup_flags, pages + i);
 			break;
 		case PIN_FAST_BENCHMARK:
 			nr = pin_user_pages_fast(addr, nr, gup->gup_flags,
@@ -161,7 +160,7 @@ static int __gup_test_ioctl(unsigned int
 						    pages + i, NULL);
 			else
 				nr = get_user_pages(addr, nr, gup->gup_flags,
-						    pages + i, NULL);
+						    pages + i);
 			break;
 		default:
 			ret = -EINVAL;
--- a/virt/kvm/kvm_main.c~mm-gup-remove-unused-vmas-parameter-from-get_user_pages
+++ a/virt/kvm/kvm_main.c
@@ -2477,7 +2477,7 @@ static inline int check_user_page_hwpois
 {
 	int rc, flags = FOLL_HWPOISON | FOLL_WRITE;
 
-	rc = get_user_pages(addr, 1, flags, NULL, NULL);
+	rc = get_user_pages(addr, 1, flags, NULL);
 	return rc == -EHWPOISON;
 }
 
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-vmalloc-do-not-output-a-spurious-warning-when-huge-vmalloc-fails.patch

