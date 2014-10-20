From: akpm@linux-foundation.org
Subject: + ratelimit-add-initialization-macro.patch added to -mm tree
Date: Mon, 20 Oct 2014 16:09:17 -0700
Message-ID: <5445961d.pqBuHHPyEwE2EkxL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbaJTXJR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Oct 2014 19:09:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@openvz.org, akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ratelimit: add initialization macro
has been added to the -mm tree.  Its filename is
     ratelimit-add-initialization-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ratelimit-add-initialization-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ratelimit-add-initialization-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ratelimit-add-initialization-macro.patch
fault-inject-add-ratelimit-option-v2.patch
linux-next.patch

