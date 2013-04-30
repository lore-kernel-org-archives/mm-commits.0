From: akpm@linux-foundation.org
Subject: [merged] backlight-adp8870-add-missing-braces.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:51:33 -0700
Message-ID: <20130430185133.6E88C31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:35460 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669Ab3D3Sve (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:51:34 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so86441vcb.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:51:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/adp8870_bl.c:  add missing braces
has been removed from the -mm tree.  Its filename was
     backlight-adp8870-add-missing-braces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/adp8870_bl.c:  add missing braces

Add missing braces to include error message.  The error message is related
to the return value for sysfs_create_group().  However,
sysfs_create_group() is called when pdata->en_ambl_sens is not zero. 
Thus, the checking return value should be included in the if statement.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp8870_bl.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/adp8870_bl.c~backlight-adp8870-add-missing-braces drivers/video/backlight/adp8870_bl.c
--- a/drivers/video/backlight/adp8870_bl.c~backlight-adp8870-add-missing-braces
+++ a/drivers/video/backlight/adp8870_bl.c
@@ -895,13 +895,13 @@ static int adp8870_probe(struct i2c_clie
 
 	data->bl = bl;
 
-	if (pdata->en_ambl_sens)
+	if (pdata->en_ambl_sens) {
 		ret = sysfs_create_group(&bl->dev.kobj,
 			&adp8870_bl_attr_group);
