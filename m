From: akpm@linux-foundation.org
Subject: - rcupdate-fix-comment.patch removed from -mm tree
Date: Thu, 14 Feb 2008 14:15:36 -0500
Message-ID: <200802150218.m1F2ItaP014962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55350 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758228AbYBOCTH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 21:19:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmck@linux.vnet.ibm.com, harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     rcupdate: fix comment
has been removed from the -mm tree.  Its filename was
     rcupdate-fix-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rcupdate: fix comment
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This comment caused some consternation during fastcall removal.  Make it
truthful.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcupdate.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/rcupdate.c~rcupdate-fix-comment kernel/rcupdate.c
--- a/kernel/rcupdate.c~rcupdate-fix-comment
+++ a/kernel/rcupdate.c
@@ -56,7 +56,10 @@ static atomic_t rcu_barrier_cpu_count;
 static DEFINE_MUTEX(rcu_barrier_mutex);
 static struct completion rcu_barrier_completion;
 
-/* Because of FASTCALL declaration of complete, we use this wrapper */
+/*
+ * Awaken the corresponding synchronize_rcu() instance now that a
+ * grace period has elapsed.
+ */
 static void wakeme_after_rcu(struct rcu_head  *head)
 {
 	struct rcu_synchronize *rcu;
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

origin.patch
git-sched.patch
remove-rcu_assign_pointernull-penalty-with-type-macro-safety.patch
add-rcu_assign_index-if-ever-needed.patch
add-rcu_assign_index-if-ever-needed-fix.patch
