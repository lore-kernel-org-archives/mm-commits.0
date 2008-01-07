From: akpm@linux-foundation.org
Subject: - nfs-fix-up-problems-with-steves-sillyrename-fix.patch removed from -mm tree
Date: Mon, 07 Jan 2008 13:39:41 -0800
Message-ID: <200801072139.m07LdLk7013559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34742 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754210AbYAGVnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 16:43:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Trond.Myklebust@netapp.com, SteveD@redhat.com, mm-commits@vger.kernel.org


The patch titled
     NFS: Fix up problems with Steve's sillyrename fix
has been removed from the -mm tree.  Its filename was
     nfs-fix-up-problems-with-steves-sillyrename-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: NFS: Fix up problems with Steve's sillyrename fix
From: Trond Myklebust <Trond.Myklebust@netapp.com>

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Steve Dickson <SteveD@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/client.c           |    6 +++---
 fs/nfs/internal.h         |    2 ++
 fs/nfs/super.c            |   33 ++++++++++++++++++++++-----------
 fs/nfs/unlink.c           |    2 ++
 include/linux/nfs_fs_sb.h |   13 +------------
 5 files changed, 30 insertions(+), 26 deletions(-)

diff -puN fs/nfs/client.c~nfs-fix-up-problems-with-steves-sillyrename-fix fs/nfs/client.c
--- a/fs/nfs/client.c~nfs-fix-up-problems-with-steves-sillyrename-fix
+++ a/fs/nfs/client.c
@@ -591,9 +591,6 @@ static int nfs_init_server(struct nfs_se
 	/* Create a client RPC handle for the NFSv3 ACL management interface */
 	nfs_init_server_aclclient(server);
 
-	init_waitqueue_head(&server->active_wq);
-	atomic_set(&server->active, 0);
-
 	dprintk("<-- nfs_init_server() = 0 [new %p]\n", clp);
 	return 0;
 
@@ -733,6 +730,9 @@ static struct nfs_server *nfs_alloc_serv
 	INIT_LIST_HEAD(&server->client_link);
 	INIT_LIST_HEAD(&server->master_link);
 
+	init_waitqueue_head(&server->active_wq);
+	atomic_set(&server->active, 0);
+
 	server->io_stats = nfs_alloc_iostats();
 	if (!server->io_stats) {
 		kfree(server);
diff -puN fs/nfs/internal.h~nfs-fix-up-problems-with-steves-sillyrename-fix fs/nfs/internal.h
--- a/fs/nfs/internal.h~nfs-fix-up-problems-with-steves-sillyrename-fix
+++ a/fs/nfs/internal.h
@@ -160,6 +160,8 @@ extern struct rpc_stat nfs_rpcstat;
 
 extern int __init register_nfs_fs(void);
 extern void __exit unregister_nfs_fs(void);
+extern void nfs_sb_active(struct nfs_server *server);
+extern void nfs_sb_deactive(struct nfs_server *server);
 
 /* namespace.c */
 extern char *nfs_path(const char *base,
diff -puN fs/nfs/super.c~nfs-fix-up-problems-with-steves-sillyrename-fix fs/nfs/super.c
--- a/fs/nfs/super.c~nfs-fix-up-problems-with-steves-sillyrename-fix
+++ a/fs/nfs/super.c
@@ -327,6 +327,28 @@ void __exit unregister_nfs_fs(void)
 	unregister_filesystem(&nfs_fs_type);
 }
 
+void nfs_sb_active(struct nfs_server *server)
+{
+	atomic_inc(&server->active);
+}
+
+void nfs_sb_deactive(struct nfs_server *server)
+{
+	if (atomic_dec_and_test(&server->active))
+		wake_up(&server->active_wq);
+}
+
+static void nfs_put_super(struct super_block *sb)
+{
+	struct nfs_server *server = NFS_SB(sb);
+	/*
+	 * Make sure there are no outstanding ops to this server.
+	 * If so, wait for them to finish before allowing the
+	 * unmount to continue.
+	 */
+	wait_event(server->active_wq, atomic_read(&server->active) == 0);
+}
+
 /*
  * Deliver file system statistics to userspace
  */
@@ -1776,17 +1798,6 @@ static void nfs4_kill_super(struct super
 	nfs_free_server(server);
 }
 
-static void nfs_put_super(struct super_block *sb)
-{
-	struct nfs_server *server = NFS_SB(sb);
-	/*
-	 * Make sure there are no outstanding ops to this server.
-	 * If so, wait for them to finish before allowing the
-	 * unmount to continue.
-	 */
-	wait_event(server->active_wq, atomic_read(&server->active) == 0);
-}
-
 /*
  * Clone an NFS4 server record on xdev traversal (FSID-change)
  */
diff -puN fs/nfs/unlink.c~nfs-fix-up-problems-with-steves-sillyrename-fix fs/nfs/unlink.c
--- a/fs/nfs/unlink.c~nfs-fix-up-problems-with-steves-sillyrename-fix
+++ a/fs/nfs/unlink.c
@@ -14,6 +14,8 @@
 #include <linux/sched.h>
 #include <linux/wait.h>
 
+#include "internal.h"
+
 struct nfs_unlinkdata {
 	struct hlist_node list;
 	struct nfs_removeargs args;
diff -puN include/linux/nfs_fs_sb.h~nfs-fix-up-problems-with-steves-sillyrename-fix include/linux/nfs_fs_sb.h
--- a/include/linux/nfs_fs_sb.h~nfs-fix-up-problems-with-steves-sillyrename-fix
+++ a/include/linux/nfs_fs_sb.h
@@ -3,6 +3,7 @@
 
 #include <linux/list.h>
 #include <linux/backing-dev.h>
+#include <linux/wait.h>
 
 #include <asm/atomic.h>
 
@@ -117,18 +118,6 @@ struct nfs_server {
 	wait_queue_head_t active_wq;  /* Wait for any activity to stop  */
 };
 
-static inline void
-nfs_sb_active(struct nfs_server *server)
-{
-	atomic_inc(&server->active);
-}
-static inline void
-nfs_sb_deactive(struct nfs_server *server)
-{
-	if (atomic_dec_and_test(&server->active))
-		wake_up(&server->active_wq);
-}
-
 /* Server capabilities */
 #define NFS_CAP_READDIRPLUS	(1U << 0)
 #define NFS_CAP_HARDLINKS	(1U << 1)
_

Patches currently in -mm which might be from Trond.Myklebust@netapp.com are

git-nfs.patch
