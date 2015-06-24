From: akpm@linux-foundation.org
Subject: [folded-merged]
 watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-2.patch removed
 from -mm tree
Date: Wed, 24 Jun 2015 16:44:22 -0700
Message-ID: <558b40d6.TO0RVJYC3hbEY0UJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbbFXXoW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jun 2015 19:44:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmetcalf@ezchip.com, dzickus@redhat.com, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: avoid changing cpumask on unregistered smpboot thread
has been removed from the -mm tree.  Its filename was
     watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-2.patch

This patch was dropped because it was folded into watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz.patch

------------------------------------------------------
From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: watchdog: avoid changing cpumask on unregistered smpboot thread

Also, add a line documenting that you are not supposed to try to do this.

The risk, as Ulrich Obergfell pointed out, is that if registration fails
due to ENOMEM, there may be no valid cpumask field in the smpboot object,
so attempting to modify it in smpboot_update_cpumask_percpu_thread() would
crash.

In the case of the watchdog this change is fine because we will reset the
smpboot cpumask as soon as we successfully manage to register the smpboot
thread.

Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smpboot.c  |    1 +
 kernel/watchdog.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/smpboot.c~watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-2 kernel/smpboot.c
--- a/kernel/smpboot.c~watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-2
+++ a/kernel/smpboot.c
@@ -338,6 +338,7 @@ EXPORT_SYMBOL_GPL(smpboot_unregister_per
  *
  * The cpumask field in the smp_hotplug_thread must not be updated directly
  * by the client, but only by calling this function.
+ * This function can only be called on a registered smp_hotplug_thread.
  */
 int smpboot_update_cpumask_percpu_thread(struct smp_hotplug_thread *plug_thread,
 					 const struct cpumask *new)
diff -puN kernel/watchdog.c~watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-2 kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-2
+++ a/kernel/watchdog.c
@@ -909,7 +909,7 @@ int proc_watchdog_cpumask(struct ctl_tab
 		cpumask_and(&watchdog_cpumask, &watchdog_cpumask,
 			    cpu_possible_mask);
 
-		if (watchdog_enabled && watchdog_thresh) {
+		if (watchdog_running) {
 			/*
 			 * Failure would be due to being unable to allocate
 			 * a temporary cpumask, so we are likely not in a
_

Patches currently in -mm which might be from cmetcalf@ezchip.com are

origin.patch
smpboot-allow-excluding-cpus-from-the-smpboot-threads.patch
watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz.patch
watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-3.patch
procfs-treat-parked-tasks-as-sleeping-for-task-state.patch
mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare.patch

