From: akpm@linux-foundation.org
Subject: [merged] w1-fix-omap-1-wire-driver-compilation.patch removed from -mm tree
Date: Mon, 26 Apr 2010 10:26:44 -0400
Message-ID: <201004261728.o3QHSI9u009112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752656Ab0DZR2a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Apr 2010 13:28:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amit.kucheria@canonical.com, johnpol@2ka.mipt.ru, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     w1: fix omap 1-wire driver compilation
has been removed from the -mm tree.  Its filename was
     w1-fix-omap-1-wire-driver-compilation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1: fix omap 1-wire driver compilation
From: Amit Kucheria <amit.kucheria@canonical.com>

Fixes the following error:

drivers/w1/masters/omap_hdq.c: In function 'hdq_wait_for_flag':
drivers/w1/masters/omap_hdq.c:137: error: implicit declaration of function
'schedule_timeout_uninterruptible'
drivers/w1/masters/omap_hdq.c: In function 'hdq_write_byte':
drivers/w1/masters/omap_hdq.c:177: error: 'TASK_UNINTERRUPTIBLE' undeclared
(first use in this function)
drivers/w1/masters/omap_hdq.c:177: error: (Each undeclared identifier is
reported only once
drivers/w1/masters/omap_hdq.c:177: error: for each function it appears in.)
drivers/w1/masters/omap_hdq.c:177: error: implicit declaration of function
'schedule_timeout'
drivers/w1/masters/omap_hdq.c: In function 'hdq_isr':
drivers/w1/masters/omap_hdq.c:221: error: 'TASK_NORMAL' undeclared (first use
in this function)
drivers/w1/masters/omap_hdq.c: In function 'omap_hdq_break':
drivers/w1/masters/omap_hdq.c:316: error: 'TASK_UNINTERRUPTIBLE' undeclared
(first use in this function)

Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/omap_hdq.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/w1/masters/omap_hdq.c~w1-fix-omap-1-wire-driver-compilation drivers/w1/masters/omap_hdq.c
--- a/drivers/w1/masters/omap_hdq.c~w1-fix-omap-1-wire-driver-compilation
+++ a/drivers/w1/masters/omap_hdq.c
@@ -16,6 +16,7 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/sched.h>
 
 #include <asm/irq.h>
 #include <mach/hardware.h>
_

Patches currently in -mm which might be from amit.kucheria@canonical.com are

origin.patch
linux-next.patch

