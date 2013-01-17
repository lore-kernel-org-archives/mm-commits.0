From: akpm@linux-foundation.org
Subject: + pm-runtime-introduce-pm_runtime_set_memalloc_noio.patch added to -mm tree
Date: Thu, 17 Jan 2013 13:57:47 -0800
Message-ID: <20130117215747.AF1C85A41EB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f201.google.com ([209.85.210.201]:39570 "EHLO
	mail-ia0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab3AQWEw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jan 2013 17:04:52 -0500
Received: by mail-ia0-f201.google.com with SMTP id t4so212853iag.2
        for <mm-commits@vger.kernel.org>; Thu, 17 Jan 2013 14:04:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ming.lei@canonical.com, axboe@kernel.dk, davem@davemloft.net, david.decotigny@google.com, eric.dumazet@gmail.com, greg@kroah.com, jiri.kosina@suse.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, minchan@kernel.org, mingo@elte.hu, mingo@redhat.com, oneukum@suse.de, peterz@infradead.org, rjw@sisk.pl, stern@rowland.harvard.edu, therbert@google.com


The patch titled
     Subject: pm / runtime: introduce pm_runtime_set_memalloc_noio()
has been added to the -mm tree.  Its filename is
     pm-runtime-introduce-pm_runtime_set_memalloc_noio.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ming Lei <ming.lei@canonical.com>
Subject: pm / runtime: introduce pm_runtime_set_memalloc_noio()

Introduce the flag memalloc_noio in 'struct dev_pm_info' to help PM core
to teach mm not allocating memory with GFP_KERNEL flag for avoiding
probable deadlock.

As explained in the comment, any GFP_KERNEL allocation inside
runtime_resume() or runtime_suspend() on any one of device in the path
from one block or network device to the root device in the device tree may
cause deadlock, the introduced pm_runtime_set_memalloc_noio() sets or
clears the flag on device in the path recursively.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.de>
Cc: Jiri Kosina <jiri.kosina@suse.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Decotigny <david.decotigny@google.com>
Cc: Tom Herbert <therbert@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/power/runtime.c |   70 +++++++++++++++++++++++++++++++++
 include/linux/pm.h           |    1 
 include/linux/pm_runtime.h   |    3 +
 3 files changed, 74 insertions(+)

diff -puN drivers/base/power/runtime.c~pm-runtime-introduce-pm_runtime_set_memalloc_noio drivers/base/power/runtime.c
--- a/drivers/base/power/runtime.c~pm-runtime-introduce-pm_runtime_set_memalloc_noio
+++ a/drivers/base/power/runtime.c
@@ -124,6 +124,76 @@ unsigned long pm_runtime_autosuspend_exp
 }
 EXPORT_SYMBOL_GPL(pm_runtime_autosuspend_expiration);
 
+static int dev_memalloc_noio(struct device *dev, void *data)
+{
+	return dev->power.memalloc_noio;
+}
+
+/*
+ * pm_runtime_set_memalloc_noio - Set a device's memalloc_noio flag.
+ * @dev: Device to handle.
+ * @enable: True for setting the flag and False for clearing the flag.
+ *
+ * Set the flag for all devices in the path from the device to the
+ * root device in the device tree if @enable is true, otherwise clear
+ * the flag for devices in the path whose siblings don't set the flag.
+ *
+ * The function should only be called by block device, or network
+ * device driver for solving the deadlock problem during runtime
+ * resume/suspend:
+ *
+ *     If memory allocation with GFP_KERNEL is called inside runtime
+ *     resume/suspend callback of any one of its ancestors(or the
+ *     block device itself), the deadlock may be triggered inside the
+ *     memory allocation since it might not complete until the block
+ *     device becomes active and the involed page I/O finishes. The
+ *     situation is pointed out first by Alan Stern. Network device
+ *     are involved in iSCSI kind of situation.
+ *
+ * The lock of dev_hotplug_mutex is held in the function for handling
+ * hotplug race because pm_runtime_set_memalloc_noio() may be called
+ * in async probe().
+ *
+ * The function should be called between device_add() and device_del()
+ * on the affected device(block/network device).
+ */
+void pm_runtime_set_memalloc_noio(struct device *dev, bool enable)
+{
+	static DEFINE_MUTEX(dev_hotplug_mutex);
+
+	mutex_lock(&dev_hotplug_mutex);
+	for (;;) {
+		bool enabled;
+
+		/* hold power lock since bitfield is not SMP-safe. */
+		spin_lock_irq(&dev->power.lock);
+		enabled = dev->power.memalloc_noio;
+		dev->power.memalloc_noio = enable;
+		spin_unlock_irq(&dev->power.lock);
+
+		/*
+		 * not need to enable ancestors any more if the device
+		 * has been enabled.
+		 */
+		if (enabled && enable)
+			break;
+
+		dev = dev->parent;
+
+		/*
+		 * clear flag of the parent device only if all the
+		 * children don't set the flag because ancestor's
+		 * flag was set by any one of the descendants.
+		 */
+		if (!dev || (!enable &&
+			     device_for_each_child(dev, NULL,
+						   dev_memalloc_noio)))
+			break;
+	}
+	mutex_unlock(&dev_hotplug_mutex);
+}
+EXPORT_SYMBOL_GPL(pm_runtime_set_memalloc_noio);
+
 /**
  * rpm_check_suspend_allowed - Test whether a device may be suspended.
  * @dev: Device to test.
diff -puN include/linux/pm.h~pm-runtime-introduce-pm_runtime_set_memalloc_noio include/linux/pm.h
--- a/include/linux/pm.h~pm-runtime-introduce-pm_runtime_set_memalloc_noio
+++ a/include/linux/pm.h
@@ -538,6 +538,7 @@ struct dev_pm_info {
 	unsigned int		irq_safe:1;
 	unsigned int		use_autosuspend:1;
 	unsigned int		timer_autosuspends:1;
+	unsigned int		memalloc_noio:1;
 	enum rpm_request	request;
 	enum rpm_status		runtime_status;
 	int			runtime_error;
diff -puN include/linux/pm_runtime.h~pm-runtime-introduce-pm_runtime_set_memalloc_noio include/linux/pm_runtime.h
--- a/include/linux/pm_runtime.h~pm-runtime-introduce-pm_runtime_set_memalloc_noio
+++ a/include/linux/pm_runtime.h
@@ -47,6 +47,7 @@ extern void pm_runtime_set_autosuspend_d
 extern unsigned long pm_runtime_autosuspend_expiration(struct device *dev);
 extern void pm_runtime_update_max_time_suspended(struct device *dev,
 						 s64 delta_ns);
+extern void pm_runtime_set_memalloc_noio(struct device *dev, bool enable);
 
 static inline bool pm_children_suspended(struct device *dev)
 {
@@ -149,6 +150,8 @@ static inline void pm_runtime_set_autosu
 						int delay) {}
 static inline unsigned long pm_runtime_autosuspend_expiration(
 				struct device *dev) { return 0; }
+static inline void pm_runtime_set_memalloc_noio(struct device *dev,
+						bool enable){}
 
 #endif /* !CONFIG_PM_RUNTIME */
 
_

Patches currently in -mm which might be from ming.lei@canonical.com are

origin.patch
linux-next.patch
mm-teach-mm-by-current-context-info-to-not-do-i-o-during-memory-allocation.patch
pm-runtime-introduce-pm_runtime_set_memalloc_noio.patch
block-genhdc-apply-pm_runtime_set_memalloc_noio-on-block-devices.patch
net-core-apply-pm_runtime_set_memalloc_noio-on-network-devices.patch
pm-runtime-force-memory-allocation-with-no-i-o-during-runtime-pm-callbcack.patch
usb-forbid-memory-allocation-with-i-o-during-bus-reset.patch

