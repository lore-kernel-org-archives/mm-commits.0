From: akpm@linux-foundation.org
Subject: [merged] writeback-put-unused-inodes-to-lru-after-writeback-completion.patch removed from -mm tree
Date: Fri, 30 Nov 2012 13:28:37 -0800
Message-ID: <20121130212838.4940C200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:61726 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab2K3V2l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Nov 2012 16:28:41 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so64992eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 30 Nov 2012 13:28:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, david@fromorbit.com, fengguang.wu@intel.com, hirofumi@mail.parknet.co.jp, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: writeback: put unused inodes to LRU after writeback completion
has been removed from the -mm tree.  Its filename was
     writeback-put-unused-inodes-to-lru-after-writeback-completion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: writeback: put unused inodes to LRU after writeback completion

Commit 169ebd90 ("writeback: Avoid iput() from flusher thread") removed
iget-iput pair from inode writeback.  As a side effect, inodes that are
dirty during iput_final() call won't be ever added to inode LRU
(iput_final() doesn't add dirty inodes to LRU and later when the inode is
cleaned there's noone to add the inode there).  Thus inodes are
effectively unreclaimable until someone looks them up again.

Practical effect of this bug is limited by the fact that inodes are pinned
by a dentry for long enough that the inode gets cleaned.  But still the
bug can have nasty consequences leading up to OOM conditions under certain
circumstances.  Following can easily reproduce the problem:

for (( i = 0; i < 1000; i++ )); do
  mkdir $i
  for (( j = 0; j < 1000; j++ )); do
    touch $i/$j
    echo 2 > /proc/sys/vm/drop_caches
  done
done

then one needs to run 'sync; ls -lR' to make inodes reclaimable again.

We fix the issue by inserting unused clean inodes into the LRU after
writeback finishes in inode_sync_complete().

Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: <stable@vger.kernel.org>		[3.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    2 ++
 fs/inode.c        |   16 ++++++++++++++--
 fs/internal.h     |    1 +
 3 files changed, 17 insertions(+), 2 deletions(-)

diff -puN fs/fs-writeback.c~writeback-put-unused-inodes-to-lru-after-writeback-completion fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-put-unused-inodes-to-lru-after-writeback-completion
+++ a/fs/fs-writeback.c
@@ -228,6 +228,8 @@ static void requeue_io(struct inode *ino
 static void inode_sync_complete(struct inode *inode)
 {
 	inode->i_state &= ~I_SYNC;
+	/* If inode is clean an unused, put it into LRU now... */
+	inode_add_lru(inode);
 	/* Waiters must see I_SYNC cleared before being woken up */
 	smp_mb();
 	wake_up_bit(&inode->i_state, __I_SYNC);
diff -puN fs/inode.c~writeback-put-unused-inodes-to-lru-after-writeback-completion fs/inode.c
--- a/fs/inode.c~writeback-put-unused-inodes-to-lru-after-writeback-completion
+++ a/fs/inode.c
@@ -408,6 +408,19 @@ static void inode_lru_list_add(struct in
 	spin_unlock(&inode->i_sb->s_inode_lru_lock);
 }
 
+/*
+ * Add inode to LRU if needed (inode is unused and clean).
+ *
+ * Needs inode->i_lock held.
+ */
+void inode_add_lru(struct inode *inode)
+{
+	if (!(inode->i_state & (I_DIRTY | I_SYNC | I_FREEING | I_WILL_FREE)) &&
+	    !atomic_read(&inode->i_count) && inode->i_sb->s_flags & MS_ACTIVE)
+		inode_lru_list_add(inode);
+}
+
+
 static void inode_lru_list_del(struct inode *inode)
 {
 	spin_lock(&inode->i_sb->s_inode_lru_lock);
@@ -1390,8 +1403,7 @@ static void iput_final(struct inode *ino
 
 	if (!drop && (sb->s_flags & MS_ACTIVE)) {
 		inode->i_state |= I_REFERENCED;
-		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
-			inode_lru_list_add(inode);
+		inode_add_lru(inode);
 		spin_unlock(&inode->i_lock);
 		return;
 	}
diff -puN fs/internal.h~writeback-put-unused-inodes-to-lru-after-writeback-completion fs/internal.h
--- a/fs/internal.h~writeback-put-unused-inodes-to-lru-after-writeback-completion
+++ a/fs/internal.h
@@ -110,6 +110,7 @@ extern int open_check_o_direct(struct fi
  * inode.c
  */
 extern spinlock_t inode_sb_list_lock;
+extern void inode_add_lru(struct inode *inode);
 
 /*
  * fs-writeback.c
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
linux-next.patch
fs-change-return-values-from-eacces-to-eperm.patch
mm-add-comment-on-storage-key-dirty-bit-semantics.patch
mm-print-out-information-of-file-affected-by-memory-error.patch
maintainers-remove-include-linux-ext3.patch
hfsplus-avoid-crash-on-failed-block-map-free.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes-fix.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch
fat-provide-option-for-setting-timezone-offset.patch
fat-fix-mount-option-parsing.patch

