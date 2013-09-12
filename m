From: akpm@linux-foundation.org
Subject: [withdrawn]
 vmpressure-fix-divide-by-0-in-vmpressure_work_fn.patch removed from -mm
 tree
Date: Thu, 12 Sep 2013 13:00:32 -0700
Message-ID: <52321d60.S55b0/WGneo4802Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58915 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab3ILUAd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 16:00:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, rientjes@google.com, hughd@google.com, anton@enomsg.org, mhocko@suse.cz

Subject: [withdrawn] vmpressure-fix-divide-by-0-in-vmpressure_work_fn.patch removed from -mm tree
To: mhocko@suse.cz,anton@enomsg.org,hughd@google.com,rientjes@google.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 13:00:32 -0700


The patch titled
     Subject: vmpressure: fix divide-by-0 in vmpressure_work_fn
has been removed from the -mm tree.  Its filename was
     vmpressure-fix-divide-by-0-in-vmpressure_work_fn.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: vmpressure: fix divide-by-0 in vmpressure_work_fn

Hugh Dickins has reported a division by 0 when a vmpressure event is
processed.  The reason for the exception is that a single vmpressure work
item (which is per memcg) might be processed by multiple CPUs because it
is enqueued on system_wq which is !WQ_NON_REENTRANT.  This means that the
out of lock vmpr->scanned check in vmpressure_work_fn is inherently racy
and the racing workers will see already zeroed scanned value after they
manage to take the spin lock.

The patch simply moves the vmp->scanned check inside the sr_lock to fix
the race.

The issue was there since the very beginning but "vmpressure: change
vmpressure::sr_lock to spinlock" might have made it more visible as the
racing workers would sleep on the mutex and give it more time to see
updated value.  The issue was still there, though.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Hugh Dickins <hughd@google.com>
Acked-by: Anton Vorontsov <anton@enomsg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmpressure.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN mm/vmpressure.c~vmpressure-fix-divide-by-0-in-vmpressure_work_fn mm/vmpressure.c
--- a/mm/vmpressure.c~vmpressure-fix-divide-by-0-in-vmpressure_work_fn
+++ a/mm/vmpressure.c
@@ -164,18 +164,19 @@ static void vmpressure_work_fn(struct wo
 	unsigned long scanned;
 	unsigned long reclaimed;
 
+	spin_lock(&vmpr->sr_lock);
+
 	/*
-	 * Several contexts might be calling vmpressure(), so it is
-	 * possible that the work was rescheduled again before the old
-	 * work context cleared the counters. In that case we will run
-	 * just after the old work returns, but then scanned might be zero
-	 * here. No need for any locks here since we don't care if
-	 * vmpr->reclaimed is in sync.
+	 * Several contexts might be calling vmpressure() and the work
+	 * item is sitting on !WQ_NON_REENTRANT workqueue so different
+	 * CPUs might execute it concurrently. Bail out if the scanned
+	 * counter is already 0 because all the work has been done already.
 	 */
-	if (!vmpr->scanned)
+	if (!vmpr->scanned) {
+		spin_unlock(&vmpr->sr_lock);
 		return;
+	}
 
-	spin_lock(&vmpr->sr_lock);
 	scanned = vmpr->scanned;
 	reclaimed = vmpr->reclaimed;
 	vmpr->scanned = 0;
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
watchdog-update-watchdog-attributes-atomically.patch
watchdog-update-watchdog_tresh-properly.patch
watchdog-update-watchdog_tresh-properly-fix.patch
memcg-remove-redundant-code-in-mem_cgroup_force_empty_write.patch
memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
memcg-get-rid-of-soft-limit-tree-infrastructure.patch
vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
memcg-enhance-memcg-iterator-to-support-predicates.patch
memcg-enhance-memcg-iterator-to-support-predicates-fix.patch
memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
memcg-track-all-children-over-limit-in-the-root.patch
memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
memcg-trivial-cleanups.patch
arch-mm-remove-obsolete-init-oom-protection.patch
arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom.patch
arch-mm-pass-userspace-fault-flag-to-generic-fault-handler.patch
x86-finish-user-fault-error-path-with-fatal-signal.patch
mm-memcg-enable-memcg-oom-killer-only-for-user-faults.patch
mm-memcg-rework-and-document-oom-waiting-and-wakeup.patch
mm-memcg-do-not-trap-chargers-with-full-callstack-on-oom.patch
memcg-correct-resource_max-to-ullong_max.patch
memcg-rename-resource_max-to-res_counter_max.patch
memcg-avoid-overflow-caused-by-page_align.patch
memcg-reduce-function-dereference.patch
memcg-remove-memcg_nr_file_mapped.patch
memcg-check-for-proper-lock-held-in-mem_cgroup_update_page_stat.patch
memcg-add-per-cgroup-writeback-pages-accounting.patch
memcg-document-cgroup-dirty-writeback-memory-statistics.patch
mm-kconfig-add-mmu-dependency-for-migration.patch

