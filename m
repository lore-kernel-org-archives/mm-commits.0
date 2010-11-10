From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-isl29020c-fix-signedness-bug.patch removed from -mm tree
Date: Wed, 10 Nov 2010 12:13:09 -0800
Message-ID: <201011102015.oAAKFXDU003522@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755876Ab0KJUPi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Nov 2010 15:15:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segooon@gmail.com, alan@linux.intel.com, arjan@linux.intel.com, hong.liu@intel.com, kalhan.trisal@intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/misc/isl29020.c: fix signedness bug
has been removed from the -mm tree.  Its filename was
     drivers-misc-isl29020c-fix-signedness-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc/isl29020.c: fix signedness bug
From: Vasiliy Kulikov <segooon@gmail.com>

i2c_smbus_write_byte_data() may return negative error code.  This is not
seen to als_sensing_range_store() as the result is stored in unsigned int.
Made it signed.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Cc: Liu Hong <hong.liu@intel.com>
Cc: Kalhan Trisal <kalhan.trisal@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/isl29020.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/isl29020.c~drivers-misc-isl29020c-fix-signedness-bug drivers/misc/isl29020.c
--- a/drivers/misc/isl29020.c~drivers-misc-isl29020c-fix-signedness-bug
+++ a/drivers/misc/isl29020.c
@@ -87,7 +87,7 @@ static ssize_t als_sensing_range_store(s
 		struct device_attribute *attr, const  char *buf, size_t count)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	unsigned int ret_val;
+	int ret_val;
 	unsigned long val;
 
 	if (strict_strtoul(buf, 10, &val))
_

Patches currently in -mm which might be from segooon@gmail.com are

origin.patch
linux-next.patch
drivers-misc-apds9802alsc-fix-signedness-bug.patch
memstick-core-fix-device_register-error-handling.patch

