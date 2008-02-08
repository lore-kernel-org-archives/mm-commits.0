From: akpm@linux-foundation.org
Subject: - preemptible-rcu-sparse-annotations.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:20:45 -0800
Message-ID: <200802082020.m18KKQD8011230@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43937 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934318AbYBHUku (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:40:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kaber@trash.net, dipankar@in.ibm.com, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     preemptible RCU: sparse annotations
has been removed from the -mm tree.  Its filename was
     preemptible-rcu-sparse-annotations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: preemptible RCU: sparse annotations
From: Patrick McHardy <kaber@trash.net>

Signed-off-by: Patrick McHardy <kaber@trash.net>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rcupreempt.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/rcupreempt.h~preemptible-rcu-sparse-annotations include/linux/rcupreempt.h
--- a/include/linux/rcupreempt.h~preemptible-rcu-sparse-annotations
+++ a/include/linux/rcupreempt.h
@@ -46,8 +46,8 @@
 #define rcu_bh_qsctr_inc(cpu)
 #define call_rcu_bh(head, rcu) call_rcu(head, rcu)
 
-extern void __rcu_read_lock(void);
-extern void __rcu_read_unlock(void);
+extern void __rcu_read_lock(void)	__acquires(RCU);
+extern void __rcu_read_unlock(void)	__releases(RCU);
 extern int rcu_pending(int cpu);
 extern int rcu_needs_cpu(int cpu);
 
_

Patches currently in -mm which might be from kaber@trash.net are

origin.patch
