From: akpm@linux-foundation.org
Subject: [merged] lib-plistc-make-config_debug_pi_list-selectable.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 13:05:19 -0700
Message-ID: <5390cd7f.OJNe0bwjwSaX341j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56816 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaFEUFU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 16:05:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, peterz@infradead.org, ddstreet@ieee.org

Subject: [merged] lib-plistc-make-config_debug_pi_list-selectable.patch removed from -mm tree
To: ddstreet@ieee.org,peterz@infradead.org,rostedt@goodmis.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 13:05:19 -0700


The patch titled
     Subject: lib/plist.c: make CONFIG_DEBUG_PI_LIST selectable
has been removed from the -mm tree.  Its filename was
     lib-plistc-make-config_debug_pi_list-selectable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: lib/plist.c: make CONFIG_DEBUG_PI_LIST selectable

Change CONFIG_DEBUG_PI_LIST to be user-selectable, and add a title and
description.  Remove the dependency on DEBUG_RT_MUTEXES since they were
changed to use rbtrees, and there are other users of plists now.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN lib/Kconfig.debug~lib-plistc-make-config_debug_pi_list-selectable lib/Kconfig.debug
--- a/lib/Kconfig.debug~lib-plistc-make-config_debug_pi_list-selectable
+++ a/lib/Kconfig.debug
@@ -833,11 +833,6 @@ config DEBUG_RT_MUTEXES
 	 This allows rt mutex semantics violations and rt mutex related
 	 deadlocks (lockups) to be detected and reported automatically.
 
-config DEBUG_PI_LIST
-	bool
-	default y
-	depends on DEBUG_RT_MUTEXES
-
 config RT_MUTEX_TESTER
 	bool "Built-in scriptable tester for rt-mutexes"
 	depends on DEBUG_KERNEL && RT_MUTEXES
@@ -1063,6 +1058,16 @@ config DEBUG_LIST
 
 	  If unsure, say N.
 
+config DEBUG_PI_LIST
+	bool "Debug priority linked list manipulation"
+	depends on DEBUG_KERNEL
+	help
+	  Enable this to turn on extended checks in the priority-ordered
+	  linked-list (plist) walking routines.  This checks the entire
+	  list multiple times during each manipulation.
+
+	  If unsure, say N.
+
 config DEBUG_SG
 	bool "Debug SG table operations"
 	depends on DEBUG_KERNEL
_

Patches currently in -mm which might be from ddstreet@ieee.org are

origin.patch
linux-next.patch

