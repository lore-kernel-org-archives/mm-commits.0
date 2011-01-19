From: akpm@linux-foundation.org
Subject: + drivers-misc-bmp085c-free-initmem-memory.patch added to -mm tree
Date: Tue, 18 Jan 2011 16:06:27 -0800
Message-ID: <201101190006.p0J06R0k014904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186Ab1ASAG3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Jan 2011 19:06:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shubhrajyoti@ti.com


The patch titled
     drivers/misc/bmp085.c: free initmem memory
has been added to the -mm tree.  Its filename is
     drivers-misc-bmp085c-free-initmem-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -457,7 +457,7 @@ static struct i2c_driver bmp085_driver =
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
bh1780gli-convert-to-dev-pm-ops.patch
drivers-misc-bmp085c-free-initmem-memory.patch

