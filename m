From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-apds9802alsc-fix-signedness-bug.patch removed from -mm tree
Date: Tue, 16 Nov 2010 11:30:08 -0800
Message-ID: <201011161933.oAGJXK3l003098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756322Ab0KPTdX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 14:33:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segooon@gmail.com, alan@linux.intel.com, anantha.narayanan@intel.com, hong.liu@intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/misc/apds9802als.c: fix signedness bug
has been removed from the -mm tree.  Its filename was
     drivers-misc-apds9802alsc-fix-signedness-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc/apds9802als.c: fix signedness bug
From: Vasiliy Kulikov <segooon@gmail.com>

i2c_smbus_read_byte_data() may return negative error code.  This is not
seen to als_sensing_range_store() as the result is stored in unsigned int.
 Made it signed.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Cc: Hong Liu <hong.liu@intel.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Anantha Narayanan <anantha.narayanan@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/apds9802als.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/apds9802als.c~drivers-misc-apds9802alsc-fix-signedness-bug drivers/misc/apds9802als.c
--- a/drivers/misc/apds9802als.c~drivers-misc-apds9802alsc-fix-signedness-bug
+++ a/drivers/misc/apds9802als.c
@@ -123,7 +123,7 @@ static ssize_t als_sensing_range_store(s
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct als_data *data = i2c_get_clientdata(client);
-	unsigned int ret_val;
+	int ret_val;
 	unsigned long val;
 
 	if (strict_strtoul(buf, 10, &val))
_

Patches currently in -mm which might be from segooon@gmail.com are

linux-next.patch
fs-select-fix-information-leak-to-userspace.patch
fs-select-fix-information-leak-to-userspace-fix.patch
memstick-core-fix-device_register-error-handling.patch

