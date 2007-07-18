From: akpm@linux-foundation.org
Subject: + bpqether-fix-rcu-usage.patch added to -mm tree
Date: Tue, 17 Jul 2007 17:44:21 -0700
Message-ID: <200707180044.l6I0iL78016081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39381 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757376AbXGRAod (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 20:44:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, jeff@garzik.org


The patch titled
     bpqether: fix rcu usage
has been added to the -mm tree.  Its filename is
     bpqether-fix-rcu-usage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: bpqether: fix rcu usage
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Awaiting changelog..

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/hamradio/bpqether.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

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
bpqether-fix-rcu-usage.patch
