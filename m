From: akpm@linux-foundation.org
Subject: + revert-cpufreq-fix-race-in-cpufreq_update_policy.patch added to -mm tree
Date: Tue, 12 Jan 2010 17:00:44 -0800
Message-ID: <201001130100.o0D10ixG005998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754279Ab0AMBBG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jan 2010 20:01:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Valdis.Kletnieks@vt.edu, davej@redhat.com, minchan.kim@gmail.com, mschmidt@redhat.com, trenn@suse.de


The patch titled
     revert "[CPUFREQ] Fix race in cpufreq_update_policy()"
has been added to the -mm tree.  Its filename is
     revert-cpufreq-fix-race-in-cpufreq_update_policy.patch

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
Subject: revert "[CPUFREQ] Fix race in cpufreq_update_policy()"
From: Andrew Morton <akpm@linux-foundation.org>

Revert

: commit 46aeb7430f79cb4d03e17fedd6399884ab3aa697
: Author: Thomas Renninger <trenn@suse.de>
: AuthorDate: Mon Dec 14 11:44:11 2009 +0100
: Commit: Dave Jones <davej@redhat.com>
: CommitDate: Thu Dec 17 12:33:02 2009 -0500
:
:	[CPUFREQ] Fix race in cpufreq_update_policy()

Due to "kernel BUG at drivers/cpufreq/cpufreq.c:88!" reports from Valdis
Kletnieks and Minchan Kim.

Cc: Thomas Renninger <trenn@suse.de>
Cc: Michal Schmidt <mschmidt@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Reported-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff -puN drivers/cpufreq/cpufreq.c~revert-cpufreq-fix-race-in-cpufreq_update_policy drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~revert-cpufreq-fix-race-in-cpufreq_update_policy
+++ a/drivers/cpufreq/cpufreq.c
@@ -1811,22 +1811,20 @@ error_out:
  */
 int cpufreq_update_policy(unsigned int cpu)
 {
-	struct cpufreq_policy *data;
+	struct cpufreq_policy *data = cpufreq_cpu_get(cpu);
 	struct cpufreq_policy policy;
 	int ret;
 
-	if (unlikely(lock_policy_rwsem_write(cpu))) {
-		ret = -EINVAL;
-		goto fail;
-	}
-	data = cpufreq_cpu_get(cpu);
-
 	if (!data) {
-		dprintk("Update: No policy on cpu: %u\n", cpu);
 		ret = -ENODEV;
 		goto no_policy;
 	}
 
+	if (unlikely(lock_policy_rwsem_write(cpu))) {
+		ret = -EINVAL;
+		goto fail;
+	}
+
 	dprintk("updating policy for CPU %u\n", cpu);
 	memcpy(&policy, data, sizeof(struct cpufreq_policy));
 	policy.min = data->user_policy.min;
@@ -1850,10 +1848,11 @@ int cpufreq_update_policy(unsigned int c
 
 	ret = __cpufreq_set_policy(data, &policy);
 
-	cpufreq_cpu_put(data);
-no_policy:
 	unlock_policy_rwsem_write(cpu);
+
 fail:
+	cpufreq_cpu_put(data);
+no_policy:
 	return ret;
 }
 EXPORT_SYMBOL(cpufreq_update_policy);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
revert-clockevents-prevent-clockevent_devices-list-corruption-on-cpu-hotplug.patch
revert-cpufreq-fix-race-in-cpufreq_update_policy.patch
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
vmscan-check-high-watermark-after-shrink-zone-fix.patch
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

