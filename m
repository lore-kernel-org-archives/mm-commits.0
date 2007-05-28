From: akpm@linux-foundation.org
Subject: - fix-x86_64-mm-sched-clock-share.patch removed from -mm tree
Date: Mon, 28 May 2007 10:38:57 -0700
Message-ID: <200705281738.l4SHcxm2017788@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750914AbXE1RjK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 May 2007 13:39:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     sched_clock vs tsc_disable
has been removed from the -mm tree.  Its filename was
     fix-x86_64-mm-sched-clock-share.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: sched_clock vs tsc_disable
From: Rusty Russell <rusty@rustcorp.com.au>

If you set tsc_disable (eg "notsc" on cmdline), sched-clock.c gives a
divide by zero on boot.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/sched-clock.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/sched-clock.c~fix-x86_64-mm-sched-clock-share arch/i386/kernel/sched-clock.c
--- a/arch/i386/kernel/sched-clock.c~fix-x86_64-mm-sched-clock-share
+++ a/arch/i386/kernel/sched-clock.c
@@ -115,7 +115,7 @@ unsigned long long printk_clock(void)
 static void resync_sc_freq(struct sc_data *sc, unsigned int newfreq)
 {
 	sc->sync_base = jiffies;
-	if (!cpu_has_tsc) {
+	if (!cpu_has_tsc || tsc_disable) {
 		sc->unstable = 1;
 		return;
 	}
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

fix-x86_64-mm-sched-clock-share.patch
xfs-clean-up-shrinker-games.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
use-menuconfig-objects-ii-module-menu.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
define-new-percpu-interface-for-shared-data.patch
use-the-new-percpu-interface-for-shared-data.patch
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
