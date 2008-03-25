From: akpm@linux-foundation.org
Subject: - markers-remove-access_once.patch removed from -mm tree
Date: Tue, 25 Mar 2008 15:29:38 -0700
Message-ID: <200803252229.m2PMTcuN016823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754354AbYCYWbV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Mar 2008 18:31:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, adrian.bunk@movial.fi, dipankar@in.ibm.com, dsmith@redhat.com, hch@infradead.org, mmlnx@us.ibm.com, paulmck@us.ibm.com, rostedt@goodmis.org, mm-commits@v


The patch titled
     markers: remove ACCESS_ONCE
has been removed from the -mm tree.  Its filename was
     markers-remove-access_once.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: markers: remove ACCESS_ONCE
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

As Paul pointed out, the ACCESS_ONCE are not needed because we already have
the explicit surrounding memory barriers.

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

 kernel/marker.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN kernel/marker.c~markers-remove-access_once kernel/marker.c
--- a/kernel/marker.c~markers-remove-access_once
+++ a/kernel/marker.c
@@ -109,13 +109,13 @@ void marker_probe_cb(const struct marker
 	 * modules and they insure RCU read coherency.
 	 */
 	preempt_disable();
-	ptype = ACCESS_ONCE(mdata->ptype);
+	ptype = mdata->ptype;
 	if (likely(!ptype)) {
 		marker_probe_func *func;
 		/* Must read the ptype before ptr. They are not data dependant,
 		 * so we put an explicit smp_rmb() here. */
 		smp_rmb();
-		func = ACCESS_ONCE(mdata->single.func);
+		func = mdata->single.func;
 		/* Must read the ptr before private data. They are not data
 		 * dependant, so we put an explicit smp_rmb() here. */
 		smp_rmb();
@@ -133,7 +133,7 @@ void marker_probe_cb(const struct marker
 		 * in the fast path, so put the explicit barrier here.
 		 */
 		smp_read_barrier_depends();
-		multi = ACCESS_ONCE(mdata->multi);
+		multi = mdata->multi;
 		for (i = 0; multi[i].func; i++) {
 			va_start(args, fmt);
 			multi[i].func(multi[i].probe_private, call_private, fmt,
@@ -161,13 +161,13 @@ void marker_probe_cb_noarg(const struct 
 	char ptype;
 
 	preempt_disable();
-	ptype = ACCESS_ONCE(mdata->ptype);
+	ptype = mdata->ptype;
 	if (likely(!ptype)) {
 		marker_probe_func *func;
 		/* Must read the ptype before ptr. They are not data dependant,
 		 * so we put an explicit smp_rmb() here. */
 		smp_rmb();
-		func = ACCESS_ONCE(mdata->single.func);
+		func = mdata->single.func;
 		/* Must read the ptr before private data. They are not data
 		 * dependant, so we put an explicit smp_rmb() here. */
 		smp_rmb();
@@ -183,7 +183,7 @@ void marker_probe_cb_noarg(const struct 
 		 * in the fast path, so put the explicit barrier here.
 		 */
 		smp_read_barrier_depends();
-		multi = ACCESS_ONCE(mdata->multi);
+		multi = mdata->multi;
 		for (i = 0; multi[i].func; i++)
 			multi[i].func(multi[i].probe_private, call_private, fmt,
 				&args);
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
make-marker_debug-static.patch

