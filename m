Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFCB1C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 01:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbiAVBNX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Jan 2022 20:13:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiAVBNW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jan 2022 20:13:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88154C06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 17:13:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38E9DB808D1
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 01:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC207C340E1;
        Sat, 22 Jan 2022 01:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642813999;
        bh=SNEyv1hKJrygOv0ECLPcGbJF5/2M8YzqxnGdBn+JfWo=;
        h=Date:From:To:Subject:From;
        b=Azmw1Q/X7T76l+TzqyuIu+56/yhneqv6bxwvCu1XfiSbkLPnE6GBL+VQoOFf0ASau
         RUvxOUpZkWxIf0vi52E+RL1Zd4kydRyYmlC68BtyaNc43mNnz46sKi814uB/0BjEaD
         FLwynv4lk4tsq73HuC5eZAhAwbI2SVlc5mUi+DX8=
Date:   Fri, 21 Jan 2022 17:13:19 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, lkp@intel.com, mcgrof@kernel.org,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject:  [folded-merged]
 firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch removed
 from -mm tree
Message-ID: <20220122011319.jbqBP9N01%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix
has been removed from the -mm tree.  Its filename was
     firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch

This patch was dropped because it was folded into firmware_loader-move-firmware-sysctl-to-its-own-files.patch

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

firmware_loader-move-firmware-sysctl-to-its-own-files.patch
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

