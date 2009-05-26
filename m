From: akpm@linux-foundation.org
Subject: [wrecked] fsnotify-handle-filesystem-unmounts-with-fsnotify-marks.patch removed from -mm tree
Date: Tue, 26 May 2009 12:34:43 -0700
Message-ID: <200905261934.n4QJYhxO005757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757250AbZEZTgD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 15:36:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eparis@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fsnotify: handle filesystem unmounts with fsnotify marks
has been removed from the -mm tree.  Its filename was
     fsnotify-handle-filesystem-unmounts-with-fsnotify-marks.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fsnotify: handle filesystem unmounts with fsnotify marks
From: Eric Paris <eparis@redhat.com>

When an fs is unmounted with an fsnotify mark entry attached to one of its
inodes we need to destroy that mark entry and we also (like inotify) send
an unmount event.

Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c                       |    1 
 fs/notify/inode_mark.c           |   72 +++++++++++++++++++++++++++++
 include/linux/fsnotify_backend.h |    4 +
 3 files changed, 77 insertions(+)

diff -puN fs/inode.c~fsnotify-handle-filesystem-unmounts-with-fsnotify-marks fs/inode.c
--- a/fs/inode.c~fsnotify-handle-filesystem-unmounts-with-fsnotify-marks
+++ a/fs/inode.c
@@ -408,6 +408,7 @@ int invalidate_inodes(struct super_block
 	mutex_lock(&iprune_mutex);
 	spin_lock(&inode_lock);
 	inotify_unmount_inodes(&sb->s_inodes);
+	fsnotify_unmount_inodes(&sb->s_inodes);
 	busy = invalidate_list(&sb->s_inodes, &throw_away);
 	spin_unlock(&inode_lock);
 
diff -puN fs/notify/inode_mark.c~fsnotify-handle-filesystem-unmounts-with-fsnotify-marks fs/notify/inode_mark.c
--- a/fs/notify/inode_mark.c~fsnotify-handle-filesystem-unmounts-with-fsnotify-marks
+++ a/fs/notify/inode_mark.c
@@ -89,6 +89,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/writeback.h> /* for inode_lock */
 
 #include <asm/atomic.h>
 
@@ -351,3 +352,74 @@ int fsnotify_add_mark(struct fsnotify_ma
 
 	return ret;
 }
+
+/**
+ * fsnotify_unmount_inodes - an sb is unmounting.  handle any watched inodes.
+ * @list: list of inodes being unmounted (sb->s_inodes)
+ *
+ * Called with inode_lock held, protecting the unmounting super block's list
+ * of inodes, and with iprune_mutex held, keeping shrink_icache_memory() at bay.
+ * We temporarily drop inode_lock, however, and CAN block.
+ */
+void fsnotify_unmount_inodes(struct list_head *list)
+{
+	struct inode *inode, *next_i, *need_iput = NULL;
+
+	list_for_each_entry_safe(inode, next_i, list, i_sb_list) {
+		struct inode *need_iput_tmp;
+
+		/*
+		 * We cannot __iget() an inode in state I_CLEAR, I_FREEING,
+		 * I_WILL_FREE, or I_NEW which is fine because by that point
+		 * the inode cannot have any associated watches.
+		 */
+		if (inode->i_state & (I_CLEAR|I_FREEING|I_WILL_FREE|I_NEW))
+			continue;
+
+		/*
+		 * If i_count is zero, the inode cannot have any watches and
+		 * doing an __iget/iput with MS_ACTIVE clear would actually
+		 * evict all inodes with zero i_count from icache which is
+		 * unnecessarily violent and may in fact be illegal to do.
+		 */
+		if (!atomic_read(&inode->i_count))
+			continue;
+
+		need_iput_tmp = need_iput;
+		need_iput = NULL;
+
+		/* In case fsnotify_inode_delete() drops a reference. */
+		if (inode != need_iput_tmp)
+			__iget(inode);
+		else
+			need_iput_tmp = NULL;
+
+		/* In case the dropping of a reference would nuke next_i. */
+		if ((&next_i->i_sb_list != list) &&
+		    atomic_read(&next_i->i_count) &&
+		    !(next_i->i_state & (I_CLEAR | I_FREEING | I_WILL_FREE))) {
+			__iget(next_i);
+			need_iput = next_i;
+		}
+
+		/*
+		 * We can safely drop inode_lock here because we hold
+		 * references on both inode and next_i.  Also no new inodes
+		 * will be added since the umount has begun.  Finally,
+		 * iprune_mutex keeps shrink_icache_memory() away.
+		 */
+		spin_unlock(&inode_lock);
+
+		if (need_iput_tmp)
+			iput(need_iput_tmp);
+
+		/* for each watch, send FS_UNMOUNT and then remove it */
+		fsnotify(inode, FS_UNMOUNT, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
+
+		fsnotify_inode_delete(inode);
+
+		iput(inode);
+
+		spin_lock(&inode_lock);
+	}
+}
diff -puN include/linux/fsnotify_backend.h~fsnotify-handle-filesystem-unmounts-with-fsnotify-marks include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~fsnotify-handle-filesystem-unmounts-with-fsnotify-marks
+++ a/include/linux/fsnotify_backend.h
@@ -337,6 +337,7 @@ extern void fsnotify_destroy_mark_by_ent
 extern void fsnotify_clear_marks_by_group(struct fsnotify_group *group);
 extern void fsnotify_get_mark(struct fsnotify_mark_entry *entry);
 extern void fsnotify_put_mark(struct fsnotify_mark_entry *entry);
+extern void fsnotify_unmount_inodes(struct list_head *list);
 
 /* put here because inotify does some weird stuff when destroying watches */
 extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
@@ -366,6 +367,9 @@ static inline u32 fsnotify_get_cookie(vo
 	return 0;
 }
 
+static inline void fsnotify_unmount_inodes(struct list_head *list)
+{}
+
 #endif	/* CONFIG_FSNOTIFY */
 
 #endif	/* __KERNEL __ */
_

Patches currently in -mm which might be from eparis@redhat.com are

linux-next.patch
fsnotify-handle-filesystem-unmounts-with-fsnotify-marks.patch
inotify-reimplement-inotify-using-fsnotify.patch
inotify-reimplement-inotify-using-fsnotify-report-rounded-up-event-size-to-user-space.patch

