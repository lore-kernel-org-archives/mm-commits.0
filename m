Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD1EBC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 01:51:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344882AbiATBvm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 20:51:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57246 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345656AbiATBvh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 20:51:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68A9E6154E
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 01:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC6CC004E1;
        Thu, 20 Jan 2022 01:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642643496;
        bh=MiYFLy/xJJm94i9XofEeLlITv8BpW1SiZBP1+XRHCbA=;
        h=Date:From:To:Subject:From;
        b=bStUQpuOUfxTS0AQKxTWAJ1GFaP3PSy+BQgqwRJ4hCGcBnGyy3Oc3FBPLt295XgQZ
         qly5Xy1DBxy+fnAaux3uJqwZcju0xLkkjUZcOkT11vEU5IAWbFvJ7rD6YpCHuZCKg2
         6wZR4boceuZsb/RMNafiWlGxe+RvVcq+xNrJ8H/I=
Date:   Wed, 19 Jan 2022 17:51:36 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hdegoede@redhat.com, lkp@intel.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 proc-make-the-proc_create-stubs-static-inlines-fix2-fix.patch removed from
 -mm tree
Message-ID: <20220120015136.GHjQKwoIm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc-make-the-proc_create-stubs-static-inlines-fix2-fix
has been removed from the -mm tree.  Its filename was
     proc-make-the-proc_create-stubs-static-inlines-fix2-fix.patch

This patch was dropped because it was folded into proc-make-the-proc_create-stubs-static-inlines.patch

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

proc-make-the-proc_create-stubs-static-inlines.patch
kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp-checkpatch-fixes.patch
hashh-remove-unused-define-directive-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
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

