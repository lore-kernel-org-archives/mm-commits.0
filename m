From: akpm@osdl.org
Subject: - char-istallion-dynamic-tty-device.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:10:28 -0800
Message-ID: <200612082010.kB8KAS7c002811@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58798 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946522AbWLHUKc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:10:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: istallion, dynamic tty device
has been removed from the -mm tree.  Its filename was
     char-istallion-dynamic-tty-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: istallion, dynamic tty device
From: Jiri Slaby <jirislaby@gmail.com>

register tty device dynamically according to the count of board ports.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/istallion.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN drivers/char/istallion.c~char-istallion-dynamic-tty-device drivers/char/istallion.c
--- a/drivers/char/istallion.c~char-istallion-dynamic-tty-device
+++ a/drivers/char/istallion.c
@@ -3846,6 +3846,10 @@ static int stli_findeisabrds(void)
 
 		stli_brds[brdp->brdnr] = brdp;
 		found++;
+
+		for (i = 0; i < brdp->nrports; i++)
+			tty_register_device(stli_serial,
+					brdp->brdnr * STL_MAXPORTS + i, NULL);
 	}
 
 	return found;
@@ -3872,6 +3876,7 @@ static int __devinit stli_pciprobe(struc
 		const struct pci_device_id *ent)
 {
 	struct stlibrd *brdp;
+	unsigned int i;
 	int brdnr, retval = -EIO;
 
 	retval = pci_enable_device(pdev);
@@ -3912,6 +3917,10 @@ static int __devinit stli_pciprobe(struc
 	brdp->enable = NULL;
 	brdp->disable = NULL;
 
+	for (i = 0; i < brdp->nrports; i++)
+		tty_register_device(stli_serial, brdp->brdnr * STL_MAXPORTS + i,
+				&pdev->dev);
+
 	return 0;
 err_null:
 	stli_brds[brdp->brdnr] = NULL;
@@ -3992,6 +4001,10 @@ static int stli_initbrds(void)
 		}
 		stli_brds[brdp->brdnr] = brdp;
 		found++;
+
+		for (i = 0; i < brdp->nrports; i++)
+			tty_register_device(stli_serial,
+					brdp->brdnr * STL_MAXPORTS + i, NULL);
 	}
 
 	retval = stli_findeisabrds();
@@ -4596,7 +4609,7 @@ static int __init istallion_module_init(
 	stli_serial->type = TTY_DRIVER_TYPE_SERIAL;
 	stli_serial->subtype = SERIAL_TYPE_NORMAL;
 	stli_serial->init_termios = stli_deftermios;
-	stli_serial->flags = TTY_DRIVER_REAL_RAW;
+	stli_serial->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
 	tty_set_operations(stli_serial, &stli_ops);
 
 	retval = tty_register_driver(stli_serial);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-istallion-dynamic-tty-device.patch
char-istallion-use-mod_timer.patch
char-cyclades-save-indent-levels.patch
char-cyclades-lindent-the-code.patch
char-cyclades-cleanup.patch
char-cyclades-fix-warnings.patch

