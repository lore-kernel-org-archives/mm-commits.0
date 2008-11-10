From: akpm@linux-foundation.org
Subject: + linux-ratelimith-fixed-missing-initializer-warning.patch added to -mm tree
Date: Mon, 10 Nov 2008 10:33:33 -0800
Message-ID: <200811101833.mAAIXXA1029862@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754695AbYKJSeK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 13:34:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mk@cm4all.com, bart.vanassche@gmail.com


The patch titled
     linux/ratelimit.h: fixed "missing initializer" warning
has been added to the -mm tree.  Its filename is
     linux-ratelimith-fixed-missing-initializer-warning.patch

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

