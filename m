From: akpm@linux-foundation.org
Subject: - char-mxser_new-mark-init-functions.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:51:22 -0800
Message-ID: <200702112251.l1BMpMXb015939@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60108 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932753AbXBKWvY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:51:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: mxser_new, mark init functions
has been removed from the -mm tree.  Its filename was
     char-mxser_new-mark-init-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: mxser_new, mark init functions
From: Jiri Slaby <jirislaby@gmail.com>

Mark some funcions with __init and __devinit.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

origin.patch
char-use-more-pci_device-macro.patch
char-cyclades-use-pci_device_id.patch
maintainers-remove-two-dead-e-mail.patch
char-specialix-isr-have-2-params.patch
char-timers-cleanup.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
video-fb-add-true-ref_count-atomicity.patch
video-fb-kzalloc-changes.patch
shrink_slab-handle-bad-shrinkers.patch
