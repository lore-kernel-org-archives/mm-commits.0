From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-bmp085c-free-initmem-memory.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:38:38 -0700
Message-ID: <201103232042.p2NKgEn0028735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933404Ab1CWUmn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:42:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shubhrajyoti@ti.com, mm-commits@vger.kernel.org


The patch titled
     drivers/misc/bmp085.c: free initmem memory
has been removed from the -mm tree.  Its filename was
     drivers-misc-bmp085c-free-initmem-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc/bmp085.c: free initmem memory
From: Shubhrajyoti Datta <shubhrajyoti@ti.com>

Free the memory that is used only at init

Signed-off-by: Shubhrajyoti Datta <shubhrajyoti@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/bmp085.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/misc/bmp085.c~drivers-misc-bmp085c-free-initmem-memory drivers/misc/bmp085.c
--- a/drivers/misc/bmp085.c~drivers-misc-bmp085c-free-initmem-memory
+++ a/drivers/misc/bmp085.c
@@ -402,7 +402,7 @@ exit:
 	return status;
 }
 
-static int bmp085_probe(struct i2c_client *client,
+static int __devinit bmp085_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
 	struct bmp085_data *data;
@@ -438,7 +438,7 @@ exit:
 	return err;
 }
 
-static int bmp085_remove(struct i2c_client *client)
+static int __devexit bmp085_remove(struct i2c_client *client)
 {
 	sysfs_remove_group(&client->dev.kobj, &bmp085_attr_group);
 	kfree(i2c_get_clientdata(client));
@@ -458,7 +458,7 @@ static struct i2c_driver bmp085_driver =
 	},
 	.id_table	= bmp085_id,
 	.probe		= bmp085_probe,
-	.remove		= bmp085_remove,
+	.remove		= __devexit_p(bmp085_remove),
 
 	.detect		= bmp085_detect,
 	.address_list	= normal_i2c
_

Patches currently in -mm which might be from shubhrajyoti@ti.com are

origin.patch

