From: akpm@linux-foundation.org
Subject: + vt-add-k_off-return-value-to-vt_ioctl-kdgkbmode.patch added to -mm tree
Date: Thu, 07 Apr 2011 16:12:59 -0700
Message-ID: <201104072313.p37ND038006133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57272 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757111Ab1DGXNd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2011 19:13:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: art@ified.ca, gregkh@suse.de


The patch titled
     vt: add K_OFF return value to vt_ioctl KDGKBMODE
has been added to the -mm tree.  Its filename is
     vt-add-k_off-return-value-to-vt_ioctl-kdgkbmode.patch

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

vt-add-k_off-return-value-to-vt_ioctl-kdgkbmode.patch
drivers-tty-vt-vt_ioctlc-repair-insane-expression.patch

