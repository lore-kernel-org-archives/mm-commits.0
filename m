From: akpm@linux-foundation.org
Subject: - char-mxser-simplify-mxser_get_serial_info.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:10:01 -0800
Message-ID: <200802080809.m1889g5B014873@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46972 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761658AbYBHITn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@redhat.com, jengelh@computergmbh.de, mm-commits@vger.kernel.org


The patch titled
     Char: mxser, simplify mxser_get_serial_info
has been removed from the -mm tree.  Its filename was
     char-mxser-simplify-mxser_get_serial_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: mxser, simplify mxser_get_serial_info
From: Jiri Slaby <jirislaby@gmail.com>

Initialize temp structure directly with proper values without first zeroing
it and setting later as suggested by Jan.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>
Reviewed-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser_new.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser-simplify-mxser_get_serial_info drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser-simplify-mxser_get_serial_info
+++ a/drivers/char/mxser_new.c
@@ -1168,21 +1168,18 @@ static void mxser_flush_buffer(struct tt
 static int mxser_get_serial_info(struct mxser_port *info,
 		struct serial_struct __user *retinfo)
 {
-	struct serial_struct tmp;
-
-	if (!retinfo)
-		return -EFAULT;
-	memset(&tmp, 0, sizeof(tmp));
-	tmp.type = info->type;
-	tmp.line = info->tty->index;
-	tmp.port = info->ioaddr;
-	tmp.irq = info->board->irq;
-	tmp.flags = info->flags;
-	tmp.baud_base = info->baud_base;
-	tmp.close_delay = info->close_delay;
-	tmp.closing_wait = info->closing_wait;
-	tmp.custom_divisor = info->custom_divisor;
-	tmp.hub6 = 0;
+	struct serial_struct tmp = {
+		.type = info->type,
+		.line = info->tty->index,
+		.port = info->ioaddr,
+		.irq = info->board->irq,
+		.flags = info->flags,
+		.baud_base = info->baud_base,
+		.close_delay = info->close_delay,
+		.closing_wait = info->closing_wait,
+		.custom_divisor = info->custom_divisor,
+		.hub6 = 0
+	};
 	if (copy_to_user(retinfo, &tmp, sizeof(*retinfo)))
 		return -EFAULT;
 	return 0;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
git-watchdog.patch
moxa-first-pass-at-termios-reporting.patch
char-applicom-use-pci_resource_start.patch
char-applicom-use-pci_match_id.patch
char-applicom-use-pci_match_id-fix.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
