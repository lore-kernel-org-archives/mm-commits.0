From: akpm@linux-foundation.org
Subject: + i2o-check-return-code-from-put_user.patch added to -mm tree
Date: Wed, 21 Jul 2010 14:45:45 -0700
Message-ID: <201007212145.o6LLjjhR016931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756832Ab0GUVps (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Jul 2010 17:45:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segooon@gmail.com


The patch titled
     i2o: check return code from put_user()
has been added to the -mm tree.  Its filename is
     i2o-check-return-code-from-put_user.patch

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
Subject: i2o: check return code from put_user()
From: Kulikov Vasiliy <segooon@gmail.com>

Check return value of put_user() and return -EFAULT if it failed. 
Original comment "We did a get user...so assuming mem is ok...is this
bad?" is incorrect because memory can be read only.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/i2o_config.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/message/i2o/i2o_config.c~i2o-check-return-code-from-put_user drivers/message/i2o/i2o_config.c
--- a/drivers/message/i2o/i2o_config.c~i2o-check-return-code-from-put_user
+++ a/drivers/message/i2o/i2o_config.c
@@ -111,9 +111,9 @@ static int i2o_cfg_gethrt(unsigned long 
 
 	len = 8 + ((hrt->entry_len * hrt->num_entries) << 2);
 
-	/* We did a get user...so assuming mem is ok...is this bad? */
-	put_user(len, kcmd.reslen);
-	if (len > reslen)
+	if (put_user(len, kcmd.reslen))
+		ret = -EFAULT;
+	else if (len > reslen)
 		ret = -ENOBUFS;
 	else if (copy_to_user(kcmd.resbuf, (void *)hrt, len))
 		ret = -EFAULT;
@@ -147,8 +147,9 @@ static int i2o_cfg_getlct(unsigned long 
 	lct = (i2o_lct *) c->lct;
 
 	len = (unsigned int)lct->table_size << 2;
-	put_user(len, kcmd.reslen);
-	if (len > reslen)
+	if (put_user(len, kcmd.reslen))
+		ret = -EFAULT;
+	else if (len > reslen)
 		ret = -ENOBUFS;
 	else if (copy_to_user(kcmd.resbuf, lct, len))
 		ret = -EFAULT;
@@ -208,8 +209,9 @@ static int i2o_cfg_parms(unsigned long a
 		return -EAGAIN;
 	}
 
-	put_user(len, kcmd.reslen);
-	if (len > reslen)
+	if (put_user(len, kcmd.reslen))
+		ret = -EFAULT;
+	else if (len > reslen)
 		ret = -ENOBUFS;
 	else if (copy_to_user(kcmd.resbuf, res, len))
 		ret = -EFAULT;
_

Patches currently in -mm which might be from segooon@gmail.com are

origin.patch
linux-next.patch
i2o-fix-overflow-of-copy_to_user.patch
i2o-check-return-code-from-put_user.patch

