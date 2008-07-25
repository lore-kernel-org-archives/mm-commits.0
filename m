From: akpm@linux-foundation.org
Subject: - markers-use-rcu_barrier_sched-and-call_rcu_sched.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:02:37 -0700
Message-ID: <200807252302.m6PN2bTZ003840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753564AbYGYXD3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:03:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mingo@elte.hu, paulmck@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     markers: use rcu_barrier_sched() and call_rcu_sched()
has been removed from the -mm tree.  Its filename was
     markers-use-rcu_barrier_sched-and-call_rcu_sched.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: markers: use rcu_barrier_sched() and call_rcu_sched()
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

rcu_barrier_sched() and call_rcu_sched() were introduced in 2.6.26 for the
Markers.  Change the marker code to use them.

It can be seen as a fix since the marker code was using an ugly,
temporary, #ifdef hack to work around CONFIG_PREEMPT_RCU.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Paul McKenney <paulmck@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/marker.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff -puN kernel/marker.c~markers-use-rcu_barrier_sched-and-call_rcu_sched kernel/marker.c
--- a/kernel/marker.c~markers-use-rcu_barrier_sched-and-call_rcu_sched
+++ a/kernel/marker.c
@@ -441,7 +441,7 @@ static int remove_marker(const char *nam
 	hlist_del(&e->hlist);
 	/* Make sure the call_rcu has been executed */
 	if (e->rcu_pending)
-		rcu_barrier();
+		rcu_barrier_sched();
 	kfree(e);
 	return 0;
 }
@@ -476,7 +476,7 @@ static int marker_set_format(struct mark
 	hlist_del(&(*entry)->hlist);
 	/* Make sure the call_rcu has been executed */
 	if ((*entry)->rcu_pending)
-		rcu_barrier();
+		rcu_barrier_sched();
 	kfree(*entry);
 	*entry = e;
 	trace_mark(core_marker_format, "name %s format %s",
@@ -655,7 +655,7 @@ int marker_probe_register(const char *na
 	 * make sure it's executed now.
 	 */
 	if (entry->rcu_pending)
-		rcu_barrier();
+		rcu_barrier_sched();
 	old = marker_entry_add_probe(entry, probe, probe_private);
 	if (IS_ERR(old)) {
 		ret = PTR_ERR(old);
@@ -670,10 +670,7 @@ int marker_probe_register(const char *na
 	entry->rcu_pending = 1;
 	/* write rcu_pending before calling the RCU callback */
 	smp_wmb();
-#ifdef CONFIG_PREEMPT_RCU
-	synchronize_sched();	/* Until we have the call_rcu_sched() */
-#endif
-	call_rcu(&entry->rcu, free_old_closure);
+	call_rcu_sched(&entry->rcu, free_old_closure);
 end:
 	mutex_unlock(&markers_mutex);
 	return ret;
@@ -704,7 +701,7 @@ int marker_probe_unregister(const char *
 	if (!entry)
 		goto end;
 	if (entry->rcu_pending)
-		rcu_barrier();
+		rcu_barrier_sched();
 	old = marker_entry_remove_probe(entry, probe, probe_private);
 	mutex_unlock(&markers_mutex);
 	marker_update_probes();		/* may update entry */
@@ -716,10 +713,7 @@ int marker_probe_unregister(const char *
 	entry->rcu_pending = 1;
 	/* write rcu_pending before calling the RCU callback */
 	smp_wmb();
-#ifdef CONFIG_PREEMPT_RCU
-	synchronize_sched();	/* Until we have the call_rcu_sched() */
-#endif
-	call_rcu(&entry->rcu, free_old_closure);
+	call_rcu_sched(&entry->rcu, free_old_closure);
 	remove_marker(name);	/* Ignore busy error message */
 	ret = 0;
 end:
@@ -786,7 +780,7 @@ int marker_probe_unregister_private_data
 		goto end;
 	}
 	if (entry->rcu_pending)
-		rcu_barrier();
+		rcu_barrier_sched();
 	old = marker_entry_remove_probe(entry, NULL, probe_private);
 	mutex_unlock(&markers_mutex);
 	marker_update_probes();		/* may update entry */
@@ -797,10 +791,7 @@ int marker_probe_unregister_private_data
 	entry->rcu_pending = 1;
 	/* write rcu_pending before calling the RCU callback */
 	smp_wmb();
-#ifdef CONFIG_PREEMPT_RCU
-	synchronize_sched();	/* Until we have the call_rcu_sched() */
-#endif
-	call_rcu(&entry->rcu, free_old_closure);
+	call_rcu_sched(&entry->rcu, free_old_closure);
 	remove_marker(entry->name);	/* Ignore busy error message */
 end:
 	mutex_unlock(&markers_mutex);
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
linux-next.patch

