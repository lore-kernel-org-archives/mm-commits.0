From: akpm@linux-foundation.org
Subject: - remove-rcu_assign_pointer-penalty-for-null-pointers.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:23:38 -0800
Message-ID: <200802070023.m170NJBC006510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47729 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935086AbYBGApl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmck@linux.vnet.ibm.com, herbert@gondor.apana.org.au, mm-commits@vger.kernel.org


The patch titled
     Remove rcu_assign_pointer() penalty for NULL pointers
has been removed from the -mm tree.  Its filename was
     remove-rcu_assign_pointer-penalty-for-null-pointers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove rcu_assign_pointer() penalty for NULL pointers
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The rcu_assign_pointer() primitive currently unconditionally executes a
memory barrier, even when a NULL pointer is being assigned.  This has lead
some to avoid using rcu_assign_pointer() for NULL pointers, which loses the
self-documenting advantages of rcu_assign_pointer() This patch uses
__builtin_const_p() to omit needless memory barriers for NULL-pointer
assignments at compile time with no runtime penalty, as discussed in the
following thread:

	http://www.mail-archive.com/netdev@vger.kernel.org/msg54852.html

Tested on x86_64 and ppc64, also compiled the four cases (NULL/non-NULL
and const/non-const) with gcc version 4.1.2, and hand-checked the
assembly output.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rcupdate.h |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN include/linux/rcupdate.h~remove-rcu_assign_pointer-penalty-for-null-pointers include/linux/rcupdate.h
--- a/include/linux/rcupdate.h~remove-rcu_assign_pointer-penalty-for-null-pointers
+++ a/include/linux/rcupdate.h
@@ -174,10 +174,13 @@ struct rcu_head {
  * code.
  */
 
-#define rcu_assign_pointer(p, v)	({ \
-						smp_wmb(); \
-						(p) = (v); \
-					})
+#define rcu_assign_pointer(p, v) \
+	({ \
+		if (!__builtin_constant_p(v) || \
+		    ((v) != NULL)) \
+			smp_wmb(); \
+		(p) = (v); \
+	})
 
 /**
  * synchronize_sched - block until all CPUs have exited any non-preemptive
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

origin.patch
git-sched.patch
preemptible-rcu-sparse-annotations.patch
