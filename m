From: akpm@linux-foundation.org
Subject: + compat-return-efault-on-error-in-waitid.patch added to -mm tree
Date: Mon, 07 Jan 2013 15:26:24 -0800
Message-ID: <20130107232624.AC8C5100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:35373 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab3AGX0Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 18:26:25 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so2151685vcd.5
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 15:26:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: compat: return -EFAULT on error in waitid()
has been added to the -mm tree.  Its filename is
     compat-return-efault-on-error-in-waitid.patch

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
Subject: compat: return -EFAULT on error in waitid()

The copy_to_user() call returns the number of bytes remaining but we want
to return -EFAULT on error.

Fixes "x32: fix waitid()"

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/compat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/compat.c~compat-return-efault-on-error-in-waitid kernel/compat.c
--- a/kernel/compat.c~compat-return-efault-on-error-in-waitid
+++ a/kernel/compat.c
@@ -593,7 +593,7 @@ COMPAT_SYSCALL_DEFINE5(waitid,
 		else
 			ret = put_compat_rusage(&ru, uru);
 		if (ret)
-			return ret;
+			return -EFAULT;
 	}
 
 	BUG_ON(info.si_code & __SI_MASK);
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

linux-next.patch
compat-return-efault-on-error-in-waitid.patch

