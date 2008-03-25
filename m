From: akpm@linux-foundation.org
Subject: - markers-update-preempt_disable-call_rcu-rcu_barrier-comments.patch removed from -mm tree
Date: Tue, 25 Mar 2008 15:29:34 -0700
Message-ID: <200803252229.m2PMTYeq016820@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756604AbYCYWbZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Mar 2008 18:31:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, adrian.bunk@movial.fi, dipankar@in.ibm.com, dsmith@redhat.com, hch@infradead.org, mmlnx@us.ibm.com, paulmck@us.ibm.com, rostedt@goodmis.org, mm-commits@v


The patch titled
     markers: update preempt_disable. call_rcu, rcu_barrier comments
has been removed from the -mm tree.  Its filename was
     markers-update-preempt_disable-call_rcu-rcu_barrier-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: markers: update preempt_disable. call_rcu, rcu_barrier comments
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Add comments requested by Andrew.

Updated comments about synchronize_sched().  Since we use call_rcu and
rcu_barrier now, these comments were out of sync with the code.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Mike Mason <mmlnx@us.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: David Smith <dsmith@redhat.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Adrian Bunk <adrian.bunk@movial.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/marker.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff -puN kernel/marker.c~markers-update-preempt_disable-call_rcu-rcu_barrier-comments kernel/marker.c
--- a/kernel/marker.c~markers-update-preempt_disable-call_rcu-rcu_barrier-comments
+++ a/kernel/marker.c
@@ -104,9 +104,9 @@ void marker_probe_cb(const struct marker
 	char ptype;
 
 	/*
-	 * disabling preemption to make sure the teardown of the callbacks can
-	 * be done correctly when they are in modules and they insure RCU read
-	 * coherency.
+	 * preempt_disable does two things : disabling preemption to make sure
+	 * the teardown of the callbacks can be done correctly when they are in
+	 * modules and they insure RCU read coherency.
 	 */
 	preempt_disable();
 	ptype = ACCESS_ONCE(mdata->ptype);
@@ -551,9 +551,9 @@ static int set_marker(struct marker_entr
 
 /*
  * Disable a marker and its probe callback.
- * Note: only after a synchronize_sched() issued after setting elem->call to the
- * empty function insures that the original callback is not used anymore. This
- * insured by preemption disabling around the call site.
+ * Note: only waiting an RCU period after setting elem->call to the empty
+ * function insures that the original callback is not used anymore. This insured
+ * by preempt_disable around the call site.
  */
 static void disable_marker(struct marker *elem)
 {
@@ -565,8 +565,8 @@ static void disable_marker(struct marker
 	elem->ptype = 0;	/* single probe */
 	/*
 	 * Leave the private data and id there, because removal is racy and
-	 * should be done only after a synchronize_sched(). These are never used
-	 * until the next initialization anyway.
+	 * should be done only after an RCU period. These are never used until
+	 * the next initialization anyway.
 	 */
 }
 
@@ -601,9 +601,6 @@ void marker_update_probe_range(struct ma
 
 /*
  * Update probes, removing the faulty probes.
- * Issues a synchronize_sched() when no reference to the module passed
- * as parameter is found in the probes so the probe module can be
- * safely unloaded from now on.
  *
  * Internal callback only changed before the first probe is connected to it.
  * Single probe private data can only be changed on 0 -> 1 and 2 -> 1
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
make-marker_debug-static.patch

