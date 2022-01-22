Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E5BEC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 01:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbiAVBNV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Jan 2022 20:13:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34844 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiAVBNU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jan 2022 20:13:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B118B8213B
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 01:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBE7C340E1;
        Sat, 22 Jan 2022 01:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642813997;
        bh=7ZjUKYb+xymzg7kpEaAkL5gHUGpfYYkozrNfs04vKoY=;
        h=Date:From:To:Subject:From;
        b=O8RjVr3uYQ8PDAzBAQv8o3AKXj8K3ASWfxMfIOzDmdpanPZaTyqKk8Wj4CIfAc2h6
         eWOnArTb4iHHh5ziUEXlmxwpnTeMUfjI3SV1uOH1prWCqB+ofRt5/69Yw0QFNZkrWA
         XurWjZvHnvkmyVauDVPDBp6UR7nc7WmSTlhob/2U=
Date:   Fri, 21 Jan 2022 17:13:16 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, lkp@intel.com, mcgrof@kernel.org,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject:  [folded-merged]
 firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch removed
 from -mm tree
Message-ID: <20220122011316.gLAAXvS3F%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: firmware_loader-move-firmware-sysctl-to-its-own-files-fix
has been removed from the -mm tree.  Its filename was
     firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch

This patch was dropped because it was folded into firmware_loader-move-firmware-sysctl-to-its-own-files.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: firmware_loader-move-firmware-sysctl-to-its-own-files-fix

export register_firmware_config_sysctl and unregister_firmware_config_sysctl to
modules

ERROR: modpost: "register_firmware_config_sysctl" [drivers/base/firmware_loader/firmware_class.ko] undefined!
ERROR: modpost: "unregister_firmware_config_sysctl" [drivers/base/firmware_loader/firmware_class.ko] undefined!

Cc: Luis Chamberlain <mcgrof@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/firmware_loader/fallback_table.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/base/firmware_loader/fallback_table.c~firmware_loader-move-firmware-sysctl-to-its-own-files-fix
+++ a/drivers/base/firmware_loader/fallback_table.c
@@ -4,6 +4,7 @@
 #include <linux/kconfig.h>
 #include <linux/list.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <linux/security.h>
 #include <linux/highmem.h>
 #include <linux/umh.h>
@@ -56,10 +57,13 @@ int register_firmware_config_sysctl(void
 		return -ENOMEM;
 	return 0;
 }
+EXPORT_SYMBOL(register_firmware_config_sysctl);
 
 void unregister_firmware_config_sysctl(void)
 {
 	unregister_sysctl_table(firmware_config_sysct_table_header);
 	firmware_config_sysct_table_header = NULL;
 }
+EXPORT_SYMBOL(unregister_firmware_config_sysctl);
+
 #endif /* CONFIG_SYSCTL */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

firmware_loader-move-firmware-sysctl-to-its-own-files.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
sysctl-move-maxolduid-as-a-sysctl-specific-const-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
mm-remove-cleancache-fix.patch
mm-simplify-try_to_unuse-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
arch-x86-include-asm-pgtableh-needs-spinlockh.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

