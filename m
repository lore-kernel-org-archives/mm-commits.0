From: akpm@linux-foundation.org
Subject: - make-nfs-client-use-seq_list_xxx-helpers.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:53:54 -0700
Message-ID: <200707162053.l6GKrssd001688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38705 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759700AbXGPVeC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:34:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@sw.ru, trond.myklebust@fys.uio.no, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Make NFS client use seq_list_xxx helpers
has been removed from the -mm tree.  Its filename was
     make-nfs-client-use-seq_list_xxx-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make NFS client use seq_list_xxx helpers
From: Pavel Emelianov <xemul@sw.ru>

This includes /proc/fs/nfsfs/servers and /proc/fs/nfsfs/volumes entries.

Both need to show the header and use the list_head.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Acked-by: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/client.c |   54 +++++-----------------------------------------
 1 file changed, 6 insertions(+), 48 deletions(-)

diff -puN fs/nfs/client.c~make-nfs-client-use-seq_list_xxx-helpers fs/nfs/client.c
--- a/fs/nfs/client.c~make-nfs-client-use-seq_list_xxx-helpers
+++ a/fs/nfs/client.c
@@ -1206,23 +1206,9 @@ static int nfs_server_list_open(struct i
  */
 static void *nfs_server_list_start(struct seq_file *m, loff_t *_pos)
 {
-	struct list_head *_p;
-	loff_t pos = *_pos;
-
 	/* lock the list against modification */
 	spin_lock(&nfs_client_lock);
-
-	/* allow for the header line */
-	if (!pos)
-		return SEQ_START_TOKEN;
-	pos--;
-
-	/* find the n'th element in the list */
-	list_for_each(_p, &nfs_client_list)
-		if (!pos--)
-			break;
-
-	return _p != &nfs_client_list ? _p : NULL;
+	return seq_list_start_head(&nfs_client_list, *_pos);
 }
 
 /*
@@ -1230,14 +1216,7 @@ static void *nfs_server_list_start(struc
  */
 static void *nfs_server_list_next(struct seq_file *p, void *v, loff_t *pos)
 {
-	struct list_head *_p;
-
-	(*pos)++;
-
-	_p = v;
-	_p = (v == SEQ_START_TOKEN) ? nfs_client_list.next : _p->next;
-
-	return _p != &nfs_client_list ? _p : NULL;
+	return seq_list_next(v, &nfs_client_list, pos);
 }
 
 /*
@@ -1256,7 +1235,7 @@ static int nfs_server_list_show(struct s
 	struct nfs_client *clp;
 
 	/* display header on line 1 */
-	if (v == SEQ_START_TOKEN) {
+	if (v == &nfs_client_list) {
 		seq_puts(m, "NV SERVER   PORT USE HOSTNAME\n");
 		return 0;
 	}
@@ -1297,23 +1276,9 @@ static int nfs_volume_list_open(struct i
  */
 static void *nfs_volume_list_start(struct seq_file *m, loff_t *_pos)
 {
-	struct list_head *_p;
-	loff_t pos = *_pos;
-
 	/* lock the list against modification */
 	spin_lock(&nfs_client_lock);
-
-	/* allow for the header line */
-	if (!pos)
-		return SEQ_START_TOKEN;
-	pos--;
-
-	/* find the n'th element in the list */
-	list_for_each(_p, &nfs_volume_list)
-		if (!pos--)
-			break;
-
-	return _p != &nfs_volume_list ? _p : NULL;
+	return seq_list_start_head(&nfs_volume_list, *_pos);
 }
 
 /*
@@ -1321,14 +1286,7 @@ static void *nfs_volume_list_start(struc
  */
 static void *nfs_volume_list_next(struct seq_file *p, void *v, loff_t *pos)
 {
-	struct list_head *_p;
-
-	(*pos)++;
-
-	_p = v;
-	_p = (v == SEQ_START_TOKEN) ? nfs_volume_list.next : _p->next;
-
-	return _p != &nfs_volume_list ? _p : NULL;
+	return seq_list_next(v, &nfs_volume_list, pos);
 }
 
 /*
@@ -1349,7 +1307,7 @@ static int nfs_volume_list_show(struct s
 	char dev[8], fsid[17];
 
 	/* display header on line 1 */
-	if (v == SEQ_START_TOKEN) {
+	if (v == &nfs_volume_list) {
 		seq_puts(m, "NV SERVER   PORT DEV     FSID\n");
 		return 0;
 	}
_

Patches currently in -mm which might be from xemul@sw.ru are

origin.patch
make-input-layer-use-seq_list_xxx-helpers.patch
make-isdn-capi-use-seq_list_xxx-helpers.patch
