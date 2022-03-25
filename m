Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 940A9C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354643AbiCYBen (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357364AbiCYBdm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCF1BD8BE
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36DD660B03
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0B5C340ED;
        Fri, 25 Mar 2022 01:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171926;
        bh=AOAJ07J3aYB2mRkTG+3gSoj0qEDf0HkZHR5eZhCM684=;
        h=Date:To:From:Subject:From;
        b=ur/tC1acQTAUU9bTcWQmW9jf8lyTw9WweEkVfl4bwvoPVM4hJ0TCAhrXjx0wraaw6
         uzAjXJMaE/4YU+umR4Q3Nnu8MHeyMnS7LtCGRZpntvZ27xm124qgNpzMziik9osaYi
         otL9OZl0EGPSTzxFJhjbIJCU+ATsr+YHoWtICRyk=
Date:   Thu, 24 Mar 2022 18:32:06 -0700
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com, peterx@redhat.com,
        jack@suse.cz, david@redhat.com, aarcange@redhat.com,
        namit@vmware.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] userfaultfd-provide-unmasked-address-on-page-fault.patch removed from -mm tree
Message-Id: <20220325013206.8B0B5C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: provide unmasked address on page-fault
has been removed from the -mm tree.  Its filename was
     userfaultfd-provide-unmasked-address-on-page-fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nadav Amit <namit@vmware.com>
Subject: userfaultfd: provide unmasked address on page-fault

Userfaultfd is supposed to provide the full address (i.e., unmasked) of
the faulting access back to userspace.  However, that is not the case for
quite some time.

Even running "userfaultfd_demo" from the userfaultfd man page provides the
wrong output (and contradicts the man page).  Notice that
"UFFD_EVENT_PAGEFAULT event" shows the masked address (7fc5e30b3000) and
not the first read address (0x7fc5e30b300f).

	Address returned by mmap() = 0x7fc5e30b3000

	fault_handler_thread():
	    poll() returns: nready = 1; POLLIN = 1; POLLERR = 0
	    UFFD_EVENT_PAGEFAULT event: flags = 0; address = 7fc5e30b3000
		(uffdio_copy.copy returned 4096)
	Read address 0x7fc5e30b300f in main(): A
	Read address 0x7fc5e30b340f in main(): A
	Read address 0x7fc5e30b380f in main(): A
	Read address 0x7fc5e30b3c0f in main(): A

The exact address is useful for various reasons and specifically for
prefetching decisions.  If it is known that the memory is populated by
certain objects whose size is not page-aligned, then based on the faulting
address, the uffd-monitor can decide whether to prefetch and prefault the
adjacent page.

This bug has been for quite some time in the kernel: since commit
1a29d85eb0f1 ("mm: use vmf->address instead of of vmf->virtual_address")
vmf->virtual_address"), which dates back to 2016.  A concern has been
raised that existing userspace application might rely on the old/wrong
behavior in which the address is masked.  Therefore, it was suggested to
provide the masked address unless the user explicitly asks for the exact
address.

Add a new userfaultfd feature UFFD_FEATURE_EXACT_ADDRESS to direct
userfaultfd to provide the exact address.  Add a new "real_address" field
to vmf to hold the unmasked address.  Provide the address to userspace
accordingly.

Initialize real_address in various code-paths to be consistent with
address, even when it is not used, to be on the safe side.

[namit@vmware.com: initialize real_address on all code paths, per Jan]
  Link: https://lkml.kernel.org/r/20220226022655.350562-1-namit@vmware.com
[akpm@linux-foundation.org: fix typo in comment, per Jan]
Link: https://lkml.kernel.org/r/20220218041003.3508-1-namit@vmware.com
Signed-off-by: Nadav Amit <namit@vmware.com>
Acked-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c                 |    5 ++++-
 include/linux/mm.h               |    3 ++-
 include/uapi/linux/userfaultfd.h |    8 +++++++-
 mm/hugetlb.c                     |    6 ++++--
 mm/memory.c                      |    1 +
 mm/swapfile.c                    |    1 +
 6 files changed, 19 insertions(+), 5 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-provide-unmasked-address-on-page-fault
+++ a/fs/userfaultfd.c
@@ -198,6 +198,9 @@ static inline struct uffd_msg userfault_
 	struct uffd_msg msg;
 	msg_init(&msg);
 	msg.event = UFFD_EVENT_PAGEFAULT;
+
+	if (!(features & UFFD_FEATURE_EXACT_ADDRESS))
+		address &= PAGE_MASK;
 	msg.arg.pagefault.address = address;
 	/*
 	 * These flags indicate why the userfault occurred:
@@ -482,7 +485,7 @@ vm_fault_t handle_userfault(struct vm_fa
 
 	init_waitqueue_func_entry(&uwq.wq, userfaultfd_wake_function);
 	uwq.wq.private = current;
-	uwq.msg = userfault_msg(vmf->address, vmf->flags, reason,
+	uwq.msg = userfault_msg(vmf->real_address, vmf->flags, reason,
 			ctx->features);
 	uwq.ctx = ctx;
 	uwq.waken = false;
--- a/include/linux/mm.h~userfaultfd-provide-unmasked-address-on-page-fault
+++ a/include/linux/mm.h
@@ -478,7 +478,8 @@ struct vm_fault {
 		struct vm_area_struct *vma;	/* Target VMA */
 		gfp_t gfp_mask;			/* gfp mask to be used for allocations */
 		pgoff_t pgoff;			/* Logical page offset based on vma */
-		unsigned long address;		/* Faulting virtual address */
+		unsigned long address;		/* Faulting virtual address - masked */
+		unsigned long real_address;	/* Faulting virtual address - unmasked */
 	};
 	enum fault_flag flags;		/* FAULT_FLAG_xxx flags
 					 * XXX: should really be 'const' */
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-provide-unmasked-address-on-page-fault
+++ a/include/uapi/linux/userfaultfd.h
@@ -32,7 +32,8 @@
 			   UFFD_FEATURE_SIGBUS |		\
 			   UFFD_FEATURE_THREAD_ID |		\
 			   UFFD_FEATURE_MINOR_HUGETLBFS |	\
-			   UFFD_FEATURE_MINOR_SHMEM)
+			   UFFD_FEATURE_MINOR_SHMEM |		\
+			   UFFD_FEATURE_EXACT_ADDRESS)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -189,6 +190,10 @@ struct uffdio_api {
 	 *
 	 * UFFD_FEATURE_MINOR_SHMEM indicates the same support as
 	 * UFFD_FEATURE_MINOR_HUGETLBFS, but for shmem-backed pages instead.
+	 *
+	 * UFFD_FEATURE_EXACT_ADDRESS indicates that the exact address of page
+	 * faults would be provided and the offset within the page would not be
+	 * masked.
 	 */
 #define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)
 #define UFFD_FEATURE_EVENT_FORK			(1<<1)
@@ -201,6 +206,7 @@ struct uffdio_api {
 #define UFFD_FEATURE_THREAD_ID			(1<<8)
 #define UFFD_FEATURE_MINOR_HUGETLBFS		(1<<9)
 #define UFFD_FEATURE_MINOR_SHMEM		(1<<10)
+#define UFFD_FEATURE_EXACT_ADDRESS		(1<<11)
 	__u64 features;
 
 	__u64 ioctls;
--- a/mm/hugetlb.c~userfaultfd-provide-unmasked-address-on-page-fault
+++ a/mm/hugetlb.c
@@ -5341,6 +5341,7 @@ static inline vm_fault_t hugetlb_handle_
 						  pgoff_t idx,
 						  unsigned int flags,
 						  unsigned long haddr,
+						  unsigned long addr,
 						  unsigned long reason)
 {
 	vm_fault_t ret;
@@ -5348,6 +5349,7 @@ static inline vm_fault_t hugetlb_handle_
 	struct vm_fault vmf = {
 		.vma = vma,
 		.address = haddr,
+		.real_address = addr,
 		.flags = flags,
 
 		/*
@@ -5416,7 +5418,7 @@ retry:
 		/* Check for page in userfault range */
 		if (userfaultfd_missing(vma)) {
 			ret = hugetlb_handle_userfault(vma, mapping, idx,
-						       flags, haddr,
+						       flags, haddr, address,
 						       VM_UFFD_MISSING);
 			goto out;
 		}
@@ -5480,7 +5482,7 @@ retry:
 			unlock_page(page);
 			put_page(page);
 			ret = hugetlb_handle_userfault(vma, mapping, idx,
-						       flags, haddr,
+						       flags, haddr, address,
 						       VM_UFFD_MINOR);
 			goto out;
 		}
--- a/mm/memory.c~userfaultfd-provide-unmasked-address-on-page-fault
+++ a/mm/memory.c
@@ -4633,6 +4633,7 @@ static vm_fault_t __handle_mm_fault(stru
 	struct vm_fault vmf = {
 		.vma = vma,
 		.address = address & PAGE_MASK,
+		.real_address = address,
 		.flags = flags,
 		.pgoff = linear_page_index(vma, address),
 		.gfp_mask = __get_fault_gfp_mask(vma),
--- a/mm/swapfile.c~userfaultfd-provide-unmasked-address-on-page-fault
+++ a/mm/swapfile.c
@@ -1951,6 +1951,7 @@ static int unuse_pte_range(struct vm_are
 			struct vm_fault vmf = {
 				.vma = vma,
 				.address = addr,
+				.real_address = addr,
 				.pmd = pmd,
 			};
 
_

Patches currently in -mm which might be from namit@vmware.com are

userfaultfd-mark-uffd_wp-regardless-of-vm_write-flag.patch

