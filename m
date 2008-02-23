From: akpm@linux-foundation.org
Subject: + vt-notifier-fix-for-vt-switch.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:34:26 -0800
Message-ID: <200802230735.m1N7ZFI4018348@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917AbYBWHte (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:49:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samuel.thibault@ens-lyon.org


The patch titled
     VT notifier fix for VT switch
has been added to the -mm tree.  Its filename is
     vt-notifier-fix-for-vt-switch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: VT notifier fix for VT switch
From: Samuel Thibault <samuel.thibault@ens-lyon.org>

Needs a changelog

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/vt.c~vt-notifier-fix-for-vt-switch drivers/char/vt.c
--- a/drivers/char/vt.c~vt-notifier-fix-for-vt-switch
+++ a/drivers/char/vt.c
@@ -702,6 +702,7 @@ void redraw_screen(struct vc_data *vc, i
 	if (is_switch) {
 		set_leds();
 		compute_shiftstate();
+		notify_update(vc);
 	}
 }
 
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

keyboard-notifier-documentation.patch
vt-notifier-extension-for-accessibility.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
vt-notifier-fix-for-vt-switch.patch
basic-braille-screen-reader-support.patch
