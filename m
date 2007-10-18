From: akpm@linux-foundation.org
Subject: - freezer-introduce-freezer-firendly-waiting-macros-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 01:28:06 -0700
Message-ID: <200710180828.l9I8S6m0002165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35054 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755948AbXJRI2r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 04:28:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     freezer-introduce-freezer-firendly-waiting-macros fix
has been removed from the -mm tree.  Its filename was
     freezer-introduce-freezer-firendly-waiting-macros-fix.patch

This patch was dropped because it was folded into freezer-introduce-freezer-firendly-waiting-macros.patch

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

origin.patch
make-kernel-power-maincsuspend_enter-static.patch
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
freezer-measure-freezing-time.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
s2ram-kill-old-debugging-junk.patch
hibernation-arbitrary-boot-kernel-support-generic-code-rev-2.patch
hibernation-arbitrary-boot-kernel-support-on-x86_64-rev-2.patch
hibernation-pass-cr3-in-the-image-header-on-x86_64-rev-2.patch
hibernation-use-temporary-page-tables-for-kernel-text-mapping-on-x86_64.patch
hibernation-check-if-acpi-is-enabled-during-restore-in-the-right-place.patch
hibernation-enter-platform-hibernation-state-in-a-consistent-way-rev-4.patch
hibernation-enter-platform-hibernation-state-in-a-consistent-way-rev-4-fix.patch
