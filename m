From: akpm@osdl.org
Subject: - rcu-add-a-prefetch-in-rcu_do_batch.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:06:51 -0800
Message-ID: <200612072306.kB7N6pLV030315@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52713 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163924AbWLGXHD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:07:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, paulmck@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     rcu: add a prefetch() in rcu_do_batch()
has been removed from the -mm tree.  Its filename was
     rcu-add-a-prefetch-in-rcu_do_batch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rcu: add a prefetch() in rcu_do_batch()
From: Eric Dumazet <dada1@cosmosbay.com>

On some workloads, (for example when lot of close() syscalls are done), RCU
qlen can be quite large, and RCU heads are no longer in cpu cache when
rcu_do_batch() is called.

This patch adds a prefetch() in rcu_do_batch() to give CPU a hint to bring
back cache lines containing 'struct rcu_head's.

Most list manipulations macros include prefetch(), but not open coded ones
(at least with current C compilers :) )

I got a nice speedup on a trivial benchmark (3.48 us per iteration instead
of 3.95 us on a 1.6 GHz Pentium-M)

while (1) { pipe(p); close(fd[0]); close(fd[1]);}

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/rcupdate.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/rcupdate.c~rcu-add-a-prefetch-in-rcu_do_batch kernel/rcupdate.c
--- a/kernel/rcupdate.c~rcu-add-a-prefetch-in-rcu_do_batch
+++ a/kernel/rcupdate.c
@@ -235,12 +235,14 @@ static void rcu_do_batch(struct rcu_data
 
 	list = rdp->donelist;
 	while (list) {
-		next = rdp->donelist = list->next;
+		next = list->next;
+		prefetch(next);
 		list->func(list);
 		list = next;
 		if (++count >= rdp->blimit)
 			break;
 	}
+	rdp->donelist = list;
 
 	local_irq_disable();
 	rdp->qlen -= count;
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch
convert-i386-pda-code-to-use-%fs.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch

