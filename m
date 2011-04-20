From: akpm@linux-foundation.org
Subject: [alternative-merged] vt-add-k_off-return-value-to-vt_ioctl-kdgkbmode.patch removed from -mm tree
Date: Wed, 20 Apr 2011 13:52:35 -0700
Message-ID: <201104202048.p3KKmSxK026029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814Ab1DTUsc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Apr 2011 16:48:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: art@ified.ca, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     vt: add K_OFF return value to vt_ioctl KDGKBMODE
has been removed from the -mm tree.  Its filename was
     vt-add-k_off-return-value-to-vt_ioctl-kdgkbmode.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vt: add K_OFF return value to vt_ioctl KDGKBMODE
From: Arthur Taylor <art@ified.ca>

After adding support for K_OFF in KDSKBMODE, it was forgotten to add
support for returning it in KDGKBMODE.

Signed-off-by: Arthur Taylor <art@ified.ca>
Cc: Greg KH <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/vt/vt_ioctl.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/tty/vt/vt_ioctl.c~vt-add-k_off-return-value-to-vt_ioctl-kdgkbmode drivers/tty/vt/vt_ioctl.c
--- a/drivers/tty/vt/vt_ioctl.c~vt-add-k_off-return-value-to-vt_ioctl-kdgkbmode
+++ a/drivers/tty/vt/vt_ioctl.c
@@ -701,6 +701,7 @@ int vt_ioctl(struct tty_struct *tty,
 		uival = ((kbd->kbdmode == VC_RAW) ? K_RAW :
 				 (kbd->kbdmode == VC_MEDIUMRAW) ? K_MEDIUMRAW :
 				 (kbd->kbdmode == VC_UNICODE) ? K_UNICODE :
+				 (kbd->kbdmode == VC_OFF) ? K_OFF :
 				 K_XLATE);
 		goto setint;
 
_

Patches currently in -mm which might be from art@ified.ca are

linux-next.patch
drivers-tty-vt-vt_ioctlc-repair-insane-expression.patch

