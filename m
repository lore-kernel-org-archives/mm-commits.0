From: akpm@linux-foundation.org
Subject: - v4l-stk11xx-use-array_size-in-another-2-cases.patch removed from -mm tree
Date: Mon, 05 Nov 2007 23:33:51 -0800
Message-ID: <200711060740.lA67ed7q012692@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51200 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754543AbXKFHkt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 02:40:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     V4L: stk11xx, use ARRAY_SIZE in another 2 cases
has been removed from the -mm tree.  Its filename was
     v4l-stk11xx-use-array_size-in-another-2-cases.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: V4L: stk11xx, use ARRAY_SIZE in another 2 cases
From: Jiri Slaby <jirislaby@gmail.com>

There were 2 places with constant in for loop.  Use ARRARY_SIZE instead to
allow easy update of the tables.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/stk1125.c |    2 +-
 drivers/media/video/stk1135.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/media/video/stk1125.c~v4l-stk11xx-use-array_size-in-another-2-cases drivers/media/video/stk1125.c
--- a/drivers/media/video/stk1125.c~v4l-stk11xx-use-array_size-in-another-2-cases
+++ a/drivers/media/video/stk1125.c
@@ -80,7 +80,7 @@ static int stk1125_load_microcode(struct
 		break;
 	}
 
-	for (i = 0; i < 59; i++) {
+	for (i = 0; i < ARRAY_SIZE(values_1_204); i++) {
 		stk11xx_read_dummy(dev, 0x02ff);
 		stk11xx_write_reg(dev, 0x02ff, 0x00);
 
diff -puN drivers/media/video/stk1135.c~v4l-stk11xx-use-array_size-in-another-2-cases drivers/media/video/stk1135.c
--- a/drivers/media/video/stk1135.c~v4l-stk11xx-use-array_size-in-another-2-cases
+++ a/drivers/media/video/stk1135.c
@@ -53,7 +53,7 @@ static int stk1135_load_microcode(struct
 		0xe4, 0x09, 0xc8, 0x08, 0x08, 0x10, 0x14
 	};
 
-	for (i = 0; i < 117; i++) {
+	for (i = 0; i < ARRAY_SIZE(values_204); i++) {
 		stk11xx_read_dummy(dev, 0x02ff);
 		stk11xx_write_reg(dev, 0x02ff, 0x00);
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

v4l-stk11xx-add-a-new-webcam-driver.patch
v4l-stk11xx-use-array_size-in-another-2-cases.patch
v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
v4l-stk11xx-add-static-to-tables.patch
git-wireless.patch
crisv10-serial-driver-rewrite-take-three.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
