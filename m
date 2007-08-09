From: akpm@linux-foundation.org
Subject: + freezer-introduce-freezer-firendly-waiting-macros-fix.patch added to -mm tree
Date: Thu, 09 Aug 2007 12:11:53 -0700
Message-ID: <200708091911.l79JBrkm014731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57116 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751658AbXHITMd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 15:12:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl


The patch titled
     freezer-introduce-freezer-firendly-waiting-macros fix
has been added to the -mm tree.  Its filename is
     freezer-introduce-freezer-firendly-waiting-macros-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: freezer-introduce-freezer-firendly-waiting-macros fix
From: Rafael J. Wysocki <rjw@sisk.pl>

Fix a bug in freezer-introduce-freezer-firendly-waiting-macros.patch which
uses a wrong variable name in wait_event_freezable() and
wait_event_freezable_timeout() (this name is also used in
wait_event_interruptible() and wait_event_interruptible_timeout() which are
macros and the names clash).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/freezer.h |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff -puN include/linux/freezer.h~freezer-introduce-freezer-firendly-waiting-macros-fix include/linux/freezer.h
--- a/include/linux/freezer.h~freezer-introduce-freezer-firendly-waiting-macros-fix
+++ a/include/linux/freezer.h
@@ -134,28 +134,28 @@ static inline void set_freezable(void)
 
 #define wait_event_freezable(wq, condition)				\
 ({									\
-	int __ret;							\
+	int __retval;							\
 	do {								\
-		__ret = wait_event_interruptible(wq, 			\
+		__retval = wait_event_interruptible(wq, 		\
 				(condition) || freezing(current));	\
-		if (__ret && !freezing(current))			\
+		if (__retval && !freezing(current))			\
 			break;						\
 		else if (!(condition))					\
-			__ret = -ERESTARTSYS;				\
+			__retval = -ERESTARTSYS;			\
 	} while (try_to_freeze());					\
-	__ret;								\
+	__retval;							\
 })
 
 
 #define wait_event_freezable_timeout(wq, condition, timeout)		\
 ({									\
-	long __ret = timeout;						\
+	long __retval = timeout;					\
 	do {								\
-		__ret = wait_event_interruptible_timeout(wq,		\
+		__retval = wait_event_interruptible_timeout(wq,		\
 				(condition) || freezing(current),	\
-				__ret); 				\
+				__retval); 				\
 	} while (try_to_freeze());					\
-	__ret;								\
+	__retval;							\
 })
 #else /* !CONFIG_PM_SLEEP */
 static inline int frozen(struct task_struct *p) { return 0; }
_

Patches currently in -mm which might be from rjw@sisk.pl are

hibernation-do-not-try-to-mark-invalid-pfns-as-nosave.patch
uli526x-add-suspend-and-resume-routines.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
freezer-document-relationship-with-memory-shrinking.patch
freezer-do-not-sync-filesystems-from-freeze_processes.patch
freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch
freezer-introduce-freezer-firendly-waiting-macros.patch
freezer-introduce-freezer-firendly-waiting-macros-fix.patch
freezer-do-not-send-signals-to-kernel-threads.patch
unexport-pm_power_off_prepare.patch
pm_trace-displays-the-wrong-time-from-the-rtc.patch
freezer-be-more-verbose.patch
freezer-use-wait-queue-instead-of-busy-looping.patch
freezer-measure-freezing-time.patch
shrink_slab-handle-bad-shrinkers.patch
