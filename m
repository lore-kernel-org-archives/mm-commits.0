From: akpm@linux-foundation.org
Subject: + mousedev-fix.patch added to -mm tree
Date: Tue, 24 Apr 2007 22:16:50 -0700
Message-ID: <200704250516.l3P5GowH027618@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161620AbXDYFQz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 01:16:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dtor@insightbb.com, dtor@mail.ru


The patch titled
     mosuedev fix
has been added to the -mm tree.  Its filename is
     mousedev-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mosuedev fix
From: Dmitry Torokhov <dtor@insightbb.com>

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mousedev.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/input/mousedev.c~mousedev-fix drivers/input/mousedev.c
--- a/drivers/input/mousedev.c~mousedev-fix
+++ a/drivers/input/mousedev.c
@@ -406,12 +406,14 @@ static void mixdev_open_devices(void)
 	struct mousedev *mousedev;
 
 	list_for_each_entry(mousedev, &mousedev_mix_list, mixdev_node) {
-		if (mousedev->exist && !mousedev->open) {
-			if (input_open_device(&mousedev->handle))
-				continue;
+		if (mousedev->exist && !mousedev->mixdev_open) {
+			if (!mousedev->open) {
+				if (input_open_device(&mousedev->handle))
+					continue;
 
-			get_device(&mousedev->dev);
-			mousedev->open++;
+				get_device(&mousedev->dev);
+				mousedev->open++;
+			}
 			mousedev->mixdev_open++;
 		}
 	}
_

Patches currently in -mm which might be from dtor@insightbb.com are

git-input.patch
input-convert-from-class-devices-to-standard-devices.patch
input-evdev-implement-proper-locking.patch
mousedev-fix.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes-fix.patch
