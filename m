From: akpm@linux-foundation.org
Subject: + hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch added to -mm tree
Date: Wed, 26 Aug 2009 16:24:39 -0700
Message-ID: <200908262324.n7QNOdbC014863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753745AbZHZXZr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Aug 2009 19:25:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebmunson@us.ibm.com, agl@us.ibm.com, david@gibson.dropbear.id.au, hugh.dickins@tiscali.co.uk, lee.schermerhorn@hp.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au, rientjes@google.com


The patch titled
     hugetlbfs: allow the creation of files suitable for MAP_PRIVATE on the vfs internal mount
has been added to the -mm tree.  Its filename is
     hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlbfs: allow the creation of files suitable for MAP_PRIVATE on the vfs internal mount
From: Eric B Munson <ebmunson@us.ibm.com>

This patchset adds a flag to mmap that allows the user to request that an
anonymous mapping be backed with huge pages.  This mapping will borrow
functionality from the huge page shm code to create a file on the kernel
internal mount and use it to approximate an anonymous mapping.  The
MAP_HUGETLB flag is a modifier to MAP_ANONYMOUS and will not work without
both flags being preset.

A new flag is necessary because there is no other way to hook into huge
pages without creating a file on a hugetlbfs mount which wouldn't be
MAP_ANONYMOUS.

To userspace, this mapping will behave just like an anonymous mapping
because the file is not accessible outside of the kernel.

This patchset is meant to simplify the programming model.  Presently there
is a large chunk of boiler platecode, contained in libhugetlbfs, required
to create private, hugepage backed mappings.  This patch set would allow
use of hugepages without linking to libhugetlbfs or having hugetblfs
mounted.

Unification of the VM code would provide these same benefits, but it has
been resisted each time that it has been suggested for several reasons: it
would break PAGE_SIZE assumptions across the kernel, it makes page-table
abstractions really expensive, and it does not provide any benefit on
architectures that do not support huge pages, incurring fast path
penalties without providing any benefit on these architectures.



This patch:

There are two means of creating mappings backed by huge pages:

        1. mmap() a file created on hugetlbfs
        2. Use shm which creates a file on an internal mount which essentially
           maps it MAP_SHARED

The internal mount is only used for shared mappings but there is very
little that stops it being used for private mappings. This patch extends
hugetlbfs_file_setup() to deal with the creation of files that will be
mapped MAP_PRIVATE on the internal hugetlbfs mount. This extended API is
used in a subsequent patch to implement the MAP_HUGETLB mmap() flag.

Signed-off-by: Eric Munson <ebmunson@us.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Adam Litke <agl@us.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |   21 +++++++++++++++++----
 include/linux/hugetlb.h |   12 ++++++++++--
 ipc/shm.c               |    2 +-
 3 files changed, 28 insertions(+), 7 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount
+++ a/fs/hugetlbfs/inode.c
@@ -481,6 +481,13 @@ static struct inode *hugetlbfs_get_inode
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		INIT_LIST_HEAD(&inode->i_mapping->private_list);
 		info = HUGETLBFS_I(inode);
+		/*
+		 * The policy is initialized here even if we are creating a
+		 * private inode because initialization simply creates an
+		 * an empty rb tree and calls spin_lock_init(), later when we
+		 * call mpol_free_shared_policy() it will just return because
+		 * the rb tree will still be empty.
+		 */
 		mpol_shared_policy_init(&info->policy, NULL);
 		switch (mode & S_IFMT) {
 		default:
@@ -905,13 +912,19 @@ static struct file_system_type hugetlbfs
 
 static struct vfsmount *hugetlbfs_vfsmount;
 
-static int can_do_hugetlb_shm(void)
+static int can_do_hugetlb_shm(int creat_flags)
 {
-	return capable(CAP_IPC_LOCK) || in_group_p(sysctl_hugetlb_shm_group);
+	if (creat_flags != HUGETLB_SHMFS_INODE)
+		return 0;
+	if (capable(CAP_IPC_LOCK))
+		return 1;
+	if (in_group_p(sysctl_hugetlb_shm_group))
+		return 1;
+	return 0;
 }
 
 struct file *hugetlb_file_setup(const char *name, size_t size, int acctflag,
-						struct user_struct **user)
+				struct user_struct **user, int creat_flags)
 {
 	int error = -ENOMEM;
 	struct file *file;
@@ -923,7 +936,7 @@ struct file *hugetlb_file_setup(const ch
 	if (!hugetlbfs_vfsmount)
 		return ERR_PTR(-ENOENT);
 
-	if (!can_do_hugetlb_shm()) {
+	if (!can_do_hugetlb_shm(creat_flags)) {
 		*user = current_user();
 		if (user_shm_lock(size, *user)) {
 			WARN_ONCE(1,
diff -puN include/linux/hugetlb.h~hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount
+++ a/include/linux/hugetlb.h
@@ -110,6 +110,14 @@ static inline void hugetlb_report_meminf
 
 #endif /* !CONFIG_HUGETLB_PAGE */
 
+enum {
+	/*
+	 * The file will be used as an shm file so shmfs accounting rules
+	 * apply
+	 */
+	HUGETLB_SHMFS_INODE     = 1,
+};
+
 #ifdef CONFIG_HUGETLBFS
 struct hugetlbfs_config {
 	uid_t   uid;
@@ -148,7 +156,7 @@ static inline struct hugetlbfs_sb_info *
 extern const struct file_operations hugetlbfs_file_operations;
 extern struct vm_operations_struct hugetlb_vm_ops;
 struct file *hugetlb_file_setup(const char *name, size_t size, int acct,
-						struct user_struct **user);
+				struct user_struct **user, int creat_flags);
 int hugetlb_get_quota(struct address_space *mapping, long delta);
 void hugetlb_put_quota(struct address_space *mapping, long delta);
 
@@ -170,7 +178,7 @@ static inline void set_file_hugepages(st
 
 #define is_file_hugepages(file)			0
 #define set_file_hugepages(file)		BUG()
-#define hugetlb_file_setup(name,size,acct,user)	ERR_PTR(-ENOSYS)
+#define hugetlb_file_setup(name,size,acct,user,creat)	ERR_PTR(-ENOSYS)
 
 #endif /* !CONFIG_HUGETLBFS */
 
diff -puN ipc/shm.c~hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount ipc/shm.c
--- a/ipc/shm.c~hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount
+++ a/ipc/shm.c
@@ -370,7 +370,7 @@ static int newseg(struct ipc_namespace *
 		if (shmflg & SHM_NORESERVE)
 			acctflag = VM_NORESERVE;
 		file = hugetlb_file_setup(name, size, acctflag,
-							&shp->mlock_user);
+					&shp->mlock_user, HUGETLB_SHMFS_INODE);
 	} else {
 		/*
 		 * Do not allow no accounting for OVERCOMMIT_NEVER, even
_

Patches currently in -mm which might be from ebmunson@us.ibm.com are

hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-example.patch

