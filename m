From: akpm@linux-foundation.org
Subject: - lguest-the-host-code-update-for-mm-simplify-boot_params.patch removed from -mm tree
Date: Thu, 07 Jun 2007 23:15:06 -0700
Message-ID: <200706080615.l586F6ik021007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52692 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755333AbXFHGPR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 02:15:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest update for mm: simplify boot_params
has been removed from the -mm tree.  Its filename was
     lguest-the-host-code-update-for-mm-simplify-boot_params.patch

This patch was dropped because it was folded into lguest-the-host-code.patch

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

git-kbuild.patch
paravirt-helper-to-disable-all-io-space.patch
paravirt-helper-to-disable-all-io-space-fix.patch
xen-disable-all-non-virtual-devices.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
use-menuconfig-objects-ii-module-menu.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-host-code.patch
lguest-the-host-code-update-for-mm-simplify-boot_params.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-makefile-and-kconfig-tidyups.patch
lguest-the-console-driver.patch
lguest-the-console-driver-tidyups.patch
lguest-the-net-driver.patch
lguest-the-net-driver-tidyups.patch
lguest-the-net-driver-tidyups-update.patch
lguest-the-net-driver-include-fix.patch
lguest-the-block-driver.patch
lguest-the-block-driver-tidyups.patch
lguest-the-block-driver-tidyups-update.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-example-launcher-fix.patch
lguest-dont-signal-like-crazy-use-lhreq_break-command-doc.patch
lguest-documentation-infrastructure-and-chapter-i.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
