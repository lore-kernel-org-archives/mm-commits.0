From: akpm@linux-foundation.org
Subject: [folded] oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 14 Dec 2009 16:59:42 -0800
Message-ID: <200912150059.nBF0xgqC024683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757361AbZLOA7z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 19:59:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux-foundation.org, kamezawa.hioryu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch

This patch was dropped because it was folded into oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#99: FILE: mm/oom_kill.c:209:
+ ^I * to kill current.We have to random task kill in this case.$

ERROR: code indent should use tabs where possible
#100: FILE: mm/oom_kill.c:210:
+ ^I * Hopefully, CONSTRAINT_THISNODE...but no way to handle it, now.$

ERROR: code indent should use tabs where possible
#101: FILE: mm/oom_kill.c:211:
+ ^I */$

ERROR: code indent should use tabs where possible
#107: FILE: mm/oom_kill.c:216:
+ ^I * The nodemask here is a nodemask passed to alloc_pages(). Now,$

ERROR: code indent should use tabs where possible
#108: FILE: mm/oom_kill.c:217:
+ ^I * cpuset doesn't use this nodemask for its hardwall/softwall/hierarchy$

ERROR: code indent should use tabs where possible
#109: FILE: mm/oom_kill.c:218:
+ ^I * feature. mempolicy is an only user of nodemask here.$

ERROR: code indent should use tabs where possible
#111: FILE: mm/oom_kill.c:220:
+ ^I */$

ERROR: code indent should use tabs where possible
#169: FILE: mm/page_alloc.c:1672:
+^I ^I* GFP_THISNODE contains __GFP_NORETRY and we never hit this.$

ERROR: code indent should use tabs where possible
#170: FILE: mm/page_alloc.c:1673:
+^I ^I* Sanity check for bare calls of __GFP_THISNODE, not real OOM.$

ERROR: code indent should use tabs where possible
#171: FILE: mm/page_alloc.c:1674:
+^I ^I* The caller should handle page allocation failure by itself if$

ERROR: code indent should use tabs where possible
#172: FILE: mm/page_alloc.c:1675:
+^I ^I* it specifies __GFP_THISNODE.$

ERROR: code indent should use tabs where possible
#173: FILE: mm/page_alloc.c:1676:
+^I ^I* Note: Hugepage uses it but will hit PAGE_ALLOC_COSTLY_ORDER.$

ERROR: code indent should use tabs where possible
#174: FILE: mm/page_alloc.c:1677:
+^I ^I*/$

total: 13 errors, 0 warnings, 125 lines checked

./patches/oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hioryu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c   |   14 +++++++-------
 mm/page_alloc.c |   14 +++++++-------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff -puN mm/oom_kill.c~oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes mm/oom_kill.c
--- a/mm/oom_kill.c~oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes
+++ a/mm/oom_kill.c
@@ -206,18 +206,18 @@ static enum oom_constraint constrained_a
 
 	/*
 	 * Reach here only when __GFP_NOFAIL is used. So, we should avoid
- 	 * to kill current.We have to random task kill in this case.
- 	 * Hopefully, CONSTRAINT_THISNODE...but no way to handle it, now.
- 	 */
+	 * to kill current.We have to random task kill in this case.
+	 * Hopefully, CONSTRAINT_THISNODE...but no way to handle it, now.
+	 */
 	if (gfp_mask & __GFP_THISNODE)
 		return CONSTRAINT_NONE;
 
 	/*
- 	 * The nodemask here is a nodemask passed to alloc_pages(). Now,
- 	 * cpuset doesn't use this nodemask for its hardwall/softwall/hierarchy
- 	 * feature. mempolicy is an only user of nodemask here.
+	 * The nodemask here is a nodemask passed to alloc_pages(). Now,
+	 * cpuset doesn't use this nodemask for its hardwall/softwall/hierarchy
+	 * feature. mempolicy is an only user of nodemask here.
 	 * check mempolicy's nodemask contains all N_HIGH_MEMORY
- 	 */
+	 */
 	if (nodemask && !nodes_subset(node_states[N_HIGH_MEMORY], *nodemask))
 		return CONSTRAINT_MEMORY_POLICY;
 
diff -puN mm/page_alloc.c~oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes mm/page_alloc.c
--- a/mm/page_alloc.c~oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -1669,12 +1669,12 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 		if (order > PAGE_ALLOC_COSTLY_ORDER)
 			goto out;
 		/*
-	 	* GFP_THISNODE contains __GFP_NORETRY and we never hit this.
-	 	* Sanity check for bare calls of __GFP_THISNODE, not real OOM.
-	 	* The caller should handle page allocation failure by itself if
-	 	* it specifies __GFP_THISNODE.
-	 	* Note: Hugepage uses it but will hit PAGE_ALLOC_COSTLY_ORDER.
-	 	*/
+		 * GFP_THISNODE contains __GFP_NORETRY and we never hit this.
+		 * Sanity check for bare calls of __GFP_THISNODE, not real OOM.
+		 * The caller should handle page allocation failure by itself if
+		 * it specifies __GFP_THISNODE.
+		 * Note: Hugepage uses it but will hit PAGE_ALLOC_COSTLY_ORDER.
+		 */
 		if (gfp_mask & __GFP_THISNODE)
 			goto out;
 	}
@@ -3143,7 +3143,7 @@ static int __cpuinit process_zones(int c
 
 		if (percpu_pagelist_fraction)
 			setup_pagelist_highmark(zone_pcp(zone, cpu),
-			 	(zone->present_pages / percpu_pagelist_fraction));
+			    (zone->present_pages / percpu_pagelist_fraction));
 	}
 
 	return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
mm-memory_hotplug-make-offline_pages-static.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore-cleanup.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore-build-fix.patch
mm-hugetlb-add-hugepage-support-to-pagemap-build-fix.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-cleanup.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
cs5535-add-a-generic-mfgpt-driver-fix.patch
cs5535-add-a-generic-clock-event-mfgpt-driver-fix.patch
drivers-scsi-sym53c8xx_2-sym_gluec-rename-skip_spaces-to-sym_skip_spaces.patch
lib-introduce-strim-checkpatch-fixes.patch
blackfin-sd-host-controller-driver-fix.patch
blackfin-sd-host-controller-driver-fix-fix.patch
blackfin-sd-host-controller-driver-fix-fix-fix.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
lis3-update-documentation-to-match-latest-changes-fix.patch

