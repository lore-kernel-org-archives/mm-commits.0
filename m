Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C9BC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 29 Nov 2021 20:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237684AbhK2UGK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Nov 2021 15:06:10 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:49002 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352068AbhK2UEK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Nov 2021 15:04:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6C20FCE13DF
        for <mm-commits@vger.kernel.org>; Mon, 29 Nov 2021 20:00:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846E6C53FC7;
        Mon, 29 Nov 2021 20:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638216049;
        bh=IXcdQ/vm+BduHcEYoe1eDg77H5rYZnPsB2RsRq89LkI=;
        h=Date:From:To:Subject:From;
        b=vtNvyVak8yLjruaCCND7tPOdYaRDfia1aS6XYJJnGIVSvQAisopW7OUCRu9c2kJXA
         abiIqOMkGRj+4nSUlY1Po2n9fd7YMZmKuLHA4m2KMWRZzjeSJHMLiisviQY594einF
         tGPoirvN8q0RrRjGNvAZjlsHVzwDQWG+NXUeqWkU=
Date:   Mon, 29 Nov 2021 12:00:48 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20211129200048.XY9IfxedI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/book3s_hv_builtin.c |   25 -------------------------
 1 file changed, 25 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv_builtin.c~linux-next-git-rejects
+++ a/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -689,32 +689,7 @@ static void flush_guest_tlb(struct kvm *
 		asm volatile(PPC_TLBIEL(%0, %4, %3, %2, %1)
 			     : : "r" (rb), "i" (0), "i" (0), "i" (0),
 			       "r" (0) : "memory");
-<<<<<<< HEAD
-		for (set = 1; set < kvm->arch.tlb_sets; ++set) {
-			rb += PPC_BIT(51);	/* increment set number */
-			/* R=1 PRS=1 RIC=0 */
-			asm volatile(PPC_TLBIEL(%0, %4, %3, %2, %1)
-				     : : "r" (rb), "i" (1), "i" (1), "i" (0),
-				       "r" (0) : "memory");
-		}
-		asm volatile("ptesync": : :"memory");
-		// POWER9 congruence-class TLBIEL leaves ERAT. Flush it now.
-		asm volatile(PPC_RADIX_INVALIDATE_ERAT_GUEST : : :"memory");
-	} else {
-		for (set = 0; set < kvm->arch.tlb_sets; ++set) {
-			/* R=0 PRS=0 RIC=0 */
-			asm volatile(PPC_TLBIEL(%0, %4, %3, %2, %1)
-				     : : "r" (rb), "i" (0), "i" (0), "i" (0),
-				       "r" (0) : "memory");
-			rb += PPC_BIT(51);	/* increment set number */
-		}
-		asm volatile("ptesync": : :"memory");
-		// POWER9 congruence-class TLBIEL leaves ERAT. Flush it now.
-		if (cpu_has_feature(CPU_FTR_ARCH_300))
-			asm volatile(PPC_ISA_3_0_INVALIDATE_ERAT : : :"memory");
-=======
 		rb += PPC_BIT(51);	/* increment set number */
->>>>>>> linux-next/akpm-base
 	}
 	asm volatile("ptesync": : :"memory");
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-page-table-check-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

