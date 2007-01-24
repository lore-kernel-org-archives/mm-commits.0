From: akpm@osdl.org
Subject: + rcu-trivial-fixes.patch added to -mm tree
Date: Tue, 23 Jan 2007 16:38:55 -0800
Message-ID: <200701240038.l0O0ctrX003962@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44700 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965462AbXAXAjA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 19:39:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dipankar@in.ibm.com, paulmck@in.ibm.com


The patch titled
     rcu: trivial fixes
has been added to the -mm tree.  Its filename is
     rcu-trivial-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rcu: trivial fixes
From: Dipankar Sarma <dipankar@in.ibm.com>

Fix a few trivial things based on review comments.

Signed-off-by: Dipankar Sarma <dipankar@in.ibm.com>

Acked-by: Paul E. McKenney <paulmck@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/rcupreempt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/rcupreempt.c~rcu-trivial-fixes kernel/rcupreempt.c
--- a/kernel/rcupreempt.c~rcu-trivial-fixes
+++ a/kernel/rcupreempt.c
@@ -156,7 +156,7 @@ void __rcu_read_lock(void)
 		local_irq_save(oldirq);
 
 		/*
-		 * Outermost nesting of rcu_read_lock(), so atomically
+		 * Outermost nesting of rcu_read_lock(), so
 		 * increment the current counter for the current CPU.
 		 */
 		idx = rcu_ctrlblk.completed & 0x1;
@@ -169,7 +169,7 @@ void __rcu_read_lock(void)
 		 * Now that the per-CPU counter has been incremented, we
 		 * are protected.  We can therefore safely increment
 		 * the nesting counter, relieving further NMIs of the
-		 * need to do so.
+		 * need to increment the per-CPU counter.
 		 */
 		current->rcu_read_lock_nesting = nesting + 1;
 		barrier();
_

Patches currently in -mm which might be from dipankar@in.ibm.com are

rcu-split-classic-rcu.patch
rcu-softirq-for-rcu.patch
rcu-fix-barriers.patch
rcu-preemptible-rcu.patch
rcu-debug-trace-for-rcu.patch
rcu-trivial-fixes.patch
