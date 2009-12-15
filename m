From: akpm@linux-foundation.org
Subject: [merged] lis3lv02d-axis-remap-and-resource-setup-release.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:59:09 -0800
Message-ID: <200912152159.nBFLx9J3015878@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761374AbZLOWQm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:16:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samu.p.onkalo@nokia.com, eric.piel@tremplin-utc.net, kalhan.trisal@intel.com, khali@linux-fr.org, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     lis3lv02d: axis remap and resource setup/release
has been removed from the -mm tree.  Its filename was
     lis3lv02d-axis-remap-and-resource-setup-release.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: lis3lv02d: axis remap and resource setup/release
=46rom: Samu Onkalo <samu.p.onkalo@nokia.com>

Add the possibility to remap axes via platform data.  Function pointers
for resource setup and release purposes

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: =C9ric Piel <eric.piel@tremplin-utc.net>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Jean Delvare <khali@linux-fr.org>
Cc:  "Trisal, Kalhan" <kalhan.trisal@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lis3lv02d.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN include/linux/lis3lv02d.h~lis3lv02d-axis-remap-and-resource-s=
etup-release include/linux/lis3lv02d.h
--- a/include/linux/lis3lv02d.h~lis3lv02d-axis-remap-and-resource-setup=
-release
+++ a/include/linux/lis3lv02d.h
@@ -43,6 +43,18 @@ struct lis3lv02d_platform_data {
 #define LIS3_WAKEUP_Z_HI	(1 << 5)
 	unsigned char wakeup_flags;
 	unsigned char wakeup_thresh;
+#define LIS3_NO_MAP		0
+#define LIS3_DEV_X		1
+#define LIS3_DEV_Y		2
+#define LIS3_DEV_Z		3
+#define LIS3_INV_DEV_X	       -1
+#define LIS3_INV_DEV_Y	       -2
+#define LIS3_INV_DEV_Z	       -3
+	s8 axis_x;
+	s8 axis_y;
+	s8 axis_z;
+	int (*setup_resources)(void);
+	int (*release_resources)(void);
 };
=20
 #endif /* __LIS3LV02D_H_ */
_

Patches currently in -mm which might be from samu.p.onkalo@nokia.com ar=
e

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
