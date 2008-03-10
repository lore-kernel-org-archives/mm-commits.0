From: akpm@linux-foundation.org
Subject: + add-warn_on_secs-macro.patch added to -mm tree
Date: Mon, 10 Mar 2008 13:52:06 -0700
Message-ID: <200803102052.m2AKq7sw004934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751956AbYCJUwQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 16:52:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, paulmck@linux.vnet.ibm.com


The patch titled
     add WARN_ON_SECS macro
has been added to the -mm tree.  Its filename is
     add-warn_on_secs-macro.patch

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
Subject: add WARN_ON_SECS macro
From: Dave Young <hidave.darkstar@gmail.com>

Add WARN_ON_SECS macro for some serious cases which need to repeat the
warnings, but with some ratelimiting.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN include/asm-generic/bug.h~add-warn_on_secs-macro include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~add-warn_on_secs-macro
+++ a/include/asm-generic/bug.h
@@ -3,6 +3,7 @@
 
 #include <linux/compiler.h>
 
+
 #ifdef CONFIG_BUG
 
 #ifdef CONFIG_GENERIC_BUG
@@ -75,6 +76,13 @@ extern void warn_on_slowpath(const char 
 	unlikely(__ret_warn_once);				\
 })
 
+#define WARN_ON_SECS(condition, secs) ({			\
+	int __ret_warn_on = !!(condition);			\
+	if (unlikely(__ret_warn_on))				\
+		if (__ratelimit(secs * HZ, 1))			\
+			WARN_ON(condition);			\
+})
+
 #ifdef CONFIG_SMP
 # define WARN_ON_SMP(x)			WARN_ON(x)
 #else
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
git-net.patch
isolate-ratelimit-from-printkc-for-other-use.patch
add-warn_on_secs-macro.patch
use-warn_on_secs-in-rcupreempth.patch

