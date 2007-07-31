From: akpm@linux-foundation.org
Subject: - bpqether-fix-rcu-usage.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:57:20 -0700
Message-ID: <200707312357.l6VNvKSY029388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45223 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760905AbXHAARD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:17:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmck@linux.vnet.ibm.com, jeff@garzik.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     bpqether: fix rcu usage
has been removed from the -mm tree.  Its filename was
     bpqether-fix-rcu-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: bpqether: fix rcu usage
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The rcu_dereference() primitive needs to be applied to an l-value in order to
ensure that compiler writers don't get an opportunity to apply reordering
optimizations that could result in multiple fetches or in other misbehavior. 
This patch pulls the rcu_dereference() calls in bpq_seq_next() up to the point
at which the fetched pointers are still l-values, rather than after
list_entry() has transformed them into r-values.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/hamradio/bpqether.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/net/hamradio/bpqether.c~bpqether-fix-rcu-usage drivers/net/hamradio/bpqether.c
--- a/drivers/net/hamradio/bpqether.c~bpqether-fix-rcu-usage
+++ a/drivers/net/hamradio/bpqether.c
@@ -413,12 +413,12 @@ static void *bpq_seq_next(struct seq_fil
 	++*pos;
 
 	if (v == SEQ_START_TOKEN)
-		p = bpq_devices.next;
+		p = rcu_dereference(bpq_devices.next);
 	else
-		p = ((struct bpqdev *)v)->bpq_list.next;
+		p = rcu_dereference(((struct bpqdev *)v)->bpq_list.next);
 
 	return (p == &bpq_devices) ? NULL 
-		: rcu_dereference(list_entry(p, struct bpqdev, bpq_list));
+		: list_entry(p, struct bpqdev, bpq_list);
 }
 
 static void bpq_seq_stop(struct seq_file *seq, void *v)
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

origin.patch
fib_trie-cleanup-fix.patch
immunize-rcu_dereference-against-crazy-compiler-writers.patch
remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
clean-up-duplicate-includes-in-kernel.patch
