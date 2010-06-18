From: akpm@linux-foundation.org
Subject: + fs-fcntlc-kill_fasync_rcu-fa_lock-must-be-irq-safe.patch added to -mm tree
Date: Fri, 18 Jun 2010 13:30:11 -0700
Message-ID: <201006182030.o5IKUBdn021729@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745Ab0FRUam (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 16:30:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davem@davemloft.net, eric.dumazet@gmail.com, laijs@cn.fujitsu.com, linux@dominikbrodowski.net, maciej.rutecki@gmail.com, paulmck@linux.vnet.ibm.com, sergey.senozhatsky@gmail.com


The patch titled
     fs/fcntl.c:kill_fasync_rcu() fa_lock must be IRQ-safe
has been added to the -mm tree.  Its filename is
     fs-fcntlc-kill_fasync_rcu-fa_lock-must-be-irq-safe.patch

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
Subject: fs/fcntl.c:kill_fasync_rcu() fa_lock must be IRQ-safe
From: Andrew Morton <akpm@linux-foundation.org>

Fix a lockdep-splat-causing regression introduced by

: commit 989a2979205dd34269382b357e6d4b4b6956b889
: Author:     Eric Dumazet <eric.dumazet@gmail.com>
: AuthorDate: Wed Apr 14 09:55:35 2010 +0000
: Commit:     David S. Miller <davem@davemloft.net>
: CommitDate: Wed Apr 21 16:19:29 2010 -0700
: 
:     fasync: RCU and fine grained locking

kill_fasync() can be called from both process and hard-irq context, so
fa_lock must be taken with IRQs disabled.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=16230

Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reported-by: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fcntl.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/fcntl.c~fs-fcntlc-kill_fasync_rcu-fa_lock-must-be-irq-safe fs/fcntl.c
--- a/fs/fcntl.c~fs-fcntlc-kill_fasync_rcu-fa_lock-must-be-irq-safe
+++ a/fs/fcntl.c
@@ -733,12 +733,14 @@ static void kill_fasync_rcu(struct fasyn
 {
 	while (fa) {
 		struct fown_struct *fown;
+		unsigned long flags;
+
 		if (fa->magic != FASYNC_MAGIC) {
 			printk(KERN_ERR "kill_fasync: bad magic number in "
 			       "fasync_struct!\n");
 			return;
 		}
-		spin_lock(&fa->fa_lock);
+		spin_lock_irqsave(&fa->fa_lock, flags);
 		if (fa->fa_file) {
 			fown = &fa->fa_file->f_owner;
 			/* Don't send SIGURG to processes which have not set a
@@ -747,7 +749,7 @@ static void kill_fasync_rcu(struct fasyn
 			if (!(sig == SIGURG && fown->signum == 0))
 				send_sigio(fown, fa->fa_fd, band);
 		}
-		spin_unlock(&fa->fa_lock);
+		spin_unlock_irqrestore(&fa->fa_lock, flags);
 		fa = rcu_dereference(fa->fa_next);
 	}
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix-fix.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix-fix-fix.patch
fs-fcntlc-kill_fasync_rcu-fa_lock-must-be-irq-safe.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent-fix.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
dib3000mc-reduce-large-stack-usage-fix.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
3x59x-fix-pci-resource-management.patch
altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch
serial-mcf-dont-take-spinlocks-in-already-protected-functions-fix.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mm.patch
tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar.patch
mm-vmap-area-cache-fix.patch
mm-track-the-root-oldest-anon_vma-fix.patch
oom-improve-commentary-in-dump_tasks.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
mmc-recognize-csd-structure-fix.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-fix.patch
fix-vc-vc_origin-on-take_over_console-checkpatch-fixes.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

