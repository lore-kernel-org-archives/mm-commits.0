From: akpm@linux-foundation.org
Subject: - char-stallion-dont-fail-with-less-than-max-panels.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:56:59 -0700
Message-ID: <200706121856.l5CIuxgL018436@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37846 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754597AbXFLS5P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 14:57:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, ingo@akana.de, mm-commits@vger.kernel.org


The patch titled
     Char: stallion, don't fail with less than max panels
has been removed from the -mm tree.  Its filename was
     char-stallion-dont-fail-with-less-than-max-panels.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: stallion, don't fail with less than max panels
From: Jiri Slaby <jirislaby@gmail.com>

Since it's not neccesary to have MAX_PANELS on the card, don't fail to let
users use this card even in this case.  Stop the testing for loop instead.

Thanks to Ingo.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: "Ingo Korb" <ingo@akana.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/stallion.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/stallion.c~char-stallion-dont-fail-with-less-than-max-panels drivers/char/stallion.c
--- a/drivers/char/stallion.c~char-stallion-dont-fail-with-less-than-max-panels
+++ a/drivers/char/stallion.c
@@ -2172,7 +2172,7 @@ static int __devinit stl_initech(struct 
 		}
 		status = inb(ioaddr + ECH_PNLSTATUS);
 		if ((status & ECH_PNLIDMASK) != nxtid)
-			goto err_fr;
+			break;
 		panelp = kzalloc(sizeof(struct stlpanel), GFP_KERNEL);
 		if (!panelp) {
 			printk("STALLION: failed to allocate memory "
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
