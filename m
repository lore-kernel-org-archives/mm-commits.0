From: akpm@linux-foundation.org
Subject: - rcu_batches_completed-prototype-cleanup.patch removed from -mm tree
Date: Tue, 08 Apr 2008 11:59:27 -0700
Message-ID: <200804081859.m38IxRTW006986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757827AbYDHTAE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2008 15:00:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, paulmck@us.ibm.com, srostedt@redhat.com, mm-commits@vger.kernel.org


The patch titled
     rcu_batches_completed() prototype cleanup
has been removed from the -mm tree.  Its filename was
     rcu_batches_completed-prototype-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rcu_batches_completed() prototype cleanup
From: Steven Rostedt <rostedt@goodmis.org>

rcu_batches_completed and rcu_patches_completed_bh are both declared in
rcuclassic.h and rcupreempt.h.  This patch removes the extra prototypes for
them from rcupdate.h.

rcu_batches_completed_bh is defined as a static inline in the rcupreempt.h
header file.  Trying to export this as EXPORT_SYMBOL_GPL causes section
problems with the powerpc compiler.  There's no need to export a static
inlined function.

Modules must be compiled with the same type of RCU implementation as the
kernel they are for.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Acked-by: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rcupdate.h |    2 --
 kernel/rcupreempt.c      |    2 --
 2 files changed, 4 deletions(-)

diff -puN include/linux/rcupdate.h~rcu_batches_completed-prototype-cleanup include/linux/rcupdate.h
--- a/include/linux/rcupdate.h~rcu_batches_completed-prototype-cleanup
+++ a/include/linux/rcupdate.h
@@ -256,8 +256,6 @@ extern void call_rcu_bh(struct rcu_head 
 /* Exported common interfaces */
 extern void synchronize_rcu(void);
 extern void rcu_barrier(void);
-extern long rcu_batches_completed(void);
-extern long rcu_batches_completed_bh(void);
 
 /* Internal to kernel */
 extern void rcu_init(void);
diff -puN kernel/rcupreempt.c~rcu_batches_completed-prototype-cleanup kernel/rcupreempt.c
--- a/kernel/rcupreempt.c~rcu_batches_completed-prototype-cleanup
+++ a/kernel/rcupreempt.c
@@ -217,8 +217,6 @@ long rcu_batches_completed(void)
 }
 EXPORT_SYMBOL_GPL(rcu_batches_completed);
 
-EXPORT_SYMBOL_GPL(rcu_batches_completed_bh);
