From: akpm@linux-foundation.org
Subject: - add-warn_on_secs-macro.patch removed from -mm tree
Date: Tue, 06 May 2008 12:24:27 -0700
Message-ID: <200805061924.m46JOSFT023111@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757277AbYEFTZH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 15:25:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     add WARN_ON_SECS macro
has been removed from the -mm tree.  Its filename was
     add-warn_on_secs-macro.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: add WARN_ON_SECS macro
From: Dave Young <hidave.darkstar@gmail.com>

Add WARN_ON_SECS macro for some serious cases which need to repeat the
warnings, but with some ratelimiting.

[akpm@linux-foundation.org: fix a few things]
Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/asm-generic/bug.h~add-warn_on_secs-macro include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~add-warn_on_secs-macro
+++ a/include/asm-generic/bug.h
@@ -2,6 +2,7 @@
 #define _ASM_GENERIC_BUG_H
 
 #include <linux/compiler.h>
+#include <linux/param.h>
 
 #ifdef CONFIG_BUG
 
@@ -75,6 +76,9 @@ extern void warn_on_slowpath(const char 
 	unlikely(__ret_warn_once);				\
 })
 
+#define WARN_ON_SECS(condition, secs)				\
+		WARN_ON((condition) && __ratelimit((secs) * HZ, 1))
+
 #ifdef CONFIG_SMP
 # define WARN_ON_SMP(x)			WARN_ON(x)
 #else
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
printk-ratelimiting-rewrite.patch
add-warn_on_secs-macro.patch
use-warn_on_secs-in-rcupreempth.patch

