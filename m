From: akpm@linux-foundation.org
Subject: + ratelimit-add-ratelimit_state_init.patch added to -mm tree
Date: Wed, 19 May 2010 13:57:27 -0700
Message-ID: <201005192057.o4JKvRwQ005654@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57671 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751383Ab0ESU5a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 16:57:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp


The patch titled
     ratelimit: add ratelimit_state_init()
has been added to the -mm tree.  Its filename is
     ratelimit-add-ratelimit_state_init.patch

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
Subject: ratelimit: add ratelimit_state_init()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

For now, all users of ratelimit_state allocates it statically, so
DEFINE_RATELIMIT_STATE() is enough.  But, I want to use ratelimit_state
for fs, i.e.  per super_block to suppress too many error reports.

So, this adds ratelimit_state_init() to initialize ratelimite_state
which is dynamically allocated, instead of opencoding.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ratelimit.h |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN include/linux/ratelimit.h~ratelimit-add-ratelimit_state_init include/linux/ratelimit.h
--- a/include/linux/ratelimit.h~ratelimit-add-ratelimit_state_init
+++ a/include/linux/ratelimit.h
@@ -2,7 +2,7 @@
 #define _LINUX_RATELIMIT_H
 
 #include <linux/param.h>
-#include <linux/spinlock_types.h>
+#include <linux/spinlock.h>
 
 #define DEFAULT_RATELIMIT_INTERVAL	(5 * HZ)
 #define DEFAULT_RATELIMIT_BURST		10
@@ -25,6 +25,17 @@ struct ratelimit_state {
 		.burst		= burst_init,				\
 	}
 
+static inline void ratelimit_state_init(struct ratelimit_state *rs,
+					int interval, int burst)
+{
+	spin_lock_init(&rs->lock);
+	rs->interval = interval;
+	rs->burst = burst;
+	rs->printed = 0;
+	rs->missed = 0;
+	rs->begin = 0;
+}
+
 extern int ___ratelimit(struct ratelimit_state *rs, const char *func);
 #define __ratelimit(state) ___ratelimit(state, __func__)
 
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

origin.patch
linux-next.patch
printk_ratelimited-fix-uninitialized-spinlock.patch
ratelimit-add-ratelimit_state_init.patch
fatfs-ratelimit-corruption-report.patch

