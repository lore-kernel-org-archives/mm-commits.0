Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2109C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Dec 2021 01:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245176AbhLCBGU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Dec 2021 20:06:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233835AbhLCBGT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Dec 2021 20:06:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3AB8C06174A
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 17:02:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CF8DB823BC
        for <mm-commits@vger.kernel.org>; Fri,  3 Dec 2021 01:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00305C00446;
        Fri,  3 Dec 2021 01:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638493374;
        bh=ntFhVa5vdqnzXL++Qp6CqXSIqYhnukVTeVRnuach+Lw=;
        h=Date:From:To:Subject:From;
        b=L/98bwrz6+isdT93DOOcepvzeX6lkRcYpqyUKzU918uuLN7s/QcV0rCxZ/kuwM/WB
         juOuBW1ValzgMWa/gX20tahpvnSdYgCoNKMNTe7JnKlB3V9m/NSsWDJ6P4pV7IjSAI
         c3kFfUipCEG4vli7z3fXcR8goSgDs5Aq4PL+Yr6Y=
Date:   Thu, 02 Dec 2021 17:02:53 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, joao.m.martins@oracle.com,
        mm-commits@vger.kernel.org
Subject:  +
 device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix.patch added to -mm
 tree
Message-ID: <20211203010253.o_xz9VCmJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix
has been added to the -mm tree.  Its filename is
     device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix.patch

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
Subject: device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix

fix CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=n build

Cc: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dax/device.c~device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix
+++ a/drivers/dax/device.c
@@ -222,7 +222,7 @@ static vm_fault_t __dev_dax_pud_fault(st
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

mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-page-table-check-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix2.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
proc-remove-pde_data-completely-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

