Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63A84C7EE24
	for <mm-commits@archiver.kernel.org>; Mon, 15 May 2023 19:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243613AbjEOTys (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 May 2023 15:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243631AbjEOTyn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2023 15:54:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B448E727
        for <mm-commits@vger.kernel.org>; Mon, 15 May 2023 12:54:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 066B26217E
        for <mm-commits@vger.kernel.org>; Mon, 15 May 2023 19:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44EF4C433EF;
        Mon, 15 May 2023 19:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684180481;
        bh=fQx2pTGThS/QQ2Yuw31lCdTJQa2l1PuCci2nU+k//Wc=;
        h=Date:To:From:Subject:From;
        b=yPva5+dM7g/9kREaJISrHyO6ixEDNbYeOroyjmZOxuNqDkqEOZD7quaFMmQ7sO86g
         8F3V1Xfvj0SP5gEuRyXKcUgo1rJGWZlYPA89aUP9OIBKUCPwBwjfHDLl+xSoMhcyqp
         WfLzWyn/nHfKtRZadba0zXrXakAZ22HsoXIWFdh4=
Date:   Mon, 15 May 2023 12:54:40 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, pabeni@redhat.com,
        npiggin@gmail.com, neescoba@cisco.com, mst@redhat.com,
        mpe@ellerman.id.au, mchehab@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, leon@kernel.org, kuba@kernel.org,
        jonathan.lemon@gmail.com, john.fastabend@gmail.com,
        jhubbard@nvidia.com, jgg@ziepe.ca, jgg@nvidia.com,
        jasowang@redhat.com, jarkko@kernel.org, hch@lst.de,
        hawk@kernel.org, gregkh@linuxfoundation.org, frankja@linux.ibm.com,
        edumazet@google.com, dennis.dalessandro@cornelisnetworks.com,
        david@redhat.com, davem@davemloft.net, daniel@iogearbox.net,
        christophe.leroy@csgroup.eu, christian.koenig@amd.com,
        catalin.marinas@arm.com, bmt@zurich.ibm.com, bjorn@kernel.org,
        benve@cisco.com, axboe@kernel.dk, ast@kernel.org,
        asml.silence@gmail.com, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote.patch added to mm-unstable branch
Message-Id: <20230515195441.44EF4C433EF@smtp.kernel.org>
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
Date: Sun, 14 May 2023 22:26:47 +0100

No invocation of pin_user_pages_remote() uses the vmas parameter, so
remove it.  This forms part of a larger patch set eliminating the use of
the vmas parameters altogether.

Link: https://lkml.kernel.org/r/61f0d12058825a14feee6a3292e5a257662e719c.1684097002.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Bernard Metzler <bmt@zurich.ibm.com>
Cc: Björn Töpel <bjorn@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Benvenuti <benve@cisco.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Nelson Escobar <neescoba@cisco.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/iommufd/pages.c   |    4 ++--
 drivers/vfio/vfio_iommu_type1.c |    2 +-
 include/linux/mm.h              |    2 +-
 mm/gup.c                        |    8 +++-----
 mm/process_vm_access.c          |    2 +-
 5 files changed, 8 insertions(+), 10 deletions(-)

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

