From: akpm@linux-foundation.org
Subject: + rcupdate-fix-comment.patch added to -mm tree
Date: Mon, 11 Feb 2008 18:47:41 -0800
Message-ID: <200802120248.m1C2mmco014363@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52316 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755441AbYBLCtD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Feb 2008 21:49:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, harvey.harrison@gmail.com


The patch titled
     rcupdate: fix comment
has been added to the -mm tree.  Its filename is
     rcupdate-fix-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
rcupdate-fix-comment.patch
git-sched.patch
