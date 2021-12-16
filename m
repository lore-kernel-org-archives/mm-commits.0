Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93472C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 16 Dec 2021 22:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbhLPWh3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Dec 2021 17:37:29 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51414 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbhLPWh2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Dec 2021 17:37:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 747E561F92
        for <mm-commits@vger.kernel.org>; Thu, 16 Dec 2021 22:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B77C36AE2;
        Thu, 16 Dec 2021 22:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639694247;
        bh=vl6TELIiwwjdInJt7qNL5l6XPgy2WjNhGv6J0wL+qf0=;
        h=Date:From:To:Subject:From;
        b=k/KIqY/KVAGMLHXCeQhe0Vxzbm/xie/JWiDdL2YBprqoUIw5Emy42LE4MysfTWT4E
         1RBa8z3vRPe/jEd8VN7a0QI+OkhgiCYtlGDRNvin2oTvBjK/OsA126UXJM+eL18/pZ
         /11/BGrL4BczWdvQihmzAtsKOC37mS/J7EsizMkE=
Date:   Thu, 16 Dec 2021 14:37:27 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, luto@kernel.org, corbet@lwn.net,
        skhan@linuxfoundation.org
Subject:  + docs-vm-add-vmalloced-kernel-stacks-document.patch added
 to -mm tree
Message-ID: <20211216223727.2SCHz%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs/vm: add vmalloced-kernel-stacks document
has been added to the -mm tree.  Its filename is
     docs-vm-add-vmalloced-kernel-stacks-document.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/docs-vm-add-vmalloced-kernel-stacks-document.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/docs-vm-add-vmalloced-kernel-stacks-document.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shuah Khan <skhan@linuxfoundation.org>
Subject: docs/vm: add vmalloced-kernel-stacks document

Add a new document to explain Virtually Mapped Kernel Stack Support.  This
is a compilation of information from the code and original patch series
that introduced the Virtually Mapped Kernel Stacks feature.

This document summarizes the feature and provides details on allocation,
free, and stack overflow handling.  Provides reference to available tests.

Link: https://lkml.kernel.org/r/20211215002004.47981-1-skhan@linuxfoundation.org
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/index.rst                   |    1 
 Documentation/vm/vmalloced-kernel-stacks.rst |  153 +++++++++++++++++
 2 files changed, 154 insertions(+)

--- a/Documentation/vm/index.rst~docs-vm-add-vmalloced-kernel-stacks-document
+++ a/Documentation/vm/index.rst
@@ -37,5 +37,6 @@ algorithms.  If you are looking for advi
    split_page_table_lock
    transhuge
    unevictable-lru
+   vmalloced-kernel-stacks
    z3fold
    zsmalloc
--- /dev/null
+++ a/Documentation/vm/vmalloced-kernel-stacks.rst
@@ -0,0 +1,153 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=====================================
+Virtually Mapped Kernel Stack Support
+=====================================
+
+:Author: Shuah Khan <skhan@linuxfoundation.org>
+
+.. contents:: :local:
+
+Overview
+--------
+
+This is a compilation of information from the code and original patch
+series that introduced the `Virtually Mapped Kernel Stacks feature
+<https://lwn.net/Articles/694348/>`
+
+Introduction
+------------
+
+Kernel stack overflows are often hard to debug and make the kernel
+susceptible to exploits. Problems could show up at a later time making
+it difficult to isolate and root-cause.
+
+Virtually-mapped kernel stacks with guard pages causes kernel stack
+overflows to be caught immediately rather than causing difficult to
+diagnose corruptions.
+
+HAVE_ARCH_VMAP_STACK and VMAP_STACK configuration options enable
+support for virtually mapped stacks with guard pages. This feature
+causes reliable faults when the stack overflows. The usability of
+the stack trace after overflow and response to the overflow itself
+is architecture dependent.
+
+.. note::
+        As of this writing, arm64, powerpc, riscv, s390, um, and x86 have
+        support for VMAP_STACK.
+
+HAVE_ARCH_VMAP_STACK
+--------------------
+
+Architectures that can support Virtually Mapped Kernel Stacks should
+enable this bool configuration option. The requirements are:
+
+- vmalloc space must be large enough to hold many kernel stacks. This
+  may rule out many 32-bit architectures.
+- Stacks in vmalloc space need to work reliably.  For example, if
+  vmap page tables are created on demand, either this mechanism
+  needs to work while the stack points to a virtual address with
+  unpopulated page tables or arch code (switch_to() and switch_mm(),
+  most likely) needs to ensure that the stack's page table entries
+  are populated before running on a possibly unpopulated stack.
+- If the stack overflows into a guard page, something reasonable
+  should happen. The definition of "reasonable" is flexible, but
+  instantly rebooting without logging anything would be unfriendly.
+
+VMAP_STACK
+----------
+
+VMAP_STACK bool configuration option when enabled allocates virtually
+mapped task stacks. This option depends on HAVE_ARCH_VMAP_STACK.
+
+- Enable this if you want the use virtually-mapped kernel stacks
+  with guard pages. This causes kernel stack overflows to be caught
+  immediately rather than causing difficult-to-diagnose corruption.
+
+.. note::
+
+        Using this feature with KASAN requires architecture support
+        for backing virtual mappings with real shadow memory, and
+        KASAN_VMALLOC must be enabled.
+
+.. note::
+
+        VMAP_STACK is enabled, it is not possible to run DMA on stack
+        allocated data.
+
+Kernel configuration options and dependencies keep changing. Refer to
+the latest code base:
+
+`Kconfig <https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/Kconfig>`
+
+Allocation
+-----------
+
+When a new kernel thread is created, thread stack is allocated from
+virtually contiguous memory pages from the page level allocator. These
+pages are mapped into contiguous kernel virtual space with PAGE_KERNEL
+protections.
+
+alloc_thread_stack_node() calls __vmalloc_node_range() to allocate stack
+with PAGE_KERNEL protections.
+
+- Allocated stacks are cached and later reused by new threads, so memcg
+  accounting is performed manually on assigning/releasing stacks to tasks.
+  Hence, __vmalloc_node_range is called without __GFP_ACCOUNT.
+- vm_struct is cached to be able to find when thread free is initiated
+  in interrupt context. free_thread_stack() can be called in interrupt
+  context.
+- On arm64, all VMAP's stacks need to have the same alignment to ensure
+  that VMAP'd stack overflow detection works correctly. Arch specific
+  vmap stack allocator takes care of this detail.
+- This does not address interrupt stacks - according to the original patch
+
+Thread stack allocation is initiated from clone(), fork(), vfork(),
+kernel_thread() via kernel_clone(). Leaving a few hints for searching
+the code base to understand when and how thread stack is allocated.
+
+Bulk of the code is in:
+`kernel/fork.c <https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/kernel/fork.c>`.
+
+stack_vm_area pointer in task_struct keeps track of the virtually allocated
+stack and a non-null stack_vm_area pointer serves as a indication that the
+virtually mapped kernel stacks are enabled.
+
+::
+
+        struct vm_struct *stack_vm_area;
+
+Stack overflow handling
+-----------------------
+
+Leading and trailing guard pages help detect stack overflows. When stack
+overflows into the guard pages, handlers have to be careful not overflow
+the stack again. When handlers are called, it is likely that very little
+stack space is left.
+
+On x86, this is done by handling the page fault indicating the kernel
+stack overflow on the double-fault stack.
+
+Testing VMAP allocation with guard pages
+----------------------------------------
+
+How do we ensure that VMAP_STACK is actually allocating with a leading
+and trailing guard page? The following lkdtm tests can help detect any
+regressions.
+
+::
+
+        void lkdtm_STACK_GUARD_PAGE_LEADING()
+        void lkdtm_STACK_GUARD_PAGE_TRAILING()
+
+Conclusions
+-----------
+
+- A percpu cache of vmalloced stacks appears to be a bit faster than a
+  high-order stack allocation, at least when the cache hits.
+- THREAD_INFO_IN_TASK gets rid of arch-specific thread_info entirely and
+  simply embed the thread_info (containing only flags) and 'int cpu' into
+  task_struct.
+- The thread stack can be free'ed as soon as the task is dead (without
+  waiting for RCU) and then, if vmapped stacks are in use, cache the
+  entire stack for reuse on the same cpu.
_

Patches currently in -mm which might be from skhan@linuxfoundation.org are

docs-vm-fix-unexpected-indentation-warns-in-page_owner.patch
docs-vm-add-vmalloced-kernel-stacks-document.patch

