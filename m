From: akpm@linux-foundation.org
Subject: + lis3lv02d-send-sync-event.patch added to -mm tree
Date: Mon, 16 Nov 2009 12:04:08 -0800
Message-ID: <200911162004.nAGK49dC027551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752121AbZKPUER (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Nov 2009 15:04:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samu.p.onkalo@nokia.com, eric.piel@tremplin-utc.net, pavel@ucw.cz


The patch titled
     lis3lv02d: send sync event
has been added to the -mm tree.  Its filename is
     lis3lv02d-send-sync-event.patch

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
Subject: lis3lv02d: send sync event
=46rom: Samu Onkalo <samu.p.onkalo@nokia.com>

Send input_sync after each measurement round. This helps userspace to
detect which reported values belongs to the same measurement.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Tested-by: =C9ric Piel <eric.piel@tremplin-utc.net>
Acked-by: =C9ric Piel <eric.piel@tremplin-utc.net>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lis3lv02d.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/hwmon/lis3lv02d.c~lis3lv02d-send-sync-event drivers/h=
wmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3lv02d-send-sync-event
+++ a/drivers/hwmon/lis3lv02d.c
@@ -276,6 +276,7 @@ static void lis3lv02d_joystick_poll(stru
 	input_report_abs(pidev->input, ABS_X, x - lis3_dev.xcalib);
 	input_report_abs(pidev->input, ABS_Y, y - lis3_dev.ycalib);
 	input_report_abs(pidev->input, ABS_Z, z - lis3_dev.zcalib);
+	input_sync(pidev->input);
 }
=20
=20
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
