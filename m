From: akpm@linux-foundation.org
Subject: + i2o-fix-overflow-of-copy_to_user.patch added to -mm tree
Date: Wed, 21 Jul 2010 14:45:43 -0700
Message-ID: <201007212145.o6LLjhTJ016926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40687 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756832Ab0GUVpr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Jul 2010 17:45:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segooon@gmail.com


The patch titled
     i2o: fix overflow of copy_to_user()
has been added to the -mm tree.  Its filename is
     i2o-fix-overflow-of-copy_to_user.patch

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
Subject: i2o: fix overflow of copy_to_user()
From: Kulikov Vasiliy <segooon@gmail.com>

If (len > reslen) we must not call copy_to_user() since kernel buffer is
smaller than we want to copy.  Similar code in this file is correct, so
this bug was a typo.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/i2o_config.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/message/i2o/i2o_config.c~i2o-fix-overflow-of-copy_to_user drivers/message/i2o/i2o_config.c
--- a/drivers/message/i2o/i2o_config.c~i2o-fix-overflow-of-copy_to_user
+++ a/drivers/message/i2o/i2o_config.c
@@ -115,7 +115,7 @@ static int i2o_cfg_gethrt(unsigned long 
 	put_user(len, kcmd.reslen);
 	if (len > reslen)
 		ret = -ENOBUFS;
-	if (copy_to_user(kcmd.resbuf, (void *)hrt, len))
+	else if (copy_to_user(kcmd.resbuf, (void *)hrt, len))
 		ret = -EFAULT;
 
 	return ret;
_

Patches currently in -mm which might be from segooon@gmail.com are

origin.patch
linux-next.patch
i2o-fix-overflow-of-copy_to_user.patch
i2o-check-return-code-from-put_user.patch

