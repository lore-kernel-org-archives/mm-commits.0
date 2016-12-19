From: akpm@linux-foundation.org
Subject: + ratelimit-fix-warn_on_ratelimit-return-value.patch added to -mm tree
Date: Mon, 19 Dec 2016 15:17:09 -0800
Message-ID: <58586a75.ugfuRlH/xOmCofgT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48408 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751499AbcLSXQJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2016 18:16:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: ratelimit: fix WARN_ON_RATELIMIT return value
has been added to the -mm tree.  Its filename is
     ratelimit-fix-warn_on_ratelimit-return-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ratelimit-fix-warn_on_ratelimit-return-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ratelimit-fix-warn_on_ratelimit-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from jslaby@suse.cz are

ratelimit-fix-warn_on_ratelimit-return-value.patch

