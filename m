From: akpm@linux-foundation.org
Subject: + git-acpi-fix-cpuidle-borkage-2.patch added to -mm tree
Date: Fri, 02 Mar 2007 14:42:31 -0800
Message-ID: <200703022242.l22MgVmm021212@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45209 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992645AbXCBWnI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 17:43:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, abelay@novell.com, len.brown@intel.com, shaohua.li@intel.com


The patch titled
     git-acpi-fix-cpuidle-borkage 2
has been added to the -mm tree.  Its filename is
     git-acpi-fix-cpuidle-borkage-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-acpi-fix-cpuidle-borkage 2
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Fix the compile issues when CPU_IDLE is not configured.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Adam Belay <abelay@novell.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuidle.h |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+)

diff -puN include/linux/cpuidle.h~git-acpi-fix-cpuidle-borkage-2 include/linux/cpuidle.h
--- a/include/linux/cpuidle.h~git-acpi-fix-cpuidle-borkage-2
+++ a/include/linux/cpuidle.h
@@ -130,10 +130,21 @@ struct cpuidle_driver {
 	struct module 		*owner;
 };
 
+#ifdef CONFIG_CPU_IDLE
+
 extern int cpuidle_register_driver(struct cpuidle_driver *drv);
 extern void cpuidle_unregister_driver(struct cpuidle_driver *drv);
 extern int cpuidle_force_redetect(struct cpuidle_device *dev);
 
+#else
+
+static inline int cpuidle_register_driver(struct cpuidle_driver *drv)
+{return 0;}
+static inline void cpuidle_unregister_driver(struct cpuidle_driver *drv) { }
+static inline int cpuidle_force_redetect(struct cpuidle_device *dev)
+{return 0;}
+
+#endif
 
 /******************************
  * CPUIDLE GOVERNOR INTERFACE *
@@ -153,8 +164,20 @@ struct cpuidle_governor {
 	struct module 		*owner;
 };
 
+#ifdef CONFIG_CPU_IDLE
+
 extern int cpuidle_register_governor(struct cpuidle_governor *gov);
 extern void cpuidle_unregister_governor(struct cpuidle_governor *gov);
 extern int cpuidle_get_bm_activity(void);
 
+#else
+
+static inline int cpuidle_register_governor(struct cpuidle_governor *gov)
+{return 0;}
+static inline void cpuidle_unregister_governor(struct cpuidle_governor *gov) { }
+static inline int cpuidle_get_bm_activity(void)
+{return 0;}
+
+#endif
+
 #endif /* _LINUX_CPUIDLE_H */
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

git-acpi.patch
git-acpi-fix-cpuidle-borkage-2.patch
git-acpi-fix-cpuidle-borkage.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
