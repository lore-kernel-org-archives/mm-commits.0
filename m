From: akpm@linux-foundation.org
Subject: + oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch added to -mm tree
Date: Thu, 12 Nov 2009 13:54:55 -0800
Message-ID: <200911122154.nACLstav029908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754370AbZKLVy6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 16:54:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, cl@linux-foundation.org, kamezawa.hioryu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com


The patch titled
     oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch

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
alpha-move-thread_size-definition-outside-ifndef-assembly.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-compiler-gcc4h-gcc-402-doesnt-understand-__builtin_object_size.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix.patch
acpi-remove-nid_inval-checkpatch-fixes.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
include-trace-events-lockdeph-fix-do_div-warning.patch
st-fix-test-of-value-range-in-st_set_options.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
msm_sdccc-add-missing-include-fix-compilation-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
spi-controller-driver-for-designware-spi-core-fix.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-disable.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

