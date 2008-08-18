From: akpm@linux-foundation.org
Subject: - drivers-hwmon-w83791dc-fix-unused-var-warning.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:39:52 -0700
Message-ID: <200808181939.m7IJdqAc008373@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762786AbYHRTkt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:40:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: niro@tut.by, mhoffman@lightlink.com, mm-commits@vger.kernel.org


The patch titled
     drivers/hwmon/w83791d.c: fix unused var warning
has been removed from the -mm tree.  Its filename was
     drivers-hwmon-w83791dc-fix-unused-var-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/hwmon/w83791d.c: fix unused var warning
From: Michael Borisov <niro@tut.by>

drivers/hwmon/w83791d.c: In function `w83791d_probe':
drivers/hwmon/w83791d.c:1049: warning: unused variable `val1'

Signed-off-by: Michael Borisov <niro@tut.by>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/w83791d.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/hwmon/w83791d.c~drivers-hwmon-w83791dc-fix-unused-var-warning drivers/hwmon/w83791d.c
--- a/drivers/hwmon/w83791d.c~drivers-hwmon-w83791dc-fix-unused-var-warning
+++ a/drivers/hwmon/w83791d.c
@@ -1055,9 +1055,10 @@ static int w83791d_probe(struct i2c_clie
 {
 	struct w83791d_data *data;
 	struct device *dev = &client->dev;
-	int i, val1, err;
+	int i, err;
 
 #ifdef DEBUG
+	int val1;
 	val1 = w83791d_read(client, W83791D_REG_DID_VID4);
 	dev_dbg(dev, "Device ID version: %d.%d (0x%02x)\n",
 			(val1 >> 5) & 0x07, (val1 >> 1) & 0x0f, val1);
_

Patches currently in -mm which might be from niro@tut.by are

origin.patch

