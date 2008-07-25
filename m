From: akpm@linux-foundation.org
Subject: - printk-ratelimiting-rewrite-fix.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:12:46 -0700
Message-ID: <200807250012.m6P0Ckss013493@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60544 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752486AbYGYANS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:13:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, mm-commits@vger.kernel.org


The patch titled
     printk-ratelimiting-rewrite fix
has been removed from the -mm tree.  Its filename was
     printk-ratelimiting-rewrite-fix.patch

This patch was dropped because it was folded into printk-ratelimiting-rewrite.patch

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

origin.patch
printk-ratelimiting-rewrite.patch
printk-ratelimiting-rewrite-fix.patch

