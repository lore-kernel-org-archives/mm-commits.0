From: akpm@linux-foundation.org
Subject: [merged] obsolete-config-in-kernel-source-hso_autopm.patch removed from -mm tree
Date: Thu, 18 Mar 2010 11:09:01 -0400
Message-ID: <201003181809.o2II9gTm007590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55448 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752448Ab0CRSKM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 14:10:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: siccegge@stud.informatik.uni-erlangen.de, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     obsolete config in kernel source: HSO_AUTOPM
has been removed from the -mm tree.  Its filename was
     obsolete-config-in-kernel-source-hso_autopm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: obsolete config in kernel source: HSO_AUTOPM
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>

CONFIG_HSO_AUTOPM is set by KConfig / set in the Kernel source, makefiles
and won't be ever set this way, therefor simply removing the protected
code.

Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/hso.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/net/usb/hso.c~obsolete-config-in-kernel-source-hso_autopm drivers/net/usb/hso.c
--- a/drivers/net/usb/hso.c~obsolete-config-in-kernel-source-hso_autopm
+++ a/drivers/net/usb/hso.c
@@ -1155,9 +1155,6 @@ static void _hso_serial_set_termios(stru
 static void hso_resubmit_rx_bulk_urb(struct hso_serial *serial, struct urb *urb)
 {
 	int result;
-#ifdef CONFIG_HSO_AUTOPM
-	usb_mark_last_busy(urb->dev);
-#endif
 	/* We are done with this URB, resubmit it. Prep the USB to wait for
 	 * another frame */
 	usb_fill_bulk_urb(urb, serial->parent->usb,
_

Patches currently in -mm which might be from siccegge@stud.informatik.uni-erlangen.de are

origin.patch
linux-next.patch

