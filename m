From: akpm@linux-foundation.org
Subject: - char-stallion-proper-fail-return-values.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:57:04 -0700
Message-ID: <200706121857.l5CIv4ZO018442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59195 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756514AbXFLS5M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 14:57:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: stallion, proper fail return values
has been removed from the -mm tree.  Its filename was
     char-stallion-proper-fail-return-values.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: stallion, proper fail return values
From: Jiri Slaby <jirislaby@gmail.com>

do not return 0 in one case and return proper values in other 2.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/stallion.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/char/stallion.c~char-stallion-proper-fail-return-values drivers/char/stallion.c
--- a/drivers/char/stallion.c~char-stallion-proper-fail-return-values
+++ a/drivers/char/stallion.c
@@ -2177,6 +2177,7 @@ static int __devinit stl_initech(struct 
 		if (!panelp) {
 			printk("STALLION: failed to allocate memory "
 				"(size=%Zd)\n", sizeof(struct stlpanel));
+			retval = -ENOMEM;
 			goto err_fr;
 		}
 		panelp->magic = STL_PANELMAGIC;
@@ -2223,8 +2224,10 @@ static int __devinit stl_initech(struct 
 		brdp->nrports += panelp->nrports;
 		brdp->panels[panelnr++] = panelp;
 		if ((brdp->brdtype != BRD_ECHPCI) &&
-		    (ioaddr >= (brdp->ioaddr2 + brdp->iosize2)))
+		    (ioaddr >= (brdp->ioaddr2 + brdp->iosize2))) {
+			retval = -EINVAL;
 			goto err_fr;
+		}
 	}
 
 	brdp->nrpanels = panelnr;
@@ -2371,6 +2374,7 @@ static int __devinit stl_pciprobe(struct
 		dev_err(&pdev->dev, "too many boards found, "
 			"maximum supported %d\n", STL_MAXBRDS);
 		mutex_unlock(&stl_brdslock);
+		retval = -ENODEV;
 		goto err_fr;
 	}
 	brdp->brdnr = (unsigned int)brdnr;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
rocketc-fix-unchecked-mutex_lock_interruptible.patch
char-n_hdlc-allow-restartsys-retval-of-tty-write.patch
char-mxser_new-fix-sparse-warning.patch
char-tty_ioctl-use-wait_event_interruptible_timeout.patch
char-tty_ioctl-little-whitespace-cleanup.patch
char-genrtc-use-wait_event_interruptible.patch
char-n_r3964-use-wait_event_interruptible.patch
char-ip2-use-msleep-for-sleeping.patch
drop-an-empty-isicomh-from-being-exported-to-user-space.patch
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
char-isicom-cleanup-locking.patch
char-isicom-del_timer-at-exit.patch
char-isicom-proper-variables-types.patch
char-moxa-eliminate-busy-waiting.patch
char-specialix-remove-busy-waiting.patch
char-riscom8-eliminate-busy-loop.patch
char-vt-use-kzalloc.patch
char-vt-use-array_size.patch
char-kconfig-mxser_new-remove-experimental-comment.patch
char-stallion-remove-user-class-report-request.patch
shrink_slab-handle-bad-shrinkers.patch
