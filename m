From: akpm@linux-foundation.org
Subject: - char-mxser-various-cleanups.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:01:50 -0700
Message-ID: <200807252301.m6PN1olM003742@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753227AbYGYXCh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:02:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Char: mxser, various cleanups
has been removed from the -mm tree.  Its filename was
     char-mxser-various-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: mxser, various cleanups
From: Jiri Slaby <jirislaby@gmail.com>

- remove unused macro
- some whitespace cleanup
- useless debug prints removal

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.c |   24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff -puN drivers/char/mxser.c~char-mxser-various-cleanups drivers/char/mxser.c
--- a/drivers/char/mxser.c~char-mxser-various-cleanups
+++ a/drivers/char/mxser.c
@@ -48,7 +48,6 @@
 
 #define	MXSER_VERSION	"2.0.4"		/* 1.12 */
 #define	MXSERMAJOR	 174
-#define	MXSERCUMAJOR	 175
 
 #define MXSER_BOARDS		4	/* Max. boards */
 #define MXSER_PORTS_PER_BOARD	8	/* Max. ports per board */
@@ -191,7 +190,6 @@ struct mxser_log {
 	unsigned long txcnt[MXSER_PORTS];
 };
 
-
 struct mxser_mon {
 	unsigned long rxcnt;
 	unsigned long txcnt;
@@ -1305,13 +1303,9 @@ static void mxser_flush_chars(struct tty
 	struct mxser_port *info = tty->driver_data;
 	unsigned long flags;
 
-	if (info->xmit_cnt <= 0 ||
-			tty->stopped ||
-			!info->port.xmit_buf ||
-			(tty->hw_stopped &&
-			 (info->type != PORT_16550A) &&
-			 (!info->board->chip_flag)
-			))
+	if (info->xmit_cnt <= 0 || tty->stopped || !info->port.xmit_buf ||
+			(tty->hw_stopped && info->type != PORT_16550A &&
+			 !info->board->chip_flag))
 		return;
 
 	spin_lock_irqsave(&info->slock, flags);
@@ -1329,9 +1323,7 @@ static int mxser_write_room(struct tty_s
 	int ret;
 
 	ret = SERIAL_XMIT_SIZE - info->xmit_cnt - 1;
-	if (ret < 0)
-		ret = 0;
-	return ret;
+	return ret < 0 ? 0 : ret;
 }
 
 static int mxser_chars_in_buffer(struct tty_struct *tty)
@@ -2762,8 +2754,6 @@ static int __init mxser_module_init(void
 	unsigned int b, i, m;
 	int retval;
 
-	pr_debug("Loading module mxser ...\n");
-
 	mxvar_sdriver = alloc_tty_driver(MXSER_PORTS + 1);
 	if (!mxvar_sdriver)
 		return -ENOMEM;
@@ -2829,8 +2819,6 @@ static int __init mxser_module_init(void
 		} /* else: we have some ISA cards under control */
 	}
 
-	pr_debug("Done.\n");
-
 	return 0;
 err_unr:
 	tty_unregister_driver(mxvar_sdriver);
@@ -2843,8 +2831,6 @@ static void __exit mxser_module_exit(voi
 {
 	unsigned int i, j;
 
-	pr_debug("Unloading module mxser ...\n");
-
 	pci_unregister_driver(&mxser_driver);
 
 	for (i = 0; i < MXSER_BOARDS; i++) /* ISA remains */
@@ -2858,8 +2844,6 @@ static void __exit mxser_module_exit(voi
 	for (i = 0; i < MXSER_BOARDS; i++)
 		if (mxser_boards[i].info != NULL)
 			mxser_release_res(&mxser_boards[i], NULL, 1);
-
-	pr_debug("Done.\n");
 }
 
 module_init(mxser_module_init);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
ath5k-fix-memory-corruption.patch
ath5k-kill-tasklets-on-shutdown.patch
ath5k-flush-work.patch
ath5k-fix-dma-operation.patch
ath5k-suspend-resume-fixes.patch
ath5k-fix-beacon-update-deadlock.patch
ath5k-mask-out-unneeded-interrupts.patch
ath5k-unify-resets.patch
mac80211-tx-use-dev_kfree_skb_any-for-beacon_get.patch
mac80211-return-correct-error-return-from-ieee80211_wep_init.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
char-ds1286-eliminate-busy-waiting.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

