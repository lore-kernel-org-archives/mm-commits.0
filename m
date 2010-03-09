From: akpm@linux-foundation.org
Subject: [merged] mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:04:23 -0800
Message-ID: <201003091904.o29J4NN8031038@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755790Ab0CITFZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:05:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, benh@kernel.crashing.org, kosaki.motohiro@jp.fujitsu.com, maximlevitsky@gmail.com, sebott@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     mm/pm: force GFP_NOIO during suspend/hibernation and resume
has been removed from the -mm tree.  Its filename was
     mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/pm: force GFP_NOIO during suspend/hibernation and resume
From: "Rafael J. Wysocki" <rjw@sisk.pl>

There are quite a few GFP_KERNEL memory allocations made during
suspend/hibernation and resume that may cause the system to hang, because
the I/O operations they depend on cannot be completed due to the
underlying devices being suspended.

Avoid this problem by clearing the __GFP_IO and __GFP_FS bits in
gfp_allowed_mask before suspend/hibernation and restoring the original
values of these bits in gfp_allowed_mask durig the subsequent resume.

[akpm@linux-foundation.org: fix CONFIG_PM=n linkage]
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h      |    7 +++----
 init/main.c              |    2 +-
 kernel/power/hibernate.c |    9 +++++++++
 kernel/power/suspend.c   |    3 +++
 mm/page_alloc.c          |   25 +++++++++++++++++++++++++
 5 files changed, 41 insertions(+), 5 deletions(-)

diff -puN include/linux/gfp.h~mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume include/linux/gfp.h
--- a/include/linux/gfp.h~mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume
+++ a/include/linux/gfp.h
@@ -83,6 +83,7 @@ struct vm_area_struct;
 #define GFP_HIGHUSER_MOVABLE	(__GFP_WAIT | __GFP_IO | __GFP_FS | \
 				 __GFP_HARDWALL | __GFP_HIGHMEM | \
 				 __GFP_MOVABLE)
+#define GFP_IOFS	(__GFP_IO | __GFP_FS)
 
 #ifdef CONFIG_NUMA
 #define GFP_THISNODE	(__GFP_THISNODE | __GFP_NOWARN | __GFP_NORETRY)
@@ -337,9 +338,7 @@ void drain_local_pages(void *dummy);
 
 extern gfp_t gfp_allowed_mask;
 
-static inline void set_gfp_allowed_mask(gfp_t mask)
-{
-	gfp_allowed_mask = mask;
-}
+extern void set_gfp_allowed_mask(gfp_t mask);
+extern gfp_t clear_gfp_allowed_mask(gfp_t mask);
 
 #endif /* __LINUX_GFP_H */
diff -puN init/main.c~mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume init/main.c
--- a/init/main.c~mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume
+++ a/init/main.c
@@ -618,7 +618,7 @@ asmlinkage void __init start_kernel(void
 	local_irq_enable();
 
 	/* Interrupts are enabled now so all GFP allocations are safe. */
-	set_gfp_allowed_mask(__GFP_BITS_MASK);
+	gfp_allowed_mask = __GFP_BITS_MASK;
 
 	kmem_cache_init_late();
 
diff -puN kernel/power/hibernate.c~mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume kernel/power/hibernate.c
--- a/kernel/power/hibernate.c~mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume
+++ a/kernel/power/hibernate.c
@@ -323,6 +323,7 @@ static int create_image(int platform_mod
 int hibernation_snapshot(int platform_mode)
 {
 	int error;
+	gfp_t saved_mask;
 
 	error = platform_begin(platform_mode);
 	if (error)
@@ -334,6 +335,7 @@ int hibernation_snapshot(int platform_mo
 		goto Close;
 
 	suspend_console();
+	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
 	error = dpm_suspend_start(PMSG_FREEZE);
 	if (error)
 		goto Recover_platform;
@@ -351,6 +353,7 @@ int hibernation_snapshot(int platform_mo
 
 	dpm_resume_end(in_suspend ?
 		(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
+	set_gfp_allowed_mask(saved_mask);
 	resume_console();
  Close:
 	platform_end(platform_mode);
@@ -445,14 +448,17 @@ static int resume_target_kernel(bool pla
 int hibernation_restore(int platform_mode)
 {
 	int error;
+	gfp_t saved_mask;
 
 	pm_prepare_console();
 	suspend_console();
+	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
 	error = dpm_suspend_start(PMSG_QUIESCE);
 	if (!error) {
 		error = resume_target_kernel(platform_mode);
 		dpm_resume_end(PMSG_RECOVER);
 	}
+	set_gfp_allowed_mask(saved_mask);
 	resume_console();
 	pm_restore_console();
 	return error;
@@ -466,6 +472,7 @@ int hibernation_restore(int platform_mod
 int hibernation_platform_enter(void)
 {
 	int error;
+	gfp_t saved_mask;
 
 	if (!hibernation_ops)
 		return -ENOSYS;
@@ -481,6 +488,7 @@ int hibernation_platform_enter(void)
 
 	entering_platform_hibernation = true;
 	suspend_console();
+	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
 	error = dpm_suspend_start(PMSG_HIBERNATE);
 	if (error) {
 		if (hibernation_ops->recover)
@@ -518,6 +526,7 @@ int hibernation_platform_enter(void)
  Resume_devices:
 	entering_platform_hibernation = false;
 	dpm_resume_end(PMSG_RESTORE);
+	set_gfp_allowed_mask(saved_mask);
 	resume_console();
 
  Close:
diff -puN kernel/power/suspend.c~mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume kernel/power/suspend.c
--- a/kernel/power/suspend.c~mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume
+++ a/kernel/power/suspend.c
@@ -189,6 +189,7 @@ static int suspend_enter(suspend_state_t
 int suspend_devices_and_enter(suspend_state_t state)
 {
 	int error;
+	gfp_t saved_mask;
 
 	if (!suspend_ops)
 		return -ENOSYS;
@@ -199,6 +200,7 @@ int suspend_devices_and_enter(suspend_st
 			goto Close;
 	}
 	suspend_console();
+	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
 	suspend_test_start();
 	error = dpm_suspend_start(PMSG_SUSPEND);
 	if (error) {
@@ -215,6 +217,7 @@ int suspend_devices_and_enter(suspend_st
 	suspend_test_start();
 	dpm_resume_end(PMSG_RESUME);
 	suspend_test_finish("resume devices");
+	set_gfp_allowed_mask(saved_mask);
 	resume_console();
  Close:
 	if (suspend_ops->end)
diff -puN mm/page_alloc.c~mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume mm/page_alloc.c
--- a/mm/page_alloc.c~mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume
+++ a/mm/page_alloc.c
@@ -76,6 +76,31 @@ unsigned long totalreserve_pages __read_
 int percpu_pagelist_fraction;
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 
+#ifdef CONFIG_PM_SLEEP
+/*
+ * The following functions are used by the suspend/hibernate code to temporarily
+ * change gfp_allowed_mask in order to avoid using I/O during memory allocations
+ * while devices are suspended.  To avoid races with the suspend/hibernate code,
+ * they should always be called with pm_mutex held (gfp_allowed_mask also should
+ * only be modified with pm_mutex held, unless the suspend/hibernate code is
+ * guaranteed not to run in parallel with that modification).
+ */
+void set_gfp_allowed_mask(gfp_t mask)
+{
+	WARN_ON(!mutex_is_locked(&pm_mutex));
+	gfp_allowed_mask = mask;
+}
+
+gfp_t clear_gfp_allowed_mask(gfp_t mask)
+{
+	gfp_t ret = gfp_allowed_mask;
+
+	WARN_ON(!mutex_is_locked(&pm_mutex));
+	gfp_allowed_mask &= ~mask;
+	return ret;
+}
+#endif /* CONFIG_PM_SLEEP */
+
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 int pageblock_order __read_mostly;
 #endif
_

Patches currently in -mm which might be from rjw@sisk.pl are

linux-next.patch
arch-x86-kernel-rebootc-add-imac91-to-pci_reboot_dmi_table.patch

