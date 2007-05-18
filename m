From: akpm@linux-foundation.org
Subject: + lguest-the-host-code-update-for-mm-simplify-boot_params.patch added to -mm tree
Date: Thu, 17 May 2007 20:15:08 -0700
Message-ID: <200705180315.l4I3F84D006646@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49518 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755457AbXERDQ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 23:16:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au


The patch titled
     lguest update for mm: simplify boot_params
has been added to the -mm tree.  Its filename is
     lguest-the-host-code-update-for-mm-simplify-boot_params.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest update for mm: simplify boot_params
From: Rusty Russell <rusty@rustcorp.com.au>

Andrew patched up lguest after the boot parameters became a proper
structure, but in fact it can be considerably neatened.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/lguest.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/lguest/lguest.c~lguest-the-host-code-update-for-mm-simplify-boot_params drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~lguest-the-host-code-update-for-mm-simplify-boot_params
+++ a/drivers/lguest/lguest.c
@@ -444,8 +444,7 @@ __init void lguest_init(void *boot)
 {
 	/* Copy boot parameters first. */
 	memcpy(&boot_params, boot, PARAM_SIZE);
-	memcpy(boot_command_line,
-	       __va(*(unsigned long *)((void *)&boot_params + NEW_CL_POINTER)),
+	memcpy(boot_command_line, __va(boot_params.hdr.cmd_line_ptr),
 	       COMMAND_LINE_SIZE);
 
 	paravirt_ops.name = "lguest";
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

refine-screen_info-sanity-check-for-vgacon-initialization.patch
fix-x86_64-mm-sched-clock-share.patch
xfs-clean-up-shrinker-games.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
use-menuconfig-objects-ii-module-menu.patch
split-usermodehelper-setup-from-execution.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-guest-code-tidyups.patch
lguest-the-guest-code-tidyups-update.patch
lguest-the-host-code.patch
lguest-the-host-code-tidyups.patch
lguest-the-host-code-tidyups-update.patch
lguest-the-host-code-borkages.patch
lguest-the-host-code-update-for-mm-simplify-boot_params.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-makefile-and-kconfig-tidyups.patch
lguest-the-console-driver.patch
lguest-the-console-driver-tidyups.patch
lguest-the-net-driver.patch
lguest-the-net-driver-tidyups.patch
lguest-the-net-driver-tidyups-update.patch
lguest-the-block-driver.patch
lguest-the-block-driver-tidyups.patch
lguest-the-block-driver-tidyups-update.patch
lguest-the-documentation-example-launcher.patch
lguest-update-for-mm-disable-tsc-dont-set-pge-bit.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
