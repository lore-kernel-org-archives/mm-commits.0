From: akpm@linux-foundation.org
Subject: + ds1374-check-for-workqueue-creation.patch added to -mm tree
Date: Fri, 16 Feb 2007 17:26:23 -0800
Message-ID: <200702170126.l1H1QNq0015718@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43846 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946360AbXBQB0Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 20:26:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com


The patch titled
     DS1374: check for workqueue creation
has been added to the -mm tree.  Its filename is
     ds1374-check-for-workqueue-creation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: DS1374: check for workqueue creation
From: "Cyrill V. Gorcunov" <gorcunov@gmail.com>

Check if workqueue creation failed.  Further usage of NULL pointed
workqueue is not good I guess ;)

Signed-off-by: Cyrill V. Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/chips/ds1374.c |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN drivers/i2c/chips/ds1374.c~ds1374-check-for-workqueue-creation drivers/i2c/chips/ds1374.c
--- a/drivers/i2c/chips/ds1374.c~ds1374-check-for-workqueue-creation
+++ a/drivers/i2c/chips/ds1374.c
@@ -207,6 +207,10 @@ static int ds1374_probe(struct i2c_adapt
 	client->driver = &ds1374_driver;
 
 	ds1374_workqueue = create_singlethread_workqueue("ds1374");
+	if (!ds1374_workqueue) {
+		kfree(client);
+		return -ENOMEM;	/* most expected reason */
+	}
 
 	if ((rc = i2c_attach_client(client)) != 0) {
 		kfree(client);
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
ds1374-check-for-workqueue-creation.patch
git-input.patch
