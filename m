From: akpm@linux-foundation.org
Subject: + kprobes-fix-a-memory-leak-in-function-pre_handler_kretprobe-fix.patch added to -mm tree
Date: Tue, 31 Jan 2012 12:52:58 -0800
Message-ID: <20120131213542.082D05C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:44699 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab2AaVfq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2012 16:35:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net, jiang.liu@huawei.com, jkenisto@us.ibm.com, liuj97@gmail.com, masami.hiramatsu.pt@hitachi.com, stable@vger.kernel.org


The patch titled
     Subject: kprobes-fix-a-memory-leak-in-function-pre_handler_kretprobe-fix
has been added to the -mm tree.  Its filename is
     kprobes-fix-a-memory-leak-in-function-pre_handler_kretprobe-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: kprobes-fix-a-memory-leak-in-function-pre_handler_kretprobe-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-memcontrolc-fix-warning-with-config_numa=n.patch
mm-filemap_xipc-fix-race-condition-in-xip_file_fault-fix.patch
kprobes-fix-a-memory-leak-in-function-pre_handler_kretprobe-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
alix2-supplement-driver-to-include-gpio-button-support-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
fs-btrfs-inode-mapc-fix-warnings.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
hpet-factor-timer-allocate-from-open.patch
thermal-thermal_sys-fix-build-warning-fix.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-fix.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-checkpatch-fixes.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

