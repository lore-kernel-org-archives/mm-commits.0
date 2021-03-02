Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59E83C433E0
	for <mm-commits@archiver.kernel.org>; Tue,  2 Mar 2021 21:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 015B764F21
	for <mm-commits@archiver.kernel.org>; Tue,  2 Mar 2021 21:12:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383540AbhCBVDf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 Mar 2021 16:03:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:47532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345073AbhCBA1z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Mar 2021 19:27:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B59860C3E;
        Tue,  2 Mar 2021 00:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614644785;
        bh=eIGlj8n1ZbZV7GPBS1so2gWhytsF7fFbqSTQrT7+aOs=;
        h=Date:From:To:Subject:From;
        b=T+LiaCFAMUgD0bZGvYKoeX3ub6Fs/0YtGXQL9e909WVUekgprv8+64t+09Kt4OiEh
         riULti4IBb+6bM1ihoYg93scQynhNq6avUC7RZ6OHT7qr8OtoGq+1A8rpVkTOre6zf
         2UzHDPjZcFzj1/w/GAtrDj7UIKt9tyI0NqOetu7I=
Date:   Mon, 01 Mar 2021 16:26:24 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, adobriyan@gmail.com, almasrymina@google.com,
        anshuman.khandual@arm.com, axelrasmussen@google.com,
        cannonmatthews@google.com, catalin.marinas@arm.com,
        chinwen.chang@mediatek.com, dgilbert@redhat.com, jannh@google.com,
        jglisse@redhat.com, kirill@shutemov.name, lokeshgidra@google.com,
        mike.kravetz@oracle.com, mingo@redhat.com, mkoutny@suse.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
        oupton@google.com, peterx@redhat.com, rientjes@google.com,
        rostedt@goodmis.org, rppt@linux.vnet.ibm.com, ruprecht@google.com,
        shawn@anastas.io, shli@fb.com, steven.price@arm.com,
        vbabka@suse.cz, viro@zeniv.linux.org.uk, walken@google.com,
        willy@infradead.org, ying.huang@intel.com
Subject:  + userfaultfd-add-minor-fault-registration-mode.patch
 added to -mm tree
Message-ID: <20210302002624.ANmtA2RnA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: add minor fault registration mode
has been added to the -mm tree.  Its filename is
     userfaultfd-add-minor-fault-registration-mode.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-add-minor-fault-registration-mode.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-add-minor-fault-registration-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd: add minor fault registration mode

Patch series "userfaultfd: add minor fault handling", v9.

Overview
========

This series adds a new userfaultfd feature, UFFD_FEATURE_MINOR_HUGETLBFS. 
When enabled (via the UFFDIO_API ioctl), this feature means that any
hugetlbfs VMAs registered with UFFDIO_REGISTER_MODE_MISSING will *also*
get events for "minor" faults.  By "minor" fault, I mean the following
situation:

Let there exist two mappings (i.e., VMAs) to the same page(s) (shared
memory).  One of the mappings is registered with userfaultfd (in minor
mode), and the other is not.  Via the non-UFFD mapping, the underlying
pages have already been allocated & filled with some contents.  The UFFD
mapping has not yet been faulted in; when it is touched for the first
time, this results in what I'm calling a "minor" fault.  As a concrete
example, when working with hugetlbfs, we have huge_pte_none(), but
find_lock_page() finds an existing page.

We also add a new ioctl to resolve such faults: UFFDIO_CONTINUE.  The idea
is, userspace resolves the fault by either a) doing nothing if the
contents are already correct, or b) updating the underlying contents using
the second, non-UFFD mapping (via memcpy/memset or similar, or something
fancier like RDMA, or etc...).  In either case, userspace issues
UFFDIO_CONTINUE to tell the kernel "I have ensured the page contents are
correct, carry on setting up the mapping".

Use Case
========

Consider the use case of VM live migration (e.g. under QEMU/KVM):

1. While a VM is still running, we copy the contents of its memory to a
   target machine. The pages are populated on the target by writing to the
   non-UFFD mapping, using the setup described above. The VM is still running
   (and therefore its memory is likely changing), so this may be repeated
   several times, until we decide the target is "up to date enough".

2. We pause the VM on the source, and start executing on the target machine.
   During this gap, the VM's user(s) will *see* a pause, so it is desirable to
   minimize this window.

3. Between the last time any page was copied from the source to the target, and
   when the VM was paused, the contents of that page may have changed - and
   therefore the copy we have on the target machine is out of date. Although we
   can keep track of which pages are out of date, for VMs with large amounts of
   memory, it is "slow" to transfer this information to the target machine. We
   want to resume execution before such a transfer would complete.

4. So, the guest begins executing on the target machine. The first time it
   touches its memory (via the UFFD-registered mapping), userspace wants to
   intercept this fault. Userspace checks whether or not the page is up to date,
   and if not, copies the updated page from the source machine, via the non-UFFD
   mapping. Finally, whether a copy was performed or not, userspace issues a
   UFFDIO_CONTINUE ioctl to tell the kernel "I have ensured the page contents
   are correct, carry on setting up the mapping".

We don't have to do all of the final updates on-demand. The userfaultfd manager
can, in the background, also copy over updated pages once it receives the map of
which pages are up-to-date or not.

Interaction with Existing APIs
==============================

Because this is a feature, a registered VMA could potentially receive both
missing and minor faults.  I spent some time thinking through how the
existing API interacts with the new feature:

UFFDIO_CONTINUE cannot be used to resolve non-minor faults, as it does not
allocate a new page.  If UFFDIO_CONTINUE is used on a non-minor fault:

- For non-shared memory or shmem, -EINVAL is returned.
- For hugetlb, -EFAULT is returned.

UFFDIO_COPY and UFFDIO_ZEROPAGE cannot be used to resolve minor faults. 
Without modifications, the existing codepath assumes a new page needs to
be allocated.  This is okay, since userspace must have a second
non-UFFD-registered mapping anyway, thus there isn't much reason to want
to use these in any case (just memcpy or memset or similar).

- If UFFDIO_COPY is used on a minor fault, -EEXIST is returned.
- If UFFDIO_ZEROPAGE is used on a minor fault, -EEXIST is returned (or -EINVAL
  in the case of hugetlb, as UFFDIO_ZEROPAGE is unsupported in any case).
- UFFDIO_WRITEPROTECT simply doesn't work with shared memory, and returns
  -ENOENT in that case (regardless of the kind of fault).

Future Work
===========

This series only supports hugetlbfs.  I have a second series in flight to
support shmem as well, extending the functionality.  This series is more
mature than the shmem support at this point, and the functionality works
fully on hugetlbfs, so this series can be merged first and then shmem
support will follow.


This patch (of 6):

This feature allows userspace to intercept "minor" faults.  By "minor"
faults, I mean the following situation:

Let there exist two mappings (i.e., VMAs) to the same page(s).  One of the
mappings is registered with userfaultfd (in minor mode), and the other is
not.  Via the non-UFFD mapping, the underlying pages have already been
allocated & filled with some contents.  The UFFD mapping has not yet been
faulted in; when it is touched for the first time, this results in what
I'm calling a "minor" fault.  As a concrete example, when working with
hugetlbfs, we have huge_pte_none(), but find_lock_page() finds an existing
page.

This commit adds the new registration mode, and sets the relevant flag on
the VMAs being registered.  In the hugetlb fault path, if we find that we
have huge_pte_none(), but find_lock_page() does indeed find an existing
page, then we have a "minor" fault, and if the VMA has the userfaultfd
registration flag, we call into userfaultfd to handle it.

This is implemented as a new registration mode, instead of an API feature.
This is because the alternative implementation has significant drawbacks
[1].

However, doing it this was requires we allocate a VM_* flag for the new
registration mode.  On 32-bit systems, there are no unused bits, so this
feature is only supported on architectures with
CONFIG_ARCH_USES_HIGH_VMA_FLAGS.  When attempting to register a VMA in
MINOR mode on 32-bit architectures, we return -EINVAL.

[1] https://lore.kernel.org/patchwork/patch/1380226/

Link: https://lkml.kernel.org/r/20210301222728.176417-1-axelrasmussen@google.com
Link: https://lkml.kernel.org/r/20210301222728.176417-2-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michal Koutn" <mkoutny@suse.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shawn Anastasio <shawn@anastas.io>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Steven Price <steven.price@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Adam Ruprecht <ruprecht@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Cannon Matthews <cannonmatthews@google.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig               |    1 
 arch/x86/Kconfig                 |    1 
 fs/proc/task_mmu.c               |    3 +
 fs/userfaultfd.c                 |   78 +++++++++++++++++-----------
 include/linux/mm.h               |    7 ++
 include/linux/userfaultfd_k.h    |   15 +++++
 include/trace/events/mmflags.h   |    7 ++
 include/uapi/linux/userfaultfd.h |   15 ++++-
 init/Kconfig                     |    5 +
 mm/hugetlb.c                     |   79 ++++++++++++++++++-----------
 10 files changed, 149 insertions(+), 62 deletions(-)

--- a/arch/arm64/Kconfig~userfaultfd-add-minor-fault-registration-mode
+++ a/arch/arm64/Kconfig
@@ -208,6 +208,7 @@ config ARM64
 	select SWIOTLB
 	select SYSCTL_EXCEPTION_TRACE
 	select THREAD_INFO_IN_TASK
+	select HAVE_ARCH_USERFAULTFD_MINOR if USERFAULTFD
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
--- a/arch/x86/Kconfig~userfaultfd-add-minor-fault-registration-mode
+++ a/arch/x86/Kconfig
@@ -164,6 +164,7 @@ config X86
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD if X86_64
 	select HAVE_ARCH_USERFAULTFD_WP         if X86_64 && USERFAULTFD
+	select HAVE_ARCH_USERFAULTFD_MINOR	if X86_64 && USERFAULTFD
 	select HAVE_ARCH_VMAP_STACK		if X86_64
 	select HAVE_ARCH_WITHIN_STACK_FRAMES
 	select HAVE_ASM_MODVERSIONS
--- a/fs/proc/task_mmu.c~userfaultfd-add-minor-fault-registration-mode
+++ a/fs/proc/task_mmu.c
@@ -661,6 +661,9 @@ static void show_smap_vma_flags(struct s
 		[ilog2(VM_PKEY_BIT4)]	= "",
 #endif
 #endif /* CONFIG_ARCH_HAS_PKEYS */
+#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
+		[ilog2(VM_UFFD_MINOR)]	= "ui",
+#endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
 	};
 	size_t i;
 
--- a/fs/userfaultfd.c~userfaultfd-add-minor-fault-registration-mode
+++ a/fs/userfaultfd.c
@@ -197,24 +197,21 @@ static inline struct uffd_msg userfault_
 	msg_init(&msg);
 	msg.event = UFFD_EVENT_PAGEFAULT;
 	msg.arg.pagefault.address = address;
+	/*
+	 * These flags indicate why the userfault occurred:
+	 * - UFFD_PAGEFAULT_FLAG_WP indicates a write protect fault.
+	 * - UFFD_PAGEFAULT_FLAG_MINOR indicates a minor fault.
+	 * - Neither of these flags being set indicates a MISSING fault.
+	 *
+	 * Separately, UFFD_PAGEFAULT_FLAG_WRITE indicates it was a write
+	 * fault. Otherwise, it was a read fault.
+	 */
 	if (flags & FAULT_FLAG_WRITE)
-		/*
-		 * If UFFD_FEATURE_PAGEFAULT_FLAG_WP was set in the
-		 * uffdio_api.features and UFFD_PAGEFAULT_FLAG_WRITE
-		 * was not set in a UFFD_EVENT_PAGEFAULT, it means it
-		 * was a read fault, otherwise if set it means it's
-		 * a write fault.
-		 */
 		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_WRITE;
 	if (reason & VM_UFFD_WP)
-		/*
-		 * If UFFD_FEATURE_PAGEFAULT_FLAG_WP was set in the
-		 * uffdio_api.features and UFFD_PAGEFAULT_FLAG_WP was
-		 * not set in a UFFD_EVENT_PAGEFAULT, it means it was
-		 * a missing fault, otherwise if set it means it's a
-		 * write protect fault.
-		 */
 		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_WP;
+	if (reason & VM_UFFD_MINOR)
+		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_MINOR;
 	if (features & UFFD_FEATURE_THREAD_ID)
 		msg.arg.pagefault.feat.ptid = task_pid_vnr(current);
 	return msg;
@@ -401,8 +398,10 @@ vm_fault_t handle_userfault(struct vm_fa
 
 	BUG_ON(ctx->mm != mm);
 
-	VM_BUG_ON(reason & ~(VM_UFFD_MISSING|VM_UFFD_WP));
-	VM_BUG_ON(!(reason & VM_UFFD_MISSING) ^ !!(reason & VM_UFFD_WP));
+	/* Any unrecognized flag is a bug. */
+	VM_BUG_ON(reason & ~__VM_UFFD_FLAGS);
+	/* 0 or > 1 flags set is a bug; we expect exactly 1. */
+	VM_BUG_ON(!reason || (reason & (reason - 1)));
 
 	if (ctx->features & UFFD_FEATURE_SIGBUS)
 		goto out;
@@ -612,7 +611,7 @@ static void userfaultfd_event_wait_compl
 		for (vma = mm->mmap; vma; vma = vma->vm_next)
 			if (vma->vm_userfaultfd_ctx.ctx == release_new_ctx) {
 				vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
-				vma->vm_flags &= ~(VM_UFFD_WP | VM_UFFD_MISSING);
+				vma->vm_flags &= ~__VM_UFFD_FLAGS;
 			}
 		mmap_write_unlock(mm);
 
@@ -644,7 +643,7 @@ int dup_userfaultfd(struct vm_area_struc
 	octx = vma->vm_userfaultfd_ctx.ctx;
 	if (!octx || !(octx->features & UFFD_FEATURE_EVENT_FORK)) {
 		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
-		vma->vm_flags &= ~(VM_UFFD_WP | VM_UFFD_MISSING);
+		vma->vm_flags &= ~__VM_UFFD_FLAGS;
 		return 0;
 	}
 
@@ -726,7 +725,7 @@ void mremap_userfaultfd_prep(struct vm_a
 	} else {
 		/* Drop uffd context if remap feature not enabled */
 		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
-		vma->vm_flags &= ~(VM_UFFD_WP | VM_UFFD_MISSING);
+		vma->vm_flags &= ~__VM_UFFD_FLAGS;
 	}
 }
 
@@ -867,12 +866,12 @@ static int userfaultfd_release(struct in
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		cond_resched();
 		BUG_ON(!!vma->vm_userfaultfd_ctx.ctx ^
-		       !!(vma->vm_flags & (VM_UFFD_MISSING | VM_UFFD_WP)));
+		       !!(vma->vm_flags & __VM_UFFD_FLAGS));
 		if (vma->vm_userfaultfd_ctx.ctx != ctx) {
 			prev = vma;
 			continue;
 		}
-		new_flags = vma->vm_flags & ~(VM_UFFD_MISSING | VM_UFFD_WP);
+		new_flags = vma->vm_flags & ~__VM_UFFD_FLAGS;
 		prev = vma_merge(mm, prev, vma->vm_start, vma->vm_end,
 				 new_flags, vma->anon_vma,
 				 vma->vm_file, vma->vm_pgoff,
@@ -1262,9 +1261,19 @@ static inline bool vma_can_userfault(str
 				     unsigned long vm_flags)
 {
 	/* FIXME: add WP support to hugetlbfs and shmem */
-	return vma_is_anonymous(vma) ||
-		((is_vm_hugetlb_page(vma) || vma_is_shmem(vma)) &&
-		 !(vm_flags & VM_UFFD_WP));
+	if (vm_flags & VM_UFFD_WP) {
+		if (is_vm_hugetlb_page(vma) || vma_is_shmem(vma))
+			return false;
+	}
+
+	if (vm_flags & VM_UFFD_MINOR) {
+		/* FIXME: Add minor fault interception for shmem. */
+		if (!is_vm_hugetlb_page(vma))
+			return false;
+	}
+
+	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
+	       vma_is_shmem(vma);
 }
 
 static int userfaultfd_register(struct userfaultfd_ctx *ctx,
@@ -1290,14 +1299,19 @@ static int userfaultfd_register(struct u
 	ret = -EINVAL;
 	if (!uffdio_register.mode)
 		goto out;
-	if (uffdio_register.mode & ~(UFFDIO_REGISTER_MODE_MISSING|
-				     UFFDIO_REGISTER_MODE_WP))
+	if (uffdio_register.mode & ~UFFD_API_REGISTER_MODES)
 		goto out;
 	vm_flags = 0;
 	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_MISSING)
 		vm_flags |= VM_UFFD_MISSING;
 	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_WP)
 		vm_flags |= VM_UFFD_WP;
+	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_MINOR) {
+#ifndef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
+		goto out;
+#endif
+		vm_flags |= VM_UFFD_MINOR;
+	}
 
 	ret = validate_range(mm, &uffdio_register.range.start,
 			     uffdio_register.range.len);
@@ -1341,7 +1355,7 @@ static int userfaultfd_register(struct u
 		cond_resched();
 
 		BUG_ON(!!cur->vm_userfaultfd_ctx.ctx ^
-		       !!(cur->vm_flags & (VM_UFFD_MISSING | VM_UFFD_WP)));
+		       !!(cur->vm_flags & __VM_UFFD_FLAGS));
 
 		/* check not compatible vmas */
 		ret = -EINVAL;
@@ -1421,8 +1435,7 @@ static int userfaultfd_register(struct u
 			start = vma->vm_start;
 		vma_end = min(end, vma->vm_end);
 
-		new_flags = (vma->vm_flags &
-			     ~(VM_UFFD_MISSING|VM_UFFD_WP)) | vm_flags;
+		new_flags = (vma->vm_flags & ~__VM_UFFD_FLAGS) | vm_flags;
 		prev = vma_merge(mm, prev, start, vma_end, new_flags,
 				 vma->anon_vma, vma->vm_file, vma->vm_pgoff,
 				 vma_policy(vma),
@@ -1544,7 +1557,7 @@ static int userfaultfd_unregister(struct
 		cond_resched();
 
 		BUG_ON(!!cur->vm_userfaultfd_ctx.ctx ^
-		       !!(cur->vm_flags & (VM_UFFD_MISSING | VM_UFFD_WP)));
+		       !!(cur->vm_flags & __VM_UFFD_FLAGS));
 
 		/*
 		 * Check not compatible vmas, not strictly required
@@ -1595,7 +1608,7 @@ static int userfaultfd_unregister(struct
 			wake_userfault(vma->vm_userfaultfd_ctx.ctx, &range);
 		}
 
-		new_flags = vma->vm_flags & ~(VM_UFFD_MISSING | VM_UFFD_WP);
+		new_flags = vma->vm_flags & ~__VM_UFFD_FLAGS;
 		prev = vma_merge(mm, prev, start, vma_end, new_flags,
 				 vma->anon_vma, vma->vm_file, vma->vm_pgoff,
 				 vma_policy(vma),
@@ -1863,6 +1876,9 @@ static int userfaultfd_api(struct userfa
 		goto err_out;
 	/* report all available features and ioctls to userland */
 	uffdio_api.features = UFFD_API_FEATURES;
+#ifndef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
+	uffdio_api.features &= ~UFFD_FEATURE_MINOR_HUGETLBFS;
+#endif
 	uffdio_api.ioctls = UFFD_API_IOCTLS;
 	ret = -EFAULT;
 	if (copy_to_user(buf, &uffdio_api, sizeof(uffdio_api)))
--- a/include/linux/mm.h~userfaultfd-add-minor-fault-registration-mode
+++ a/include/linux/mm.h
@@ -362,6 +362,13 @@ extern unsigned int kobjsize(const void
 # define VM_GROWSUP	VM_NONE
 #endif
 
+#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
+# define VM_UFFD_MINOR_BIT	37
+# define VM_UFFD_MINOR		BIT(VM_UFFD_MINOR_BIT)	/* UFFD minor faults */
+#else /* !CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
+# define VM_UFFD_MINOR		VM_NONE
+#endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
+
 /* Bits set in the VMA until the stack is in its final location */
 #define VM_STACK_INCOMPLETE_SETUP	(VM_RAND_READ | VM_SEQ_READ)
 
--- a/include/linux/userfaultfd_k.h~userfaultfd-add-minor-fault-registration-mode
+++ a/include/linux/userfaultfd_k.h
@@ -17,6 +17,9 @@
 #include <linux/mm.h>
 #include <asm-generic/pgtable_uffd.h>
 
+/* The set of all possible UFFD-related VM flags. */
+#define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_WP | VM_UFFD_MINOR)
+
 /*
  * CAREFUL: Check include/uapi/asm-generic/fcntl.h when defining
  * new flags, since they might collide with O_* ones. We want
@@ -71,6 +74,11 @@ static inline bool userfaultfd_wp(struct
 	return vma->vm_flags & VM_UFFD_WP;
 }
 
+static inline bool userfaultfd_minor(struct vm_area_struct *vma)
+{
+	return vma->vm_flags & VM_UFFD_MINOR;
+}
+
 static inline bool userfaultfd_pte_wp(struct vm_area_struct *vma,
 				      pte_t pte)
 {
@@ -85,7 +93,7 @@ static inline bool userfaultfd_huge_pmd_
 
 static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 {
-	return vma->vm_flags & (VM_UFFD_MISSING | VM_UFFD_WP);
+	return vma->vm_flags & __VM_UFFD_FLAGS;
 }
 
 extern int dup_userfaultfd(struct vm_area_struct *, struct list_head *);
@@ -131,6 +139,11 @@ static inline bool userfaultfd_wp(struct
 {
 	return false;
 }
+
+static inline bool userfaultfd_minor(struct vm_area_struct *vma)
+{
+	return false;
+}
 
 static inline bool userfaultfd_pte_wp(struct vm_area_struct *vma,
 				      pte_t pte)
--- a/include/trace/events/mmflags.h~userfaultfd-add-minor-fault-registration-mode
+++ a/include/trace/events/mmflags.h
@@ -137,6 +137,12 @@ IF_HAVE_PG_ARCH_2(PG_arch_2,		"arch_2"	)
 #define IF_HAVE_VM_SOFTDIRTY(flag,name)
 #endif
 
+#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
+# define IF_HAVE_UFFD_MINOR(flag, name) {flag, name},
+#else
+# define IF_HAVE_UFFD_MINOR(flag, name)
+#endif
+
 #define __def_vmaflag_names						\
 	{VM_READ,			"read"		},		\
 	{VM_WRITE,			"write"		},		\
@@ -148,6 +154,7 @@ IF_HAVE_PG_ARCH_2(PG_arch_2,		"arch_2"	)
 	{VM_MAYSHARE,			"mayshare"	},		\
 	{VM_GROWSDOWN,			"growsdown"	},		\
 	{VM_UFFD_MISSING,		"uffd_missing"	},		\
+IF_HAVE_UFFD_MINOR(VM_UFFD_MINOR,	"uffd_minor"	)		\
 	{VM_PFNMAP,			"pfnmap"	},		\
 	{VM_DENYWRITE,			"denywrite"	},		\
 	{VM_UFFD_WP,			"uffd_wp"	},		\
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-add-minor-fault-registration-mode
+++ a/include/uapi/linux/userfaultfd.h
@@ -19,15 +19,19 @@
  * means the userland is reading).
  */
 #define UFFD_API ((__u64)0xAA)
+#define UFFD_API_REGISTER_MODES (UFFDIO_REGISTER_MODE_MISSING |	\
+				 UFFDIO_REGISTER_MODE_WP |	\
+				 UFFDIO_REGISTER_MODE_MINOR)
 #define UFFD_API_FEATURES (UFFD_FEATURE_PAGEFAULT_FLAG_WP |	\
 			   UFFD_FEATURE_EVENT_FORK |		\
 			   UFFD_FEATURE_EVENT_REMAP |		\
-			   UFFD_FEATURE_EVENT_REMOVE |	\
+			   UFFD_FEATURE_EVENT_REMOVE |		\
 			   UFFD_FEATURE_EVENT_UNMAP |		\
 			   UFFD_FEATURE_MISSING_HUGETLBFS |	\
 			   UFFD_FEATURE_MISSING_SHMEM |		\
 			   UFFD_FEATURE_SIGBUS |		\
-			   UFFD_FEATURE_THREAD_ID)
+			   UFFD_FEATURE_THREAD_ID |		\
+			   UFFD_FEATURE_MINOR_HUGETLBFS)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -127,6 +131,7 @@ struct uffd_msg {
 /* flags for UFFD_EVENT_PAGEFAULT */
 #define UFFD_PAGEFAULT_FLAG_WRITE	(1<<0)	/* If this was a write fault */
 #define UFFD_PAGEFAULT_FLAG_WP		(1<<1)	/* If reason is VM_UFFD_WP */
+#define UFFD_PAGEFAULT_FLAG_MINOR	(1<<2)	/* If reason is VM_UFFD_MINOR */
 
 struct uffdio_api {
 	/* userland asks for an API number and the features to enable */
@@ -171,6 +176,10 @@ struct uffdio_api {
 	 *
 	 * UFFD_FEATURE_THREAD_ID pid of the page faulted task_struct will
 	 * be returned, if feature is not requested 0 will be returned.
+	 *
+	 * UFFD_FEATURE_MINOR_HUGETLBFS indicates that minor faults
+	 * can be intercepted (via REGISTER_MODE_MINOR) for
+	 * hugetlbfs-backed pages.
 	 */
 #define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)
 #define UFFD_FEATURE_EVENT_FORK			(1<<1)
@@ -181,6 +190,7 @@ struct uffdio_api {
 #define UFFD_FEATURE_EVENT_UNMAP		(1<<6)
 #define UFFD_FEATURE_SIGBUS			(1<<7)
 #define UFFD_FEATURE_THREAD_ID			(1<<8)
+#define UFFD_FEATURE_MINOR_HUGETLBFS		(1<<9)
 	__u64 features;
 
 	__u64 ioctls;
@@ -195,6 +205,7 @@ struct uffdio_register {
 	struct uffdio_range range;
 #define UFFDIO_REGISTER_MODE_MISSING	((__u64)1<<0)
 #define UFFDIO_REGISTER_MODE_WP		((__u64)1<<1)
+#define UFFDIO_REGISTER_MODE_MINOR	((__u64)1<<2)
 	__u64 mode;
 
 	/*
--- a/init/Kconfig~userfaultfd-add-minor-fault-registration-mode
+++ a/init/Kconfig
@@ -1627,6 +1627,11 @@ config HAVE_ARCH_USERFAULTFD_WP
 	help
 	  Arch has userfaultfd write protection support
 
+config HAVE_ARCH_USERFAULTFD_MINOR
+	bool
+	help
+	  Arch has userfaultfd minor fault support
+
 config MEMBARRIER
 	bool "Enable membarrier() system call" if EXPERT
 	default y
--- a/mm/hugetlb.c~userfaultfd-add-minor-fault-registration-mode
+++ a/mm/hugetlb.c
@@ -4230,6 +4230,44 @@ int huge_add_to_page_cache(struct page *
 	return 0;
 }
 
+static inline vm_fault_t hugetlb_handle_userfault(struct vm_area_struct *vma,
+						  struct address_space *mapping,
+						  pgoff_t idx,
+						  unsigned int flags,
+						  unsigned long haddr,
+						  unsigned long reason)
+{
+	vm_fault_t ret;
+	u32 hash;
+	struct vm_fault vmf = {
+		.vma = vma,
+		.address = haddr,
+		.flags = flags,
+
+		/*
+		 * Hard to debug if it ends up being
+		 * used by a callee that assumes
+		 * something about the other
+		 * uninitialized fields... same as in
+		 * memory.c
+		 */
+	};
+
+	/*
+	 * hugetlb_fault_mutex and i_mmap_rwsem must be
+	 * dropped before handling userfault.  Reacquire
+	 * after handling fault to make calling code simpler.
+	 */
+	hash = hugetlb_fault_mutex_hash(mapping, idx);
+	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+	i_mmap_unlock_read(mapping);
+	ret = handle_userfault(&vmf, reason);
+	i_mmap_lock_read(mapping);
+	mutex_lock(&hugetlb_fault_mutex_table[hash]);
+
+	return ret;
+}
+
 static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 			struct vm_area_struct *vma,
 			struct address_space *mapping, pgoff_t idx,
@@ -4268,35 +4306,11 @@ static vm_fault_t hugetlb_no_page(struct
 retry:
 	page = find_lock_page(mapping, idx);
 	if (!page) {
-		/*
-		 * Check for page in userfault range
-		 */
+		/* Check for page in userfault range */
 		if (userfaultfd_missing(vma)) {
-			u32 hash;
-			struct vm_fault vmf = {
-				.vma = vma,
-				.address = haddr,
-				.flags = flags,
-				/*
-				 * Hard to debug if it ends up being
-				 * used by a callee that assumes
-				 * something about the other
-				 * uninitialized fields... same as in
-				 * memory.c
-				 */
-			};
-
-			/*
-			 * hugetlb_fault_mutex and i_mmap_rwsem must be
-			 * dropped before handling userfault.  Reacquire
-			 * after handling fault to make calling code simpler.
-			 */
-			hash = hugetlb_fault_mutex_hash(mapping, idx);
-			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
-			i_mmap_unlock_read(mapping);
-			ret = handle_userfault(&vmf, VM_UFFD_MISSING);
-			i_mmap_lock_read(mapping);
-			mutex_lock(&hugetlb_fault_mutex_table[hash]);
+			ret = hugetlb_handle_userfault(vma, mapping, idx,
+						       flags, haddr,
+						       VM_UFFD_MISSING);
 			goto out;
 		}
 
@@ -4355,6 +4369,15 @@ retry:
 				VM_FAULT_SET_HINDEX(hstate_index(h));
 			goto backout_unlocked;
 		}
+
+		/* Check for page in userfault range. */
+		if (userfaultfd_minor(vma)) {
+			unlock_page(page);
+			ret = hugetlb_handle_userfault(vma, mapping, idx,
+						       flags, haddr,
+						       VM_UFFD_MINOR);
+			goto out;
+		}
 	}
 
 	/*
_

Patches currently in -mm which might be from axelrasmussen@google.com are

userfaultfd-add-minor-fault-registration-mode.patch
userfaultfd-disable-huge-pmd-sharing-for-minor-registered-vmas.patch
userfaultfd-hugetlbfs-only-compile-uffd-helpers-if-config-enabled.patch
userfaultfd-add-uffdio_continue-ioctl.patch
userfaultfd-update-documentation-to-describe-minor-fault-handling.patch
userfaultfd-selftests-add-test-exercising-minor-fault-handling.patch

