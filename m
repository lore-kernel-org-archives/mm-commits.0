From: akpm@linux-foundation.org
Subject: + pm-add-new-pm_event-codes-for-runtime-power-transitions.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:40:37 -0700
Message-ID: <200807111846.m6BIkIfP031006@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751434AbYGKSqd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:46:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stern@rowland.harvard.edu, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     pm: add new PM_EVENT codes for runtime power transitions
has been added to the -mm tree.  Its filename is
     pm-add-new-pm_event-codes-for-runtime-power-transitions.patch

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
Subject: pm: add new PM_EVENT codes for runtime power transitions
From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1112) adds some new PM_EVENT_* codes for use by kernel
subsystems.  They describe runtime power-state transitions of the sort already
implemented by the USB subsystem.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pm.h |   39 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

diff -puN include/linux/pm.h~pm-add-new-pm_event-codes-for-runtime-power-transitions include/linux/pm.h
--- a/include/linux/pm.h~pm-add-new-pm_event-codes-for-runtime-power-transitions
+++ a/include/linux/pm.h
@@ -245,6 +245,21 @@ struct pm_ext_ops {
  * RECOVER	Creation of a hibernation image or restoration of the main
  *		memory contents from a hibernation image has failed, call
  *		->thaw() and ->complete() for all devices.
+ *
+ * The following PM_EVENT_ messages are defined for internal use by
+ * kernel subsystems.  They are never issued by the PM core.
+ *
+ * USER_SUSPEND		Manual selective suspend was issued by userspace.
+ *
+ * USER_RESUME		Manual selective resume was issued by userspace.
+ *
+ * REMOTE_WAKEUP	Remote-wakeup request was received from the device.
+ *
+ * AUTO_SUSPEND		Automatic (device idle) runtime suspend was
+ *			initiated by the subsystem.
+ *
+ * AUTO_RESUME		Automatic (device needed) runtime resume was
+ *			requested by a driver.
  */
 
 #define PM_EVENT_ON		0x0000
@@ -256,9 +271,18 @@ struct pm_ext_ops {
 #define PM_EVENT_THAW		0x0020
 #define PM_EVENT_RESTORE	0x0040
 #define PM_EVENT_RECOVER	0x0080
+#define PM_EVENT_USER		0x0100
+#define PM_EVENT_REMOTE		0x0200
+#define PM_EVENT_AUTO		0x0400
+
+#define PM_EVENT_SLEEP		(PM_EVENT_SUSPEND | PM_EVENT_HIBERNATE)
+#define PM_EVENT_USER_SUSPEND	(PM_EVENT_USER | PM_EVENT_SUSPEND)
+#define PM_EVENT_USER_RESUME	(PM_EVENT_USER | PM_EVENT_RESUME)
+#define PM_EVENT_REMOTE_WAKEUP	(PM_EVENT_REMOTE | PM_EVENT_RESUME)
+#define PM_EVENT_AUTO_SUSPEND	(PM_EVENT_AUTO | PM_EVENT_SUSPEND)
+#define PM_EVENT_AUTO_RESUME	(PM_EVENT_AUTO | PM_EVENT_RESUME)
 
-#define PM_EVENT_SLEEP	(PM_EVENT_SUSPEND | PM_EVENT_HIBERNATE)
-
+#define PMSG_ON		((struct pm_message){ .event = PM_EVENT_ON, })
 #define PMSG_FREEZE	((struct pm_message){ .event = PM_EVENT_FREEZE, })
 #define PMSG_QUIESCE	((struct pm_message){ .event = PM_EVENT_QUIESCE, })
 #define PMSG_SUSPEND	((struct pm_message){ .event = PM_EVENT_SUSPEND, })
@@ -267,7 +291,16 @@ struct pm_ext_ops {
 #define PMSG_THAW	((struct pm_message){ .event = PM_EVENT_THAW, })
 #define PMSG_RESTORE	((struct pm_message){ .event = PM_EVENT_RESTORE, })
 #define PMSG_RECOVER	((struct pm_message){ .event = PM_EVENT_RECOVER, })
-#define PMSG_ON		((struct pm_message){ .event = PM_EVENT_ON, })
+#define PMSG_USER_SUSPEND	((struct pm_messge) \
+					{ .event = PM_EVENT_USER_SUSPEND, })
+#define PMSG_USER_RESUME	((struct pm_messge) \
+					{ .event = PM_EVENT_USER_RESUME, })
+#define PMSG_REMOTE_RESUME	((struct pm_messge) \
+					{ .event = PM_EVENT_REMOTE_RESUME, })
+#define PMSG_AUTO_SUSPEND	((struct pm_messge) \
+					{ .event = PM_EVENT_AUTO_SUSPEND, })
+#define PMSG_AUTO_RESUME		((struct pm_messge) \
+					{ .event = PM_EVENT_AUTO_RESUME, })
 
 /**
  * Device power management states
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

origin.patch
linux-next.patch
git-scsi-rc-fixes.patch
pm-add-new-pm_event-codes-for-runtime-power-transitions.patch

