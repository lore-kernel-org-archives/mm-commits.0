From: akpm@linux-foundation.org
Subject: [folded] kprobes-fix-a-memory-leak-in-function-pre_handler_kretprobe-fix.patch removed from -mm tree
Date: Fri, 03 Feb 2012 15:31:04 -0800
Message-ID: <20120203233105.16C0AA01D6@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:40757 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab2BCXbI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2012 18:31:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net, jiang.liu@huawei.com, jkenisto@us.ibm.com, liuj97@gmail.com, masami.hiramatsu.pt@hitachi.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kprobes-fix-a-memory-leak-in-function-pre_handler_kretprobe-fix
has been removed from the -mm tree.  Its filename was
     kprobes-fix-a-memory-leak-in-function-pre_handler_kretprobe-fix.patch

This patch was dropped because it was folded into kprobes-fix-a-memory-leak-in-function-pre_handler_kretprobe.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kprobes-fix-a-memory-leak-in-function-pre_handler_kretprobe-fix

use raw_spin_lock/unlock

kernel/kprobes.c: In function 'pre_handler_kretprobe':
kernel/kprobes.c:1677: warning: passing argument 1 of 'spinlock_check' from incompatible pointer type
include/linux/spinlock.h:272: note: expected 'struct spinlock_t *' but argument is of type 'struct raw_spinlock_t *'
kernel/kprobes.c:1679: warning: passing argument 1 of 'spin_unlock_irqrestore' from incompatible pointer type
include/linux/spinlock.h:338: note: expected 'struct spinlock_t *' but argument is of type 'struct raw_spinlock_t *'

Cc: "David S. Miller" <davem@davemloft.net>
Cc: <stable@vger.kernel.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/kprobes.c~kprobes-fix-a-memory-leak-in-function-pre_handler_kretprobe-fix kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-fix-a-memory-leak-in-function-pre_handler_kretprobe-fix
+++ a/kernel/kprobes.c
@@ -1674,9 +1674,9 @@ static int __kprobes pre_handler_kretpro
 		ri->task = current;
 
 		if (rp->entry_handler && rp->entry_handler(ri, regs)) {
-			spin_lock_irqsave(&rp->lock, flags);
+			raw_spin_lock_irqsave(&rp->lock, flags);
 			hlist_add_head(&ri->hlist, &rp->free_instances);
-			spin_unlock_irqrestore(&rp->lock, flags);
+			raw_spin_unlock_irqrestore(&rp->lock, flags);
 			return 0;
 		}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-memcontrolc-fix-warning-with-config_numa=n.patch
mm-filemap_xipc-fix-race-condition-in-xip_file_fault.patch
kprobes-fix-a-memory-leak-in-function-pre_handler_kretprobe.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
alix2-supplement-driver-to-include-gpio-button-support-fix.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
fs-btrfs-inode-mapc-fix-warnings.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-fix.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
thermal-thermal_sys-fix-build-warning-fix.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-compaction-make-compact_control-order-signed-fix.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

