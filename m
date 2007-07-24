From: akpm@linux-foundation.org
Subject: - random-warning-squishes.patch removed from -mm tree
Date: Tue, 24 Jul 2007 16:24:12 -0700
Message-ID: <200707242324.l6ONOCpg006255@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36149 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755047AbXGXXYX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 19:24:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     random warning squishes
has been removed from the -mm tree.  Its filename was
     random-warning-squishes.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: random warning squishes
From: Ingo Molnar <mingo@elte.hu>

grumble.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/namei.c            |    2 +-
 kernel/audit.c              |    2 +-
 net/core/flow.c             |    2 +-
 net/sunrpc/svc.c            |    2 +-
 sound/core/control_compat.c |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/isofs/namei.c~random-warning-squishes fs/isofs/namei.c
--- a/fs/isofs/namei.c~random-warning-squishes
+++ a/fs/isofs/namei.c
@@ -158,7 +158,7 @@ isofs_find_entry(struct inode *dir, stru
 struct dentry *isofs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 {
 	int found;
-	unsigned long block, offset;
+	unsigned long block = 0, offset = 0 /* avoid stupid gcc warning */;
 	struct inode *inode;
 	struct page *page;
 
diff -puN fs/jffs2/erase.c~random-warning-squishes fs/jffs2/erase.c
diff -puN kernel/audit.c~random-warning-squishes kernel/audit.c
--- a/kernel/audit.c~random-warning-squishes
+++ a/kernel/audit.c
@@ -1133,7 +1133,7 @@ struct audit_buffer *audit_log_start(str
 {
 	struct audit_buffer	*ab	= NULL;
 	struct timespec		t;
-	unsigned int		serial;
+	unsigned int		serial = 0 /* shut up gcc */;
 	int reserve;
 	unsigned long timeout_start = jiffies;
 
diff -puN net/core/flow.c~random-warning-squishes net/core/flow.c
--- a/net/core/flow.c~random-warning-squishes
+++ a/net/core/flow.c
@@ -172,7 +172,7 @@ static int flow_key_compare(struct flowi
 void *flow_cache_lookup(struct flowi *key, u16 family, u8 dir,
 			flow_resolve_t resolver)
 {
-	struct flow_cache_entry *fle, **head;
+	struct flow_cache_entry *fle, **head = NULL /* shut up GCC */;
 	unsigned int hash;
 	int cpu;
 
diff -puN net/sunrpc/svc.c~random-warning-squishes net/sunrpc/svc.c
--- a/net/sunrpc/svc.c~random-warning-squishes
+++ a/net/sunrpc/svc.c
@@ -547,7 +547,7 @@ __svc_create_thread(svc_thread_fn func, 
 	struct svc_rqst	*rqstp;
 	int		error = -ENOMEM;
 	int		have_oldmask = 0;
-	cpumask_t	oldmask;
+	cpumask_t	oldmask = CPU_MASK_NONE /* shut up GCC */;
 
 	rqstp = kzalloc(sizeof(*rqstp), GFP_KERNEL);
 	if (!rqstp)
diff -puN sound/core/control_compat.c~random-warning-squishes sound/core/control_compat.c
--- a/sound/core/control_compat.c~random-warning-squishes
+++ a/sound/core/control_compat.c
@@ -219,7 +219,7 @@ static int copy_ctl_value_from_user(stru
 				    struct snd_ctl_elem_value32 __user *data32,
 				    int *typep, int *countp)
 {
-	int i, type, count, size;
+	int i, type, count = 0 /* shut up gcc warning */, size;
 	unsigned int indirect;
 
 	if (copy_from_user(&data->id, &data32->id, sizeof(data->id)))
_

Patches currently in -mm which might be from mingo@elte.hu are

git-acpi.patch
git-kvm.patch
fix-theoretical-ccids_readwrite_lock-race.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
geode-mfgpt-clock-event-device-support.patch
i386-remove-unnecessary-code.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
immunize-rcu_dereference-against-crazy-compiler-writers.patch
remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch
fix-the-softlockup-watchdog-to-actually-work.patch
softlockup-make-asm-irq_regsh-available-on-every-platform.patch
softlockup-improve-debug-output.patch
softlockup-watchdog-style-cleanups.patch
softlockup-add-a-proc-tuning-parameter.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
futex-pass-nr_wake2-to-futex_wake_op.patch
mark-sysrq_sched_debug_show-static.patch
cfs-mark-print_cfs_stats-static.patch
remove-kconfig-setting-config_debug_shirq.patch
debug-handling-of-early-spurious-interrupts.patch
time-simplify-smp_call_function_single-call-sequence.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
random-warning-squishes.patch
