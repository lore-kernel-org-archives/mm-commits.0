From: akpm@linux-foundation.org
Subject: + printk-ratelimiting-rewrite-fix.patch added to -mm tree
Date: Thu, 08 May 2008 13:03:22 -0700
Message-ID: <200805082003.m48K3Mbl003180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752079AbYEHUDx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 16:03:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com


The patch titled
     printk-ratelimiting-rewrite fix
has been added to the -mm tree.  Its filename is
     printk-ratelimiting-rewrite-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk-ratelimiting-rewrite fix
From: Dave Young <hidave.darkstar@gmail.com>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ratelimit.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN include/linux/ratelimit.h~printk-ratelimiting-rewrite-fix include/linux/ratelimit.h
--- a/include/linux/ratelimit.h~printk-ratelimiting-rewrite-fix
+++ a/include/linux/ratelimit.h
@@ -1,5 +1,9 @@
 #ifndef _LINUX_RATELIMIT_H
 #define _LINUX_RATELIMIT_H
+#include <linux/param.h>
+
+#define DEFAULT_RATELIMIT_INTERVAL (5 * HZ)
+#define DEFAULT_RATELIMIT_BURST 10
 
 struct ratelimit_state {
 	int interval;
@@ -11,10 +15,13 @@ struct ratelimit_state {
 
 #define DEFINE_RATELIMIT_STATE(name, interval, burst)		\
 		struct ratelimit_state name = {interval, burst,}
+
 extern int __ratelimit(struct ratelimit_state *rs);
+
 static inline int ratelimit(void)
 {
-	static struct ratelimit_state rs;
+	static DEFINE_RATELIMIT_STATE(rs, DEFAULT_RATELIMIT_INTERVAL,
+					DEFAULT_RATELIMIT_BURST);
 	return __ratelimit(&rs);
 }
 #endif
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
printk-ratelimiting-rewrite.patch
printk-ratelimiting-rewrite-fix.patch

