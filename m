From: akpm@linux-foundation.org
Subject: + add-warn_on_secs-macro-simplification.patch added to -mm tree
Date: Thu, 13 Mar 2008 14:06:43 -0700
Message-ID: <200803132106.m2DL6hYE000413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753993AbYCMVGu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 17:06:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, hannes@saeurebad.de


The patch titled
     add-warn_on_secs-macro simplification
has been added to the -mm tree.  Its filename is
     add-warn_on_secs-macro-simplification.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: add-warn_on_secs-macro simplification
From: Dave Young <hidave.darkstar@gmail.com>

Change to the concise version as suggestion of Johannes Weiner.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN include/asm-generic/bug.h~add-warn_on_secs-macro-simplification include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~add-warn_on_secs-macro-simplification
+++ a/include/asm-generic/bug.h
@@ -76,13 +76,8 @@ extern void warn_on_slowpath(const char 
 	unlikely(__ret_warn_once);				\
 })
 
-#define WARN_ON_SECS(condition, secs) ({			\
-	int __ret_warn_on = !!(condition);			\
-	if (unlikely(__ret_warn_on))				\
-		if (__ratelimit(secs * HZ, 1))			\
-			WARN_ON(1);				\
-	unlikely(__ret_warn_on);				\
-})
+#define WARN_ON_SECS(condition, secs)				\
+		WARN_ON((condition && __ratelimit(secs * HZ, 1)))
 
 #ifdef CONFIG_SMP
 # define WARN_ON_SMP(x)			WARN_ON(x)
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
isolate-ratelimit-from-printkc-for-other-use.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
add-warn_on_secs-macro.patch
add-warn_on_secs-macro-simplification.patch
use-warn_on_secs-in-rcupreempth.patch

