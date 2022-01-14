Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FF0AC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 21:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiANVXI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 16:23:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43188 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiANVXI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 16:23:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 544A6B82A26
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 21:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB532C36AE9;
        Fri, 14 Jan 2022 21:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642195386;
        bh=1ZfMbAqvv7aVkA7JmZ18D3tgT60RLBjSackweyTaKnA=;
        h=Date:From:To:Subject:From;
        b=YyOB/jsayUFBSSpZiG6eDzCGa6lFi0U/AL6vcaqa5KNbkIwwA/6wPwxPFAyt8udiS
         RsedPbt6T3M+6iB7pWSzb2eS5+mCjRwd6czxEVpoeZR/gJ5ttbCCmxf1klaha22gIX
         YJ0ZlFBDjRPQ9x0rTAgR6xpoNxHt+pIbvsu1f27A=
Date:   Fri, 14 Jan 2022 13:23:05 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, joao.m.martins@oracle.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix.patch removed from
 -mm tree
Message-ID: <20220114212305.8zGVuD1Bx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix
has been removed from the -mm tree.  Its filename was
     device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix.patch

This patch was dropped because it was folded into device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix

fix CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=n build

Cc: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dax/device.c~device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix
+++ a/drivers/dax/device.c
@@ -216,7 +216,7 @@ static vm_fault_t __dev_dax_pud_fault(st
 }
 #else
 static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
-				struct vm_fault *vmf, pfn_t *pfn)
+				struct vm_fault *vmf)
 {
 	return VM_FAULT_FALLBACK;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault.patch
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

