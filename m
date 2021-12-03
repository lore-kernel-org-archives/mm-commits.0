Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34DB3C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Dec 2021 20:28:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235651AbhLCUbh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Dec 2021 15:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233528AbhLCUbh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Dec 2021 15:31:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DABC061751
        for <mm-commits@vger.kernel.org>; Fri,  3 Dec 2021 12:28:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A67D62CD6
        for <mm-commits@vger.kernel.org>; Fri,  3 Dec 2021 20:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFAAC53FAD;
        Fri,  3 Dec 2021 20:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638563290;
        bh=FoK0/RmyZ+aca71kyMlt/mtXZ6nIzf5x3iS/mGjQrYA=;
        h=Date:From:To:Subject:From;
        b=s439G11lpufbB/ObH8LUwZsHfMTuF1DGu0FWRr0bKQfjPXOijMDoxvilEqA9nad9b
         6WCgxWCpRv8cz4zflNG1fvciw+OlottIzspueB2h4LaJIujAZNByTCAem/S4b+SSb+
         5MmiWlIKF9MQ0TijbAk8Qt7uSSBg1mzO1ERiDw3A=
Date:   Fri, 03 Dec 2021 12:28:10 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, lkp@intel.com,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        songmuchun@bytedance.com
Subject:  + proc-remove-pde_data-completely-fix-fix.patch added to
 -mm tree
Message-ID: <20211203202810.eIo3hOTZw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc-remove-pde_data-completely-fix-fix
has been added to the -mm tree.  Its filename is
     proc-remove-pde_data-completely-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-remove-pde_data-completely-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-remove-pde_data-completely-fix-fix.patch

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
Subject: proc-remove-pde_data-completely-fix-fix

Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nubus/proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nubus/proc.c~proc-remove-pde_data-completely-fix-fix
+++ a/drivers/nubus/proc.c
@@ -93,7 +93,7 @@ struct nubus_proc_pde_data {
 static struct nubus_proc_pde_data *
 nubus_proc_alloc_pde_data(unsigned char *ptr, unsigned int size)
 {
-	struct nubus_proc_pded *pded;
+	struct nubus_proc_pde_data *pded;
 
 	pded = kmalloc(sizeof(*pded), GFP_KERNEL);
 	if (!pded)
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
linux-next-rejects.patch
linux-next-git-rejects.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

