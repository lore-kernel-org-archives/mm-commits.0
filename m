From: akpm@linux-foundation.org
Subject: + printk_ratelimited-fix-uninitialized-spinlock.patch added to -mm tree
Date: Wed, 19 May 2010 13:27:04 -0700
Message-ID: <201005192027.o4JKR468003857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756131Ab0ESU1i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 16:27:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp, joe@perches.com


The patch titled
     printk_ratelimited(): fix uninitialized spinlock 
has been added to the -mm tree.  Its filename is
     printk_ratelimited-fix-uninitialized-spinlock.patch

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
Subject: printk_ratelimited(): fix uninitialized spinlock 
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

ratelimit_state initialization of printk_ratelimited() seems broken.  This
fixes it by using DEFINE_RATELIMIT_STATE() to initialize spinlock
properly.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN include/linux/kernel.h~printk_ratelimited-fix-uninitialized-spinlock include/linux/kernel.h
--- a/include/linux/kernel.h~printk_ratelimited-fix-uninitialized-spinlock
+++ a/include/linux/kernel.h
@@ -423,14 +423,13 @@ static inline char *pack_hex_byte(char *
  * no local ratelimit_state used in the !PRINTK case
  */
 #ifdef CONFIG_PRINTK
-#define printk_ratelimited(fmt, ...)  ({		\
-	static struct ratelimit_state _rs = {		\
-		.interval = DEFAULT_RATELIMIT_INTERVAL, \
-		.burst = DEFAULT_RATELIMIT_BURST,       \
-	};                                              \
-							\
-	if (__ratelimit(&_rs))                          \
-		printk(fmt, ##__VA_ARGS__);		\
+#define printk_ratelimited(fmt, ...)  ({				\
+	static DEFINE_RATELIMIT_STATE(_rs,				\
+				      DEFAULT_RATELIMIT_INTERVAL,	\
+				      DEFAULT_RATELIMIT_BURST);		\
+									\
+	if (__ratelimit(&_rs))						\
+		printk(fmt, ##__VA_ARGS__);				\
 })
 #else
 /* No effect, but we still get type checking even in the !PRINTK case: */
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

origin.patch
linux-next.patch
printk_ratelimited-fix-uninitialized-spinlock.patch

