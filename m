From: akpm@linux-foundation.org
Subject: - ip2-avoid-add_timer-with-pending-timer.patch removed from -mm tree
Date: Fri, 19 Sep 2008 15:06:49 -0700
Message-ID: <200809192206.m8JM6neO008859@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751984AbYISWHA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Sep 2008 18:07:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, alan@lxorguk.ukuu.org.uk, jirislaby@gmail.com, mhw@wittsend.com, mm-commits@vger.kernel.org


The patch titled
     ip2: avoid add_timer() with pending timer
has been removed from the -mm tree.  Its filename was
     ip2-avoid-add_timer-with-pending-timer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ip2: avoid add_timer() with pending timer
From: Akinobu Mita <akinobu.mita@gmail.com>

add_timer() is not suppose to be called when the timer is pending.  ip2
driver attempts to avoid that condition by setting and resetting a flag
(TimerOn) in timer function.  But there is some gap between add_timer()
and setting TimerOn.

This patch fix this problem by using mod_timer() and remove TimerOn which
has been unnecessary by this change.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Michael H. Warfield <mhw@wittsend.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip2/ip2main.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff -puN drivers/char/ip2/ip2main.c~ip2-avoid-add_timer-with-pending-timer drivers/char/ip2/ip2main.c
--- a/drivers/char/ip2/ip2main.c~ip2-avoid-add_timer-with-pending-timer
+++ a/drivers/char/ip2/ip2main.c
@@ -249,7 +249,6 @@ static unsigned long bh_counter;
  */
 #define  POLL_TIMEOUT   (jiffies + 1)
 static DEFINE_TIMER(PollTimer, ip2_poll, 0, 0);
-static char  TimerOn;
 
 #ifdef IP2DEBUG_TRACE
 /* Trace (debug) buffer data */
@@ -374,11 +373,7 @@ static void __exit ip2_cleanup_module(vo
 	int err;
 	int i;
 
-	/* Stop poll timer if we had one. */
-	if (TimerOn) {
-		del_timer(&PollTimer);
-		TimerOn = 0;
-	}
+	del_timer_sync(&PollTimer);
 
 	/* Reset the boards we have. */
 	for (i = 0; i < IP2_MAX_BOARDS; i++)
@@ -774,10 +769,8 @@ static int __init ip2_loadmain(void)
 		}
 		if (ip2config.irq[i] == CIR_POLL) {
 retry:
-			if (!TimerOn) {
-				PollTimer.expires = POLL_TIMEOUT;
-				add_timer(&PollTimer);
-				TimerOn = 1;
+			if (!timer_pending(&PollTimer)) {
+				mod_timer(&PollTimer, POLL_TIMEOUT);
 				printk(KERN_INFO "IP2: polling\n");
 			}
 		} else {
@@ -1283,16 +1276,12 @@ ip2_poll(unsigned long arg)
 {
 	ip2trace (ITRC_NO_PORT, ITRC_INTR, 100, 0 );
 
-	TimerOn = 0; // it's the truth but not checked in service
