Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3FA0C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 21:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiANVVC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 16:21:02 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51616 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiANVVC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 16:21:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E78D961F6E
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 21:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E5FC36AE9;
        Fri, 14 Jan 2022 21:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642195261;
        bh=WiD2FOcNygk0XOO0VQSx9kNZB/lGk0Q2NhsNPvr1LZY=;
        h=Date:From:To:Subject:From;
        b=tN84xBuDeeaEQll3nVxJCDdc7JMLC/N1zRO03sBZZsY/74Wq5azaL9/B3qB2nu03+
         gApxbhnVosrZZyu/RoDj4sj7i+FK47GeEHv8THuV6X1F4AP/hCvbjDn22KLJ/CTZbZ
         qVY+9S8k5NjXSEoMXnLsCP55cLvLyUZbSXt/Vl/k=
Date:   Fri, 14 Jan 2022 13:21:00 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, caihuoqing@baidu.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch removed from
 -mm tree
Message-ID: <20220114212100.JPoQWp2eU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kthread-add-the-helper-function-kthread_run_on_cpu-fix
has been removed from the -mm tree.  Its filename was
     kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch

This patch was dropped because it was folded into kthread-add-the-helper-function-kthread_run_on_cpu.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kthread-add-the-helper-function-kthread_run_on_cpu-fix

export kthread_create_on_cpu to modules

ERROR: modpost: "kthread_create_on_cpu" [drivers/infiniband/sw/siw/siw.ko] undefined!
ERROR: modpost: "kthread_create_on_cpu" [kernel/rcu/rcutorture.ko] undefined!

Cc: Cai Huoqing <caihuoqing@baidu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/kthread.c~kthread-add-the-helper-function-kthread_run_on_cpu-fix
+++ a/kernel/kthread.c
@@ -523,6 +523,7 @@ struct task_struct *kthread_create_on_cp
 	to_kthread(p)->cpu = cpu;
 	return p;
 }
+EXPORT_SYMBOL(kthread_create_on_cpu);
 
 void kthread_set_per_cpu(struct task_struct *k, int cpu)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread-add-the-helper-function-kthread_run_on_cpu.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
mm-defer-kmemleak-object-creation-of-module_alloc-v4-fix.patch
device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes.patch
shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
memcg-add-per-memcg-vmalloc-stat-v2-fix.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-page_allocc-do-not-warn-allocation-failure-on-zone-dma-if-no-managed-pages-fix.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
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

