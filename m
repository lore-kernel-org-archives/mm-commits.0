From: akpm@linux-foundation.org
Subject: [merged] ratelimit-add-initialization-macro.patch removed from
 -mm tree
Date: Sat, 13 Dec 2014 20:09:50 -0800
Message-ID: <548d0d8e.kJC8Wv7FR6tazEg9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbaLNEJm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:09:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@openvz.org, akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ratelimit: add initialization macro
has been removed from the -mm tree.  Its filename was
     ratelimit-add-initialization-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: ratelimit: add initialization macro

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ratelimit.h |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN include/linux/ratelimit.h~ratelimit-add-initialization-macro include/linux/ratelimit.h
--- a/include/linux/ratelimit.h~ratelimit-add-initialization-macro
+++ a/include/linux/ratelimit.h
@@ -17,14 +17,20 @@ struct ratelimit_state {
 	unsigned long	begin;
 };
 
-#define DEFINE_RATELIMIT_STATE(name, interval_init, burst_init)		\
-									\
-	struct ratelimit_state name = {					\
+#define RATELIMIT_STATE_INIT(name, interval_init, burst_init) {		\
 		.lock		= __RAW_SPIN_LOCK_UNLOCKED(name.lock),	\
 		.interval	= interval_init,			\
 		.burst		= burst_init,				\
 	}
 
+#define RATELIMIT_STATE_INIT_DISABLED					\
+	RATELIMIT_STATE_INIT(ratelimit_state, 0, DEFAULT_RATELIMIT_BURST)
+
+#define DEFINE_RATELIMIT_STATE(name, interval_init, burst_init)		\
+									\
+	struct ratelimit_state name =					\
+		RATELIMIT_STATE_INIT(name, interval_init, burst_init)	\
+
 static inline void ratelimit_state_init(struct ratelimit_state *rs,
 					int interval, int burst)
 {
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

origin.patch
linux-next.patch

