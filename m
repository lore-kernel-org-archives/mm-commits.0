From: akpm@linux-foundation.org
Subject: [folded] memcg-implement-memory-thresholds-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 10 Mar 2010 14:56:59 -0800
Message-ID: <201003102256.o2AMuxqC008876@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757414Ab0CJW5s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 17:57:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, dan@embeddedalley.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, vb


The patch titled
     memcg-implement-memory-thresholds-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     memcg-implement-memory-thresholds-checkpatch-fixes.patch

This patch was dropped because it was folded into memcg-implement-memory-thresholds.patch

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

diff -puN mm/memcontrol.c~memcg-implement-memory-thresholds-checkpatch-fixes mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-implement-memory-thresholds-checkpatch-fixes
+++ a/mm/memcontrol.c
@@ -201,8 +201,8 @@ struct mem_cgroup_threshold_ary {
 	struct mem_cgroup_threshold entries[0];
 };
 
-static bool mem_cgroup_threshold_check(struct mem_cgroup* mem);
-static void mem_cgroup_threshold(struct mem_cgroup* mem);
+static bool mem_cgroup_threshold_check(struct mem_cgroup *mem);
+static void mem_cgroup_threshold(struct mem_cgroup *mem);
 
 /*
  * The memory controller data structure. The memory controller controls both
@@ -3292,11 +3292,10 @@ static void __mem_cgroup_threshold(struc
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
@@ -3316,9 +3315,8 @@ static void __mem_cgroup_threshold(struc
 	 * If none of thresholds below usage is crossed, we read
 	 * only one element of the array here.
 	 */
-	for(; i > 0 && unlikely(t->entries[i].threshold > usage); i--) {
+	for (; i > 0 && unlikely(t->entries[i].threshold > usage); i--)
 		eventfd_signal(t->entries[i].eventfd, 1);
-	}
 
 	/* i = current_threshold + 1 */
 	i++;
@@ -3329,9 +3327,8 @@ static void __mem_cgroup_threshold(struc
 	 * If none of thresholds above usage is crossed, we read
 	 * only one element of the array here.
 	 */
-	for(; i < t->size && unlikely(t->entries[i].threshold <= usage); i++) {
+	for (; i < t->size && unlikely(t->entries[i].threshold <= usage); i++)
 		eventfd_signal(t->entries[i].eventfd, 1);
-	}
 
 	/* Update current_threshold */
 	atomic_set(&t->current_threshold, i - 1);
@@ -3413,7 +3410,7 @@ static int mem_cgroup_register_event(str
 
 	/* Find current threshold */
 	atomic_set(&thresholds_new->current_threshold, -1);
-	for(i = 0; i < size; i++) {
+	for (i = 0; i < size; i++) {
 		if (thresholds_new->entries[i].threshold < usage) {
 			/*
 			 * thresholds_new->current_threshold will not be used
@@ -3475,7 +3472,7 @@ static int mem_cgroup_unregister_event(s
 	__mem_cgroup_threshold(memcg, type == _MEMSWAP);
 
 	/* Calculate new number of threshold */
-	for(i = 0; i < thresholds->size; i++) {
+	for (i = 0; i < thresholds->size; i++) {
 		if (thresholds->entries[i].eventfd != eventfd)
 			size++;
 	}
@@ -3498,7 +3495,7 @@ static int mem_cgroup_unregister_event(s
 
 	/* Copy thresholds and find current threshold */
 	atomic_set(&thresholds_new->current_threshold, -1);
-	for(i = 0, j = 0; i < thresholds->size; i++) {
+	for (i = 0, j = 0; i < thresholds->size; i++) {
 		if (thresholds->entries[i].eventfd == eventfd)
 			continue;
 
@@ -3523,7 +3520,7 @@ assign:
 	/* To be sure that nobody uses thresholds before freeing it */
 	synchronize_rcu();
 
-	for(i = 0; i < thresholds->size - size; i++)
+	for (i = 0; i < thresholds->size - size; i++)
 		mem_cgroup_put(memcg);
 
 	kfree(thresholds);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

add-generic-sys_ipc-wrapper.patch
broadsheetfb-support-storing-waveform.patch
drivers-char-memc-cleanups.patch
memcg-move-charges-of-anonymous-page.patch
memcg-move-charges-of-anonymous-swap.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
documentation-convert-pci-dma-mappingtxt-to-use-the-generic-dma-api-fix.patch
pps-linuxpps-clients-support-v3-checkpatch-fixes.patch
pps-serial-clients-support-warning-fixes.patch
sysctl-extern-cleanup-binfmts-fix.patch
sysctl-extern-cleanup-module-fix.patch
linux-next.patch
linux-next-fixups.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-i2c-busses-i2c-xiicc-is-borked.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
kernel-schedc-suppress-unused-var-warning.patch
usb-serial-ftdi-add-contec-vendor-and-product-id-fix.patch
drivers-char-tty_bufferc-fix-min-warnings.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
bitops-remove-temporary-for_each_bit.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

