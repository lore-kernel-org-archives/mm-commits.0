From: akpm@linux-foundation.org
Subject: [merged] misc-isl29020-signedness-bug-in-als_sensing_range_store.patch removed from -mm tree
Date: Tue, 16 Nov 2010 11:30:06 -0800
Message-ID: <201011161933.oAGJXIjb003095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756235Ab0KPTdV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 14:33:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, alan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     misc/isl29020: signedness bug in als_sensing_range_store()
has been removed from the -mm tree.  Its filename was
     misc-isl29020-signedness-bug-in-als_sensing_range_store.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: misc/isl29020: signedness bug in als_sensing_range_store()
From: Dan Carpenter <error27@gmail.com>

"ret_val" is supposed to be signed here or the error handling breaks.
Also we should check the return value from i2c_smbus_read_byte_data().

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/isl29020.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/misc/isl29020.c~misc-isl29020-signedness-bug-in-als_sensing_range_store drivers/misc/isl29020.c
--- a/drivers/misc/isl29020.c~misc-isl29020-signedness-bug-in-als_sensing_range_store
+++ a/drivers/misc/isl29020.c
@@ -87,7 +87,7 @@ static ssize_t als_sensing_range_store(s
 		struct device_attribute *attr, const  char *buf, size_t count)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	unsigned int ret_val;
+	int ret_val;
 	unsigned long val;
 
 	if (strict_strtoul(buf, 10, &val))
@@ -106,6 +106,8 @@ static ssize_t als_sensing_range_store(s
 		val = 4;
 
 	ret_val = i2c_smbus_read_byte_data(client, 0x00);
+	if (ret_val < 0)
+		return ret_val;
 
 	ret_val &= 0xFC; /*reset the bit before setting them */
 	ret_val |= val - 1;
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch

