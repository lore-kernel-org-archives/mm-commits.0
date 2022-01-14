Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA25CC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 21:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiANVZk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 16:25:40 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53810 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiANVZk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 16:25:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A233361F86
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 21:25:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D36C36AE5;
        Fri, 14 Jan 2022 21:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642195539;
        bh=/d2V0hJ6bm+Zpa/9okNESyJ8EhZpmZwL7l1YoHYUrJs=;
        h=Date:From:To:Subject:From;
        b=xF1du16TOcLBWl7ISs5vH8MMQf40TBSMZVLcB4PLBfreNqJklUTv/fIMdQC7xy5jC
         lhaVQ7tFoeyFnKdRABc8m8dMpxCwm6bWkbne7SWVUnWUy4C3fE3XMhBtcN84jdA0Rt
         80zGo67HcmDPNz8olVJP9cax7cXy4vGiOcr07Dzs=
Date:   Fri, 14 Jan 2022 13:25:38 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com
Subject:  [folded-merged]
 memcg-add-per-memcg-vmalloc-stat-v2-fix.patch removed from -mm tree
Message-ID: <20220114212538.BbGrVlL_1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-add-per-memcg-vmalloc-stat-v2-fix
has been removed from the -mm tree.  Its filename was
     memcg-add-per-memcg-vmalloc-stat-v2-fix.patch

This patch was dropped because it was folded into memcg-add-per-memcg-vmalloc-stat.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-add-per-memcg-vmalloc-stat-v2-fix

remove cast, per Muchun

Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~memcg-add-per-memcg-vmalloc-stat-v2-fix
+++ a/mm/vmalloc.c
@@ -2627,7 +2627,7 @@ static void __vunmap(const void *addr, i
 		int i;
 
 		mod_memcg_page_state(area->pages[0], MEMCG_VMALLOC,
-				     -(int)area->nr_pages);
+				     -area->nr_pages);
 
 		for (i = 0; i < area->nr_pages; i += 1U << page_order) {
 			struct page *page = area->pages[i];
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-add-per-memcg-vmalloc-stat.patch
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

