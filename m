From: akpm@linux-foundation.org
Subject: + lis3lv02d-correct-memory-leak-in-module-unload.patch added to -mm tree
Date: Mon, 16 Nov 2009 12:04:12 -0800
Message-ID: <200911162004.nAGK4Clk027624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752181AbZKPUER (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Nov 2009 15:04:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samu.p.onkalo@nokia.com, eric.piel@tremplin-utc.net, pavel@ucw.cz


The patch titled
     lis3lv02d: correct memory leak in module unload
has been added to the -mm tree.  Its filename is
     lis3lv02d-correct-memory-leak-in-module-unload.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: lis3lv02d: correct memory leak in module unload
=46rom: Samu Onkalo <samu.p.onkalo@nokia.com>

polled input device itself was not free'd.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Tested-by: =C9ric Piel <eric.piel@tremplin-utc.net>
Acked-by: =C9ric Piel <eric.piel@tremplin-utc.net>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lis3lv02d.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/hwmon/lis3lv02d.c~lis3lv02d-correct-memory-leak-in-mo=
dule-unload drivers/hwmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3lv02d-correct-memory-leak-in-module=
-unload
+++ a/drivers/hwmon/lis3lv02d.c
@@ -333,6 +333,7 @@ void lis3lv02d_joystick_disable(void)
 	if (lis3_dev.irq)
 		misc_deregister(&lis3lv02d_misc_device);
 	input_unregister_polled_device(lis3_dev.idev);
+	input_free_polled_device(lis3_dev.idev);
 	lis3_dev.idev =3D NULL;
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_joystick_disable);
_

Patches currently in -mm which might be from samu.p.onkalo@nokia.com ar=
e

linux-next.patch
lis3lv02d-axis-remap-and-resource-setup-release.patch
lis3lv02d-i2c-support.patch
lis3lv02d-send-sync-event.patch
lis3lv02d-correct-memory-leak-in-module-unload.patch
lis3-update-documentation-and-comments.patch
lis3-fix-show-rate-for-8-bits-chips.patch
lis3lv02d-proper-power-on-sequence.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
