From: akpm@linux-foundation.org
Subject: [merged] vm-adjust-ifdef-for-tiny_rcu.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:44:32 -0700
Message-ID: <20130430184432.762AB31C2B9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:55788 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760836Ab3D3Sod (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:44:33 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so84510ggc.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:44:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmck@linux.vnet.ibm.com, andi@firstfloor.org, mm-commits@vger.kernel.org


The patch titled
     Subject: vm: adjust ifdef for TINY_RCU
has been removed from the -mm tree.  Its filename was
     vm-adjust-ifdef-for-tiny_rcu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: vm: adjust ifdef for TINY_RCU

There is an ifdef in page_cache_get_speculative() that checks for !SMP and
TREE_RCU, which has been an impossible combination since the advent of
TINY_RCU.  The ifdef enables a fastpath that is valid when preemption is
disabled by rcu_read_lock() in UP systems, which is the case when TINY_RCU
is enabled.  This commit therefore adjusts the ifdef to generate the
fastpath when TINY_RCU is enabled.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reported-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/pagemap.h~vm-adjust-ifdef-for-tiny_rcu include/linux/pagemap.h
--- a/include/linux/pagemap.h~vm-adjust-ifdef-for-tiny_rcu
+++ a/include/linux/pagemap.h
@@ -149,7 +149,7 @@ static inline int page_cache_get_specula
 {
 	VM_BUG_ON(in_interrupt());
 
-#if !defined(CONFIG_SMP) && defined(CONFIG_TREE_RCU)
+#ifdef CONFIG_TINY_RCU
 # ifdef CONFIG_PREEMPT_COUNT
 	VM_BUG_ON(!in_atomic());
 # endif
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

origin.patch
linux-next.patch
ptrace-add-ability-to-retrieve-signals-without-removing-from-a-queue-v4.patch
selftest-add-a-test-case-for-ptrace_peeksiginfo.patch

