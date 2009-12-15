From: akpm@linux-foundation.org
Subject: [merged] lis3lv02d-send-sync-event.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:59:15 -0800
Message-ID: <200912152159.nBFLxF5Y015885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933932AbZLOWJS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:09:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samu.p.onkalo@nokia.com, eric.piel@tremplin-utc.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     lis3lv02d: send sync event
has been removed from the -mm tree.  Its filename was
     lis3lv02d-send-sync-event.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
