From: akpm@linux-foundation.org
Subject: + vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix.patch added to -mm tree
Date: Tue, 24 May 2011 13:47:21 -0700
Message-ID: <201105242124.p4OLO59V016274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753197Ab1EXVYk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 17:24:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, yinghan@google.com


The patch titled
     vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix
has been added to the -mm tree.  Its filename is
     vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix.patch

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
Subject: vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix
From: Andrew Morton <akpm@linux-foundation.org>

fs/xfs/quota/xfs_qm.c: In function 'xfs_qm_shake':
fs/xfs/quota/xfs_qm.c:2015: warning: unused variable 'nr_to_scan'

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/quota/xfs_qm.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/xfs/quota/xfs_qm.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix fs/xfs/quota/xfs_qm.c
--- a/fs/xfs/quota/xfs_qm.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix
+++ a/fs/xfs/quota/xfs_qm.c
@@ -2012,7 +2012,6 @@ xfs_qm_shake(
 	struct shrink_control *sc)
 {
 	int	ndqused, nfree, n;
-	int nr_to_scan = sc->nr_to_scan;
 	gfp_t gfp_mask = sc->gfp_mask;
 
 	if (!kmem_shake_allow(gfp_mask))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value.patch
mm-nommu-sort-mm-mmap-list-properly-fix.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur-fix.patch
mm-mmu_gather-rework-fix.patch
mm-uninline-large-generic-tlbh-functions.patch
mm-thp-optimize-memcg-charge-in-khugepaged-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-checkpatch-fixes.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix-fix.patch
nommu-add-page-alignment-to-mmap-checkpatch-fixes.patch
cris-convert-old-cpumask-api-into-new-one-checkpatch-fixes.patch
bitmap-irq-add-smp_affinity_list-interface-to-proc-irq-fix.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch
printk-allocate-kernel-log-buffer-earlier-v2-checkpatch-fixes.patch
printk-allocate-kernel-log-buffer-earlier-v2-fix.patch
drivers-leds-leds-lm3530c-add-regulator-checkpatch-fixes.patch
leds-provide-helper-to-register-leds-gpio-devices.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
percpu_counter-change-return-value-and-add-comments-fix.patch
checkpatch-suggest-using-min_t-or-max_t.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch

