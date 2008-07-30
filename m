From: akpm@linux-foundation.org
Subject: - markers-fix-markers-read-barrier-for-multiple-probes.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:14:43 -0700
Message-ID: <200807301914.m6UJEh4e010928@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752264AbYG3T1A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:27:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, paulmck@linux.vnet.ibm.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     markers: fix markers read barrier for multiple probes
has been removed from the -mm tree.  Its filename was
     markers-fix-markers-read-barrier-for-multiple-probes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: markers: fix markers read barrier for multiple probes
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Paul pointed out two incorrect read barriers in the marker handler code in
the path where multiple probes are connected.  Those are ordering reads of
"ptype" (single or multi probe marker), "multi" array pointer, and "multi"
array data access.

It should be ordered like this :

read ptype
smp_rmb()
read multi array pointer
smp_read_barrier_depends()
access data referenced by multi array pointer

The code with a single probe connected (optimized case, does not have to
allocate an array) has correct memory ordering.

It applies to kernel 2.6.26.x, 2.6.25.x and linux-next.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/marker.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN kernel/marker.c~markers-fix-markers-read-barrier-for-multiple-probes kernel/marker.c
--- a/kernel/marker.c~markers-fix-markers-read-barrier-for-multiple-probes
+++ a/kernel/marker.c
@@ -126,6 +126,11 @@ void marker_probe_cb(const struct marker
 		struct marker_probe_closure *multi;
 		int i;
 		/*
+		 * Read mdata->ptype before mdata->multi.
+		 */
+		smp_rmb();
+		multi = mdata->multi;
+		/*
 		 * multi points to an array, therefore accessing the array
 		 * depends on reading multi. However, even in this case,
 		 * we must insure that the pointer is read _before_ the array
@@ -133,7 +138,6 @@ void marker_probe_cb(const struct marker
 		 * in the fast path, so put the explicit barrier here.
 		 */
 		smp_read_barrier_depends();
-		multi = mdata->multi;
 		for (i = 0; multi[i].func; i++) {
 			va_start(args, call_private);
 			multi[i].func(multi[i].probe_private, call_private,
@@ -175,6 +179,11 @@ void marker_probe_cb_noarg(const struct 
 		struct marker_probe_closure *multi;
 		int i;
 		/*
+		 * Read mdata->ptype before mdata->multi.
+		 */
+		smp_rmb();
+		multi = mdata->multi;
+		/*
 		 * multi points to an array, therefore accessing the array
 		 * depends on reading multi. However, even in this case,
 		 * we must insure that the pointer is read _before_ the array
@@ -182,7 +191,6 @@ void marker_probe_cb_noarg(const struct 
 		 * in the fast path, so put the explicit barrier here.
 		 */
 		smp_read_barrier_depends();
-		multi = mdata->multi;
 		for (i = 0; multi[i].func; i++)
 			multi[i].func(multi[i].probe_private, call_private,
 				mdata->format, &args);
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
linux-next.patch

