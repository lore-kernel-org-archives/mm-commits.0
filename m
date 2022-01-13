Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2E9C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jan 2022 01:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbiAMBmx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Jan 2022 20:42:53 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59586 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbiAMBmv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jan 2022 20:42:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BE4B601E3
        for <mm-commits@vger.kernel.org>; Thu, 13 Jan 2022 01:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6609C36AE9;
        Thu, 13 Jan 2022 01:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642038171;
        bh=oZpW5TXJ45iozwKT5ytJV5Vr+FP04xO8e10E55exauU=;
        h=Date:From:To:Subject:From;
        b=cjhAf9UOQJBEnEioweXcjfMINlYngNbPgyIZg8QaGKEs/9avz+qsCIMUUFibH8sA7
         46mWUlSnfO6T4m8bxnEw0/pPAD15gRI4OQCW4wWJ6N4tFr4xgp0LMN3sF9zyDgnVmA
         My+imd2cLh4pFjCje7TII2xi3pwaDNC8kEk6ZPes=
Date:   Wed, 12 Jan 2022 17:42:50 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + arch-x86-include-asm-pgtableh-needs-spinlockh.patch
 added to -mm tree
Message-ID: <20220113014250.ZOFoQZ2pL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/include/asm/pgtable.h needs spinlock.h
has been added to the -mm tree.  Its filename is
     arch-x86-include-asm-pgtableh-needs-spinlockh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arch-x86-include-asm-pgtableh-needs-spinlockh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arch-x86-include-asm-pgtableh-needs-spinlockh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch/x86/include/asm/pgtable.h needs spinlock.h

In file included from ./include/linux/pgtable.h:6,
                 from ./include/linux/kasan.h:30,
                 from mm/kasan/common.c:14:
./arch/x86/include/asm/pgtable.h:56:8: error: unknown type name 'spinlock_t'
   56 | extern spinlock_t pgd_lock;
      |        ^~~~~~~~~~


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    1 +
 mm/kasan/common.c              |    1 +
 2 files changed, 2 insertions(+)

--- a/arch/x86/include/asm/pgtable.h~arch-x86-include-asm-pgtableh-needs-spinlockh
+++ a/arch/x86/include/asm/pgtable.h
@@ -3,6 +3,7 @@
 #define _ASM_X86_PGTABLE_H
 
 #include <linux/mem_encrypt.h>
+#include <linux/spinlock.h>
 #include <asm/page.h>
 #include <asm/pgtable_types.h>
 
--- a/mm/kasan/common.c~arch-x86-include-asm-pgtableh-needs-spinlockh
+++ a/mm/kasan/common.c
@@ -15,6 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/linkage.h>
 #include <linux/memblock.h>
+#include <linux/spinlock.h>
 #include <linux/memory.h>
 #include <linux/mm.h>
 #include <linux/module.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes.patch
shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
memcg-add-per-memcg-vmalloc-stat-v2-fix.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-vmalloc-allocate-small-pages-for-area-pages-fix.patch
mm-page_allocc-do-not-warn-allocation-failure-on-zone-dma-if-no-managed-pages-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix2.patch
proc-make-the-proc_create-stubs-static-inlines-fix2-fix.patch
kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp-checkpatch-fixes.patch
hashh-remove-unused-define-directive-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
arch-x86-include-asm-pgtableh-needs-spinlockh.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
sysctl-move-maxolduid-as-a-sysctl-specific-const-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
mm-remove-cleancache-fix.patch
mm-simplify-try_to_unuse-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

