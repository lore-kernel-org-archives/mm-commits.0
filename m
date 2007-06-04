From: akpm@linux-foundation.org
Subject: - fix-x86_64-mm-sched-clock-share-2.patch removed from -mm tree
Date: Mon, 04 Jun 2007 11:21:19 -0700
Message-ID: <200706041821.l54ILKSK010268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43758 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756105AbXFDSVm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 14:21:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     sched_clock vs tsc_disable
has been removed from the -mm tree.  Its filename was
     fix-x86_64-mm-sched-clock-share-2.patch

This patch was dropped because it's an lguest bug

------------------------------------------------------
Subject: sched_clock vs tsc_disable
From: Rusty Russell <rusty@rustcorp.com.au>

If you set tsc_disable (eg "notsc" on cmdline), sched-clock.c gives a
divide by zero on boot.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/sched-clock.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/sched-clock.c~fix-x86_64-mm-sched-clock-share-2 arch/i386/kernel/sched-clock.c
--- a/arch/i386/kernel/sched-clock.c~fix-x86_64-mm-sched-clock-share-2
+++ a/arch/i386/kernel/sched-clock.c
@@ -133,7 +133,7 @@ static void resync_freq(void *arg)
 	struct sc_data *sc = &__get_cpu_var(sc_data);
 
 	sc->sync_base = jiffies;
-	if (!cpu_has_tsc) {
+	if (!cpu_has_tsc || tsc_disable) {
 		sc->unstable = 1;
 		return;
 	}
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

fix-x86_64-mm-sched-clock-share-2.patch
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
lguest-speed-up-paravirt_lazy_flush-handling.patch
lguest-more-lazy_hcalls.patch
lguest-the-host-code.patch
lguest-the-host-code-tidyups.patch
lguest-the-host-code-tidyups-update.patch
lguest-the-host-code-borkages.patch
lguest-faster-tls-switching.patch
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
