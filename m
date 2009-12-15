From: akpm@linux-foundation.org
Subject: [merged] lis3lv02d-correct-memory-leak-in-module-unload.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:59:18 -0800
Message-ID: <200912152159.nBFLxIuJ015892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755621AbZLOWJp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:09:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samu.p.onkalo@nokia.com, eric.piel@tremplin-utc.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     lis3lv02d: correct memory leak in module unload
has been removed from the -mm tree.  Its filename was
     lis3lv02d-correct-memory-leak-in-module-unload.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
