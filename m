From: akpm@linux-foundation.org
Subject: - markers-use-synchronize_sched.patch removed from -mm tree
Date: Fri, 04 Apr 2008 12:00:12 -0700
Message-ID: <200804041900.m34J0CRZ004254@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391AbYDDTAn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2008 15:00:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     markers: use synchronize_sched()
has been removed from the -mm tree.  Its filename was
     markers-use-synchronize_sched.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: markers: use synchronize_sched()
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Markers do not mix well with CONFIG_PREEMPT_RCU because it uses
preempt_disable/enable() and not rcu_read_lock/unlock for minimal
intrusiveness.  We would need call_sched and sched_barrier primitives.

Currently, the modification (connection and disconnection) of probes from
markers requires changes to the data structure done in RCU-style : a new data
structure is created, the pointer is changed atomically, a quiescent state is
reached and then the old data structure is freed.

The quiescent state is reached once all the currently running preempt_disable
regions are done running.  We use the call_rcu mechanism to execute kfree()
after such quiescent state has been reached.  However, the new
CONFIG_PREEMPT_RCU version of call_rcu and rcu_barrier does not guarantee that
all preempt_disable code regions have finished, hence the race.

The "proper" way to do this is to use rcu_read_lock/unlock, but we don't want
to use it to minimize intrusiveness on the traced system.  (we do not want the
marker code to call into much of the OS code, because it would quickly
restrict what can and cannot be instrumented, such as the scheduler).

The temporary fix, until we get call_rcu_sched and rcu_barrier_sched in
mainline, is to use synchronize_sched before each call_rcu calls, so we wait
for the quiescent state in the system call code path.  It will slow down batch
marker enable/disable, but will make sure the race is gone.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/marker.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN kernel/marker.c~markers-use-synchronize_sched kernel/marker.c
--- a/kernel/marker.c~markers-use-synchronize_sched
+++ a/kernel/marker.c
@@ -671,6 +671,9 @@ int marker_probe_register(const char *na
 	entry->rcu_pending = 1;
 	/* write rcu_pending before calling the RCU callback */
 	smp_wmb();
+#ifdef CONFIG_PREEMPT_RCU
+	synchronize_sched();	/* Until we have the call_rcu_sched() */
+#endif
 	call_rcu(&entry->rcu, free_old_closure);
 end:
 	mutex_unlock(&markers_mutex);
@@ -714,6 +717,9 @@ int marker_probe_unregister(const char *
 	entry->rcu_pending = 1;
 	/* write rcu_pending before calling the RCU callback */
 	smp_wmb();
+#ifdef CONFIG_PREEMPT_RCU
+	synchronize_sched();	/* Until we have the call_rcu_sched() */
+#endif
 	call_rcu(&entry->rcu, free_old_closure);
 	remove_marker(name);	/* Ignore busy error message */
 	ret = 0;
@@ -792,6 +798,9 @@ int marker_probe_unregister_private_data
 	entry->rcu_pending = 1;
 	/* write rcu_pending before calling the RCU callback */
 	smp_wmb();
+#ifdef CONFIG_PREEMPT_RCU
+	synchronize_sched();	/* Until we have the call_rcu_sched() */
+#endif
 	call_rcu(&entry->rcu, free_old_closure);
 	remove_marker(entry->name);	/* Ignore busy error message */
 end:
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
make-marker_debug-static.patch

