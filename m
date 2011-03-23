From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:38:43 -0700
Message-ID: <201103232042.p2NKgJnh028748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48530 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933404Ab1CWUmv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:42:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, alan@linux.intel.com, kalhan.trisal@intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/misc/hmc6352.c: fix wrong return value checking for i2c_master_recv()
has been removed from the -mm tree.  Its filename was
     drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc/hmc6352.c: fix wrong return value checking for i2c_master_recv()
From: Axel Lin <axel.lin@gmail.com>

i2c_master_recv() returns negative errno, or else the number of bytes
read.  Thus i2c_master_recv(client, i2c_data, 2) returns 2 instead of 1 in
success case.

[akpm@linux-foundation.org: make `ret' signed]
Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Kalhan Trisal <kalhan.trisal@intel.com>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hmc6352.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/misc/hmc6352.c~drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv drivers/misc/hmc6352.c
--- a/drivers/misc/hmc6352.c~drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv
+++ a/drivers/misc/hmc6352.c
@@ -75,7 +75,7 @@ static ssize_t compass_heading_data_show
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	unsigned char i2c_data[2];
-	unsigned int ret;
+	int ret;
 
 	mutex_lock(&compass_mutex);
 	ret = compass_command(client, 'A');
@@ -86,7 +86,7 @@ static ssize_t compass_heading_data_show
 	msleep(10); /* sending 'A' cmd we need to wait for 7-10 millisecs */
 	ret = i2c_master_recv(client, i2c_data, 2);
 	mutex_unlock(&compass_mutex);
-	if (ret != 1) {
+	if (ret < 0) {
 		dev_warn(dev, "i2c read data cmd failed\n");
 		return ret;
 	}
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch

