From: akpm@linux-foundation.org
Subject: + printk-include-pr_fmt-in-pr_debug_ratelimited.patch added to
 -mm tree
Date: Mon, 20 Jul 2015 16:29:15 -0700
Message-ID: <55ad844b.IirYdPprnlDkpeBK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbbGTX3Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Jul 2015 19:29:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Jason@zx2c4.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/printk.h: include pr_fmt in pr_debug_ratelimited
has been added to the -mm tree.  Its filename is
     printk-include-pr_fmt-in-pr_debug_ratelimited.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-include-pr_fmt-in-pr_debug_ratelimited.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-include-pr_fmt-in-pr_debug_ratelimited.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: include/linux/printk.h: include pr_fmt in pr_debug_ratelimited

The other two implementations of pr_debug_ratelimited include pr_fmt,
along with every other pr_* function.  But pr_debug_ratelimited forgot to
add it with the CONFIG_DYNAMIC_DEBUG implementation.

This patch unifies the behavior.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/printk.h~printk-include-pr_fmt-in-pr_debug_ratelimited include/linux/printk.h
--- a/include/linux/printk.h~printk-include-pr_fmt-in-pr_debug_ratelimited
+++ a/include/linux/printk.h
@@ -404,10 +404,10 @@ do {									\
 	static DEFINE_RATELIMIT_STATE(_rs,				\
 				      DEFAULT_RATELIMIT_INTERVAL,	\
 				      DEFAULT_RATELIMIT_BURST);		\
-	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);			\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, pr_fmt(fmt));		\
 	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT) &&	\
 	    __ratelimit(&_rs))						\
-		__dynamic_pr_debug(&descriptor, fmt, ##__VA_ARGS__);	\
+		__dynamic_pr_debug(&descriptor, pr_fmt(fmt), ##__VA_ARGS__);	\
 } while (0)
 #elif defined(DEBUG)
 #define pr_debug_ratelimited(fmt, ...)					\
_

Patches currently in -mm which might be from Jason@zx2c4.com are

printk-include-pr_fmt-in-pr_debug_ratelimited.patch

