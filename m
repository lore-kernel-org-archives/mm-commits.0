From: akpm@linux-foundation.org
Subject: [patch 14/15] ratelimit: fix WARN_ON_RATELIMIT return value
Date: Mon, 19 Dec 2016 16:23:12 -0800
Message-ID: <585879f0.UxpSTQb+6BPIoolw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50682 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752993AbcLTAWN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2016 19:22:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jslaby@suse.cz

From: Jiri Slaby <jslaby@suse.cz>
Subject: ratelimit: fix WARN_ON_RATELIMIT return value

The macro is to be used similarly as WARN_ON as:
  if (WARN_ON_RATELIMIT(condition, state))
	do_something();

One would expect only 'condition' to affect the 'if', but
WARN_ON_RATELIMIT does internally only:
  WARN_ON((condition) && __ratelimit(state))

So the 'if' is affected by the ratelimiting state too. Fix this by
returning 'condition' in any case.

Note that nobody uses WARN_ON_RATELIMIT yet, so there is nothing to
worry about. But I was about to use it and was a bit surprised.

Link: http://lkml.kernel.org/r/20161215093224.23126-1-jslaby@suse.cz
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ratelimit.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN include/linux/ratelimit.h~ratelimit-fix-warn_on_ratelimit-return-value include/linux/ratelimit.h
--- a/include/linux/ratelimit.h~ratelimit-fix-warn_on_ratelimit-return-value
+++ a/include/linux/ratelimit.h
@@ -77,8 +77,11 @@ extern int ___ratelimit(struct ratelimit
 
 #ifdef CONFIG_PRINTK
 
-#define WARN_ON_RATELIMIT(condition, state)			\
-		WARN_ON((condition) && __ratelimit(state))
+#define WARN_ON_RATELIMIT(condition, state)	({		\
+	bool __rtn_cond = !!(condition);			\
+	WARN_ON(__rtn_cond && __ratelimit(state));		\
+	__rtn_cond;						\
+})
 
 #define WARN_RATELIMIT(condition, format, ...)			\
 ({								\
_
