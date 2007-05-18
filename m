From: akpm@linux-foundation.org
Subject: + make-nfs-client-use-seq_list_xxx-helpers.patch added to -mm tree
Date: Fri, 18 May 2007 10:37:58 -0700
Message-ID: <200705181737.l4IHbwSC019879@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from [207.189.120.14] ([207.189.120.14]:41116 "EHLO
	smtp2.linux-foundation.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754538AbXERRmF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 13:42:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@sw.ru, trond.myklebust@fys.uio.no, xemul@openvz.org


The patch titled
     Make NFS client use seq_list_xxx helpers
has been added to the -mm tree.  Its filename is
     make-nfs-client-use-seq_list_xxx-helpers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make NFS client use seq_list_xxx helpers
From: Pavel Emelianov <xemul@sw.ru>

This includes /proc/fs/nfsfs/servers and /proc/fs/nfsfs/volumes entries.

Both need to show the header and use the list_head.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/client.c |   54 +++++-----------------------------------------
 1 files changed, 6 insertions(+), 48 deletions(-)

diff -puN fs/nfs/client.c~make-nfs-client-use-seq_list_xxx-helpers fs/nfs/client.c
--- a/fs/nfs/client.c~make-nfs-client-use-seq_list_xxx-helpers
+++ a/fs/nfs/client.c
@@ -1232,23 +1232,9 @@ static int nfs_server_list_open(struct i
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
@@ -1256,14 +1242,7 @@ static void *nfs_server_list_start(struc
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
@@ -1282,7 +1261,7 @@ static int nfs_server_list_show(struct s
 	struct nfs_client *clp;
 
 	/* display header on line 1 */
-	if (v == SEQ_START_TOKEN) {
+	if (v == &nfs_client_list) {
 		seq_puts(m, "NV SERVER   PORT USE HOSTNAME\n");
 		return 0;
 	}
@@ -1323,23 +1302,9 @@ static int nfs_volume_list_open(struct i
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
@@ -1347,14 +1312,7 @@ static void *nfs_volume_list_start(struc
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
@@ -1375,7 +1333,7 @@ static int nfs_volume_list_show(struct s
 	char dev[8], fsid[17];
 
 	/* display header on line 1 */
-	if (v == SEQ_START_TOKEN) {
+	if (v == &nfs_volume_list) {
 		seq_puts(m, "NV SERVER   PORT DEV     FSID\n");
 		return 0;
 	}
_

Patches currently in -mm which might be from xemul@sw.ru are

make-common-helpers-for-seq_files-that-work-with-list_head-s.patch
make-afs-use-seq_list_xxx-helpers.patch
make-atm-driver-use-seq_list_xxx-helpers.patch
make-block-layer-proc-files-use-seq_list_xxx-helpers.patch
make-crypto-api-use-seq_list_xxx-helpers.patch
make-input-layer-use-seq_list_xxx-helpers.patch
make-isdn-capi-use-seq_list_xxx-helpers.patch
make-proc-misc-use-seq_list_xxx-helpers.patch
make-proc-modules-use-seq_list_xxx-helpers.patch
make-some-network-related-proc-files-use-seq_list_xxx.patch
make-some-netfilter-related-proc-files-use-seq_list_xxx.patch
make-nfs-client-use-seq_list_xxx-helpers.patch
make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
make-proc-self-mountstats-use-seq_list_xxx-helpers.patch
