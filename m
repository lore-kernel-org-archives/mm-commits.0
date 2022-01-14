Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71714C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 21:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiANVVi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 16:21:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiANVVi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 16:21:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0FAC061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 13:21:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E73DEB82A3C
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 21:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C714C36AE9;
        Fri, 14 Jan 2022 21:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642195295;
        bh=pQf7o+JAKYRrqyay0Ik/KF7hpGft9TM3Qfkad3fdLVo=;
        h=Date:From:To:Subject:From;
        b=BMU/wCbLMvLbJWDi4mMlV7wHA0P35PiB9nV+EGlCR6Ii17zU31FjXNxxnr/K+BGzX
         QMBoiN//5FSCeKSDxUvCR5b6lSmXCnAQBI+S0+uBzmh6FIjfTNhNKk3TsYpc3ZsVBf
         b/+GbNp6oeBzRtW1A97/QAMlDVhSEOyi/ji0s+ro=
Date:   Fri, 14 Jan 2022 13:21:35 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, Kuan-Ying.Lee@mediatek.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 =?US-ASCII?Q?kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-base?=
 =?US-ASCII?Q?d-kasan-enable-fix.patch?= removed from -mm tree
Message-ID: <20220114212135.bgca40juD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix
has been removed from the -mm tree.  Its filename was
     kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch

This patch was dropped because it was folded into kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix

whitespace tweak

Cc: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kmemleak.c~kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix
+++ a/mm/kmemleak.c
@@ -384,10 +384,10 @@ static struct kmemleak_object *lookup_ob
 	unsigned long untagged_ptr = (unsigned long)kasan_reset_tag((void *)ptr);
 
 	while (rb) {
-		struct kmemleak_object *object =
-			rb_entry(rb, struct kmemleak_object, rb_node);
+		struct kmemleak_object *object;
 		unsigned long untagged_objp;
 
+		object = rb_entry(rb, struct kmemleak_object, rb_node);
 		untagged_objp = (unsigned long)kasan_reset_tag((void *)object->pointer);
 
 		if (untagged_ptr < untagged_objp)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable.patch
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

