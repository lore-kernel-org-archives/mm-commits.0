From: akpm@linux-foundation.org
Subject: + w1-fix-omap-1-wire-driver-compilation.patch added to -mm tree
Date: Wed, 21 Apr 2010 11:08:28 -0700
Message-ID: <201004211808.o3LI8SDi000877@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753200Ab0DUSJJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Apr 2010 14:09:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amit.kucheria@canonical.com, johnpol@2ka.mipt.ru, tony@atomide.com


The patch titled
     w1: fix omap 1-wire driver compilation
has been added to the -mm tree.  Its filename is
     w1-fix-omap-1-wire-driver-compilation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
w1-fix-omap-1-wire-driver-compilation.patch

