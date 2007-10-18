From: akpm@linux-foundation.org
Subject: - immunize-rcu_dereference-against-crazy-compiler-writers.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:52:33 -0700
Message-ID: <200710180652.l9I6qX3x030294@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52452 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932422AbXJRHnv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:43:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmck@linux.vnet.ibm.com, josh@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Immunize rcu_dereference() against crazy compiler writers
has been removed from the -mm tree.  Its filename was
     immunize-rcu_dereference-against-crazy-compiler-writers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Immunize rcu_dereference() against crazy compiler writers
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Turns out that compiler writers are a bit more aggressive about optimizing
than one might expect.  This patch prevents a number of such optimizations
from messing up rcu_deference().  This is not merely a theoretical problem, as
evidenced by the rmb() in mce_log().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: Josh Triplett <josh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rcupdate.h |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN include/linux/rcupdate.h~immunize-rcu_dereference-against-crazy-compiler-writers include/linux/rcupdate.h
--- a/include/linux/rcupdate.h~immunize-rcu_dereference-against-crazy-compiler-writers
+++ a/include/linux/rcupdate.h
@@ -231,6 +231,18 @@ extern struct lockdep_map rcu_lock_map;
 		local_bh_enable(); \
 	} while(0)
 
+/*
+ * Prevent the compiler from merging or refetching accesses.  The compiler
+ * is also forbidden from reordering successive instances of ACCESS_ONCE(),
+ * but only when the compiler is aware of some particular ordering.  One way
+ * to make the compiler aware of ordering is to put the two invocations of
+ * ACCESS_ONCE() in different C statements.
+ *
+ * This macro does absolutely -nothing- to prevent the CPU from reordering,
+ * merging, or refetching absolutely anything at any time.
+ */
+#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
+
 /**
  * rcu_dereference - fetch an RCU-protected pointer in an
  * RCU read-side critical section.  This pointer may later
@@ -242,7 +254,7 @@ extern struct lockdep_map rcu_lock_map;
  */
 
 #define rcu_dereference(p)     ({ \
-				typeof(p) _________p1 = p; \
+				typeof(p) _________p1 = ACCESS_ONCE(p); \
 				smp_read_barrier_depends(); \
 				(_________p1); \
 				})
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

origin.patch
make-access-to-tasks-nsproxy-lighter.patch
make-access-to-tasks-nsproxy-lighterpatch-breaks-unshare.patch
make-access-to-tasks-nsproxy-lighter-update-get_net_ns_by_pid.patch
