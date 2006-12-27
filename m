From: akpm@osdl.org
Subject: + char-mxser-fix-oops-when-removing-opened.patch added to -mm tree
Date: Tue, 26 Dec 2006 23:42:19 -0800
Message-ID: <200612270742.kBR7gJZx004637@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37201 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932973AbWL0Hma (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 02:42:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, osv@javad.com


The patch titled
     Char: mxser, fix oops when removing opened
has been added to the -mm tree.  Its filename is
     char-mxser-fix-oops-when-removing-opened.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: mxser, fix oops when removing opened
From: Jiri Slaby <jirislaby@gmail.com>

tty_driver->owner is not set, so if somebody remove mxser_module, it might
oops (and doesn't tell the user: no way, it's in use). Set the .owner value.

Cc: <osv@javad.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/mxser.c     |    1 +
 drivers/char/mxser_new.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/char/mxser.c~char-mxser-fix-oops-when-removing-opened drivers/char/mxser.c
--- a/drivers/char/mxser.c~char-mxser-fix-oops-when-removing-opened
+++ a/drivers/char/mxser.c
@@ -717,6 +717,7 @@ static int mxser_init(void)
 
 	/* Initialize the tty_driver structure */
 	memset(mxvar_sdriver, 0, sizeof(struct tty_driver));
+	mxvar_sdriver->owner = THIS_MODULE;
 	mxvar_sdriver->magic = TTY_DRIVER_MAGIC;
 	mxvar_sdriver->name = "ttyMI";
 	mxvar_sdriver->major = ttymajor;
diff -puN drivers/char/mxser_new.c~char-mxser-fix-oops-when-removing-opened drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser-fix-oops-when-removing-opened
+++ a/drivers/char/mxser_new.c
@@ -2690,6 +2690,7 @@ static int __init mxser_module_init(void
 		MXSER_VERSION);
 
 	/* Initialize the tty_driver structure */
+	mxvar_sdriver->owner = THIS_MODULE;
 	mxvar_sdriver->magic = TTY_DRIVER_MAGIC;
 	mxvar_sdriver->name = "ttyMI";
 	mxvar_sdriver->major = ttymajor;
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

