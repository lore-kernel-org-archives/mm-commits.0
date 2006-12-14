From: akpm@osdl.org
Subject: + char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch added to -mm tree
Date: Wed, 13 Dec 2006 16:30:16 -0800
Message-ID: <200612140030.kBE0UGBR026290@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33587 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbWLNAaU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:30:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     Char: tty, delete wake_up_interruptible after tty_wakeup
has been added to the -mm tree.  Its filename is
     char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: tty, delete wake_up_interruptible after tty_wakeup
From: Jiri Slaby <jirislaby@gmail.com>

tty_wakeup calls wake_up_interruptible(&tty->write_wait) itself, it's not
needed to wake up again after tty_wakeup returns.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/tty_io.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/char/tty_io.c~char-tty-delete-wake_up_interruptible-after-tty_wakeup drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~char-tty-delete-wake_up_interruptible-after-tty_wakeup
+++ a/drivers/char/tty_io.c
@@ -1612,7 +1612,6 @@ void start_tty(struct tty_struct *tty)
 
 	/* If we have a running line discipline it may need kicking */
 	tty_wakeup(tty);
-	wake_up_interruptible(&tty->write_wait);
 }
 
 EXPORT_SYMBOL(start_tty);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
isicom-fix-build-with-pci-disabled.patch
mxser_new-fix-non-pci-build.patch
sx-fix-non-pci-build.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch

