From: akpm@linux-foundation.org
Subject: + make-proc-self-mountstats-use-seq_list_xxx-helpers.patch added to -mm tree
Date: Fri, 18 May 2007 10:38:04 -0700
Message-ID: <200705181738.l4IHc4lU019890@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from [207.189.120.14] ([207.189.120.14]:51219 "EHLO
	smtp2.linux-foundation.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754478AbXERRla (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 13:41:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@sw.ru, xemul@openvz.org


The patch titled
     Make /proc/self/mounts(tats) use seq_list_xxx helpers
has been added to the -mm tree.  Its filename is
     make-proc-self-mountstats-use-seq_list_xxx-helpers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make /proc/self/mounts(tats) use seq_list_xxx helpers
From: Pavel Emelianov <xemul@sw.ru>

One more simple and stupid switching to the new API.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff -puN fs/namespace.c~make-proc-self-mountstats-use-seq_list_xxx-helpers fs/namespace.c
--- a/fs/namespace.c~make-proc-self-mountstats-use-seq_list_xxx-helpers
+++ a/fs/namespace.c
@@ -393,22 +393,16 @@ EXPORT_SYMBOL(mnt_unpin);
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
@@ -423,7 +417,7 @@ static inline void mangle(struct seq_fil
 
 static int show_vfsmnt(struct seq_file *m, void *v)
 {
-	struct vfsmount *mnt = v;
+	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
 	int err = 0;
 	static struct proc_fs_info {
 		int flag;
@@ -481,7 +475,7 @@ struct seq_operations mounts_op = {
 
 static int show_vfsstat(struct seq_file *m, void *v)
 {
-	struct vfsmount *mnt = v;
+	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
 	int err = 0;
 
 	/* device */
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
