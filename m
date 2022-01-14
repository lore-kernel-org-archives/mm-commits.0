Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6C3AC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 21:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiANVWF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 16:22:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42824 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiANVWF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 16:22:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21CAEB82A26
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 21:22:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A09C36AE9;
        Fri, 14 Jan 2022 21:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642195322;
        bh=C6EoYwcM7h607LBb6OyNKeM+n8qB4iCTHtw4a6AJ3sk=;
        h=Date:From:To:Subject:From;
        b=t1pGPI/gZz3V58phbsjau2z+3zF4v3N+Rtx4IYLkAgvmxBZ2cvq55ZAV90EdtmY76
         JIyLW+a5poDoPxpWW365GRQ0BsSsngdWWqyde+qr50NDsVYy+Pt21huHbVNpgjMhyo
         cytYayqAZpUKBW+VuOXxvyJq71iBQmInR0ZdF7dA=
Date:   Fri, 14 Jan 2022 13:22:02 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        wangkefeng.wang@huawei.com
Subject:  [folded-merged]
 mm-defer-kmemleak-object-creation-of-module_alloc-v4-fix.patch removed from
 -mm tree
Message-ID: <20220114212202.Pbeb_H3zP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-defer-kmemleak-object-creation-of-module_alloc-v4-fix
has been removed from the -mm tree.  Its filename was
     mm-defer-kmemleak-object-creation-of-module_alloc-v4-fix.patch

This patch was dropped because it was folded into mm-defer-kmemleak-object-creation-of-module_alloc.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-defer-kmemleak-object-creation-of-module_alloc-v4-fix

simplify ifdefs, per Andrey

Link: https://lkml.kernel.org/r/CA+fCnZcnwJHUQq34VuRxpdoY6_XbJCDJ-jopksS5Eia4PijPzw@mail.gmail.com
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/vmalloc.h~mm-defer-kmemleak-object-creation-of-module_alloc-v4-fix
+++ a/include/linux/vmalloc.h
@@ -28,8 +28,8 @@ struct notifier_block;		/* in notifier.h
 #define VM_MAP_PUT_PAGES	0x00000200	/* put pages and free array in vfree */
 #define VM_NO_HUGE_VMAP		0x00000400	/* force PAGE_SIZE pte mapping */
 
-#if defined(CONFIG_KASAN) && (defined(CONFIG_KASAN_GENERIC) || \
-	defined(CONFIG_KASAN_SW_TAGS)) && !defined(CONFIG_KASAN_VMALLOC)
+#if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && \
+	!defined(CONFIG_KASAN_VMALLOC)
 #define VM_DEFER_KMEMLEAK	0x00000800	/* defer kmemleak object creation */
 #else
 #define VM_DEFER_KMEMLEAK	0
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-defer-kmemleak-object-creation-of-module_alloc.patch
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

