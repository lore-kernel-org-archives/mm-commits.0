From: akpm@linux-foundation.org
Subject: - lguest-the-makefile-and-kconfig-tidyups.patch removed from -mm tree
Date: Thu, 07 Jun 2007 23:16:20 -0700
Message-ID: <200706080616.l586GKfD021027@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50671 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755582AbXFHGQa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 02:16:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest host feedback tidyups
has been removed from the -mm tree.  Its filename was
     lguest-the-makefile-and-kconfig-tidyups.patch

This patch was dropped because it was folded into lguest-the-makefile-and-kconfig.patch

------------------------------------------------------
Subject: lguest host feedback tidyups
From: Rusty Russell <rusty@rustcorp.com.au>

1) Sam Ravnborg says lg-objs is deprecated, use lg-y.
2) Sparse: page_tables.c unnecessary initialization
3) Lots of __force to shut sparse up: guest "physical" addresses are
   userspace virtual.
4) Change prototype of run_lguest and do cast in caller instead (when we add
   __iomem to cast, it runs over another line).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/lguest/Makefile~lguest-the-makefile-and-kconfig-tidyups drivers/lguest/Makefile
--- a/drivers/lguest/Makefile~lguest-the-makefile-and-kconfig-tidyups
+++ a/drivers/lguest/Makefile
@@ -3,5 +3,5 @@ obj-$(CONFIG_LGUEST_GUEST) += lguest.o l
 
 # Host requires the other files, which can be a module.
 obj-$(CONFIG_LGUEST)	+= lg.o
-lg-objs := core.o hypercalls.o page_tables.o interrupts_and_traps.o \
+lg-y := core.o hypercalls.o page_tables.o interrupts_and_traps.o \
 	segments.o io.o lguest_user.o switcher.o
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
