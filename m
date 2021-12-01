Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8397C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  1 Dec 2021 00:05:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236679AbhLAAJF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 Nov 2021 19:09:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48858 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240807AbhLAAJC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Nov 2021 19:09:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E079B81DA1
        for <mm-commits@vger.kernel.org>; Wed,  1 Dec 2021 00:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D0AC53FCB;
        Wed,  1 Dec 2021 00:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638317139;
        bh=iw9Z7HZrvdN2RCo/JntnG3S3qhPUr6WaxVCDGU3Br+s=;
        h=Date:From:To:Subject:From;
        b=Wi5FUlqOwPrfMRZPS/e3O6VBETn7j5VOfgk/oXrU6+8a8Zd5LDB1h4UPT7v8AUelw
         X7QQrf+qw4sTzkH8DBNOHRih/Mlc+pYCNNhKFYIPtKKcPKGroDa7EEAvl9szWpxS8M
         cfsO/PJa/TXMU8RsQa4BstV5iw3lBzKCDECUcTXk=
Date:   Tue, 30 Nov 2021 16:05:38 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, lkp@intel.com, mcgrof@kernel.org,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject:  +
 firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch added
 to -mm tree
Message-ID: <20211201000538.0GqUUdBdv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix
has been added to the -mm tree.  Its filename is
     firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch

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
Subject: firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix

Cc: kernel test robot <lkp@intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/firmware_loader/fallback_table.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/base/firmware_loader/fallback_table.c~firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix
+++ a/drivers/base/firmware_loader/fallback_table.c
@@ -4,7 +4,7 @@
 #include <linux/kconfig.h>
 #include <linux/list.h>
 #include <linux/slab.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/security.h>
 #include <linux/highmem.h>
 #include <linux/umh.h>
@@ -57,13 +57,13 @@ int register_firmware_config_sysctl(void
 		return -ENOMEM;
 	return 0;
 }
-EXPORT_SYMBOL(register_firmware_config_sysctl);
+EXPORT_SYMBOL_NS_GPL(register_firmware_config_sysctl);
 
 void unregister_firmware_config_sysctl(void)
 {
 	unregister_sysctl_table(firmware_config_sysct_table_header);
 	firmware_config_sysct_table_header = NULL;
 }
-EXPORT_SYMBOL(unregister_firmware_config_sysctl);
+EXPORT_SYMBOL_NS_GPL(unregister_firmware_config_sysctl);
 
 #endif /* CONFIG_SYSCTL */
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
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

