From: akpm@linux-foundation.org
Subject: - netfilter-assign-pde-data-before-gluing-pde-into-proc-tree.patch removed from -mm tree
Date: Fri, 02 May 2008 12:44:00 -0700
Message-ID: <200805021944.m42Ji0mA011337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765875AbYEBToc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:44:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@openvz.org, ebiederm@xmission.com, kaber@trash.net, mm-commits@vger.kernel.org


The patch titled
     netfilter: assign PDE->data before gluing PDE into /proc tree
has been removed from the -mm tree.  Its filename was
     netfilter-assign-pde-data-before-gluing-pde-into-proc-tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: netfilter: assign PDE->data before gluing PDE into /proc tree
From: "Denis V. Lunev" <den@openvz.org>

Simply replace proc_create and further data assigned with proc_create_data.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/netfilter/ipt_CLUSTERIP.c |    6 +++---
 net/netfilter/xt_hashlimit.c       |   12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN net/ipv4/netfilter/ipt_CLUSTERIP.c~netfilter-assign-pde-data-before-gluing-pde-into-proc-tree net/ipv4/netfilter/ipt_CLUSTERIP.c
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c~netfilter-assign-pde-data-before-gluing-pde-into-proc-tree
+++ a/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -169,14 +169,14 @@ clusterip_config_init(const struct ipt_c
 
 		/* create proc dir entry */
 		sprintf(buffer, "%u.%u.%u.%u", NIPQUAD(ip));
-		c->pde = proc_create(buffer, S_IWUSR|S_IRUSR,
-				     clusterip_procdir, &clusterip_proc_fops);
+		c->pde = proc_create_data(buffer, S_IWUSR|S_IRUSR,
+					  clusterip_procdir,
+					  &clusterip_proc_fops, c);
 		if (!c->pde) {
 			kfree(c);
 			return NULL;
 		}
 	}
-	c->pde->data = c;
 #endif
 
 	write_lock_bh(&clusterip_lock);
diff -puN net/netfilter/xt_hashlimit.c~netfilter-assign-pde-data-before-gluing-pde-into-proc-tree net/netfilter/xt_hashlimit.c
--- a/net/netfilter/xt_hashlimit.c~netfilter-assign-pde-data-before-gluing-pde-into-proc-tree
+++ a/net/netfilter/xt_hashlimit.c
@@ -237,15 +237,15 @@ static int htable_create_v0(struct xt_ha
 	hinfo->family = family;
 	hinfo->rnd_initialized = 0;
 	spin_lock_init(&hinfo->lock);
-	hinfo->pde = proc_create(minfo->name, 0,
+	hinfo->pde =
+		proc_create_data(minfo->name, 0,
 				 family == AF_INET ? hashlimit_procdir4 :
 						     hashlimit_procdir6,
-				 &dl_file_ops);
+				 &dl_file_ops, hinfo);
 	if (!hinfo->pde) {
 		vfree(hinfo);
 		return -1;
 	}
-	hinfo->pde->data = hinfo;
 
 	setup_timer(&hinfo->timer, htable_gc, (unsigned long )hinfo);
 	hinfo->timer.expires = jiffies + msecs_to_jiffies(hinfo->cfg.gc_interval);
@@ -301,15 +301,15 @@ static int htable_create(struct xt_hashl
 	hinfo->rnd_initialized = 0;
 	spin_lock_init(&hinfo->lock);
 
-	hinfo->pde = proc_create(minfo->name, 0,
+	hinfo->pde =
+		proc_create_data(minfo->name, 0,
 				 family == AF_INET ? hashlimit_procdir4 :
 						     hashlimit_procdir6,
-				 &dl_file_ops);
+				 &dl_file_ops, hinfo);
 	if (hinfo->pde == NULL) {
 		vfree(hinfo);
 		return -1;
 	}
-	hinfo->pde->data = hinfo;
 
 	setup_timer(&hinfo->timer, htable_gc, (unsigned long)hinfo);
 	hinfo->timer.expires = jiffies + msecs_to_jiffies(hinfo->cfg.gc_interval);
_

Patches currently in -mm which might be from den@openvz.org are

origin.patch
git-net.patch
powerpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

