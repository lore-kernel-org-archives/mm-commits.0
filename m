Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C58CC4332F
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377911AbiATV3n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:29:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377969AbiATV3j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:29:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC52C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:29:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE469B81E69
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E000C340E0;
        Thu, 20 Jan 2022 21:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714176;
        bh=mVqhPy0ADDzfPXA3ZsB+g9W0xGuSFTCNm35a+juDDpw=;
        h=Date:From:To:Subject:From;
        b=Cz0HGrVvW4sLPMkSgFt3RjBQnOIe844FLjC8rjzcV+mm8Zw0u5k4L4er0zeTqrETT
         Px+q7wsdOjOdl5GfQ6oNTPARwfl+tk/aiSAWLwKPJ0cBicCBzer/jR30yDZN/DnQX5
         6xKPlHTsbyz6BrbZ1PP6rQOeUJTMkb00uRa3ispg=
Date:   Thu, 20 Jan 2022 13:29:36 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hdegoede@redhat.com, lkp@intel.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 proc-make-the-proc_create-stubs-static-inlines-fix2-fix.patch removed from
 -mm tree
Message-ID: <20220120212936.lho8tlfCr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc-make-the-proc_create-stubs-static-inlines-fix2-fix
has been removed from the -mm tree.  Its filename was
     proc-make-the-proc_create-stubs-static-inlines-fix2-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-make-the-proc_create-stubs-static-inlines-fix2-fix

fix build

Cc: Hans de Goede <hdegoede@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/led.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/sparc/kernel/led.c~proc-make-the-proc_create-stubs-static-inlines-fix2-fix
+++ a/arch/sparc/kernel/led.c
@@ -114,8 +114,6 @@ static const struct proc_ops led_proc_op
 };
 #endif
 
-static struct proc_dir_entry *led;
-
 #define LED_VERSION	"0.1"
 
 static int __init led_init(void)
@@ -123,8 +121,7 @@ static int __init led_init(void)
 	timer_setup(&led_blink_timer, led_blink, 0);
 
 #ifdef CONFIG_PROC_FS
-	led = proc_create("led", 0, NULL, &led_proc_ops);
-	if (!led)
+	if (!proc_create("led", 0, NULL, &led_proc_ops))
 		return -ENOMEM;
 #endif
 	printk(KERN_INFO
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
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

