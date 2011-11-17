From: akpm@linux-foundation.org
Subject: + include-log2h-fix-rounddown_pow_of_two1.patch added to -mm tree
Date: Thu, 17 Nov 2011 15:07:47 -0800
Message-ID: <201111172307.pAHN7lmT031304@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:62597 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab1KQXHt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2011 18:07:49 -0500
Received: by qyd20 with SMTP id 20so418097qyd.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2011 15:07:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andreiw@vmware.com, eike-kernel@sf-tec.de, jj@chaosbits.net


The patch titled
     Subject: include/log2.h: fix rounddown_pow_of_two(1)
has been added to the -mm tree.  Its filename is
     include-log2h-fix-rounddown_pow_of_two1.patch

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
From: Andrei Warkentin <andreiw@vmware.com>
Subject: include/log2.h: fix rounddown_pow_of_two(1)

1 is a power of two, therefore rounddown_pow_of_two(1) should return 1. 
It does in case the argument is a variable but in case it's a constant it
behaves wrong and returns 0.  Probably nobody ever did it so this was
never noticed, however net/drivers/vmxnet3 with latest GCC does and breaks
on unicpu systems.

This is similar to Rolf's patch to roundup_pow_of_two(1).

Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>
Reviewed-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Andrei Warkentin <andreiw@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/log2.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/log2.h~include-log2h-fix-rounddown_pow_of_two1 include/linux/log2.h
--- a/include/linux/log2.h~include-log2h-fix-rounddown_pow_of_two1
+++ a/include/linux/log2.h
@@ -185,7 +185,7 @@ unsigned long __rounddown_pow_of_two(uns
 #define rounddown_pow_of_two(n)			\
 (						\
 	__builtin_constant_p(n) ? (		\
-		(n == 1) ? 0 :			\
+		(n == 1) ? 1 :			\
 		(1UL << ilog2(n))) :		\
 	__rounddown_pow_of_two(n)		\
  )
_
Subject: Subject: include/log2.h: fix rounddown_pow_of_two(1)

Patches currently in -mm which might be from andreiw@vmware.com are

include-log2h-fix-rounddown_pow_of_two1.patch

