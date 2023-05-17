Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80867C77B75
	for <mm-commits@archiver.kernel.org>; Wed, 17 May 2023 20:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjEQUdN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 May 2023 16:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjEQUdM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 May 2023 16:33:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7208A7A
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 13:32:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E68964B1F
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 20:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F2BC433EF;
        Wed, 17 May 2023 20:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684355518;
        bh=WbL+ox5/oiUSau7d2qnXKfoq5AISkZQ6dZpzJnFik4w=;
        h=Date:To:From:Subject:From;
        b=a0hBbOBX/9fQItfXMV4TpTfsIiTOwU15BCe/ku39d7N+EEcjEiBepSczH4N/ID/nJ
         k7bGVRevw2de3sCydkL1Z7FaL5P60A8CH/I6GTRcg+cITpuWBQ6JNibNI6Oc5JNDht
         /iR9i/GRKw8v6HGVpXeX3Vhad/4zRM34WIOT0w0w=
Date:   Wed, 17 May 2023 13:31:57 -0700
To:     mm-commits@vger.kernel.org, jgg@nvidia.com, hch@lst.de,
        david@redhat.com, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote.patch added to mm-unstable branch
Message-Id: <20230517203158.94F2BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: remove unused vmas parameter from pin_user_pages_remote()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote.patch

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
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm/gup: remove unused vmas parameter from pin_user_pages_remote()
Date: Wed, 17 May 2023 20:25:36 +0100

No invocation of pin_user_pages_remote() uses the vmas parameter, so
remove it.  This forms part of a larger patch set eliminating the use of
the vmas parameters altogether.

Link: https://lkml.kernel.org/r/28f000beb81e45bf538a2aaa77c90f5482b67a32.1684350871.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/iommufd/pages.c    |    4 ++--
 drivers/vfio/vfio_iommu_type1.c  |    2 +-
 include/linux/mm.h               |    2 +-
 kernel/trace/trace_events_user.c |    2 +-
 mm/gup.c                         |    8 +++-----
 mm/process_vm_access.c           |    2 +-
 6 files changed, 9 insertions(+), 11 deletions(-)

--- a/drivers/iommu/iommufd/pages.c~mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote
+++ a/drivers/iommu/iommufd/pages.c
@@ -786,7 +786,7 @@ static int pfn_reader_user_pin(struct pf
 			user->locked = 1;
 		}
 		rc = pin_user_pages_remote(pages->source_mm, uptr, npages,
-					   user->gup_flags, user->upages, NULL,
+					   user->gup_flags, user->upages,
 					   &user->locked);
 	}
 	if (rc <= 0) {
@@ -1799,7 +1799,7 @@ static int iopt_pages_rw_page(struct iop
 	rc = pin_user_pages_remote(
 		pages->source_mm, (uintptr_t)(pages->uptr + index * PAGE_SIZE),
 		1, (flags & IOMMUFD_ACCESS_RW_WRITE) ? FOLL_WRITE : 0, &page,
-		NULL, NULL);
+		NULL);
 	mmap_read_unlock(pages->source_mm);
 	if (rc != 1) {
 		if (WARN_ON(rc >= 0))
--- a/drivers/vfio/vfio_iommu_type1.c~mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote
+++ a/drivers/vfio/vfio_iommu_type1.c
@@ -562,7 +562,7 @@ static int vaddr_get_pfns(struct mm_stru
 
 	mmap_read_lock(mm);
 	ret = pin_user_pages_remote(mm, vaddr, npages, flags | FOLL_LONGTERM,
-				    pages, NULL, NULL);
+				    pages, NULL);
 	if (ret > 0) {
 		int i;
 
--- a/include/linux/mm.h~mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote
+++ a/include/linux/mm.h
@@ -2380,7 +2380,7 @@ long get_user_pages_remote(struct mm_str
 long pin_user_pages_remote(struct mm_struct *mm,
 			   unsigned long start, unsigned long nr_pages,
 			   unsigned int gup_flags, struct page **pages,
-			   struct vm_area_struct **vmas, int *locked);
+			   int *locked);
 long get_user_pages(unsigned long start, unsigned long nr_pages,
 		    unsigned int gup_flags, struct page **pages);
 long pin_user_pages(unsigned long start, unsigned long nr_pages,
--- a/kernel/trace/trace_events_user.c~mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote
+++ a/kernel/trace/trace_events_user.c
@@ -406,7 +406,7 @@ static int user_event_enabler_write(stru
 		return -EBUSY;
 
 	ret = pin_user_pages_remote(mm->mm, uaddr, 1, FOLL_WRITE | FOLL_NOFAULT,
-				    &page, NULL, NULL);
+				    &page, NULL);
 
 	if (unlikely(ret <= 0)) {
 		if (!fixup_fault)
--- a/mm/gup.c~mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote
+++ a/mm/gup.c
@@ -3243,8 +3243,6 @@ EXPORT_SYMBOL_GPL(pin_user_pages_fast);
  * @gup_flags:	flags modifying lookup behaviour
  * @pages:	array that receives pointers to the pages pinned.
  *		Should be at least nr_pages long.
- * @vmas:	array of pointers to vmas corresponding to each page.
- *		Or NULL if the caller does not require them.
  * @locked:	pointer to lock flag indicating whether lock is held and
  *		subsequently whether VM_FAULT_RETRY functionality can be
  *		utilised. Lock must initially be held.
@@ -3259,14 +3257,14 @@ EXPORT_SYMBOL_GPL(pin_user_pages_fast);
 long pin_user_pages_remote(struct mm_struct *mm,
 			   unsigned long start, unsigned long nr_pages,
 			   unsigned int gup_flags, struct page **pages,
-			   struct vm_area_struct **vmas, int *locked)
+			   int *locked)
 {
 	int local_locked = 1;
 
-	if (!is_valid_gup_args(pages, vmas, locked, &gup_flags,
+	if (!is_valid_gup_args(pages, NULL, locked, &gup_flags,
 			       FOLL_PIN | FOLL_TOUCH | FOLL_REMOTE))
 		return 0;
-	return __gup_longterm_locked(mm, start, nr_pages, pages, vmas,
+	return __gup_longterm_locked(mm, start, nr_pages, pages, NULL,
 				     locked ? locked : &local_locked,
 				     gup_flags);
 }
--- a/mm/process_vm_access.c~mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote
+++ a/mm/process_vm_access.c
@@ -104,7 +104,7 @@ static int process_vm_rw_single_vec(unsi
 		mmap_read_lock(mm);
 		pinned_pages = pin_user_pages_remote(mm, pa, pinned_pages,
 						     flags, process_pages,
-						     NULL, &locked);
+						     &locked);
 		if (locked)
 			mmap_read_unlock(mm);
 		if (pinned_pages <= 0)
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-mmap-separate-writenotify-and-dirty-tracking-logic.patch
mm-gup-disallow-foll_longterm-gup-nonfast-writing-to-file-backed-mappings.patch
mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings.patch
mm-gup-add-missing-gup_must_unshare-check-to-gup_huge_pgd.patch
mm-gup-remove-unused-vmas-parameter-from-get_user_pages.patch
mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote.patch
mm-gup-remove-vmas-parameter-from-get_user_pages_remote.patch
io_uring-rsrc-delegate-vma-file-backed-check-to-gup.patch
mm-gup-remove-vmas-parameter-from-pin_user_pages.patch
mm-gup-remove-vmas-array-from-internal-gup-functions.patch

