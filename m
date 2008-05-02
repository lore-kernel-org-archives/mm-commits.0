From: akpm@linux-foundation.org
Subject: - netfilter-assign-pde-fops-before-gluing-pde-into-proc-tree.patch removed from -mm tree
Date: Fri, 02 May 2008 12:44:14 -0700
Message-ID: <200805021944.m42JiENB011362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935418AbYEBTxF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:53:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@openvz.org, ebiederm@xmission.com, kaber@trash.net, mm-commits@vger.kernel.org


The patch titled
     netfilter: assign PDE->fops before gluing PDE into /proc tree
has been removed from the -mm tree.  Its filename was
     netfilter-assign-pde-fops-before-gluing-pde-into-proc-tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: netfilter: assign PDE->fops before gluing PDE into /proc tree
From: "Denis V. Lunev" <den@openvz.org>

Replace create_proc_entry with specially created for this purpose proc_create.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/nf_conntrack_standalone.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN net/netfilter/nf_conntrack_standalone.c~netfilter-assign-pde-fops-before-gluing-pde-into-proc-tree net/netfilter/nf_conntrack_standalone.c
--- a/net/netfilter/nf_conntrack_standalone.c~netfilter-assign-pde-fops-before-gluing-pde-into-proc-tree
+++ a/net/netfilter/nf_conntrack_standalone.c
@@ -296,11 +296,11 @@ static int nf_conntrack_standalone_init_
 	pde = proc_net_fops_create(&init_net, "nf_conntrack", 0440, &ct_file_ops);
 	if (!pde)
 		goto out_nf_conntrack;
-	pde = create_proc_entry("nf_conntrack", S_IRUGO, init_net.proc_net_stat);
+
+	pde = proc_create("nf_conntrack", S_IRUGO, init_net.proc_net_stat,
+			  &ct_cpu_seq_fops);
 	if (!pde)
 		goto out_stat_nf_conntrack;
-	pde->proc_fops = &ct_cpu_seq_fops;
-	pde->owner = THIS_MODULE;
 	return 0;
 
 out_stat_nf_conntrack:
_

Patches currently in -mm which might be from den@openvz.org are

origin.patch
git-net.patch
powerpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

