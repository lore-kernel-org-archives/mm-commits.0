From: akpm@linux-foundation.org
Subject: + drivers-misc-apds9802alsc-fix-signedness-bug.patch added to -mm tree
Date: Fri, 29 Oct 2010 15:30:30 -0700
Message-ID: <201010292230.o9TMUU0N020715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933070Ab0J2WbC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Oct 2010 18:31:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segooon@gmail.com, alan@linux.intel.com, anantha.narayanan@intel.com, hong.liu@intel.com


The patch titled
     drivers/misc/apds9802als.c: fix signedness bug
has been added to the -mm tree.  Its filename is
     drivers-misc-apds9802alsc-fix-signedness-bug.patch

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

origin.patch
linux-next.patch
drivers-misc-isl29020c-fix-signedness-bug.patch
drivers-misc-isl29020c-dont-ignore-the-i2c_smbus_read_byte_data-return-value.patch
drivers-misc-apds9802alsc-fix-signedness-bug.patch
memstick-core-fix-device_register-error-handling.patch

