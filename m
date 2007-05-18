From: akpm@linux-foundation.org
Subject: + lguest-the-guest-code-update-for-mm-disable-tsc-dont-set-pge-bit.patch added to -mm tree
Date: Thu, 17 May 2007 20:15:58 -0700
Message-ID: <200705180315.l4I3Fv4X006656@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58762 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754646AbXERDRO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 23:17:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au


The patch titled
     lguest update for mm: disable tsc, don't set PGE bit
has been added to the -mm tree.  Its filename is
     lguest-the-guest-code-update-for-mm-disable-tsc-dont-set-pge-bit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest update for mm: disable tsc, don't set PGE bit
From: Rusty Russell <rusty@rustcorp.com.au>

Lguest guests don't use the TSC, and so we must disable it otherwise
sched-clock.c barfs.

Also, we no longer need to explicitly set the PGE feature bit:
cpu_detect->cpuid->lguest_cpuid does that for us now that cpu_detect
uses paravirt_ops (IIRC it used to do a direct cpuid from assembler).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/lguest.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/lguest/lguest.c~lguest-the-guest-code-update-for-mm-disable-tsc-dont-set-pge-bit drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~lguest-the-guest-code-update-for-mm-disable-tsc-dont-set-pge-bit
+++ a/drivers/lguest/lguest.c
@@ -502,11 +502,11 @@ __init void lguest_init(void)
 	reserve_top_address(lguest_data.reserve_mem);
 
 	cpu_detect(&new_cpu_data);
-	/* Need this before paging_init. */
-	set_bit(X86_FEATURE_PGE, new_cpu_data.x86_capability);
 	/* Math is always hard! */
 	new_cpu_data.hard_math = 1;
 
+	tsc_disable = 1;
+
 #ifdef CONFIG_X86_MCE
 	mce_disabled = 1;
 #endif
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
lguest-the-guest-code-update-for-mm-disable-tsc-dont-set-pge-bit.patch
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
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
