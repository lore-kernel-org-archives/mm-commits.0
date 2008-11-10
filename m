From: akpm@linux-foundation.org
Subject: - linux-ratelimith-fixed-missing-initializer-warning.patch removed from -mm tree
Date: Mon, 10 Nov 2008 09:46:36 -0800
Message-ID: <200811101746.mAAHkaY3006591@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753934AbYKJRrR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 12:47:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mk@cm4all.com, mm-commits@vger.kernel.org


The patch titled
     linux/ratelimit.h: fixed "missing initializer" warning
has been removed from the -mm tree.  Its filename was
     linux-ratelimith-fixed-missing-initializer-warning.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux/ratelimit.h: fixed "missing initializer" warning
From: Max Kellermann <mk@cm4all.com>

When compiled with -Wmissing-field-initializers (-Wextra), gcc complains
that there are uninitialized fields in the struct:

 include/linux/ratelimit.h: In function 'ratelimit':
 include/linux/ratelimit.h:23: warning: missing initializer
 include/linux/ratelimit.h:23: warning: (near initialization for 'rs.printed')

Fix this by using C99 initializers.

Signed-off-by: Max Kellermann <mk@cm4all.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ratelimit.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN include/linux/ratelimit.h~linux-ratelimith-fixed-missing-initializer-warning include/linux/ratelimit.h
--- a/include/linux/ratelimit.h~linux-ratelimith-fixed-missing-initializer-warning
+++ a/include/linux/ratelimit.h
@@ -13,8 +13,11 @@ struct ratelimit_state {
 	unsigned long begin;
 };
 
-#define DEFINE_RATELIMIT_STATE(name, interval, burst)		\
-		struct ratelimit_state name = {interval, burst,}
+#define DEFINE_RATELIMIT_STATE(name, _interval, _burst) \
+		struct ratelimit_state name = { \
+			.interval = _interval, \
+			.burst = _burst, \
+		}
 
 extern int __ratelimit(struct ratelimit_state *rs);
 
_

Patches currently in -mm which might be from mk@cm4all.com are

linux-ratelimith-fixed-missing-initializer-warning.patch

