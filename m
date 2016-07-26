From: akpm@linux-foundation.org
Subject: [patch 018/126] fs/fs-writeback.c: add a new writeback list for
 sync
Date: Tue, 26 Jul 2016 15:21:50 -0700
Message-ID: <5797e27e.AE/xzSNehtNxsRAm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56498 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066AbcGZWVw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:21:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dchinner@redhat.com, bfoster@redhat.com, holger.hoffstaette@applied-asynchrony.com, jack@suse.cz, jbacik@fb.com, viro@ZenIV.linux.org.uk

=46rom: Dave Chinner <dchinner@redhat.com>
Subject: fs/fs-writeback.c: add a new writeback list for sync

wait_sb_inodes() currently does a walk of all inodes in the filesystem =
to
find dirty one to wait on during sync.  This is highly inefficient and
wastes a lot of CPU when there are lots of clean cached inodes that we
don't need to wait on.

To avoid this "all inode" walk, we need to track inodes that are curren=
tly
under writeback that we need to wait for.  We do this by adding inodes =
to
a writeback list on the sb when the mapping is first tagged as having
pages under writeback.  wait_sb_inodes() can then walk this list of
"inodes under IO" and wait specifically just for the inodes that the
current sync(2) needs to wait for.

Define a couple helpers to add/remove an inode from the writeback list =
and
call them when the overall mapping is tagged for or cleared from
writeback.  Update wait_sb_inodes() to walk only the inodes under
writeback due to the sync.

With this change, filesystem sync times are significantly reduced for f=
s'
with largely populated inode caches and otherwise no other work to do.=20
=46or example, on a 16xcpu 2GHz x86-64 server, 10TB XFS filesystem with=
 a
~10m entry inode cache, sync times are reduced from ~7.3s to less than
0.1s when the filesystem is fully clean.

Link: http://lkml.kernel.org/r/1466594593-6757-2-git-send-email-bfoster=
@redhat.com
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Tested-by: Holger Hoffst=E4tte <holger.hoffstaette@applied-asynchrony.c=
om>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c         |  106 +++++++++++++++++++++++++++---------
 fs/inode.c                |    2=20
 fs/super.c                |    2=20
 include/linux/fs.h        |    4 +
 include/linux/writeback.h |    3 +
 mm/page-writeback.c       |   18 ++++++
 6 files changed, 110 insertions(+), 25 deletions(-)

diff -puN fs/fs-writeback.c~sb-add-a-new-writeback-list-for-sync fs/fs-=
writeback.c
--- a/fs/fs-writeback.c~sb-add-a-new-writeback-list-for-sync
+++ a/fs/fs-writeback.c
@@ -981,6 +981,37 @@ void inode_io_list_del(struct inode *ino
 }
=20
 /*
+ * mark an inode as under writeback on the sb
+ */
+void sb_mark_inode_writeback(struct inode *inode)
+{
+	struct super_block *sb =3D inode->i_sb;
+	unsigned long flags;
+
+	if (list_empty(&inode->i_wb_list)) {
+		spin_lock_irqsave(&sb->s_inode_wblist_lock, flags);
+		if (list_empty(&inode->i_wb_list))
+			list_add_tail(&inode->i_wb_list, &sb->s_inodes_wb);
+		spin_unlock_irqrestore(&sb->s_inode_wblist_lock, flags);
+	}
+}
+
+/*
+ * clear an inode as under writeback on the sb
+ */
+void sb_clear_inode_writeback(struct inode *inode)
+{
+	struct super_block *sb =3D inode->i_sb;
+	unsigned long flags;
+
+	if (!list_empty(&inode->i_wb_list)) {
+		spin_lock_irqsave(&sb->s_inode_wblist_lock, flags);
+		list_del_init(&inode->i_wb_list);
+		spin_unlock_irqrestore(&sb->s_inode_wblist_lock, flags);
+	}
+}
+
+/*
  * Redirty an inode: set its when-it-was dirtied timestamp and move it=
 to the
  * furthest end of its superblock's dirty-inode list.
  *
@@ -2154,7 +2185,7 @@ EXPORT_SYMBOL(__mark_inode_dirty);
  */
 static void wait_sb_inodes(struct super_block *sb)
 {
-	struct inode *inode, *old_inode =3D NULL;
+	LIST_HEAD(sync_list);
=20
 	/*
 	 * We need to be protected against the filesystem going from
@@ -2163,38 +2194,60 @@ static void wait_sb_inodes(struct super_
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
=20
 	mutex_lock(&sb->s_sync_lock);
-	spin_lock(&sb->s_inode_list_lock);
=20
 	/*
-	 * Data integrity sync. Must wait for all pages under writeback,
-	 * because there may have been pages dirtied before our sync
-	 * call, but which had writeout started before we write it out.
-	 * In which case, the inode may not be on the dirty list, but
-	 * we still have to wait for that writeout.
+	 * Splice the writeback list onto a temporary list to avoid waiting o=
n
+	 * inodes that have started writeback after this point.
+	 *
+	 * Use rcu_read_lock() to keep the inodes around until we have a
+	 * reference. s_inode_wblist_lock protects sb->s_inodes_wb as well as
+	 * the local list because inodes can be dropped from either by writeb=
ack
+	 * completion.
 	 */
-	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+	rcu_read_lock();
+	spin_lock_irq(&sb->s_inode_wblist_lock);
+	list_splice_init(&sb->s_inodes_wb, &sync_list);
+
+	/*
+	 * Data integrity sync. Must wait for all pages under writeback, beca=
use
+	 * there may have been pages dirtied before our sync call, but which =
had
+	 * writeout started before we write it out.  In which case, the inode
+	 * may not be on the dirty list, but we still have to wait for that
+	 * writeout.
+	 */
+	while (!list_empty(&sync_list)) {
+		struct inode *inode =3D list_first_entry(&sync_list, struct inode,
+						       i_wb_list);
 		struct address_space *mapping =3D inode->i_mapping;
=20
+		/*
+		 * Move each inode back to the wb list before we drop the lock
+		 * to preserve consistency between i_wb_list and the mapping
+		 * writeback tag. Writeback completion is responsible to remove
+		 * the inode from either list once the writeback tag is cleared.
+		 */
+		list_move_tail(&inode->i_wb_list, &sb->s_inodes_wb);
+
+		/*
+		 * The mapping can appear untagged while still on-list since we
+		 * do not have the mapping lock. Skip it here, wb completion
+		 * will remove it.
+		 */
+		if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
+			continue;
+
+		spin_unlock_irq(&sb->s_inode_wblist_lock);
+
 		spin_lock(&inode->i_lock);
-		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
-		    (mapping->nrpages =3D=3D 0)) {
+		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
 			spin_unlock(&inode->i_lock);
+
+			spin_lock_irq(&sb->s_inode_wblist_lock);
 			continue;
 		}
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&sb->s_inode_list_lock);
-
-		/*
-		 * We hold a reference to 'inode' so it couldn't have been
-		 * removed from s_inodes list while we dropped the
-		 * s_inode_list_lock.  We cannot iput the inode now as we can
-		 * be holding the last reference and we cannot iput it under
-		 * s_inode_list_lock. So we keep the reference and iput it
-		 * later.
-		 */
-		iput(old_inode);
-		old_inode =3D inode;
+		rcu_read_unlock();
=20
 		/*
 		 * We keep the error status of individual mapping so that
@@ -2205,10 +2258,13 @@ static void wait_sb_inodes(struct super_
=20
 		cond_resched();
=20
-		spin_lock(&sb->s_inode_list_lock);
+		iput(inode);
+
+		rcu_read_lock();
+		spin_lock_irq(&sb->s_inode_wblist_lock);
 	}
-	spin_unlock(&sb->s_inode_list_lock);
-	iput(old_inode);
+	spin_unlock_irq(&sb->s_inode_wblist_lock);
+	rcu_read_unlock();
 	mutex_unlock(&sb->s_sync_lock);
 }
=20
diff -puN fs/inode.c~sb-add-a-new-writeback-list-for-sync fs/inode.c
--- a/fs/inode.c~sb-add-a-new-writeback-list-for-sync
+++ a/fs/inode.c
@@ -365,6 +365,7 @@ void inode_init_once(struct inode *inode
 	INIT_HLIST_NODE(&inode->i_hash);
 	INIT_LIST_HEAD(&inode->i_devices);
 	INIT_LIST_HEAD(&inode->i_io_list);
+	INIT_LIST_HEAD(&inode->i_wb_list);
 	INIT_LIST_HEAD(&inode->i_lru);
 	address_space_init_once(&inode->i_data);
 	i_size_ordered_init(inode);
@@ -507,6 +508,7 @@ void clear_inode(struct inode *inode)
 	BUG_ON(!list_empty(&inode->i_data.private_list));
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(inode->i_state & I_CLEAR);
+	BUG_ON(!list_empty(&inode->i_wb_list));
 	/* don't need i_lock here, no concurrent mods to i_state */
 	inode->i_state =3D I_FREEING | I_CLEAR;
 }
diff -puN fs/super.c~sb-add-a-new-writeback-list-for-sync fs/super.c
--- a/fs/super.c~sb-add-a-new-writeback-list-for-sync
+++ a/fs/super.c
@@ -206,6 +206,8 @@ static struct super_block *alloc_super(s
 	mutex_init(&s->s_sync_lock);
 	INIT_LIST_HEAD(&s->s_inodes);
 	spin_lock_init(&s->s_inode_list_lock);
+	INIT_LIST_HEAD(&s->s_inodes_wb);
+	spin_lock_init(&s->s_inode_wblist_lock);
=20
 	if (list_lru_init_memcg(&s->s_dentry_lru))
 		goto fail;
diff -puN include/linux/fs.h~sb-add-a-new-writeback-list-for-sync inclu=
de/linux/fs.h
--- a/include/linux/fs.h~sb-add-a-new-writeback-list-for-sync
+++ a/include/linux/fs.h
@@ -665,6 +665,7 @@ struct inode {
 #endif
 	struct list_head	i_lru;		/* inode LRU list */
 	struct list_head	i_sb_list;
+	struct list_head	i_wb_list;	/* backing dev writeback list */
 	union {
 		struct hlist_head	i_dentry;
 		struct rcu_head		i_rcu;
@@ -1448,6 +1449,9 @@ struct super_block {
 	/* s_inode_list_lock protects s_inodes */
 	spinlock_t		s_inode_list_lock ____cacheline_aligned_in_smp;
 	struct list_head	s_inodes;	/* all inodes */
+
+	spinlock_t		s_inode_wblist_lock;
+	struct list_head	s_inodes_wb;	/* writeback inodes */
 };
=20
 extern struct timespec current_fs_time(struct super_block *sb);
diff -puN include/linux/writeback.h~sb-add-a-new-writeback-list-for-syn=
c include/linux/writeback.h
--- a/include/linux/writeback.h~sb-add-a-new-writeback-list-for-sync
+++ a/include/linux/writeback.h
@@ -384,4 +384,7 @@ void tag_pages_for_writeback(struct addr
=20
 void account_page_redirty(struct page *page);
=20
+void sb_mark_inode_writeback(struct inode *inode);
+void sb_clear_inode_writeback(struct inode *inode);
+
 #endif		/* WRITEBACK_H */
diff -puN mm/page-writeback.c~sb-add-a-new-writeback-list-for-sync mm/p=
age-writeback.c
--- a/mm/page-writeback.c~sb-add-a-new-writeback-list-for-sync
+++ a/mm/page-writeback.c
@@ -2747,6 +2747,11 @@ int test_clear_page_writeback(struct pag
 				__wb_writeout_inc(wb);
 			}
 		}
+
+		if (mapping->host && !mapping_tagged(mapping,
+						     PAGECACHE_TAG_WRITEBACK))
+			sb_clear_inode_writeback(mapping->host);
+
 		spin_unlock_irqrestore(&mapping->tree_lock, flags);
 	} else {
 		ret =3D TestClearPageWriteback(page);
@@ -2774,11 +2779,24 @@ int __test_set_page_writeback(struct pag
 		spin_lock_irqsave(&mapping->tree_lock, flags);
 		ret =3D TestSetPageWriteback(page);
 		if (!ret) {
+			bool on_wblist;
+
+			on_wblist =3D mapping_tagged(mapping,
+						   PAGECACHE_TAG_WRITEBACK);
+
 			radix_tree_tag_set(&mapping->page_tree,
 						page_index(page),
 						PAGECACHE_TAG_WRITEBACK);
 			if (bdi_cap_account_writeback(bdi))
 				__inc_wb_stat(inode_to_wb(inode), WB_WRITEBACK);
+
+			/*
+			 * We can come through here when swapping anonymous
+			 * pages, so we don't necessarily have an inode to track
+			 * for sync.
+			 */
+			if (mapping->host && !on_wblist)
+				sb_mark_inode_writeback(mapping->host);
 		}
 		if (!PageDirty(page))
 			radix_tree_tag_clear(&mapping->page_tree,
_
--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
