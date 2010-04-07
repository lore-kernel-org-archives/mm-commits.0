From: akpm@linux-foundation.org
Subject: [merged] kernelh-fix-wrong-usage-of-__ratelimit.patch removed from -mm tree
Date: Wed, 07 Apr 2010 11:50:22 -0400
Message-ID: <201004071851.o37IpmmV001329@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756232Ab0DGSwG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 14:52:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yong.zhang@windriver.com, joe@perches.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     kernel.h: fix wrong usage of __ratelimit()
has been removed from the -mm tree.  Its filename was
     kernelh-fix-wrong-usage-of-__ratelimit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

