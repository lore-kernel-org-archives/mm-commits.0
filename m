From: akpm@linux-foundation.org
Subject: + revert-clockevents-prevent-clockevent_devices-list-corruption-on-cpu-hotplug.patch added to -mm tree
Date: Tue, 12 Jan 2010 14:08:20 -0800
Message-ID: <201001122208.o0CM8KxJ030607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754155Ab0ALWJS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jan 2010 17:09:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dfeng@redhat.com, mrb74@gmx.at, rjw@sisk.pl, stable@kernel.org, tglx@linutronix.de


The patch titled
     revert "clockevents: Prevent clockevent_devices list corruption on cpu hotplug"
has been added to the -mm tree.  Its filename is
     revert-clockevents-prevent-clockevent_devices-list-corruption-on-cpu-hotplug.patch

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
Subject: revert "clockevents: Prevent clockevent_devices list corruption on cpu hotplug"
From: Andrew Morton <akpm@linux-foundation.org>

Revert

: commit bb6eddf7676e1c1f3e637aa93c5224488d99036f
: Author:     Thomas Gleixner <tglx@linutronix.de>
: AuthorDate: Thu Dec 10 15:35:10 2009 +0100
: Commit:     Thomas Gleixner <tglx@linutronix.de>
: CommitDate: Fri Dec 11 10:28:08 2009 +0100
: 
:     clockevents: Prevent clockevent_devices list corruption on cpu hotplug

due to the regression reported in
http://bugzilla.kernel.org/show_bug.cgi?id=15005

Cc: Xiaotian Feng <dfeng@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Reported-by: Martin Bammer <mrb74@gmx.at>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/clockevents.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff -puN kernel/time/clockevents.c~revert-clockevents-prevent-clockevent_devices-list-corruption-on-cpu-hotplug kernel/time/clockevents.c
--- a/kernel/time/clockevents.c~revert-clockevents-prevent-clockevent_devices-list-corruption-on-cpu-hotplug
+++ a/kernel/time/clockevents.c
@@ -238,9 +238,8 @@ void clockevents_exchange_device(struct 
  */
 void clockevents_notify(unsigned long reason, void *arg)
 {
-	struct clock_event_device *dev, *tmp;
+	struct list_head *node, *tmp;
 	unsigned long flags;
-	int cpu;
 
 	raw_spin_lock_irqsave(&clockevents_lock, flags);
 	clockevents_do_notify(reason, arg);
@@ -251,19 +250,8 @@ void clockevents_notify(unsigned long re
 		 * Unregister the clock event devices which were
 		 * released from the users in the notify chain.
 		 */
-		list_for_each_entry_safe(dev, tmp, &clockevents_released, list)
-			list_del(&dev->list);
-		/*
-		 * Now check whether the CPU has left unused per cpu devices
-		 */
-		cpu = *((int *)arg);
-		list_for_each_entry_safe(dev, tmp, &clockevent_devices, list) {
-			if (cpumask_test_cpu(cpu, dev->cpumask) &&
-			    cpumask_weight(dev->cpumask) == 1) {
-				BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
-				list_del(&dev->list);
-			}
-		}
+		list_for_each_safe(node, tmp, &clockevents_released)
+			list_del(node);
 		break;
 	default:
 		break;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
revert-clockevents-prevent-clockevent_devices-list-corruption-on-cpu-hotplug.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
fs-improve-remountro-vs-buffercache-coherency.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
sort-introduce-generic-list_sort-function-v3-checkpatch-fixes.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

