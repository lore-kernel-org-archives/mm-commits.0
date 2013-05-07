From: akpm@linux-foundation.org
Subject: [merged] i2o-check-copy_from_user-size-parameter.patch removed from -mm tree
Date: Tue, 07 May 2013 10:48:30 -0700
Message-ID: <20130507174830.806965A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:43566 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931Ab3EGRsb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:48:31 -0400
Received: by mail-gh0-f202.google.com with SMTP id g24so73451ghb.3
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:48:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, alan@linux.intel.com, jkosina@suse.cz, linux@roeck-us.net, standby24x7@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: i2o: check copy_from_user() size parameter
has been removed from the -mm tree.  Its filename was
     i2o-check-copy_from_user-size-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: i2o: check copy_from_user() size parameter

Limit the size of the copy so we don't corrupt memory.  Hopefully this can
only be called by root, but fixing this makes the static checkers happier.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Masanari Iida <standby24x7@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/i2o_config.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/message/i2o/i2o_config.c~i2o-check-copy_from_user-size-parameter drivers/message/i2o/i2o_config.c
--- a/drivers/message/i2o/i2o_config.c~i2o-check-copy_from_user-size-parameter
+++ a/drivers/message/i2o/i2o_config.c
@@ -687,6 +687,11 @@ static int i2o_cfg_passthru32(struct fil
 		}
 		size = size >> 16;
 		size *= 4;
+		if (size > sizeof(rmsg)) {
+			rcode = -EINVAL;
+			goto sg_list_cleanup;
+		}
+
 		/* Copy in the user's I2O command */
 		if (copy_from_user(rmsg, user_msg, size)) {
 			rcode = -EFAULT;
@@ -922,6 +927,11 @@ static int i2o_cfg_passthru(unsigned lon
 		}
 		size = size >> 16;
 		size *= 4;
+		if (size > sizeof(rmsg)) {
+			rcode = -EFAULT;
+			goto sg_list_cleanup;
+		}
+
 		/* Copy in the user's I2O command */
 		if (copy_from_user(rmsg, user_msg, size)) {
 			rcode = -EFAULT;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
mwave-fix-info-leak-in-mwave_ioctl.patch

