Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA2F6C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 21:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiANVf0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 16:35:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57970 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiANVfZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 16:35:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FE2361F99
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 21:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70E1C36AE9;
        Fri, 14 Jan 2022 21:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642196125;
        bh=wYwYc644E7TLGSj+Kz2yimB2MP0S9xYk/j/Yz05LvCw=;
        h=Date:From:To:Subject:From;
        b=iu7wo8uaeuHmKGcmSVBKqeuqfP1e78DhwC+kb2xFqQnDrEaseH3c98pqeiJom84cO
         sj4LEAMdYRWJuRYoKdUnGyAOacyE8TldjMz7sT7uSljnTzfJrK/KYauxgbSvDx2xPo
         +5NGTr4+zotGedaDt0/4na3BBwC4mbnpG1nRficg=
Date:   Fri, 14 Jan 2022 13:35:24 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        zhengqi.arch@bytedance.com
Subject:  [folded-merged]
 mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
 removed from -mm tree
Message-ID: <20220114213524.t6z4i7uEW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix
has been removed from the -mm tree.  Its filename was
     mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch

This patch was dropped because it was folded into mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix

fix layout

Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu-internal.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/percpu-internal.h~mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix
+++ a/mm/percpu-internal.h
@@ -123,8 +123,9 @@ static inline int pcpu_chunk_map_bits(st
  */
 static inline size_t pcpu_obj_full_size(size_t size)
 {
-	size_t extra_size =
-		size / PCPU_MIN_ALLOC_SIZE * sizeof(struct obj_cgroup *);
+	size_t extra_size;
+
+	extra_size = size / PCPU_MIN_ALLOC_SIZE * sizeof(struct obj_cgroup *);
 
 	return size * num_possible_cpus() + extra_size;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups.patch
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

