From: akpm@linux-foundation.org
Subject: + ip2-avoid-add_timer-with-pending-timer.patch added to -mm tree
Date: Tue, 22 Jul 2008 11:37:47 -0700
Message-ID: <200807221837.m6MIblw1010988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751769AbYGVSh7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 14:37:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, alan@lxorguk.ukuu.org.uk, jirislaby@gmail.com, mhw@wittsend.com


The patch titled
     ip2: avoid add_timer() with pending timer
has been added to the -mm tree.  Its filename is
     ip2-avoid-add_timer-with-pending-timer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
-
 	// Just polled boards, IRQ = 0 will hit all non-interrupt boards.
 	// It will NOT poll boards handled by hard interrupts.
 	// The issue of queued BH interrupts is handled in ip2_interrupt().
 	ip2_polled_interrupt();
 
-	PollTimer.expires = POLL_TIMEOUT;
-	add_timer( &PollTimer );
-	TimerOn = 1;
+	mod_timer(&PollTimer, POLL_TIMEOUT);
 
 	ip2trace (ITRC_NO_PORT, ITRC_INTR, ITRC_RETURN, 0 );
 }
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
move-memory_read_from_buffer-from-fsh-to-stringh.patch
linux-next.patch
ipr-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer-fix.patch
pm-hibernation-simplify-memory-bitmap.patch
cris-use-simple_read_from_buffer.patch
binfmt_misc-use-simple_read_from_buffer.patch
aty-use-memory_read_from_buffer.patch
aty-use-memory_read_from_buffer-fix.patch
auxdisplay-small-cleanups.patch
workqueues-do-cpu_up_canceled-if-cpu_up_prepare-fails.patch
ipc-use-simple_read_from_buffer.patch
nwflash-use-simple_read_from_buffer.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
firmware-use-memory_read_from_buffer.patch
firmware-use-memory_read_from_buffer-fix.patch
dcdbas-use-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer-fix.patch
dell_rbu-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer-fix.patch

