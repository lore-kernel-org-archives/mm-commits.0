From: akpm@linux-foundation.org
Subject: - add-warn_on_secs-macro-simplification.patch removed from -mm tree
Date: Mon, 28 Apr 2008 22:20:02 -0700
Message-ID: <200804290520.m3T5K2tx002744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753543AbYD2FUo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 01:20:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, hannes@saeurebad.de, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     add-warn_on_secs-macro simplification
has been removed from the -mm tree.  Its filename was
     add-warn_on_secs-macro-simplification.patch

This patch was dropped because it was folded into add-warn_on_secs-macro.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: add-warn_on_secs-macro simplification
From: Dave Young <hidave.darkstar@gmail.com>

Change to the concise version as suggestion of Johannes Weiner.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Johannes Weiner <hannes@saeurebad.de>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
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
isolate-ratelimit-from-printkc-for-other-use.patch
add-warn_on_secs-macro.patch
add-warn_on_secs-macro-simplification.patch
add-warn_on_secs-macro-simplification-fix.patch
add-warn_on_secs-macro-simplification-fix-fix.patch
use-warn_on_secs-in-rcupreempth.patch

