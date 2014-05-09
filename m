From: akpm@linux-foundation.org
Subject: + lib-plistc-make-config_debug_pi_list-selectable.patch added to
 -mm tree
Date: Fri, 09 May 2014 14:42:19 -0700
Message-ID: <536d4bbb.YbzAHC4zbs1m6B78%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368AbaEIVmU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2014 17:42:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, peterz@infradead.org, ddstreet@ieee.org

Subject: + lib-plistc-make-config_debug_pi_list-selectable.patch added to -mm tree
To: ddstreet@ieee.org,peterz@infradead.org,rostedt@goodmis.org
From: akpm@linux-foundation.org
Date: Fri, 09 May 2014 14:42:19 -0700


The patch titled
     Subject: lib/plist.c: make CONFIG_DEBUG_PI_LIST selectable
has been added to the -mm tree.  Its filename is
     lib-plistc-make-config_debug_pi_list-selectable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-plistc-make-config_debug_pi_list-selectable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-plistc-make-config_debug_pi_list-selectable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

documentation-expand-clarify-debug-documentation.patch
lib-plistc-replace-pr_debug-with-printk-in-plist_test.patch
lib-plistc-make-config_debug_pi_list-selectable.patch

