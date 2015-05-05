From: akpm@linux-foundation.org
Subject: + watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-2.patch added to -mm tree
Date: Tue, 05 May 2015 12:53:20 -0700
Message-ID: <55491fb0.2glt9N+SM6ypnKs2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030844AbbEETxV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2015 15:53:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmetcalf@ezchip.com, dzickus@redhat.com, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: avoid changing cpumask on unregistered smpboot thread
has been added to the -mm tree.  Its filename is
     watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -899,7 +899,7 @@ int proc_watchdog_cpumask(struct ctl_tab
 		cpumask_and(&watchdog_cpumask, &watchdog_cpumask,
 			    cpu_possible_mask);
 
-		if (watchdog_enabled && watchdog_thresh) {
+		if (watchdog_running) {
 			/*
 			 * Failure would be due to being unable to allocate
 			 * a temporary cpumask, so we are likely not in a
_

Patches currently in -mm which might be from cmetcalf@ezchip.com are

smpboot-allow-excluding-cpus-from-the-smpboot-threads.patch
smpboot-allow-excluding-cpus-from-the-smpboot-threads-fix.patch
watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz.patch
watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix.patch
watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-2.patch
procfs-treat-parked-tasks-as-sleeping-for-task-state.patch
mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare.patch
__bitmap_parselist-fix-bug-in-empty-string-handling.patch
linux-next.patch
fix-a-misaligned-load-inside-ptrace_attach.patch
change-wait_on_bit-to-take-an-unsigned-long-not-a-void.patch
change-all-uses-of-jobctl_-from-int-to-long.patch

