From: akpm@linux-foundation.org
Subject: - lib-taint-kernel-in-common-report_bug-warn-path.patch removed from -mm tree
Date: Sun, 06 Jul 2008 20:03:04 -0700
Message-ID: <200807070303.m67334JR004625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753101AbYGGDDP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 23:03:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, hskinnemoen@atmel.com, kyle@mcmartin.ca, mm-commits@vger.kernel.org


The patch titled
     lib: taint kernel in common report_bug() WARN path.
has been removed from the -mm tree.  Its filename was
     lib-taint-kernel-in-common-report_bug-warn-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: taint kernel in common report_bug() WARN path.
From: Paul Mundt <lethal@linux-sh.org>

Commit 95b570c9cef3b12356454c7112571b7e406b4b51 introduced a TAINT_WARN
that was implemented for all architectures using the generic
warn_on_slowpath(), which excluded any architecture that set
HAVE_ARCH_WARN_ON.

As all of the architectures that implement their own WARN_ON() all go
through the report_bug() path (specifically handling BUG_TRAP_TYPE_WARN),
taint the kernel there as well for consistency.

Tested on avr32 and sh. Also relevant for s390, parisc, and powerpc.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bug.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN lib/bug.c~lib-taint-kernel-in-common-report_bug-warn-path lib/bug.c
--- a/lib/bug.c~lib-taint-kernel-in-common-report_bug-warn-path
+++ a/lib/bug.c
@@ -37,6 +37,7 @@
  */
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/kernel.h>
 #include <linux/bug.h>
 #include <linux/sched.h>
 
@@ -149,6 +150,7 @@ enum bug_trap_type report_bug(unsigned l
 			       (void *)bugaddr);
 
 		show_regs(regs);
+		add_taint(TAINT_WARN);
 		return BUG_TRAP_TYPE_WARN;
 	}
 
_

Patches currently in -mm which might be from lethal@linux-sh.org are

linux-next.patch
add-have_clk-to-kconfig-for-driver-dependencies.patch
i2c-renesas-highlander-fpga-smbus-support.patch
maple-allow-removal-and-reinsertion-of-keyboard-driver-module.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
inflate-refactor-inflate-malloc-code.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
video-superh-mobile-lcdc-driver.patch
video-superh-mobile-lcdc-driver-update.patch
video-sh7760fb-sh7760-sh7763-lcdc-framebuffer-driver.patch
include-asm-ptraceh-userspace-headers-cleanup.patch

