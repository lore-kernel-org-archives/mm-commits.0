From: akpm@linux-foundation.org
Subject: + char-mxser-various-cleanups.patch added to -mm tree
Date: Mon, 30 Jun 2008 14:21:52 -0700
Message-ID: <200806302121.m5ULLr15026015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761481AbYF3VW3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 17:22:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@redhat.com


The patch titled
     Char: mxser, various cleanups
has been added to the -mm tree.  Its filename is
     char-mxser-various-cleanups.patch

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
@@ -1314,13 +1312,9 @@ static void mxser_flush_chars(struct tty
 	struct mxser_port *info = tty->driver_data;
 	unsigned long flags;
 
-	if (info->xmit_cnt <= 0 ||
-			tty->stopped ||
-			!info->xmit_buf ||
-			(tty->hw_stopped &&
-			 (info->type != PORT_16550A) &&
-			 (!info->board->chip_flag)
-			))
+	if (info->xmit_cnt <= 0 || tty->stopped || !info->xmit_buf ||
+			(tty->hw_stopped && info->type != PORT_16550A &&
+			 !info->board->chip_flag))
 		return;
 
 	spin_lock_irqsave(&info->slock, flags);
@@ -1338,9 +1332,7 @@ static int mxser_write_room(struct tty_s
 	int ret;
 
 	ret = SERIAL_XMIT_SIZE - info->xmit_cnt - 1;
-	if (ret < 0)
-		ret = 0;
-	return ret;
+	return ret < 0 ? 0 : ret;
 }
 
 static int mxser_chars_in_buffer(struct tty_struct *tty)
@@ -2771,8 +2763,6 @@ static int __init mxser_module_init(void
 	unsigned int b, i, m;
 	int retval;
 
-	pr_debug("Loading module mxser ...\n");
-
 	mxvar_sdriver = alloc_tty_driver(MXSER_PORTS + 1);
 	if (!mxvar_sdriver)
 		return -ENOMEM;
@@ -2838,8 +2828,6 @@ static int __init mxser_module_init(void
 		} /* else: we have some ISA cards under control */
 	}
 
-	pr_debug("Done.\n");
-
 	return 0;
 err_unr:
 	tty_unregister_driver(mxvar_sdriver);
@@ -2852,8 +2840,6 @@ static void __exit mxser_module_exit(voi
 {
 	unsigned int i, j;
 
-	pr_debug("Unloading module mxser ...\n");
-
 	pci_unregister_driver(&mxser_driver);
 
 	for (i = 0; i < MXSER_BOARDS; i++) /* ISA remains */
@@ -2867,8 +2853,6 @@ static void __exit mxser_module_exit(voi
 	for (i = 0; i < MXSER_BOARDS; i++)
 		if (mxser_boards[i].info != NULL)
 			mxser_release_res(&mxser_boards[i], NULL, 1);
-
-	pr_debug("Done.\n");
 }
 
 module_init(mxser_module_init);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
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
char-mxser-add-cp-102uf-support.patch
char-mxser-update-documentation.patch
char-mxser-prints-cleanup.patch
char-mxser-remove-predefined-isa-support.patch
char-mxser-various-cleanups.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

