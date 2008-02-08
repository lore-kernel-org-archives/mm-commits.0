From: akpm@linux-foundation.org
Subject: - char-istallion-remove-hangup-bottomhalf.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:09:42 -0800
Message-ID: <200802080809.m1889NHn014824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45651 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759475AbYBHITa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Char: istallion, remove hangup bottomhalf
has been removed from the -mm tree.  Its filename was
     char-istallion-remove-hangup-bottomhalf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: istallion, remove hangup bottomhalf
From: Jiri Slaby <jirislaby@gmail.com>

tty_hangup schedules a work for hangup itself, no need to do it in the driver.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/istallion.c  |   23 +----------------------
 include/linux/istallion.h |    1 -
 2 files changed, 1 insertion(+), 23 deletions(-)

diff -puN drivers/char/istallion.c~char-istallion-remove-hangup-bottomhalf drivers/char/istallion.c
--- a/drivers/char/istallion.c~char-istallion-remove-hangup-bottomhalf
+++ a/drivers/char/istallion.c
@@ -627,7 +627,6 @@ static int	stli_initopen(struct stlibrd 
 static int	stli_rawopen(struct stlibrd *brdp, struct stliport *portp, unsigned long arg, int wait);
 static int	stli_rawclose(struct stlibrd *brdp, struct stliport *portp, unsigned long arg, int wait);
 static int	stli_waitcarrier(struct stlibrd *brdp, struct stliport *portp, struct file *filp);
-static void	stli_dohangup(struct work_struct *);
 static int	stli_setport(struct stliport *portp);
 static int	stli_cmdwait(struct stlibrd *brdp, struct stliport *portp, unsigned long cmd, void *arg, int size, int copyback);
 static void	stli_sendcmd(struct stlibrd *brdp, struct stliport *portp, unsigned long cmd, void *arg, int size, int copyback);
@@ -1824,25 +1823,6 @@ static void stli_start(struct tty_struct
 /*****************************************************************************/
 
 /*
- *	Scheduler called hang up routine. This is called from the scheduler,
- *	not direct from the driver "poll" routine. We can't call it there
- *	since the real local hangup code will enable/disable the board and
- *	other things that we can't do while handling the poll. Much easier
- *	to deal with it some time later (don't really care when, hangups
- *	aren't that time critical).
- */
-
-static void stli_dohangup(struct work_struct *ugly_api)
-{
-	struct stliport *portp = container_of(ugly_api, struct stliport, tqhangup);
-	if (portp->tty != NULL) {
-		tty_hangup(portp->tty);
-	}
-}
-
-/*****************************************************************************/
-
-/*
  *	Hangup this port. This is pretty much like closing the port, only
  *	a little more brutal. No waiting for data to drain. Shutdown the
  *	port and maybe drop signals. This is rather tricky really. We want
@@ -2405,7 +2385,7 @@ static int stli_hostcmd(struct stlibrd *
 			    ((portp->sigs & TIOCM_CD) == 0)) {
 				if (portp->flags & ASYNC_CHECK_CD) {
 					if (tty)
-						schedule_work(&portp->tqhangup);
+						tty_hangup(tty);
 				}
 			}
 		}
@@ -2733,7 +2713,6 @@ static int stli_initports(struct stlibrd
 		portp->baud_base = STL_BAUDBASE;
 		portp->close_delay = STL_CLOSEDELAY;
 		portp->closing_wait = 30 * HZ;
-		INIT_WORK(&portp->tqhangup, stli_dohangup);
 		init_waitqueue_head(&portp->open_wait);
 		init_waitqueue_head(&portp->close_wait);
 		init_waitqueue_head(&portp->raw_wait);
diff -puN include/linux/istallion.h~char-istallion-remove-hangup-bottomhalf include/linux/istallion.h
--- a/include/linux/istallion.h~char-istallion-remove-hangup-bottomhalf
+++ a/include/linux/istallion.h
@@ -71,7 +71,6 @@ struct stliport {
 	wait_queue_head_t	open_wait;
 	wait_queue_head_t	close_wait;
 	wait_queue_head_t	raw_wait;
-	struct work_struct	tqhangup;
 	struct asysigs		asig;
 	unsigned long		addr;
 	unsigned long		rxoffset;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
git-watchdog.patch
moxa-first-pass-at-termios-reporting.patch
char-applicom-use-pci_resource_start.patch
char-applicom-use-pci_match_id.patch
char-applicom-use-pci_match_id-fix.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
