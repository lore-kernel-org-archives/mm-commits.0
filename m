Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E66D3C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:29:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377910AbiATV3n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:29:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39142 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377938AbiATV3f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:29:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C0B560A6C
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6D7C340E0;
        Thu, 20 Jan 2022 21:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714174;
        bh=p7aTPXUYPlbAnc1U6sZ6WMr3fyWzmxqOydv/7wD1cFM=;
        h=Date:From:To:Subject:From;
        b=ebaML6BjIUww/vKnrMP+aitem+xaLcgQezoxjBLrybHkrbiNTg2ZFkvcHCeUkwc+v
         S1p0dfKA43+tO8+adB+Ebndsd3066/+RlRED2GUGTtK8QRJl6ROmYBvDb0afJ1U0kb
         NovOBEx7tv4zPHdVarkjPtbqqXouMGRxhHcYHhiA=
Date:   Thu, 20 Jan 2022 13:29:34 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hdegoede@redhat.com, lkp@intel.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 proc-make-the-proc_create-stubs-static-inlines-fix2.patch removed from -mm
 tree
Message-ID: <20220120212934._uSr5MB_q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc-make-the-proc_create-stubs-static-inlines-fix2
has been removed from the -mm tree.  Its filename was
     proc-make-the-proc_create-stubs-static-inlines-fix2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-make-the-proc_create-stubs-static-inlines-fix2

fix arch/sparc/kernel/led.c

Reported-by: kernel test robot <lkp@intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/led.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/sparc/kernel/led.c~proc-make-the-proc_create-stubs-static-inlines-fix2
+++ a/arch/sparc/kernel/led.c
@@ -122,10 +122,11 @@ static int __init led_init(void)
 {
 	timer_setup(&led_blink_timer, led_blink, 0);
 
+#ifdef CONFIG_PROC_FS
 	led = proc_create("led", 0, NULL, &led_proc_ops);
 	if (!led)
 		return -ENOMEM;
-
+#endif
 	printk(KERN_INFO
 	       "led: version %s, Lars Kotthoff <metalhead@metalhead.ws>\n",
 	       LED_VERSION);
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

