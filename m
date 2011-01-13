From: akpm@linux-foundation.org
Subject: [merged] pps-add-parallel-port-pps-signal-generator-v7.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:09:37 -0800
Message-ID: <201101132012.p0DKCIw9030281@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36585 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933708Ab1AMUM5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:12:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasaine@lvk.cs.msu.su, giometti@linux.it, mm-commits@vger.kernel.org


The patch titled
     pps: add parallel port PPS signal generator
has been removed from the -mm tree.  Its filename was
     pps-add-parallel-port-pps-signal-generator-v7.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pps: add parallel port PPS signal generator
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Add PPS signal generator which utilizes STROBE pin of a parallel port to
send PPS signals.  It uses parport abstraction layer and hrtimers to
precisely control the signal.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/generators/Kconfig           |    6 +-----
 drivers/pps/generators/pps_gen_parport.c |   11 +++++++++--
 2 files changed, 10 insertions(+), 7 deletions(-)

diff -puN drivers/pps/generators/Kconfig~pps-add-parallel-port-pps-signal-generator-v7 drivers/pps/generators/Kconfig
--- a/drivers/pps/generators/Kconfig~pps-add-parallel-port-pps-signal-generator-v7
+++ a/drivers/pps/generators/Kconfig
@@ -2,16 +2,12 @@
 # PPS generators configuration
 #
 
-if PPS
-
 comment "PPS generators support"
 
 config PPS_GENERATOR_PARPORT
 	tristate "Parallel port PPS signal generator"
-	depends on PARPORT != n && GENERIC_TIME
+	depends on PARPORT
 	help
 	  If you say yes here you get support for a PPS signal generator which
 	  utilizes STROBE pin of a parallel port to send PPS signals. It uses
 	  parport abstraction layer and hrtimers to precisely control the signal.
-
-endif
diff -puN drivers/pps/generators/pps_gen_parport.c~pps-add-parallel-port-pps-signal-generator-v7 drivers/pps/generators/pps_gen_parport.c
--- a/drivers/pps/generators/pps_gen_parport.c~pps-add-parallel-port-pps-signal-generator-v7
+++ a/drivers/pps/generators/pps_gen_parport.c
@@ -76,8 +76,15 @@ static enum hrtimer_restart hrtimer_even
 	long lim, delta;
 	unsigned long flags;
 
-	/* NB: approx time with blocked interrupts =
-	   send_delay + 3 * SAFETY_INTERVAL */
+	/* We have to disable interrupts here. The idea is to prevent
+	 * other interrupts on the same processor to introduce random
+	 * lags while polling the clock. getnstimeofday() takes <1us on
+	 * most machines while other interrupt handlers can take much
+	 * more potentially.
+	 *
+	 * NB: approx time with blocked interrupts =
+	 * send_delay + 3 * SAFETY_INTERVAL
+	 */
 	local_irq_save(flags);
 
 	/* first of all we get the time stamp... */
_

Patches currently in -mm which might be from lasaine@lvk.cs.msu.su are

origin.patch

