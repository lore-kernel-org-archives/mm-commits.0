From: akpm@linux-foundation.org
Subject: - make-proc-self-mountstats-use-seq_list_xxx-helpers.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:53:49 -0700
Message-ID: <200707162053.l6GKrne8001678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42852 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756125AbXGPVZo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:25:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@sw.ru, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Make /proc/self/mounts(tats) use seq_list_xxx helpers
has been removed from the -mm tree.  Its filename was
     make-proc-self-mountstats-use-seq_list_xxx-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make /proc/self/mounts(tats) use seq_list_xxx helpers
From: Pavel Emelianov <xemul@sw.ru>

One more simple and stupid switching to the new API.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff -puN fs/namespace.c~make-proc-self-mountstats-use-seq_list_xxx-helpers fs/namespace.c
--- a/fs/namespace.c~make-proc-self-mountstats-use-seq_list_xxx-helpers
+++ a/fs/namespace.c
@@ -320,22 +320,16 @@ EXPORT_SYMBOL(mnt_unpin);
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
 	struct mnt_namespace *n = m->private;
-	struct list_head *p;
-	loff_t l = *pos;
 
 	down_read(&namespace_sem);
-	list_for_each(p, &n->list)
-		if (!l--)
-			return list_entry(p, struct vfsmount, mnt_list);
-	return NULL;
+	return seq_list_start(&n->list, *pos);
 }
 
 static void *m_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	struct mnt_namespace *n = m->private;
-	struct list_head *p = ((struct vfsmount *)v)->mnt_list.next;
-	(*pos)++;
-	return p == &n->list ? NULL : list_entry(p, struct vfsmount, mnt_list);
+
+	return seq_list_next(v, &n->list, pos);
 }
 
 static void m_stop(struct seq_file *m, void *v)
@@ -350,7 +344,7 @@ static inline void mangle(struct seq_fil
 
 static int show_vfsmnt(struct seq_file *m, void *v)
 {
-	struct vfsmount *mnt = v;
+	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
 	int err = 0;
 	static struct proc_fs_info {
 		int flag;
@@ -405,7 +399,7 @@ struct seq_operations mounts_op = {
 
 static int show_vfsstat(struct seq_file *m, void *v)
 {
-	struct vfsmount *mnt = v;
+	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
 	int err = 0;
 
 	/* device */
_

Patches currently in -mm which might be from xemul@sw.ru are

origin.patch
make-input-layer-use-seq_list_xxx-helpers.patch
make-isdn-capi-use-seq_list_xxx-helpers.patch
