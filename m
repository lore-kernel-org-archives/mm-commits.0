From: akpm@linux-foundation.org
Subject: + make-afs-use-seq_list_xxx-helpers.patch added to -mm tree
Date: Fri, 18 May 2007 10:37:36 -0700
Message-ID: <200705181737.l4IHbavQ019848@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from [207.189.120.14] ([207.189.120.14]:42704 "EHLO
	smtp2.linux-foundation.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754136AbXERRk4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 13:40:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@sw.ru, xemul@openvz.org


The patch titled
     Make AFS use seq_list_xxx helpers
has been added to the -mm tree.  Its filename is
     make-afs-use-seq_list_xxx-helpers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make AFS use seq_list_xxx helpers
From: Pavel Emelianov <xemul@sw.ru>

These proc files show some header before dumping the list, so the
seq_list_start_head() is used.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/proc.c |   81 ++++++------------------------------------------
 1 files changed, 11 insertions(+), 70 deletions(-)

diff -puN fs/afs/proc.c~make-afs-use-seq_list_xxx-helpers fs/afs/proc.c
--- a/fs/afs/proc.c~make-afs-use-seq_list_xxx-helpers
+++ a/fs/afs/proc.c
@@ -200,23 +200,9 @@ static int afs_proc_cells_open(struct in
  */
 static void *afs_proc_cells_start(struct seq_file *m, loff_t *_pos)
 {
-	struct list_head *_p;
-	loff_t pos = *_pos;
-
 	/* lock the list against modification */
 	down_read(&afs_proc_cells_sem);
-
-	/* allow for the header line */
-	if (!pos)
-		return (void *) 1;
-	pos--;
-
-	/* find the n'th element in the list */
-	list_for_each(_p, &afs_proc_cells)
-		if (!pos--)
-			break;
-
-	return _p != &afs_proc_cells ? _p : NULL;
+	return seq_list_start_head(&afs_proc_cells, *_pos);
 }
 
 /*
@@ -224,14 +210,7 @@ static void *afs_proc_cells_start(struct
  */
 static void *afs_proc_cells_next(struct seq_file *p, void *v, loff_t *pos)
 {
-	struct list_head *_p;
-
-	(*pos)++;
-
-	_p = v;
-	_p = v == (void *) 1 ? afs_proc_cells.next : _p->next;
-
-	return _p != &afs_proc_cells ? _p : NULL;
+	return seq_list_next(v, &afs_proc_cells, pos);
 }
 
 /*
@@ -249,7 +228,7 @@ static int afs_proc_cells_show(struct se
 {
 	struct afs_cell *cell = list_entry(v, struct afs_cell, proc_link);
 
-	if (v == (void *) 1) {
+	if (v == &afs_proc_cells) {
 		/* display header on line 1 */
 		seq_puts(m, "USE NAME\n");
 		return 0;
@@ -502,26 +481,13 @@ static int afs_proc_cell_volumes_release
  */
 static void *afs_proc_cell_volumes_start(struct seq_file *m, loff_t *_pos)
 {
-	struct list_head *_p;
 	struct afs_cell *cell = m->private;
-	loff_t pos = *_pos;
 
 	_enter("cell=%p pos=%Ld", cell, *_pos);
 
 	/* lock the list against modification */
 	down_read(&cell->vl_sem);
-
-	/* allow for the header line */
-	if (!pos)
-		return (void *) 1;
-	pos--;
-
-	/* find the n'th element in the list */
-	list_for_each(_p, &cell->vl_list)
-		if (!pos--)
-			break;
-
-	return _p != &cell->vl_list ? _p : NULL;
+	return seq_list_start_head(&cell->vl_list, *_pos);
 }
 
 /*
@@ -530,17 +496,10 @@ static void *afs_proc_cell_volumes_start
 static void *afs_proc_cell_volumes_next(struct seq_file *p, void *v,
 					loff_t *_pos)
 {
-	struct list_head *_p;
 	struct afs_cell *cell = p->private;
 
 	_enter("cell=%p pos=%Ld", cell, *_pos);
-
-	(*_pos)++;
-
-	_p = v;
-	_p = (v == (void *) 1) ? cell->vl_list.next : _p->next;
-
-	return (_p != &cell->vl_list) ? _p : NULL;
+	return seq_list_next(v, &cell->vl_list, _pos);
 }
 
 /*
@@ -568,11 +527,12 @@ const char afs_vlocation_states[][4] = {
  */
 static int afs_proc_cell_volumes_show(struct seq_file *m, void *v)
 {
+	struct afs_cell *cell = m->private;
 	struct afs_vlocation *vlocation =
 		list_entry(v, struct afs_vlocation, link);
 
 	/* display header on line 1 */
-	if (v == (void *) 1) {
+	if (v == &cell->vl_list) {
 		seq_puts(m, "USE STT VLID[0]  VLID[1]  VLID[2]  NAME\n");
 		return 0;
 	}
@@ -733,26 +693,13 @@ static int afs_proc_cell_servers_release
 static void *afs_proc_cell_servers_start(struct seq_file *m, loff_t *_pos)
 	__acquires(m->private->servers_lock)
 {
-	struct list_head *_p;
 	struct afs_cell *cell = m->private;
-	loff_t pos = *_pos;
 
 	_enter("cell=%p pos=%Ld", cell, *_pos);
 
 	/* lock the list against modification */
 	read_lock(&cell->servers_lock);
-
-	/* allow for the header line */
-	if (!pos)
-		return (void *) 1;
-	pos--;
-
-	/* find the n'th element in the list */
-	list_for_each(_p, &cell->servers)
-		if (!pos--)
-			break;
-
-	return _p != &cell->servers ? _p : NULL;
+	return seq_list_start_head(&cell->servers, *_pos);
 }
 
 /*
@@ -761,17 +708,10 @@ static void *afs_proc_cell_servers_start
 static void *afs_proc_cell_servers_next(struct seq_file *p, void *v,
 					loff_t *_pos)
 {
-	struct list_head *_p;
 	struct afs_cell *cell = p->private;
 
 	_enter("cell=%p pos=%Ld", cell, *_pos);
-
-	(*_pos)++;
-
-	_p = v;
-	_p = v == (void *) 1 ? cell->servers.next : _p->next;
-
-	return _p != &cell->servers ? _p : NULL;
+	return seq_list_next(v, &cell->servers, _pos);
 }
 
 /*
@@ -790,11 +730,12 @@ static void afs_proc_cell_servers_stop(s
  */
 static int afs_proc_cell_servers_show(struct seq_file *m, void *v)
 {
+	struct afs_cell *cell = m->private;
 	struct afs_server *server = list_entry(v, struct afs_server, link);
 	char ipaddr[20];
 
 	/* display header on line 1 */
-	if (v == (void *) 1) {
+	if (v == &cell->servers) {
 		seq_puts(m, "USE ADDR            STATE\n");
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
