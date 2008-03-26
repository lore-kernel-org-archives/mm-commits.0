From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-stub-functions.patch removed from -mm tree
Date: Wed, 26 Mar 2008 11:40:14 -0700
Message-ID: <200803261840.m2QIeEgo028643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760770AbYCZSkn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 14:40:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, hch@infradead.org, serue@us.ibm.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: stub functions
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-stub-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: r/o bind mounts: stub functions
From: Dave Hansen <haveblue@us.ibm.com>

This patch adds two function mnt_want_write() and mnt_drop_write().  These are
used like a lock pair around and fs operations that might cause a write to the
filesystem.

Before these can become useful, we must first cover each place in the VFS
where writes are performed with a want/drop pair.  When that is complete, we
can actually introduce code that will safely check the counts before allowing
r/w<->r/o transitions to occur.

Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c        |   54 ++++++++++++++++++++++++++++++++++++++++
 include/linux/mount.h |    3 ++
 2 files changed, 57 insertions(+)

diff -puN fs/namespace.c~r-o-bind-mounts-stub-functions fs/namespace.c
--- a/fs/namespace.c~r-o-bind-mounts-stub-functions
+++ a/fs/namespace.c
@@ -80,6 +80,60 @@ struct vfsmount *alloc_vfsmnt(const char
 	return mnt;
 }
 
+/*
+ * Most r/o checks on a fs are for operations that take
+ * discrete amounts of time, like a write() or unlink().
+ * We must keep track of when those operations start
+ * (for permission checks) and when they end, so that
+ * we can determine when writes are able to occur to
+ * a filesystem.
+ */
+/**
+ * mnt_want_write - get write access to a mount
+ * @mnt: the mount on which to take a write
+ *
+ * This tells the low-level filesystem that a write is
+ * about to be performed to it, and makes sure that
+ * writes are allowed before returning success.  When
+ * the write operation is finished, mnt_drop_write()
+ * must be called.  This is effectively a refcount.
+ */
+int mnt_want_write(struct vfsmount *mnt)
+{
+	if (__mnt_is_readonly(mnt))
+		return -EROFS;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mnt_want_write);
+
+/**
+ * mnt_drop_write - give up write access to a mount
+ * @mnt: the mount on which to give up write access
+ *
+ * Tells the low-level filesystem that we are done
+ * performing writes to it.  Must be matched with
+ * mnt_want_write() call above.
+ */
+void mnt_drop_write(struct vfsmount *mnt)
+{
+}
+EXPORT_SYMBOL_GPL(mnt_drop_write);
+
+/*
+ * __mnt_is_readonly: check whether a mount is read-only
+ * @mnt: the mount to check for its write status
+ *
+ * This shouldn't be used directly ouside of the VFS.
+ * It does not guarantee that the filesystem will stay
+ * r/w, just that it is right *now*.  This can not and
+ * should not be used in place of IS_RDONLY(inode).
+ */
+int __mnt_is_readonly(struct vfsmount *mnt)
+{
+	return (mnt->mnt_sb->s_flags & MS_RDONLY);
+}
+EXPORT_SYMBOL_GPL(__mnt_is_readonly);
+
 int simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
 {
 	mnt->mnt_sb = sb;
diff -puN include/linux/mount.h~r-o-bind-mounts-stub-functions include/linux/mount.h
--- a/include/linux/mount.h~r-o-bind-mounts-stub-functions
+++ a/include/linux/mount.h
@@ -70,9 +70,12 @@ static inline struct vfsmount *mntget(st
 	return mnt;
 }
 
+extern int mnt_want_write(struct vfsmount *mnt);
+extern void mnt_drop_write(struct vfsmount *mnt);
 extern void mntput_no_expire(struct vfsmount *mnt);
 extern void mnt_pin(struct vfsmount *mnt);
 extern void mnt_unpin(struct vfsmount *mnt);
+extern int __mnt_is_readonly(struct vfsmount *mnt);
 
 static inline void mntput(struct vfsmount *mnt)
 {
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

git-vfs.patch
hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages.patch
mm-make-mem_map-allocation-continuous.patch
vfs-create-proc-pid-mountinfo.patch
vfs-mountinfo-mm-fix.patch
vfs-pnode-cleanup.patch
vfs-mountinfo-stable-peer-group-id.patch
vfs-mountinfo-show-dominating-group-id.patch
vfs-optimization-to-proc-pid-mountinfo-patch.patch
vfs-mountinfo-only-show-mounts-under-tasks-root.patch
kprobes-prevent-probing-of-preempt_schedule.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
reiser4.patch
page-owner-tracking-leak-detector.patch

