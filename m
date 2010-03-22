From: akpm@linux-foundation.org
Subject: + kernelh-fix-wrong-usage-of-__ratelimit.patch added to -mm tree
Date: Mon, 22 Mar 2010 13:08:12 -0700
Message-ID: <201003222008.o2MK8CQ3024600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753687Ab0CVUIW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 16:08:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yong.zhang@windriver.com, joe@perches.com, mingo@elte.hu


The patch titled
     kernel.h: fix wrong usage of __ratelimit()
has been added to the -mm tree.  Its filename is
     kernelh-fix-wrong-usage-of-__ratelimit.patch

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
Subject: kernel.h: fix wrong usage of __ratelimit()
From: Yong Zhang <yong.zhang@windriver.com>

When __ratelimit() returns 1 this means that we can go ahead.

Signed-off-by: Yong Zhang <yong.zhang@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/kernel.h~kernelh-fix-wrong-usage-of-__ratelimit include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-fix-wrong-usage-of-__ratelimit
+++ a/include/linux/kernel.h
@@ -426,7 +426,7 @@ static inline char *pack_hex_byte(char *
 		.burst = DEFAULT_RATELIMIT_BURST,       \
 	};                                              \
 							\
-	if (!__ratelimit(&_rs))                         \
+	if (__ratelimit(&_rs))                          \
 		printk(fmt, ##__VA_ARGS__);		\
 })
 #else
_

Patches currently in -mm which might be from yong.zhang@windriver.com are

ratelimit-annotate-___ratelimit.patch
ratelimit-annotate-___ratelimit-fix.patch
kernelh-fix-wrong-usage-of-__ratelimit.patch
ratelimit-fix-the-return-value-when-__ratelimit-fails-to-acquire-the-lock.patch

