From: akpm@linux-foundation.org
Subject: - linux-ratelimith-fixed-missing-initializer-warning.patch removed from -mm tree
Date: Tue, 06 Jan 2009 15:58:12 -0800
Message-ID: <200901062358.n06NwCxs001725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752728AbZAFX6T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2009 18:58:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mk@cm4all.com, bart.vanassche@gmail.com, vst@vlnb.net, mm-commits@vger.kernel.org


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


Bart said:

  The current version of the header file include/linux/ratelimit.h
  triggers false positives when the compiler flag
  -Wmissing-field-initializers is specified.  The header file
  include/linux/ratelimit.h is included directly or indirectly by many
  other header files -- inclusion of this file can't be avoided.  The
  above patch suppresses these false positives by converting the
  initializers to C99 style, such that kernel developers who want to check
  their code through -Wmissing-field-initializers can use this compiler
  flag.

Signed-off-by: Max Kellermann <mk@cm4all.com>
Cc: "Bart Van Assche" <bart.vanassche@gmail.com>
Cc: "Vladislav Bolkhovitin" <vst@vlnb.net>
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
 #endif
_

Patches currently in -mm which might be from mk@cm4all.com are

linux-ratelimith-fixed-missing-initializer-warning.patch

