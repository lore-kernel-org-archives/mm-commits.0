From: akpm@linux-foundation.org
Subject: + obsolete-config-in-kernel-source-hso_autopm.patch added to -mm tree
Date: Fri, 05 Feb 2010 14:20:43 -0800
Message-ID: <201002052220.o15MKh8o024580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933910Ab0BEWVU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2010 17:21:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: siccegge@stud.informatik.uni-erlangen.de, davem@davemloft.net


The patch titled
     obsolete config in kernel source: HSO_AUTOPM
has been added to the -mm tree.  Its filename is
     obsolete-config-in-kernel-source-hso_autopm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
obsolete-config-in-kernel-source-use_internal_timer.patch
obsolete-config-in-kernel-source-hso_autopm.patch
fbdev-remove-obsolete-config_fb_soft_cursor.patch
obsolete-config-in-kernel-source-lwmon5.patch
obsolete-config-in-kernel-source-buffer_debug.patch

