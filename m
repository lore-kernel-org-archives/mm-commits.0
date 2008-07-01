From: akpm@linux-foundation.org
Subject: + rcu-classic-update-qlen-when-cpu-offline.patch added to -mm tree
Date: Tue, 01 Jul 2008 15:22:02 -0700
Message-ID: <200807012222.m61MM24p017664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753891AbYGAW2E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 18:28:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, paulmck@linux.vnet.ibm.com


The patch titled
     rcu classic: update qlen when cpu offline
has been added to the -mm tree.  Its filename is
     rcu-classic-update-qlen-when-cpu-offline.patch

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
Subject: rcu classic: update qlen when cpu offline
From: Lai Jiangshan <laijs@cn.fujitsu.com>

When callbacks are moved from offline cpu to this cpu, the qlen field of
this rdp should be updated.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcuclassic.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/rcuclassic.c~rcu-classic-update-qlen-when-cpu-offline kernel/rcuclassic.c
--- a/kernel/rcuclassic.c~rcu-classic-update-qlen-when-cpu-offline
+++ a/kernel/rcuclassic.c
@@ -373,6 +373,10 @@ static void __rcu_offline_cpu(struct rcu
 	rcu_move_batch(this_rdp, rdp->donelist, rdp->donetail);
 	rcu_move_batch(this_rdp, rdp->curlist, rdp->curtail);
 	rcu_move_batch(this_rdp, rdp->nxtlist, rdp->nxttail);
+
+	local_irq_disable();
+	this_rdp->qlen += rdp->qlen;
+	local_irq_enable();
 }
 
 static void rcu_offline_cpu(int cpu)
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

rcu-classic-update-qlen-when-cpu-offline.patch

