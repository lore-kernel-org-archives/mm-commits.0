From: akpm@linux-foundation.org
Subject: + mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch added to -mm tree
Date: Wed, 03 Feb 2010 14:29:54 -0800
Message-ID: <201002032229.o13MTsYv023028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756539Ab0BCWar (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 17:30:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, benh@kernel.crashing.org, kosaki.motohiro@jp.fujitsu.com, maximlevitsky@gmail.com, sebott@linux.vnet.ibm.com


The patch titled
     mm/pm: force GFP_NOIO during suspend/hibernation and resume
has been added to the -mm tree.  Its filename is
     mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h      |    8 ++++++++
 kernel/power/hibernate.c |    9 +++++++++
 kernel/power/suspend.c   |    3 +++
 3 files changed, 20 insertions(+)

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
@@ -342,4 +343,11 @@ static inline void set_gfp_allowed_mask(
 	gfp_allowed_mask = mask;
 }
 
+static inline gfp_t clear_gfp_allowed_mask(gfp_t mask)
+{
+	gfp_t ret = gfp_allowed_mask;
+	gfp_allowed_mask &= ~mask;
+	return ret;
+}
+
 #endif /* __LINUX_GFP_H */
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
_

Patches currently in -mm which might be from rjw@sisk.pl are

linux-next.patch
drivers-acpi-processor_idlec-add-two-laptops-to-the-c-state-dmi-table.patch
acpi-remove-old-blacklist-entries.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch

