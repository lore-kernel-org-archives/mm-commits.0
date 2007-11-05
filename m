From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-track-number-of-mount-writers.patch added to -mm tree
Date: Mon, 05 Nov 2007 15:39:37 -0800
Message-ID: <200711052339.lA5NdbvJ025638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33626 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752082AbXKEXt3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 18:49:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com, hch@lst.de


The patch titled
     r-o-bind-mounts: track number of mount writers
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-track-number-of-mount-writers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: r-o-bind-mounts: track number of mount writers
From: Dave Hansen <haveblue@us.ibm.com>

This is the real meat of the entire series.  It actually implements the
tracking of the number of writers to a mount.  However, it causes scalability
problems because there can be hundreds of cpus doing open()/close() on files
on the same mnt at the same time.  Even an atomic_t in the mnt has massive
scalaing problems because the cacheline gets so terribly contended.

This uses a statically-allocated percpu variable.  All operations are local to
a cpu as long that cpu operates on the same mount, and there are no writer
count imbalances.  Writer count imbalances happen when a write is taken on one
cpu, and released on another, like when an open/close pair is performed on two

Upon a remount,ro request, all of the data from the percpu variables is
collected (expensive, but very rare) and we determine if there are any
outstanding writers to the mount.

I've written a little benchmark to sit in a loop for a couple of seconds in
several cpus in parallel doing open/write/close loops.

http://sr71.net/~dave/linux/openbench.c

The code in here is a a worst-possible case for this patch.  It does opens on
a _pair_ of files in two different mounts in parallel.  This should cause my
code to lose its "operate on the same mount" optimization completely.  This
worst-case scenario causes a 3% degredation in the benchmark.

I could probably get rid of even this 3%, but it would be more complex than
what I have here, and I think this is getting into acceptable territory.  In
practice, I expect writing more than 3 bytes to a file, as well as disk I/O to
mask any effects that this has.

(To get rid of that 3%, we could have an #defined number of mounts in the
percpu variable.  So, instead of a CPU getting operate only on percpu data
when it accesses only one mount, it could stay on percpu data when it only
accesses N or fewer mounts.)

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c        |  205 +++++++++++++++++++++++++++++++++++++---
 include/linux/mount.h |    7 +
 2 files changed, 196 insertions(+), 16 deletions(-)

diff -puN fs/namespace.c~r-o-bind-mounts-track-number-of-mount-writers fs/namespace.c
--- a/fs/namespace.c~r-o-bind-mounts-track-number-of-mount-writers
+++ a/fs/namespace.c
@@ -17,6 +17,7 @@
 #include <linux/quotaops.h>
 #include <linux/acct.h>
 #include <linux/capability.h>
+#include <linux/cpumask.h>
 #include <linux/module.h>
 #include <linux/sysfs.h>
 #include <linux/seq_file.h>
@@ -55,6 +56,8 @@ static inline unsigned long hash(struct 
 	return tmp & hash_mask;
 }
 
+#define MNT_WRITER_UNDERFLOW_LIMIT -(1<<16)
+
 struct vfsmount *alloc_vfsmnt(const char *name)
 {
 	struct vfsmount *mnt = kmem_cache_zalloc(mnt_cache, GFP_KERNEL);
@@ -68,6 +71,7 @@ struct vfsmount *alloc_vfsmnt(const char
 		INIT_LIST_HEAD(&mnt->mnt_share);
 		INIT_LIST_HEAD(&mnt->mnt_slave_list);
 		INIT_LIST_HEAD(&mnt->mnt_slave);
+		atomic_set(&mnt->__mnt_writers, 0);
 		if (name) {
 			int size = strlen(name) + 1;
 			char *newname = kmalloc(size, GFP_KERNEL);
@@ -88,6 +92,84 @@ struct vfsmount *alloc_vfsmnt(const char
  * we can determine when writes are able to occur to
  * a filesystem.
  */
+/*
+ * __mnt_is_readonly: check whether a mount is read-only
+ * @mnt: the mount to check for its write status
+ *
+ * This shouldn't be used directly ouside of the VFS.
+ * It does not guarantee that the filesystem will stay
+ * r/w, just that it is right *now*.  This can not and
+ * should not be used in place of IS_RDONLY(inode).
+ * mnt_want/drop_write() will _keep_ the filesystem
+ * r/w.
+ */
+int __mnt_is_readonly(struct vfsmount *mnt)
+{
+	return (mnt->mnt_sb->s_flags & MS_RDONLY);
+}
+EXPORT_SYMBOL_GPL(__mnt_is_readonly);
+
+struct mnt_writer {
+	/*
+	 * If holding multiple instances of this lock, they
+	 * must be ordered by cpu number.
+	 */
+	spinlock_t lock;
+	unsigned long count;
+	struct vfsmount *mnt;
+} ____cacheline_aligned_in_smp;
+static DEFINE_PER_CPU(struct mnt_writer, mnt_writers);
+
+static int __init init_mnt_writers(void)
+{
+	int cpu;
+	for_each_possible_cpu(cpu) {
+		struct mnt_writer *writer = &per_cpu(mnt_writers, cpu);
+		spin_lock_init(&writer->lock);
+		writer->count = 0;
+	}
+	return 0;
+}
+fs_initcall(init_mnt_writers);
+
+static void mnt_unlock_cpus(void)
+{
+	int cpu;
+	struct mnt_writer *cpu_writer;
+
+	for_each_possible_cpu(cpu) {
+		cpu_writer = &per_cpu(mnt_writers, cpu);
+		spin_unlock(&cpu_writer->lock);
+	}
+}
+
+static inline void __clear_mnt_count(struct mnt_writer *cpu_writer)
+{
+	if (!cpu_writer->mnt)
+		return;
+	atomic_add(cpu_writer->count, &cpu_writer->mnt->__mnt_writers);
+	cpu_writer->count = 0;
+}
+ /*
+ * must hold cpu_writer->lock
+ */
+static inline void use_cpu_writer_for_mount(struct mnt_writer *cpu_writer,
+					  struct vfsmount *mnt)
+{
+	if (cpu_writer->mnt == mnt)
+		return;
+	__clear_mnt_count(cpu_writer);
+	cpu_writer->mnt = mnt;
+}
+
+/*
+ * Most r/o checks on a fs are for operations that take
+ * discrete amounts of time, like a write() or unlink().
+ * We must keep track of when those operations start
+ * (for permission checks) and when they end, so that
+ * we can determine when writes are able to occur to
+ * a filesystem.
+ */
 /**
  * mnt_want_write - get write access to a mount
  * @mnt: the mount on which to take a write
@@ -100,12 +182,58 @@ struct vfsmount *alloc_vfsmnt(const char
  */
 int mnt_want_write(struct vfsmount *mnt)
 {
-	if (__mnt_is_readonly(mnt))
-		return -EROFS;
-	return 0;
+	int ret = 0;
+	struct mnt_writer *cpu_writer;
+
+	cpu_writer = &get_cpu_var(mnt_writers);
+	spin_lock(&cpu_writer->lock);
+	if (__mnt_is_readonly(mnt)) {
+		ret = -EROFS;
+		goto out;
+	}
+	use_cpu_writer_for_mount(cpu_writer, mnt);
+	cpu_writer->count++;
+out:
+	spin_unlock(&cpu_writer->lock);
+	put_cpu_var(mnt_writers);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(mnt_want_write);
 
+static void lock_and_coalesce_cpu_mnt_writer_counts(void)
+{
+	int cpu;
+	struct mnt_writer *cpu_writer;
+
+	for_each_possible_cpu(cpu) {
+		cpu_writer = &per_cpu(mnt_writers, cpu);
+		spin_lock(&cpu_writer->lock);
+		__clear_mnt_count(cpu_writer);
+		cpu_writer->mnt = NULL;
+	}
+}
+
+/*
+ * These per-cpu write counts are not guaranteed to have
+ * matched increments and decrements on any given cpu.
+ * A file open()ed for write on one cpu and close()d on
+ * another cpu will imbalance this count.  Make sure it
+ * does not get too far out of whack.
+ */
+static void handle_write_count_underflow(struct vfsmount *mnt)
+{
+	while (atomic_read(&mnt->__mnt_writers) <
+		MNT_WRITER_UNDERFLOW_LIMIT) {
+		/*
+		 * It isn't necessary to hold all of the locks
+		 * at the same time, but doing it this way makes
+		 * us share a lot more code.
+		 */
+		lock_and_coalesce_cpu_mnt_writer_counts();
+		mnt_unlock_cpus();
+	}
+}
+
 /**
  * mnt_drop_write - give up write access to a mount
  * @mnt: the mount on which to give up write access
@@ -116,23 +244,61 @@ EXPORT_SYMBOL_GPL(mnt_want_write);
  */
 void mnt_drop_write(struct vfsmount *mnt)
 {
+	int must_check_underflow = 0;
+	struct mnt_writer *cpu_writer;
+
+	cpu_writer = &get_cpu_var(mnt_writers);
+	spin_lock(&cpu_writer->lock);
+
+	use_cpu_writer_for_mount(cpu_writer, mnt);
+	if (cpu_writer->count > 0) {
+		cpu_writer->count--;
+	} else {
+		must_check_underflow = 1;
+		atomic_dec(&mnt->__mnt_writers);
+	}
+
+	spin_unlock(&cpu_writer->lock);
+	/*
+	 * Logically, we could call this each time,
+	 * but the __mnt_writers cacheline tends to
+	 * be cold, and makes this expensive.
+	 */
+	if (must_check_underflow)
+		handle_write_count_underflow(mnt);
+	/*
+	 * This could be done right after the spinlock
+	 * is taken because the spinlock keeps us on
+	 * the cpu, and disables preemption.  However,
+	 * putting it here bounds the amount that
+	 * __mnt_writers can underflow.  Without it,
+	 * we could theoretically wrap __mnt_writers.
+	 */
+	put_cpu_var(mnt_writers);
 }
 EXPORT_SYMBOL_GPL(mnt_drop_write);
 
-/*
- * __mnt_is_readonly: check whether a mount is read-only
- * @mnt: the mount to check for its write status
- *
- * This shouldn't be used directly ouside of the VFS.
- * It does not guarantee that the filesystem will stay
- * r/w, just that it is right *now*.  This can not and
- * should not be used in place of IS_RDONLY(inode).
- */
-int __mnt_is_readonly(struct vfsmount *mnt)
+int mnt_make_readonly(struct vfsmount *mnt)
 {
-	return (mnt->mnt_sb->s_flags & MS_RDONLY);
+	int ret = 0;
+
+	lock_and_coalesce_cpu_mnt_writer_counts();
+	/*
+	 * With all the locks held, this value is stable
+	 */
+	if (atomic_read(&mnt->__mnt_writers) > 0) {
+		ret = -EBUSY;
+		goto out;
+	}
+	/*
+	 * actually set mount's r/o flag here to make
+	 * __mnt_is_readonly() true, which keeps anyone
+	 * from doing a successful mnt_want_write().
+	 */
+out:
+	mnt_unlock_cpus();
+	return ret;
 }
-EXPORT_SYMBOL_GPL(__mnt_is_readonly);
 
 int simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
 {
@@ -397,6 +563,15 @@ static struct vfsmount *clone_mnt(struct
 static inline void __mntput(struct vfsmount *mnt)
 {
 	struct super_block *sb = mnt->mnt_sb;
+	lock_and_coalesce_cpu_mnt_writer_counts();
+	mnt_unlock_cpus();
+	/*
+	 * This probably indicates that somebody messed
+	 * up a mnt_want/drop_write() pair.  If this
+	 * happens, the filesystem was probably unable
+	 * to make r/w->r/o transitions.
+	 */
+	WARN_ON(atomic_read(&mnt->__mnt_writers));
 	dput(mnt->mnt_root);
 	clear_mnt_user(mnt);
 	free_vfsmnt(mnt);
diff -puN include/linux/mount.h~r-o-bind-mounts-track-number-of-mount-writers include/linux/mount.h
--- a/include/linux/mount.h~r-o-bind-mounts-track-number-of-mount-writers
+++ a/include/linux/mount.h
@@ -14,6 +14,7 @@
 
 #include <linux/types.h>
 #include <linux/list.h>
+#include <linux/nodemask.h>
 #include <linux/spinlock.h>
 #include <asm/atomic.h>
 
@@ -63,7 +64,11 @@ struct vfsmount {
 	atomic_t mnt_count;
 	int mnt_expiry_mark;		/* true if marked for expiry */
 	int mnt_pinned;
-
+	/*
+	 * This value is not stable unless all of the mnt_writers[] spinlocks
+	 * are held, and all mnt_writer[]s on this mount have 0 as their ->count
+	 */
+	atomic_t __mnt_writers;
 	uid_t mnt_uid;			/* owner of the mount */
 };
 
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

markers-fix-warnings.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
maps4-rework-task_size-macros.patch
maps4-move-is_swap_pte.patch
maps4-introduce-a-generic-page-walker.patch
maps4-use-pagewalker-in-clear_refs-and-smaps.patch
maps4-simplify-interdependence-of-maps-and-smaps.patch
maps4-move-clear_refs-code-to-task_mmuc.patch
maps4-regroup-task_mmu-by-interface.patch
maps4-add-proc-pid-pagemap-interface.patch
maps4-add-proc-kpagecount-interface.patch
maps4-add-proc-kpageflags-interface.patch
maps4-make-page-monitoring-proc-file-optional.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
hugetlb-fix-quota-management-for-private-mappings.patch
hugetlb-debit-quota-in-alloc_huge_page.patch
hugetlb-allow-bulk-updating-in-hugetlb__quota.patch
hugetlb-enforce-quotas-during-reservation-for-shared-mappings.patch
add-remove_memory-for-ppc64-2.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
do-namei_flags-calculation-inside-open_namei.patch
make-open_namei-return-a-filp.patch
kill-do_filp_open.patch
kill-filp_open.patch
kill-filp_open-checkpatch-fixes.patch
rename-open_namei-to-open_pathname.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-file_update_time.patch
r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-elevate-write-count-opened-files.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-make-access-use-mnt-check.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
keep-track-of-mnt_writer-state-of-struct-file.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
