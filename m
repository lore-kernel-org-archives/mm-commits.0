From: akpm@linux-foundation.org
Subject: + linux-ratelimith-fixed-missing-initializer-warning.patch added to -mm tree
Date: Sun, 26 Oct 2008 20:38:29 -0700
Message-ID: <200810270338.m9R3cTFG029903@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750740AbYJ0DjF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 26 Oct 2008 23:39:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mk@cm4all.com


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

