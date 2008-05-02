From: akpm@linux-foundation.org
Subject: - netfilter-assign-pde-data-before-gluing-pde-into-proc-tree-2.patch removed from -mm tree
Date: Fri, 02 May 2008 12:44:16 -0700
Message-ID: <200805021944.m42JiGTh011366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935345AbYEBTxF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:53:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@openvz.org, ebiederm@xmission.com, kaber@trash.net, mm-commits@vger.kernel.org


The patch titled
     netfilter: assign PDE->data before gluing PDE into /proc tree (2)
has been removed from the -mm tree.  Its filename was
     netfilter-assign-pde-data-before-gluing-pde-into-proc-tree-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: netfilter: assign PDE->data before gluing PDE into /proc tree (2)
From: "Denis V. Lunev" <den@openvz.org>

Replace proc_net_fops_create with proc_create_data.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/x_tables.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN net/netfilter/x_tables.c~netfilter-assign-pde-data-before-gluing-pde-into-proc-tree-2 net/netfilter/x_tables.c
--- a/net/netfilter/x_tables.c~netfilter-assign-pde-data-before-gluing-pde-into-proc-tree-2
+++ a/net/netfilter/x_tables.c
@@ -936,25 +936,24 @@ int xt_proto_init(struct net *net, int a
 #ifdef CONFIG_PROC_FS
 	strlcpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_TABLES, sizeof(buf));
-	proc = proc_net_fops_create(net, buf, 0440, &xt_table_ops);
+	proc = proc_create_data(buf, 0440, net->proc_net, &xt_table_ops,
+				(void *)(unsigned long)af);
 	if (!proc)
 		goto out;
-	proc->data = (void *)(unsigned long)af;
-
 
 	strlcpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_MATCHES, sizeof(buf));
-	proc = proc_net_fops_create(net, buf, 0440, &xt_match_ops);
+	proc = proc_create_data(buf, 0440, net->proc_net, &xt_match_ops,
+				(void *)(unsigned long)af);
 	if (!proc)
 		goto out_remove_tables;
-	proc->data = (void *)(unsigned long)af;
 
 	strlcpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_TARGETS, sizeof(buf));
-	proc = proc_net_fops_create(net, buf, 0440, &xt_target_ops);
+	proc = proc_create_data(buf, 0440, net->proc_net, &xt_target_ops,
+				(void *)(unsigned long)af);
 	if (!proc)
 		goto out_remove_matches;
-	proc->data = (void *)(unsigned long)af;
 #endif
 
 	return 0;
_

Patches currently in -mm which might be from den@openvz.org are

origin.patch
git-net.patch
powerpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

