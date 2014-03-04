From: akpm@linux-foundation.org
Subject: + rcu-replace-__this_cpu_ptr-uses-with-raw_cpu_ptr.patch added to -mm tree
Date: Tue, 04 Mar 2014 14:27:31 -0800
Message-ID: <53165353.VxgIofVS005iK0mk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42845 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757723AbaCDW1c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 17:27:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, paulmck@linux.vnet.ibm.com, dipankar@in.ibm.com, cl@linux.com

Subject: + rcu-replace-__this_cpu_ptr-uses-with-raw_cpu_ptr.patch added to -mm tree
To: cl@linux.com,dipankar@in.ibm.com,paulmck@linux.vnet.ibm.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 14:27:31 -0800


The patch titled
     Subject: rcu: replace __this_cpu_ptr uses with raw_cpu_ptr
has been added to the -mm tree.  Its filename is
     rcu-replace-__this_cpu_ptr-uses-with-raw_cpu_ptr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rcu-replace-__this_cpu_ptr-uses-with-raw_cpu_ptr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rcu-replace-__this_cpu_ptr-uses-with-raw_cpu_ptr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: rcu: replace __this_cpu_ptr uses with raw_cpu_ptr

__this_cpu_ptr is being phased out.

One special case is increment_cpu_stall_ticks().  A per cpu variable is
incremented so use raw_cpu_inc().

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcu/tree.c        |    6 +++---
 kernel/rcu/tree_plugin.h |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN kernel/rcu/tree.c~rcu-replace-__this_cpu_ptr-uses-with-raw_cpu_ptr kernel/rcu/tree.c
--- a/kernel/rcu/tree.c~rcu-replace-__this_cpu_ptr-uses-with-raw_cpu_ptr
+++ a/kernel/rcu/tree.c
@@ -1949,7 +1949,7 @@ rcu_send_cbs_to_orphanage(int cpu, struc
 static void rcu_adopt_orphan_cbs(struct rcu_state *rsp, unsigned long flags)
 {
 	int i;
-	struct rcu_data *rdp = __this_cpu_ptr(rsp->rda);
+	struct rcu_data *rdp = raw_cpu_ptr(rsp->rda);
 
 	/* No-CBs CPUs are handled specially. */
 	if (rcu_nocb_adopt_orphan_cbs(rsp, rdp, flags))
@@ -2332,7 +2332,7 @@ static void
 __rcu_process_callbacks(struct rcu_state *rsp)
 {
 	unsigned long flags;
-	struct rcu_data *rdp = __this_cpu_ptr(rsp->rda);
+	struct rcu_data *rdp = raw_cpu_ptr(rsp->rda);
 
 	WARN_ON_ONCE(rdp->beenonline == 0);
 
@@ -2934,7 +2934,7 @@ static void rcu_barrier_callback(struct
 static void rcu_barrier_func(void *type)
 {
 	struct rcu_state *rsp = type;
-	struct rcu_data *rdp = __this_cpu_ptr(rsp->rda);
+	struct rcu_data *rdp = raw_cpu_ptr(rsp->rda);
 
 	_rcu_barrier_trace(rsp, "IRQ", -1, rsp->n_barrier_done);
 	atomic_inc(&rsp->barrier_cpu_count);
diff -puN kernel/rcu/tree_plugin.h~rcu-replace-__this_cpu_ptr-uses-with-raw_cpu_ptr kernel/rcu/tree_plugin.h
--- a/kernel/rcu/tree_plugin.h~rcu-replace-__this_cpu_ptr-uses-with-raw_cpu_ptr
+++ a/kernel/rcu/tree_plugin.h
@@ -1855,7 +1855,7 @@ static void rcu_oom_notify_cpu(void *unu
 	struct rcu_data *rdp;
 
 	for_each_rcu_flavor(rsp) {
-		rdp = __this_cpu_ptr(rsp->rda);
+		rdp = raw_cpu_ptr(rsp->rda);
 		if (rdp->qlen_lazy != 0) {
 			atomic_inc(&oom_callback_count);
 			rsp->call(&rdp->oom_head, rcu_oom_callback);
@@ -1997,7 +1997,7 @@ static void increment_cpu_stall_ticks(vo
 	struct rcu_state *rsp;
 
 	for_each_rcu_flavor(rsp)
-		__this_cpu_ptr(rsp->rda)->ticks_this_gp++;
+		raw_cpu_inc(rsp->rda->ticks_this_gp);
 }
 
 #else /* #ifdef CONFIG_RCU_CPU_STALL_INFO */
_

Patches currently in -mm which might be from cl@linux.com are

mm-close-pagetail-race.patch
mm-page_alloc-make-first_page-visible-before-pagetail.patch
kthread-ensure-locality-of-task_struct-allocations.patch
mm-slab-slub-use-page-list-consistently-instead-of-page-lru.patch
kobject-dont-block-for-each-kobject_uevent.patch
kobject-dont-block-for-each-kobject_uevent-v2.patch
slub-do-not-drop-slab_mutex-for-sysfs_slab_add.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
percpu-add-raw_cpu_ops.patch
mm-use-raw_cpu-ops-for-determining-current-numa-node.patch
modules-use-raw_cpu_write-for-initialization-of-per-cpu-refcount.patch
net-replace-__this_cpu_inc-in-routec-with-raw_cpu_inc.patch
percpu-add-preemption-checks-to-__this_cpu-ops.patch
mm-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch
tracing-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch
percpu-replace-__get_cpu_var-with-this_cpu_ptr.patch
kernel-misc-replace-__get_cpu_var-uses.patch
drivers-char-random-replace-__get_cpu_var-uses.patch
drivers-cpuidle-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-oprofile-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-leds-replace-__get_cpu_var-use-through-this_cpu_ptr.patch
drivers-clocksource-replace-__get_cpu_var-used-for-address-calculation.patch
parisc-replace-__get_cpu_var-uses-for-address-calculation.patch
metag-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-net-ethernet-tile-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-net-ethernet-tile-__get_cpu_var-call-introduced-in-314.patch
tilegx-another-case-of-get_cpu_var.patch
time-replace-__get_cpu_var-uses.patch
scheduler-replace-__get_cpu_var-with-this_cpu_ptr.patch
tick-sched-fix-two-new-uses-of-__get_cpu_ptr.patch
block-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
rcu-replace-__this_cpu_ptr-uses-with-raw_cpu_ptr.patch
watchdog-replace-__raw_get_cpu_var-uses.patch
net-replace-get_cpu_var-through-this_cpu_ptr.patch
md-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
irqchips-replace-__this_cpu_ptr-uses.patch
x86-replace-__get_cpu_var-uses.patch
x86-change-__get_cpu_var-calls-introduced-in-314.patch
uv-replace-__get_cpu_var.patch
arm-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
mips-replace-__get_cpu_var-uses-in-fpu-emulator.patch
mips-replace-__get_cpu_var-uses.patch
s390-rename-__this_cpu_ptr-to-raw_cpu_ptr.patch
s390-replace-__get_cpu_var-uses.patch
s390-handle-new-__get_cpu_var-calls-added-in-314.patch
ia64-replace-__get_cpu_var-uses.patch
powerpc-replace-__get_cpu_var-uses.patch
powerpc-handle-new-__get_cpu_var-calls-in-314.patch
sparc-replace-__get_cpu_var-uses.patch
tile-replace-__get_cpu_var-uses.patch
blackfin-replace-__get_cpu_var-uses.patch
avr32-replace-__get_cpu_var-with-__this_cpu_write.patch
alpha-replace-__get_cpu_var.patch
sh-replace-__get_cpu_var-uses.patch

