From: akpm@linux-foundation.org
Subject: - net-assign-pde-data-before-gluing-pde-into-proc-tree.patch removed from -mm tree
Date: Fri, 02 May 2008 12:44:02 -0700
Message-ID: <200805021944.m42Ji2sb011346@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49749 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933080AbYEBTof (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:44:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@openvz.org, davem@davemloft.net, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     net: assign PDE->data before gluing PDE into /proc tree
has been removed from the -mm tree.  Its filename was
     net-assign-pde-data-before-gluing-pde-into-proc-tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net: assign PDE->data before gluing PDE into /proc tree
From: "Denis V. Lunev" <den@openvz.org>

Simply replace proc_create and further data assigned with proc_create_data. 
Additionally, there is no need to assign NULL to PDE->data after creation,
/proc generic has already done this for us.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/neighbour.c |    5 ++---
 net/core/pktgen.c    |   12 ++++--------
 2 files changed, 6 insertions(+), 11 deletions(-)

diff -puN net/core/neighbour.c~net-assign-pde-data-before-gluing-pde-into-proc-tree net/core/neighbour.c
--- a/net/core/neighbour.c~net-assign-pde-data-before-gluing-pde-into-proc-tree
+++ a/net/core/neighbour.c
@@ -1430,11 +1430,10 @@ void neigh_table_init_no_netlink(struct 
 		panic("cannot create neighbour cache statistics");
 
 #ifdef CONFIG_PROC_FS
-	tbl->pde = proc_create(tbl->id, 0, init_net.proc_net_stat,
-			       &neigh_stat_seq_fops);
+	tbl->pde = proc_create_data(tbl->id, 0, init_net.proc_net_stat,
+				    &neigh_stat_seq_fops, tbl);
 	if (!tbl->pde)
 		panic("cannot create neighbour proc dir entry");
-	tbl->pde->data = tbl;
 #endif
 
 	tbl->hash_mask = 1;
diff -puN net/core/pktgen.c~net-assign-pde-data-before-gluing-pde-into-proc-tree net/core/pktgen.c
--- a/net/core/pktgen.c~net-assign-pde-data-before-gluing-pde-into-proc-tree
+++ a/net/core/pktgen.c
@@ -3570,15 +3570,14 @@ static int pktgen_add_device(struct pktg
 	if (err)
 		goto out1;
 
-	pkt_dev->entry = proc_create(ifname, 0600,
-				     pg_proc_dir, &pktgen_if_fops);
+	pkt_dev->entry = proc_create_data(ifname, 0600, pg_proc_dir,
+					  &pktgen_if_fops, pkt_dev);
 	if (!pkt_dev->entry) {
 		printk(KERN_ERR "pktgen: cannot create %s/%s procfs entry.\n",
 		       PG_PROC_DIR, ifname);
 		err = -EINVAL;
 		goto out2;
 	}
-	pkt_dev->entry->data = pkt_dev;
 #ifdef CONFIG_XFRM
 	pkt_dev->ipsmode = XFRM_MODE_TRANSPORT;
 	pkt_dev->ipsproto = IPPROTO_ESP;
@@ -3628,7 +3627,8 @@ static int __init pktgen_create_thread(i
 	kthread_bind(p, cpu);
 	t->tsk = p;
 
-	pe = proc_create(t->tsk->comm, 0600, pg_proc_dir, &pktgen_thread_fops);
+	pe = proc_create_data(t->tsk->comm, 0600, pg_proc_dir,
+			      &pktgen_thread_fops, t);
 	if (!pe) {
 		printk(KERN_ERR "pktgen: cannot create %s/%s procfs entry.\n",
 		       PG_PROC_DIR, t->tsk->comm);
@@ -3638,8 +3638,6 @@ static int __init pktgen_create_thread(i
 		return -EINVAL;
 	}
 
-	pe->data = t;
-
 	wake_up_process(p);
 
 	return 0;
@@ -3716,8 +3714,6 @@ static int __init pg_init(void)
 		return -EINVAL;
 	}
 
-	pe->data = NULL;
