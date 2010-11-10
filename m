From: akpm@linux-foundation.org
Subject: + misc-isl29020-signedness-bug-in-als_sensing_range_store.patch added to -mm tree
Date: Wed, 10 Nov 2010 07:20:36 -0800
Message-ID: <201011101522.oAAFMwlN021672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756649Ab0KJPX3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Nov 2010 10:23:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, alan@linux.intel.com


The patch titled
     misc/isl29020: signedness bug in als_sensing_range_store()
has been added to the -mm tree.  Its filename is
     misc-isl29020-signedness-bug-in-als_sensing_range_store.patch

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

origin.patch
rapidio-use-resource_size.patch
misc-isl29020-signedness-bug-in-als_sensing_range_store.patch
linux-next.patch
memcg-null-dereference-on-allocation-failure.patch
drivers-misc-bh1770glcc-error-handling-in-bh1770_power_state_store.patch

