Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC7AFC7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbjFIX3L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbjFIX2H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:28:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65DCC3C1E
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01101616B4
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D6CC433D2;
        Fri,  9 Jun 2023 23:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353275;
        bh=4SwPsGPWbchVgvzGoqXmYEb69DwiEjLK32ShnDXnt80=;
        h=Date:To:From:Subject:From;
        b=M2YqqhX9Z4PRs0WCD7L/LpZ3024nhFgkMKWJjANjwDImXEi4gSVNTRorcQlA8fiwR
         p+dXJAHISfPqtNpw2wT+DpWtPqcUoWHBJtH3MuQB2H+e4kLGvnxNOzh6M1HUAkmnci
         EqyZWui90YpKNjH6yLLwrj/uclj1abQw/Z1f9cS0=
Date:   Fri, 09 Jun 2023 16:27:54 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, seanjc@google.com,
        sakari.ailus@linux.intel.com, jgg@nvidia.com, jarkko@kernel.org,
        hch@lst.de, gregkh@linuxfoundation.org, frankja@linux.ibm.com,
        dennis.dalessandro@cornelisnetworks.com, david@redhat.com,
        christian.koenig@amd.com, catalin.marinas@arm.com, axboe@kernel.dk,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote.patch removed from -mm tree
Message-Id: <20230609232755.59D6CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: remove unused vmas parameter from pin_user_pages_remote()
has been removed from the -mm tree.  Its filename was
     mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>
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
@@ -2367,7 +2367,7 @@ long get_user_pages_remote(struct mm_str
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
@@ -3100,8 +3100,6 @@ EXPORT_SYMBOL_GPL(pin_user_pages_fast);
  * @gup_flags:	flags modifying lookup behaviour
  * @pages:	array that receives pointers to the pages pinned.
  *		Should be at least nr_pages long.
- * @vmas:	array of pointers to vmas corresponding to each page.
- *		Or NULL if the caller does not require them.
  * @locked:	pointer to lock flag indicating whether lock is held and
  *		subsequently whether VM_FAULT_RETRY functionality can be
  *		utilised. Lock must initially be held.
@@ -3116,14 +3114,14 @@ EXPORT_SYMBOL_GPL(pin_user_pages_fast);
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

mm-vmalloc-do-not-output-a-spurious-warning-when-huge-vmalloc-fails.patch

