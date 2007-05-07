From: akpm@linux-foundation.org
Subject: - mousedev-fix.patch removed from -mm tree
Date: Sun, 06 May 2007 23:23:06 -0700
Message-ID: <200705070623.l476N6wf019393@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754048AbXEGGXO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 02:23:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dtor@insightbb.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     mosuedev fix
has been removed from the -mm tree.  Its filename was
     mousedev-fix.patch

This patch was dropped because the struct subsystem removal patch got applied

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

origin.patch
git-input.patch
mousedev-fix.patch
mousedev-fix-2.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio.patch
