From: akpm@linux-foundation.org
Subject: - power-management-fix-struct-layout-and-docs.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:51:40 -0800
Message-ID: <200702282351.l1SNpenh030937@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48231 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932643AbXB1Xw1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:52:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johannes@sipsolutions.net, greg@kroah.com, pavel@ucw.cz, rdunlap@xenotime.net, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     power management: fix struct layout and docs
has been removed from the -mm tree.  Its filename was
     power-management-fix-struct-layout-and-docs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: power management: fix struct layout and docs
From: Johannes Berg <johannes@sipsolutions.net>

Because the pm ops in powermac are obviously not using them as intended, I
added documentation for it in kernel-doc format.

Reordering the fields in struct pm_ops not only makes the output of kernel-doc
make more sense but also removes a hole from the structure on 64-bit
platforms.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Macheck <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pm.h |   37 +++++++++++++++++++++++++++++++++++--
 1 files changed, 35 insertions(+), 2 deletions(-)

diff -puN include/linux/pm.h~power-management-fix-struct-layout-and-docs include/linux/pm.h
--- a/include/linux/pm.h~power-management-fix-struct-layout-and-docs
+++ a/include/linux/pm.h
@@ -120,15 +120,48 @@ typedef int __bitwise suspend_disk_metho
 #define	PM_DISK_TESTPROC	((__force suspend_disk_method_t) 6)
 #define	PM_DISK_MAX		((__force suspend_disk_method_t) 7)
 
+/**
+ * struct pm_ops - Callbacks for managing platform dependent suspend states.
+ * @valid: Callback to determine whether the given state can be entered.
+ * 	If %CONFIG_SOFTWARE_SUSPEND is set then %PM_SUSPEND_DISK is
+ *	always valid and never passed to this call.
+ *	If not assigned, all suspend states are advertised as valid
+ *	in /sys/power/state (but can still be rejected by prepare or enter.)
+ *
+ * @prepare: Prepare the platform for the given suspend state. Can return a
+ *	negative error code if necessary.
+ *
+ * @enter: Enter the given suspend state, must be assigned. Can return a
+ *	negative error code if necessary.
+ *
+ * @finish: Called when the system has left the given state and all devices
+ *	are resumed. The return value is ignored.
+ *
+ * @pm_disk_mode: Set to the disk method that the user should be able to
+ *	configure for suspend-to-disk. Since %PM_DISK_SHUTDOWN,
+ *	%PM_DISK_REBOOT, %PM_DISK_TEST and %PM_DISK_TESTPROC
+ *	are always allowed, currently only %PM_DISK_PLATFORM
+ *	makes sense. If the user then choses %PM_DISK_PLATFORM,
+ *	the @prepare call will be called before suspending to disk
+ *	(if present), the @enter call should be present and will
+ *	be called after all state has been saved and the machine
+ *	is ready to be shut down/suspended/..., and the @finish
+ *	callback is called after state has been restored. All
+ *	these calls are called with %PM_SUSPEND_DISK as the state.
+ */
 struct pm_ops {
-	suspend_disk_method_t pm_disk_mode;
 	int (*valid)(suspend_state_t state);
 	int (*prepare)(suspend_state_t state);
 	int (*enter)(suspend_state_t state);
 	int (*finish)(suspend_state_t state);
+	suspend_disk_method_t pm_disk_mode;
 };
 
-extern void pm_set_ops(struct pm_ops *);
+/**
+ * pm_set_ops - set platform dependent power management ops
+ * @pm_ops: The new power management operations to set.
+ */
+extern void pm_set_ops(struct pm_ops *pm_ops);
 extern struct pm_ops *pm_ops;
 extern int pm_suspend(suspend_state_t state);
 
_

Patches currently in -mm which might be from johannes@sipsolutions.net are
