Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF22C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 05:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiBVFcY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Feb 2022 00:32:24 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:59318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiBVFbx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Feb 2022 00:31:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7D7280
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 21:31:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56CAC615D8
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 05:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56C3C340E8;
        Tue, 22 Feb 2022 05:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645506232;
        bh=sok9lyhjnzwdCuMgu8iLA0xZjGgUPjSmF1HC1mlXz/0=;
        h=Date:To:From:Subject:From;
        b=aeKtRvpIme6wUUCxymE0aqv4p7mWYvB+X0qYLOQiIZNmgnKdpqowfjTfU6g3d3Iwh
         OZg6sLW9X3WRjo9T9k5eWSggA/RQyLn47h1IRJ7NLRve6zMR9/IN+QABdUtDjEPtt7
         2TlLr3KelAsdyjVVlq7sLKeCRElu1qa7Tj5b3dOI=
Date:   Mon, 21 Feb 2022 21:03:52 -0800
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com, peterx@redhat.com,
        jack@suse.cz, david@redhat.com, aarcange@redhat.com,
        namit@vmware.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-provide-unmasked-address-on-page-fault.patch added to -mm tree
Message-Id: <20220222050352.A56C3C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: provide unmasked address on page-fault
has been added to the -mm tree.  Its filename is
     userfaultfd-provide-unmasked-address-on-page-fault.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-provide-unmasked-address-on-page-fault.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-provide-unmasked-address-on-page-fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: https://lkml.kernel.org/r/20220218041003.3508-1-namit@vmware.com
Signed-off-by: Nadav Amit <namit@vmware.com>
Acked-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c                 |    5 ++++-
 include/linux/mm.h               |    3 ++-
 include/uapi/linux/userfaultfd.h |    8 +++++++-
 mm/memory.c                      |    1 +
 4 files changed, 14 insertions(+), 3 deletions(-)

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
@@ -472,7 +472,8 @@ struct vm_fault {
 		struct vm_area_struct *vma;	/* Target VMA */
 		gfp_t gfp_mask;			/* gfp mask to be used for allocations */
 		pgoff_t pgoff;			/* Logical page offset based on vma */
-		unsigned long address;		/* Faulting virtual address */
+		unsigned long address;		/* Faulting virtual address - masked */
+		unsigned long real_address;	/* Faulting virtual address - unmaked */
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
--- a/mm/memory.c~userfaultfd-provide-unmasked-address-on-page-fault
+++ a/mm/memory.c
@@ -4679,6 +4679,7 @@ static vm_fault_t __handle_mm_fault(stru
 	struct vm_fault vmf = {
 		.vma = vma,
 		.address = address & PAGE_MASK,
+		.real_address = address,
 		.flags = flags,
 		.pgoff = linear_page_index(vma, address),
 		.gfp_mask = __get_fault_gfp_mask(vma),
_

Patches currently in -mm which might be from namit@vmware.com are

userfaultfd-mark-uffd_wp-regardless-of-vm_write-flag.patch
userfaultfd-provide-unmasked-address-on-page-fault.patch

