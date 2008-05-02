From: akpm@linux-foundation.org
Subject: - ipv4-assign-pde-data-before-gluing-pde-into-proc-tree.patch removed from -mm tree
Date: Fri, 02 May 2008 12:44:12 -0700
Message-ID: <200805021944.m42JiCas011359@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935048AbYEBTxE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:53:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@openvz.org, davem@davemloft.net, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     ipv4: assign PDE->data before gluing PDE into /proc tree
has been removed from the -mm tree.  Its filename was
     ipv4-assign-pde-data-before-gluing-pde-into-proc-tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipv4: assign PDE->data before gluing PDE into /proc tree
From: "Denis V. Lunev" <den@openvz.org>

The check for PDE->data != NULL becomes useless after the replacement of
proc_net_fops_create with proc_create_data.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/tcp_ipv4.c |   10 +++-------
 net/ipv4/udp.c      |    7 +++----
 2 files changed, 6 insertions(+), 11 deletions(-)

diff -puN net/ipv4/tcp_ipv4.c~ipv4-assign-pde-data-before-gluing-pde-into-proc-tree net/ipv4/tcp_ipv4.c
--- a/net/ipv4/tcp_ipv4.c~ipv4-assign-pde-data-before-gluing-pde-into-proc-tree
+++ a/net/ipv4/tcp_ipv4.c
@@ -2214,9 +2214,6 @@ static int tcp_seq_open(struct inode *in
 	struct tcp_iter_state *s;
 	int err;
 
-	if (unlikely(afinfo == NULL))
-		return -EINVAL;
-
 	err = seq_open_net(inode, file, &afinfo->seq_ops,
 			  sizeof(struct tcp_iter_state));
 	if (err < 0)
@@ -2241,10 +2238,9 @@ int tcp_proc_register(struct net *net, s
 	afinfo->seq_ops.next		= tcp_seq_next;
 	afinfo->seq_ops.stop		= tcp_seq_stop;
 
-	p = proc_net_fops_create(net, afinfo->name, S_IRUGO, &afinfo->seq_fops);
-	if (p)
-		p->data = afinfo;
-	else
+	p = proc_create_data(afinfo->name, S_IRUGO, net->proc_net,
+			     &afinfo->seq_fops, afinfo);
+	if (!p)
 		rc = -ENOMEM;
 	return rc;
 }
diff -puN net/ipv4/udp.c~ipv4-assign-pde-data-before-gluing-pde-into-proc-tree net/ipv4/udp.c
--- a/net/ipv4/udp.c~ipv4-assign-pde-data-before-gluing-pde-into-proc-tree
+++ a/net/ipv4/udp.c
@@ -1605,10 +1605,9 @@ int udp_proc_register(struct net *net, s
 	afinfo->seq_ops.next		= udp_seq_next;
 	afinfo->seq_ops.stop		= udp_seq_stop;
 
-	p = proc_net_fops_create(net, afinfo->name, S_IRUGO, &afinfo->seq_fops);
-	if (p)
-		p->data = afinfo;
-	else
+	p = proc_create_data(afinfo->name, S_IRUGO, net->proc_net,
+			     &afinfo->seq_fops, afinfo);
+	if (!p)
 		rc = -ENOMEM;
 	return rc;
 }
_

Patches currently in -mm which might be from den@openvz.org are

origin.patch
git-net.patch
powerpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

