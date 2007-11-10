From: akpm@linux-foundation.org
Subject: + make-ds1wm-driver-to-check-ds1wm_platform_data-pointer-against-null.patch added to -mm tree
Date: Fri, 09 Nov 2007 17:02:44 -0800
Message-ID: <200711100102.lAA12imR008173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55483 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761675AbXKJBDy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 20:03:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.y.miao@gmail.com, eric.miao@marvell.com, johnpol@2ka.mipt.ru, szabolcs.gyurko@tlt.hu


The patch titled
     w1: make ds1wm driver to check ds1wm_platform_data pointer against NULL
has been added to the -mm tree.  Its filename is
     make-ds1wm-driver-to-check-ds1wm_platform_data-pointer-against-null.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: w1: make ds1wm driver to check ds1wm_platform_data pointer against NULL
From: "eric miao" <eric.y.miao@gmail.com>

Do a sanity check for the "struct ds1wm_platform_data" pointer passed in by
the platform_device, and so to enforce each platform to provide a valid
structure.

Signed-off-by: eric miao <eric.miao@marvell.com>
Cc: "Szabolcs Gyurko" <szabolcs.gyurko@tlt.hu>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/ds1wm.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/w1/masters/ds1wm.c~make-ds1wm-driver-to-check-ds1wm_platform_data-pointer-against-null drivers/w1/masters/ds1wm.c
--- a/drivers/w1/masters/ds1wm.c~make-ds1wm-driver-to-check-ds1wm_platform_data-pointer-against-null
+++ a/drivers/w1/masters/ds1wm.c
@@ -351,6 +351,10 @@ static int ds1wm_probe(struct platform_d
 		goto err0;
 	}
 	plat = pdev->dev.platform_data;
+	if (!plat) {
+		ret = -ENXIO;
+		goto err0;
+	}
 	ds1wm_data->bus_shift = plat->bus_shift;
 	ds1wm_data->pdev = pdev;
 	ds1wm_data->pdata = plat;
_

Patches currently in -mm which might be from eric.y.miao@gmail.com are

make-ds1wm-driver-to-check-ds1wm_platform_data-pointer-against-null.patch
