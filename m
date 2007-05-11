From: akpm@linux-foundation.org
Subject: + lguest-the-makefile-and-kconfig-tidyups.patch added to -mm tree
Date: Thu, 10 May 2007 20:50:54 -0700
Message-ID: <200705110350.l4B3osaY005531@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753186AbXEKDvB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 23:51:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au


The patch titled
     lguest host feedback tidyups
has been added to the -mm tree.  Its filename is
     lguest-the-makefile-and-kconfig-tidyups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
xfs-clean-up-shrinker-games.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
powerpc-fixup-hard_irq_disable-semantics.patch
add-hard_irq_disable.patch
stop_machine-now-uses-hard_irq_disable.patch
stop_machine-now-uses-hard_irq_disable-fix.patch
use-menuconfig-objects-ii-module-menu.patch
module_author-dont-advice-putting-in-an-email-address.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-guest-code-tidyups.patch
lguest-the-host-code.patch
lguest-the-host-code-tidyups.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-makefile-and-kconfig-tidyups.patch
lguest-the-console-driver.patch
lguest-the-console-driver-tidyups.patch
lguest-the-net-driver.patch
lguest-the-net-driver-tidyups.patch
lguest-the-block-driver.patch
lguest-the-block-driver-tidyups.patch
lguest-the-documentation-example-launcher.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
