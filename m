From: akpm@linux-foundation.org
Subject: - sunrpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch removed from -mm tree
Date: Fri, 02 May 2008 12:43:57 -0700
Message-ID: <200805021943.m42JhvSi011331@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758962AbYEBToq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:44:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@openvz.org, bfields@fieldses.org, davem@davemloft.net, ebiederm@xmission.com, neilb@suse.de, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     sunrpc: assign PDE->data before gluing PDE into /proc tree
has been removed from the -mm tree.  Its filename was
     sunrpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sunrpc: assign PDE->data before gluing PDE into /proc tree
From: "Denis V. Lunev" <den@openvz.org>

Simply replace proc_create and further data assigned with proc_create_data.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/cache.c |   15 ++++++---------
 net/sunrpc/stats.c |    8 +-------
 2 files changed, 7 insertions(+), 16 deletions(-)

diff -puN net/sunrpc/cache.c~sunrpc-assign-pde-data-before-gluing-pde-into-proc-tree net/sunrpc/cache.c
--- a/net/sunrpc/cache.c~sunrpc-assign-pde-data-before-gluing-pde-into-proc-tree
+++ a/net/sunrpc/cache.c
@@ -316,31 +316,28 @@ static int create_cache_proc_entries(str
 	cd->proc_ent->owner = cd->owner;
 	cd->channel_ent = cd->content_ent = NULL;
 
-	p = proc_create("flush", S_IFREG|S_IRUSR|S_IWUSR,
-			cd->proc_ent, &cache_flush_operations);
+	p = proc_create_data("flush", S_IFREG|S_IRUSR|S_IWUSR,
+			     cd->proc_ent, &cache_flush_operations, cd);
 	cd->flush_ent = p;
 	if (p == NULL)
 		goto out_nomem;
 	p->owner = cd->owner;
-	p->data = cd;
 
 	if (cd->cache_request || cd->cache_parse) {
-		p = proc_create("channel", S_IFREG|S_IRUSR|S_IWUSR,
-				cd->proc_ent, &cache_file_operations);
+		p = proc_create_data("channel", S_IFREG|S_IRUSR|S_IWUSR,
+				     cd->proc_ent, &cache_file_operations, cd);
 		cd->channel_ent = p;
 		if (p == NULL)
 			goto out_nomem;
 		p->owner = cd->owner;
-		p->data = cd;
 	}
 	if (cd->cache_show) {
-		p = proc_create("content", S_IFREG|S_IRUSR|S_IWUSR,
-				cd->proc_ent, &content_file_operations);
+		p = proc_create_data("content", S_IFREG|S_IRUSR|S_IWUSR,
+				cd->proc_ent, &content_file_operations, cd);
 		cd->content_ent = p;
 		if (p == NULL)
 			goto out_nomem;
 		p->owner = cd->owner;
-		p->data = cd;
 	}
 	return 0;
 out_nomem:
diff -puN net/sunrpc/stats.c~sunrpc-assign-pde-data-before-gluing-pde-into-proc-tree net/sunrpc/stats.c
--- a/net/sunrpc/stats.c~sunrpc-assign-pde-data-before-gluing-pde-into-proc-tree
+++ a/net/sunrpc/stats.c
@@ -224,16 +224,10 @@ EXPORT_SYMBOL_GPL(rpc_print_iostats);
 static inline struct proc_dir_entry *
 do_register(const char *name, void *data, const struct file_operations *fops)
 {
-	struct proc_dir_entry *ent;
