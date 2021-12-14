Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2189FC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 14 Dec 2021 20:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237682AbhLNUlp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Dec 2021 15:41:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbhLNUlp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Dec 2021 15:41:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEC6C061574
        for <mm-commits@vger.kernel.org>; Tue, 14 Dec 2021 12:41:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D814E616D5
        for <mm-commits@vger.kernel.org>; Tue, 14 Dec 2021 20:41:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F13C34606;
        Tue, 14 Dec 2021 20:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639514504;
        bh=NDS6MKqREfBKeQz37+A9eTt/EeH9Mz6Ds8TV7qOSalA=;
        h=Date:From:To:Subject:From;
        b=jlLuooSt3gzOS6RksfMn/8gMu0Hl6n9vpxtKVwmvriMAA6KPDUH4FoXSXcaeS62Qt
         +MZ5OUy+3I2+VOrAt/RWYKdTy7LEaR9knMqKukhgEt3zztaZ4HWEA9oMUDKN/2Dfx/
         yXj2ojDMpq/1lVLYcrPJbo8ggmUPwLoTzDQ1IFy4=
Date:   Tue, 14 Dec 2021 12:41:43 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, corbet@lwn.net,
        georgi.djakov@linaro.org, hanshenghong2019@email.szu.edu.cn,
        lmark@codeaurora.org, mm-commits@vger.kernel.org,
        nixiaoming@huawei.com, tangbin@cmss.chinamobile.com,
        vbabka@suse.cz, weizhenliang@huawei.com,
        zhangshengju@cmss.chinamobile.com
Subject:  +
 documentation-vm-page_ownerrst-update-the-documentation-fix.patch added to
 -mm tree
Message-ID: <20211214204143.UWymedW9h%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: documentation-vm-page_ownerrst-update-the-documentation-fix
has been added to the -mm tree.  Its filename is
     documentation-vm-page_ownerrst-update-the-documentation-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/documentation-vm-page_ownerrst-update-the-documentation-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/documentation-vm-page_ownerrst-update-the-documentation-fix.patch

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
Subject: documentation-vm-page_ownerrst-update-the-documentation-fix

small grammatical tweaks

Cc: Georgi Djakov <georgi.djakov@linaro.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Mark <lmark@codeaurora.org>
Cc: Shenghong Han <hanshenghong2019@email.szu.edu.cn>
Cc: Tang Bin <tangbin@cmss.chinamobile.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Cc: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/vm/page_owner.rst~documentation-vm-page_ownerrst-update-the-documentation-fix
+++ a/Documentation/vm/page_owner.rst
@@ -107,17 +107,17 @@ Usage
 	 // Detailed stack
 
    By default, ``page_owner_sort`` is sorted according to the times of buf.
-   If you want to sort by the pages nums of buf, use the ``-m`` parameter.
-   The detail parameters are shown as follows:
+   If you want to sort by the page nums of buf, use the ``-m`` parameter.
+   The detailed parameters are:
 
    fundamental function:
 
 	Sort:
-		-a		Sort by memory allocate time.
+		-a		Sort by memory allocation time.
 		-m		Sort by total memory.
 		-p		Sort by pid.
 		-r		Sort by memory release time.
-		-s		Sort by the stack trace.
+		-s		Sort by stack trace.
 		-t		Sort by times (default).
 
    additional function:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-vmalloc-allocate-small-pages-for-area-pages-fix.patch
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
drivers-gpu-drm-vmwgfx-vmwgfx_gemc-printk-fix.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

