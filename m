From: akpm@linux-foundation.org
Subject: + char-ip2-fix-sparse-warnings.patch added to -mm tree
Date: Tue, 22 Jul 2008 02:45:33 -0700
Message-ID: <200807220945.m6M9jXQL021586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752649AbYGVJpn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 05:45:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, akinobu.mita@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     Char: ip2, fix sparse warnings
has been added to the -mm tree.  Its filename is
     char-ip2-fix-sparse-warnings.patch

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
Subject: Char: ip2, fix sparse warnings
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip2/ip2main.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN drivers/char/ip2/ip2main.c~char-ip2-fix-sparse-warnings drivers/char/ip2/ip2main.c
--- a/drivers/char/ip2/ip2main.c~char-ip2-fix-sparse-warnings
+++ a/drivers/char/ip2/ip2main.c
@@ -375,9 +375,7 @@ have_requested_irq( char irq )
 /* handle subsequent installations of the driver. All memory allocated by the */
 /* driver should be returned since it may be unloaded from memory.            */
 /******************************************************************************/
-#ifdef MODULE
-void __exit
-ip2_cleanup_module(void)
+static void __exit ip2_cleanup_module(void)
 {
 	int err;
 	int i;
@@ -431,7 +429,8 @@ ip2_cleanup_module(void)
 			ip2config.pci_dev[i] = NULL;
 		}
 #endif
-		if ((pB = i2BoardPtrTable[i]) != 0 ) {
+		pB = i2BoardPtrTable[i];
+		if (pB != NULL) {
 			kfree ( pB );
 			i2BoardPtrTable[i] = NULL;
 		}
@@ -448,7 +447,6 @@ ip2_cleanup_module(void)
 #endif
 }
 module_exit(ip2_cleanup_module);
-#endif /* MODULE */
 
 static const struct tty_operations ip2_ops = {
 	.open            = ip2_open,
@@ -1255,9 +1253,8 @@ ip2_polled_interrupt(void)
 {
 	int i;
 	i2eBordStrPtr  pB;
-	const int irq = 0;
 
-	ip2trace (ITRC_NO_PORT, ITRC_INTR, 99, 1, irq );
+	ip2trace(ITRC_NO_PORT, ITRC_INTR, 99, 1, 0);
 
 	/* Service just the boards on the list using this irq */
 	for( i = 0; i < i2nBoards; ++i ) {
@@ -1266,9 +1263,8 @@ ip2_polled_interrupt(void)
 //		Only process those boards which match our IRQ.
 //			IRQ = 0 for polled boards, we won't poll "IRQ" boards
 
-		if ( pB && (pB->i2eUsingIrq == irq) ) {
+		if (pB && pB->i2eUsingIrq == 0)
 			ip2_irq_work(pB);
-		}
 	}
 
 	++irq_counter;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
ath5k-fix-memory-corruption.patch
ath5k-kill-tasklets-on-shutdown.patch
ath5k-flush-work.patch
ath5k-fix-dma-operation.patch
ath5k-suspend-resume-fixes.patch
mac80211-tx-use-dev_kfree_skb_any-for-beacon_get.patch
mac80211-return-correct-error-return-from-ieee80211_wep_init.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
serial-z85c30-avoid-a-hang-at-console-switch-over.patch
serial-dz11-avoid-a-hang-at-console-switch-over.patch
vt-hold-console_sem-across-sysfs-operations.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
dsp56k-bkl-pushdown.patch
char-mxser-ioctl-cleanup.patch
char-mxser-globals-cleanup.patch
char-mxser-update-documentation.patch
char-mxser-prints-cleanup.patch
char-mxser-remove-predefined-isa-support.patch
char-mxser-various-cleanups.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
drivers-misc-phantom-note-pci.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

