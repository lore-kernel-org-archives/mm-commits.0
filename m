From: akpm@linux-foundation.org
Subject: - add-rcu_assign_index-if-ever-needed.patch removed from -mm tree
Date: Fri, 02 May 2008 15:44:22 -0700
Message-ID: <200805022244.m42MiMnL018838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934220AbYEBWtm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 18:49:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmck@linux.vnet.ibm.com, ego@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     add rcu_assign_index() if ever needed
has been removed from the -mm tree.  Its filename was
     add-rcu_assign_index-if-ever-needed.patch

This patch was dropped because it isn't needed :)

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: add rcu_assign_index() if ever needed
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This is a speculative patch that as far as I can tell is not yet required. 
If anyone applies RCU to a data structure allocated out of an array, using
array indexes in place of pointers to link the array elements together,
then the rcu_assign_index() function in this patch will be needed to assign
a given element's array index to the RCU-traversed index.  The
implementation is exactly that of the old rcu_assign_pointer(), so is
extremely well tested.

The existing rcu_assign_pointer() will emit a compiler warning in cases
where rcu_assign_index() is required.

[akpm@linux-foundation.org: fix comment typo]
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rcupdate.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN include/linux/rcupdate.h~add-rcu_assign_index-if-ever-needed include/linux/rcupdate.h
--- a/include/linux/rcupdate.h~add-rcu_assign_index-if-ever-needed
+++ a/include/linux/rcupdate.h
@@ -203,6 +203,24 @@ void name(void) \
 }
 
 /**
+ * rcu_assign_index - assign (publicize) a index of a newly
+ * initialized array element that will be dereferenced by RCU
+ * read-side critical sections.  Returns the value assigned.
+ *
+ * Inserts memory barriers on architectures that require them
+ * (pretty much all of them other than x86), and also prevents
+ * the compiler from reordering the code that initializes the
+ * structure after the index assignment.  More importantly, this
+ * call documents which indexes will be dereferenced by RCU read-side
+ * code.
+ */
+
+#define rcu_assign_index(p, v)	({ \
+					smp_wmb(); \
+					(p) = (v); \
+				})
+
+/**
  * synchronize_sched - block until all CPUs have exited any non-preemptive
  * kernel code sequences.
  *
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

origin.patch
linux-next.patch
add-rcu_assign_index-if-ever-needed.patch
add-warn_on_secs-macro.patch
use-warn_on_secs-in-rcupreempth.patch

