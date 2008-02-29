From: akpm@linux-foundation.org
Subject: - remove-rcu_assign_pointernull-penalty-with-type-macro-safety.patch removed from -mm tree
Date: Fri, 29 Feb 2008 00:57:58 -0800
Message-ID: <200802290907.m1T97HBc014729@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754643AbYB2JHv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 04:07:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmck@linux.vnet.ibm.com, davem@davemloft.net, shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     remove rcu_assign_pointer(NULL) penalty with type/macro safety
has been removed from the -mm tree.  Its filename was
     remove-rcu_assign_pointernull-penalty-with-type-macro-safety.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove rcu_assign_pointer(NULL) penalty with type/macro safety
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This is an updated version of the patch posted last November:

	http://archives.free.net.ph/message/20071201.003721.cd6ff17c.en.html

This new version permits arguments with side effects, for example:

	rcu_assign_pointer(global_p, p++);

and also verifies that the arguments are pointers, while still avoiding the
unnecessary memory barrier when assigning NULL to a pointer.  This
memory-barrier avoidance means that rcu_assign_pointer() is now only
permitted for pointers (not array indexes), and so this version emits a
compiler warning if the first argument is not a pointer.  I built a "make
allyesconfig" version on an x86 system, and received no such warnings.  If
RCU is ever applied to array indexes, then the second patch in this series
should be applied, and the resulting rcu_assign_index() be used.

Given the rather surprising history of subtlely broken implementations of
rcu_assign_pointer(), I took the precaution of generating a full set of
test cases and verified that memory barriers and compiler warnings were
emitted when required.  I guess it is the simple things that get you...

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Stephen Hemminger <shemminger@osdl.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rcupdate.h |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN include/linux/rcupdate.h~remove-rcu_assign_pointernull-penalty-with-type-macro-safety include/linux/rcupdate.h
--- a/include/linux/rcupdate.h~remove-rcu_assign_pointernull-penalty-with-type-macro-safety
+++ a/include/linux/rcupdate.h
@@ -172,14 +172,19 @@ struct rcu_head {
  * structure after the pointer assignment.  More importantly, this
  * call documents which pointers will be dereferenced by RCU read-side
  * code.
+ *
+ * Throws a compiler warning for non-pointer arguments.
+ *
+ * Does not insert a memory barrier for a NULL pointer.
  */
 
-#define rcu_assign_pointer(p, v) \
+#define rcu_assign_pointer(p, v)	\
 	({ \
-		if (!__builtin_constant_p(v) || \
-		    ((v) != NULL)) \
+		typeof(*p) *_________p1 = (v); \
+		\
+		if (!__builtin_constant_p(v) || (_________p1 != NULL)) \
 			smp_wmb(); \
-		(p) = (v); \
+		(p) = _________p1; \
 	})
 
 /**
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

git-sched.patch
kthread-add-a-missing-memory-barrier-to-kthread_stop.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
remove-rcu_assign_pointernull-penalty-with-type-macro-safety.patch
add-rcu_assign_index-if-ever-needed.patch
add-rcu_assign_index-if-ever-needed-fix.patch
rcu-split-listh-and-move-rcu-protected-lists-into-rculisth.patch
lock_task_sighand-add-rcu-lock-unlock.patch
k_getrusage-dont-take-rcu_read_lock.patch
do_task_stat-dont-take-rcu_read_lock.patch

