From: akpm@linux-foundation.org
Subject: + immunize-rcu_dereference-against-crazy-compiler-writers.patch added to -mm tree
Date: Wed, 11 Jul 2007 18:26:45 -0700
Message-ID: <200707120126.l6C1QjTN000883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47578 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758935AbXGLB10 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jul 2007 21:27:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, mingo@elte.hu


The patch titled
     Immunize rcu_dereference() against crazy compiler writers
has been added to the -mm tree.  Its filename is
     immunize-rcu_dereference-against-crazy-compiler-writers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Immunize rcu_dereference() against crazy compiler writers
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Turns out that compiler writers are a bit more aggressive about optimizing
than one might expect.  This patch prevents a number of such optimizations
from messing up rcu_deference().  This is not merely a theoretical problem, as
evidenced by the rmb() in mce_log().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rcupdate.h |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletion(-)

diff -puN include/linux/rcupdate.h~immunize-rcu_dereference-against-crazy-compiler-writers include/linux/rcupdate.h
--- a/include/linux/rcupdate.h~immunize-rcu_dereference-against-crazy-compiler-writers
+++ a/include/linux/rcupdate.h
@@ -217,6 +217,18 @@ extern int rcu_needs_cpu(int cpu);
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
@@ -228,7 +240,7 @@ extern int rcu_needs_cpu(int cpu);
  */
 
 #define rcu_dereference(p)     ({ \
-				typeof(p) _________p1 = p; \
+				typeof(p) _________p1 = ACCESS_ONCE(p); \
 				smp_read_barrier_depends(); \
 				(_________p1); \
 				})
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

document-the-fact-that-rcu-callbacks-can-run-in-parallel.patch
immunize-rcu_dereference-against-crazy-compiler-writers.patch
remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
