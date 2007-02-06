From: akpm@linux-foundation.org
Subject: - rcu-debug-trace-for-rcu-fix.patch removed from -mm tree
Date: Mon, 05 Feb 2007 18:56:33 -0800
Message-ID: <200702060256.l162uXX6008357@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46154 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965165AbXBFC4m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 21:56:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bero@arklinux.org, dipankar@in.ibm.com, paulmck@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Fix compile if PREEMPT_RCU is set, but RCU_TRACE isn't
has been removed from the -mm tree.  Its filename was
     rcu-debug-trace-for-rcu-fix.patch

This patch was dropped because it was folded into rcu-debug-trace-for-rcu.patch

------------------------------------------------------
Subject: Fix compile if PREEMPT_RCU is set, but RCU_TRACE isn't
From: Bernhard Rosenkraenzer <bero@arklinux.org>

2.6.20-rc6-mm1 fails to compile if CONFIG_PREEMPT_RCU is set and
CONFIG_RCU_TRACE isn' -- the fix is fairly obvious.

Signed-off-by: Bernhard Rosenkraenzer <bero@arklinux.org>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Paul McKenney <paulmck@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/rcupreempt.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/rcupreempt.c~rcu-debug-trace-for-rcu-fix kernel/rcupreempt.c
--- a/kernel/rcupreempt.c~rcu-debug-trace-for-rcu-fix
+++ a/kernel/rcupreempt.c
@@ -619,7 +619,7 @@ void synchronize_kernel(void)
 	synchronize_rcu();
 }
 
-#ifdef RCU_TRACE
+#ifdef CONFIG_RCU_TRACE
 int *rcupreempt_flipctr(int cpu)
 {
 	return &per_cpu(rcu_flipctr, cpu)[0];
_

Patches currently in -mm which might be from bero@arklinux.org are

rcu-debug-trace-for-rcu.patch
rcu-debug-trace-for-rcu-fix.patch
rcu-debug-trace-for-rcu-fix-2.patch
