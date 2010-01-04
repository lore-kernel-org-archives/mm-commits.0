From: akpm@linux-foundation.org
Subject: + memcg-implement-memory-thresholds-checkpatch-fixes.patch added to -mm tree
Date: Mon, 04 Jan 2010 13:37:38 -0800
Message-ID: <201001042137.o04LbcAZ019680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753649Ab0ADViC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2010 16:38:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, dan@embeddedalley.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, vbuzov@embeddedalley.com, virtuoso@slind.org, xemul@openvz.org


The patch titled
     memcg-implement-memory-thresholds-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     memcg-implement-memory-thresholds-checkpatch-fixes.patch

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
Subject: memcg-implement-memory-thresholds-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "foo* bar" should be "foo *bar"
#125: FILE: mm/memcontrol.c:203:
+static bool mem_cgroup_threshold_check(struct mem_cgroup* mem);

ERROR: "foo* bar" should be "foo *bar"
#126: FILE: mm/memcontrol.c:204:
+static void mem_cgroup_threshold(struct mem_cgroup* mem);

WARNING: braces {} are not necessary for any arm of this statement
#204: FILE: mm/memcontrol.c:3297:
+	if (!swap) {
[...]
+	} else {
[...]

ERROR: space required before the open parenthesis '('
#228: FILE: mm/memcontrol.c:3321:
+	for(; i > 0 && unlikely(t->entries[i].threshold > usage); i--) {

WARNING: braces {} are not necessary for single statement blocks
#228: FILE: mm/memcontrol.c:3321:
+	for(; i > 0 && unlikely(t->entries[i].threshold > usage); i--) {
+		eventfd_signal(t->entries[i].eventfd, 1);
+	}

ERROR: space required before the open parenthesis '('
#241: FILE: mm/memcontrol.c:3334:
+	for(; i < t->size && unlikely(t->entries[i].threshold <= usage); i++) {

WARNING: braces {} are not necessary for single statement blocks
#241: FILE: mm/memcontrol.c:3334:
+	for(; i < t->size && unlikely(t->entries[i].threshold <= usage); i++) {
+		eventfd_signal(t->entries[i].eventfd, 1);
+	}

ERROR: space required before the open parenthesis '('
#325: FILE: mm/memcontrol.c:3418:
+	for(i = 0; i < size; i++) {

ERROR: space required before the open parenthesis '('
#387: FILE: mm/memcontrol.c:3480:
+	for(i = 0; i < thresholds->size; i++) {

ERROR: space required before the open parenthesis '('
#410: FILE: mm/memcontrol.c:3503:
+	for(i = 0, j = 0; i < thresholds->size; i++) {

ERROR: space required before the open parenthesis '('
#435: FILE: mm/memcontrol.c:3528:
+	for(i = 0; i < thresholds->size - size; i++)

total: 8 errors, 3 warnings, 416 lines checked

./patches/memcg-implement-memory-thresholds.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Alexander Shishkin <virtuoso@slind.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Dan Malek <dan@embeddedalley.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Vladislav Buzov <vbuzov@embeddedalley.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-implement-memory-thresholds-checkpatch-fixes Documentation/cgroups/memory.txt
diff -puN mm/memcontrol.c~memcg-implement-memory-thresholds-checkpatch-fixes mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-implement-memory-thresholds-checkpatch-fixes
+++ a/mm/memcontrol.c
@@ -200,8 +200,8 @@ struct mem_cgroup_threshold_ary {
 	struct mem_cgroup_threshold entries[0];
 };
 
-static bool mem_cgroup_threshold_check(struct mem_cgroup* mem);
-static void mem_cgroup_threshold(struct mem_cgroup* mem);
+static bool mem_cgroup_threshold_check(struct mem_cgroup *mem);
+static void mem_cgroup_threshold(struct mem_cgroup *mem);
 
 /*
  * The memory controller data structure. The memory controller controls both
@@ -3294,11 +3294,10 @@ static void __mem_cgroup_threshold(struc
 	int i;
 
 	rcu_read_lock();
-	if (!swap) {
+	if (!swap)
 		t = rcu_dereference(memcg->thresholds);
-	} else {
+	else
 		t = rcu_dereference(memcg->memsw_thresholds);
-	}
 
 	if (!t)
 		goto unlock;
@@ -3318,9 +3317,8 @@ static void __mem_cgroup_threshold(struc
 	 * If none of thresholds below usage is crossed, we read
 	 * only one element of the array here.
 	 */
-	for(; i > 0 && unlikely(t->entries[i].threshold > usage); i--) {
+	for (; i > 0 && unlikely(t->entries[i].threshold > usage); i--)
 		eventfd_signal(t->entries[i].eventfd, 1);
-	}
 
 	/* i = current_threshold + 1 */
 	i++;
@@ -3331,9 +3329,8 @@ static void __mem_cgroup_threshold(struc
 	 * If none of thresholds above usage is crossed, we read
 	 * only one element of the array here.
 	 */
-	for(; i < t->size && unlikely(t->entries[i].threshold <= usage); i++) {
+	for (; i < t->size && unlikely(t->entries[i].threshold <= usage); i++)
 		eventfd_signal(t->entries[i].eventfd, 1);
-	}
 
 	/* Update current_threshold */
 	atomic_set(&t->current_threshold, i - 1);
@@ -3415,7 +3412,7 @@ static int mem_cgroup_register_event(str
 
 	/* Find current threshold */
 	atomic_set(&thresholds_new->current_threshold, -1);
-	for(i = 0; i < size; i++) {
+	for (i = 0; i < size; i++) {
 		if (thresholds_new->entries[i].threshold < usage) {
 			/*
 			 * thresholds_new->current_threshold will not be used
@@ -3477,7 +3474,7 @@ static int mem_cgroup_unregister_event(s
 	__mem_cgroup_threshold(memcg, type == _MEMSWAP);
 
 	/* Calculate new number of threshold */
-	for(i = 0; i < thresholds->size; i++) {
+	for (i = 0; i < thresholds->size; i++) {
 		if (thresholds->entries[i].eventfd != eventfd)
 			size++;
 	}
@@ -3500,7 +3497,7 @@ static int mem_cgroup_unregister_event(s
 
 	/* Copy thresholds and find current threshold */
 	atomic_set(&thresholds_new->current_threshold, -1);
-	for(i = 0, j = 0; i < thresholds->size; i++) {
+	for (i = 0, j = 0; i < thresholds->size; i++) {
 		if (thresholds->entries[i].eventfd == eventfd)
 			continue;
 
@@ -3525,7 +3522,7 @@ assign:
 	/* To be sure that nobody uses thresholds before freeing it */
 	synchronize_rcu();
 
-	for(i = 0; i < thresholds->size - size; i++)
+	for (i = 0; i < thresholds->size - size; i++)
 		mem_cgroup_put(memcg);
 
 	kfree(thresholds);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch
lib-add-support-for-lzo-compressed-kernels.patch
linux-next.patch
linux-next-fixup.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
hid-logitech-g13-driver-002-fix.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
net-sctp-socketc-squish-warning.patch
3x59x-fix-pci-resource-management.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch
fs-improve-remountro-vs-buffercache-coherency.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
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

