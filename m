From: akpm@linux-foundation.org
Subject: + i2o-check-copy_from_user-size-parameter.patch added to -mm tree
Date: Fri, 01 Mar 2013 13:14:37 -0800
Message-ID: <20130301211437.9CF3C31C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:40337 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3CAVOj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Mar 2013 16:14:39 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so886qaj.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Mar 2013 13:14:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, alan@linux.intel.com, jkosina@suse.cz, standby24x7@gmail.com


The patch titled
     Subject: i2o: check copy_from_user() size parameter
has been added to the -mm tree.  Its filename is
     i2o-check-copy_from_user-size-parameter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: i2o: check copy_from_user() size parameter

Limit the size of the copy so we don't corrupt memory.  Hopefully this can
only be called by root, but fixing this makes the static checkers happier.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Masanari Iida <standby24x7@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
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
i2o-check-copy_from_user-size-parameter.patch

