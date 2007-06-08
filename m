From: akpm@linux-foundation.org
Subject: - lguest-speed-up-paravirt_lazy_flush-handling.patch removed from -mm tree
Date: Thu, 07 Jun 2007 23:13:55 -0700
Message-ID: <200706080613.l586Dt2N020966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54331 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754511AbXFHGOF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 02:14:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: speed up PARAVIRT_LAZY_FLUSH handling
has been removed from the -mm tree.  Its filename was
     lguest-speed-up-paravirt_lazy_flush-handling.patch

This patch was dropped because it was folded into lguest-the-guest-code.patch

------------------------------------------------------
Subject: lguest: speed up PARAVIRT_LAZY_FLUSH handling
From: Rusty Russell <rusty@rustcorp.com.au>

When Zach Amsden added PARAVIRT_LAZY_FLUSH I didn't realize how often it would
get called.  We only need to do something if we're actually in lazy mode.

Before:
Time for one context switch via pipe: 10509 (9863 - 18761)
Time for one Copy-on-Write fault: 71796 (20625 - 207750)
Time to exec client once: 1076218 (1066203 - 1085937)
Time for one fork/exit/wait: 1193125 (574750 - 1197750)
Time for two PTE updates: 10844 (10659 - 20703)

After:
Time for one context switch via pipe: 6745 (6521 - 13966)
Time for one Copy-on-Write fault: 44734 (11468 - 91988)
Time to exec client once: 815984 (801218 - 878218)
Time for one fork/exit/wait: 1023250 (397687 - 1030375)
Time for two PTE updates: 6699 (6475 - 9279)

(Native for comparison):
Time for one context switch via pipe: 4031 (3212 - 4146)
Time for one Copy-on-Write fault: 4402 (4388 - 4426)
Time to exec client once: 343859 (336859 - 349484)
Time for one fork/exit/wait: 120234 (118500 - 136140)
Time for two PTE updates: 2269 (2261 - 2272)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/lguest.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/lguest/lguest.c~lguest-speed-up-paravirt_lazy_flush-handling drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~lguest-speed-up-paravirt_lazy_flush-handling
+++ a/drivers/lguest/lguest.c
@@ -59,9 +59,10 @@ static __initdata const struct lguest_bo
 static enum paravirt_lazy_mode lazy_mode;
 static void lguest_lazy_mode(enum paravirt_lazy_mode mode)
 {
-	if (mode == PARAVIRT_LAZY_FLUSH)
-		hcall(LHCALL_FLUSH_ASYNC, 0, 0, 0);
-	else {
+	if (mode == PARAVIRT_LAZY_FLUSH) {
+		if (unlikely(lazy_mode != PARAVIRT_LAZY_NONE))
+			hcall(LHCALL_FLUSH_ASYNC, 0, 0, 0);
+	} else {
 		lazy_mode = mode;
 		if (mode == PARAVIRT_LAZY_NONE)
 			hcall(LHCALL_FLUSH_ASYNC, 0, 0, 0);
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
lguest-speed-up-paravirt_lazy_flush-handling.patch
lguest-more-lazy_hcalls.patch
lguest-the-guest-code-tsc-fix.patch
lguest-the-guest-code-suppress-ide-probing.patch
lguest-the-host-code.patch
lguest-the-host-code-tidyups.patch
lguest-the-host-code-tidyups-update.patch
lguest-the-host-code-borkages.patch
lguest-faster-tls-switching.patch
lguest-the-host-code-dont-signal-like-crazy-use-lhreq_break-command.patch
lguest-the-host-code-use-tsc.patch
lguest-the-host-code-use-hrtimers.patch
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
