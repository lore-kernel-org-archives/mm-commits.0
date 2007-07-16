From: akpm@linux-foundation.org
Subject: - make-afs-use-seq_list_xxx-helpers.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:53:36 -0700
Message-ID: <200707162053.l6GKraiF001660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43497 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758177AbXGPV2k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:28:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@sw.ru, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Make AFS use seq_list_xxx helpers
has been removed from the -mm tree.  Its filename was
     make-afs-use-seq_list_xxx-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make AFS use seq_list_xxx helpers
From: Pavel Emelianov <xemul@sw.ru>

These proc files show some header before dumping the list, so the
seq_list_start_head() is used.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/proc.c |   81 ++++++------------------------------------------
 1 file changed, 11 insertions(+), 70 deletions(-)

diff -puN fs/afs/proc.c~make-afs-use-seq_list_xxx-helpers fs/afs/proc.c
--- a/fs/afs/proc.c~make-afs-use-seq_list_xxx-helpers
+++ a/fs/afs/proc.c
@@ -201,23 +201,9 @@ static int afs_proc_cells_open(struct in
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
@@ -225,14 +211,7 @@ static void *afs_proc_cells_start(struct
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
@@ -250,7 +229,7 @@ static int afs_proc_cells_show(struct se
 {
 	struct afs_cell *cell = list_entry(v, struct afs_cell, proc_link);
 
-	if (v == (void *) 1) {
+	if (v == &afs_proc_cells) {
 		/* display header on line 1 */
 		seq_puts(m, "USE NAME\n");
 		return 0;
@@ -503,26 +482,13 @@ static int afs_proc_cell_volumes_release
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
@@ -531,17 +497,10 @@ static void *afs_proc_cell_volumes_start
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
@@ -569,11 +528,12 @@ const char afs_vlocation_states[][4] = {
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
@@ -734,26 +694,13 @@ static int afs_proc_cell_servers_release
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
@@ -762,17 +709,10 @@ static void *afs_proc_cell_servers_start
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
@@ -791,11 +731,12 @@ static void afs_proc_cell_servers_stop(s
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

origin.patch
make-input-layer-use-seq_list_xxx-helpers.patch
make-isdn-capi-use-seq_list_xxx-helpers.patch
