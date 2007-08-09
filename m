From: akpm@linux-foundation.org
Subject: + rcu-remove-prototype-for-nonexistent-function.patch added to -mm tree
Date: Thu, 09 Aug 2007 13:24:49 -0700
Message-ID: <200708092024.l79KOn51017819@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47415 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753913AbXHIUZe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 16:25:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: josht@linux.vnet.ibm.com, josh@kernel.org, paulmck@linux.vnet.ibm.com


The patch titled
     RCU: Remove prototype for nonexistent function synchronize_idle()
has been added to the -mm tree.  Its filename is
     rcu-remove-prototype-for-nonexistent-function.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: RCU: Remove prototype for nonexistent function synchronize_idle()
From: Josh Triplett <josht@linux.vnet.ibm.com>

synchronize_idle() sounds like an interesting function, but we don't
actually have it, so don't prototype it.  Introduced in commit
9b06e818985d139fd9e82c28297f7744e1b484e1, in 2005.

Signed-off-by: Josh Triplett <josh@kernel.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rcupdate.h |    1 -
 1 files changed, 1 deletion(-)

diff -puN include/linux/rcupdate.h~rcu-remove-prototype-for-nonexistent-function include/linux/rcupdate.h
--- a/include/linux/rcupdate.h~rcu-remove-prototype-for-nonexistent-function
+++ a/include/linux/rcupdate.h
@@ -281,7 +281,6 @@ extern void FASTCALL(call_rcu(struct rcu
 extern void FASTCALL(call_rcu_bh(struct rcu_head *head,
 				void (*func)(struct rcu_head *head)));
 extern void synchronize_rcu(void);
-void synchronize_idle(void);
 extern void rcu_barrier(void);
 
 #endif /* __KERNEL__ */
_

Patches currently in -mm which might be from josht@linux.vnet.ibm.com are

rcu-remove-prototype-for-nonexistent-function.patch
i386-mark-pit_clockevent-static.patch
