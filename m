From: akpm@linux-foundation.org
Subject: + vm-adjust-ifdef-for-tiny_rcu.patch added to -mm tree
Date: Tue, 05 Mar 2013 16:04:40 -0800
Message-ID: <20130306000440.6F9E831C1B6@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:41893 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab3CFAEl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 19:04:41 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so805976yhz.3
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 16:04:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, andi@firstfloor.org


The patch titled
     Subject: vm: adjust ifdef for TINY_RCU
has been added to the -mm tree.  Its filename is
     vm-adjust-ifdef-for-tiny_rcu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

revert-parts-of-hlist-drop-the-node-parameter-from-iterators.patch
mkcapflagspl-convert-to-mkcapflagssh.patch
headers_installpl-convert-to-headers_installsh.patch
vm-adjust-ifdef-for-tiny_rcu.patch
procfs-improve-scaling-in-proc.patch
procfs-improve-scaling-in-proc-v5.patch

