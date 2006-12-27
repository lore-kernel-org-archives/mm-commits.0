From: akpm@osdl.org
Subject: + char-mxser_new-mark-init-functions.patch added to -mm tree
Date: Tue, 26 Dec 2006 23:42:21 -0800
Message-ID: <200612270742.kBR7gLpx004640@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37193 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932949AbWL0HmX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 02:42:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: mxser_new, mark init functions
has been added to the -mm tree.  Its filename is
     char-mxser_new-mark-init-functions.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: mxser_new, mark init functions
From: Jiri Slaby <jirislaby@gmail.com>

Mark some funcions with __init and __devinit.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/mxser_new.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-mark-init-functions drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-mark-init-functions
+++ a/drivers/char/mxser_new.c
@@ -316,7 +316,7 @@ static int mxser_set_baud_method[MXSER_P
 static spinlock_t gm_lock;
 
 #ifdef CONFIG_PCI
-static int CheckIsMoxaMust(int io)
+static int __devinit CheckIsMoxaMust(int io)
 {
 	u8 oldmcr, hwid;
 	int i;
@@ -1373,7 +1373,7 @@ static int mxser_tiocmset(struct tty_str
 	return 0;
 }
 
-static int mxser_program_mode(int port)
+static int __init mxser_program_mode(int port)
 {
 	int id, i, j, n;
 
@@ -1410,7 +1410,7 @@ static int mxser_program_mode(int port)
 	return id;
 }
 
-static void mxser_normal_mode(int port)
+static void __init mxser_normal_mode(int port)
 {
 	int i, n;
 
@@ -1443,7 +1443,7 @@ static void mxser_normal_mode(int port)
 #define EN0_PORT	0x010	/* Rcv missed frame error counter RD */
 #define ENC_PAGE0	0x000	/* Select page 0 of chip registers   */
 #define ENC_PAGE3	0x0C0	/* Select page 3 of chip registers   */
-static int mxser_read_register(int port, unsigned short *regs)
+static int __init mxser_read_register(int port, unsigned short *regs)
 {
 	int i, k, value, id;
 	unsigned int j;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-input.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-isicom-remove-tty_hangwakeup-bottomhalves.patch
mxser-remove-ambiguous-redefinition-of-init_work.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
char-isicom-fix-locking-in-isr.patch
char-isicom-augment-card_reset.patch
char-isicom-check-card-state-in-isr.patch
char-isicom-support-higher-rates.patch
char-isicom-correct-probing-removing.patch
char-tty_wakeup-cleanup.patch
char-mxser-fix-oops-when-removing-opened.patch
char-mxser_new-mark-init-functions.patch
char-mxser_new-remove-useless-spinlock.patch
shrink_slab-handle-bad-shrinkers.patch

