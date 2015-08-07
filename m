From: akpm@linux-foundation.org
Subject: [merged]
 ipc-use-private-shmem-or-hugetlbfs-inodes-for-shm-segments.patch removed
 from -mm tree
Date: Fri, 07 Aug 2015 12:03:24 -0700
Message-ID: <55c500fc.7VGUckxmaYmIbxTo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41547 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946135AbbHGTDZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2015 15:03:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sds@tycho.nsa.gov, dave@stgolabs.net, eparis@redhat.com, hughd@google.com, manfred@colorfullife.com, mstevens@fedoraproject.org, paul@paul-moore.com, prarit@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: use private shmem or hugetlbfs inodes for shm segments.
has been removed from the -mm tree.  Its filename was
     ipc-use-private-shmem-or-hugetlbfs-inodes-for-shm-segments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: ipc: use private shmem or hugetlbfs inodes for shm segments.

The shm implementation internally uses shmem or hugetlbfs inodes for shm
segments.  As these inodes are never directly exposed to userspace and
only accessed through the shm operations which are already hooked by
security modules, mark the inodes with the S_PRIVATE flag so that inode
security initialization and permission checking is skipped.

This was motivated by the following lockdep warning:

======================================================
 [ INFO: possible circular locking dependency detected ]
 4.2.0-0.rc3.git0.1.fc24.x86_64+debug #1 Tainted: G        W
-------------------------------------------------------
 httpd/1597 is trying to acquire lock:
 (&ids->rwsem){+++++.}, at: [<ffffffff81385354>] shm_close+0x34/0x130
 but task is already holding lock:
 (&mm->mmap_sem){++++++}, at: [<ffffffff81386bbb>] SyS_shmdt+0x4b/0x180
 which lock already depends on the new lock.
 the existing dependency chain (in reverse order) is:
 -> #3 (&mm->mmap_sem){++++++}:
       [<ffffffff81109a07>] lock_acquire+0xc7/0x270
       [<ffffffff81217baa>] __might_fault+0x7a/0xa0
       [<ffffffff81284a1e>] filldir+0x9e/0x130
       [<ffffffffa019bb08>] xfs_dir2_block_getdents.isra.12+0x198/0x1c0 [xfs]
       [<ffffffffa019c5b4>] xfs_readdir+0x1b4/0x330 [xfs]
       [<ffffffffa019f38b>] xfs_file_readdir+0x2b/0x30 [xfs]
       [<ffffffff812847e7>] iterate_dir+0x97/0x130
       [<ffffffff81284d21>] SyS_getdents+0x91/0x120
       [<ffffffff81871d2e>] entry_SYSCALL_64_fastpath+0x12/0x76
 -> #2 (&xfs_dir_ilock_class){++++.+}:
       [<ffffffff81109a07>] lock_acquire+0xc7/0x270
       [<ffffffff81101e97>] down_read_nested+0x57/0xa0
       [<ffffffffa01b0e57>] xfs_ilock+0x167/0x350 [xfs]
       [<ffffffffa01b10b8>] xfs_ilock_attr_map_shared+0x38/0x50 [xfs]
       [<ffffffffa014799d>] xfs_attr_get+0xbd/0x190 [xfs]
       [<ffffffffa01c17ad>] xfs_xattr_get+0x3d/0x70 [xfs]
       [<ffffffff8129962f>] generic_getxattr+0x4f/0x70
       [<ffffffff8139ba52>] inode_doinit_with_dentry+0x162/0x670
       [<ffffffff8139cf69>] sb_finish_set_opts+0xd9/0x230
       [<ffffffff8139d66c>] selinux_set_mnt_opts+0x35c/0x660
       [<ffffffff8139ff97>] superblock_doinit+0x77/0xf0
       [<ffffffff813a0020>] delayed_superblock_init+0x10/0x20
       [<ffffffff81272d23>] iterate_supers+0xb3/0x110
       [<ffffffff813a4e5f>] selinux_complete_init+0x2f/0x40
       [<ffffffff813b47a3>] security_load_policy+0x103/0x600
       [<ffffffff813a6901>] sel_write_load+0xc1/0x750
       [<ffffffff8126e817>] __vfs_write+0x37/0x100
       [<ffffffff8126f229>] vfs_write+0xa9/0x1a0
       [<ffffffff8126ff48>] SyS_write+0x58/0xd0
       [<ffffffff81871d2e>] entry_SYSCALL_64_fastpath+0x12/0x76
....

Signed-off-by: Stephen Smalley <sds@tycho.nsa.gov>
Reported-by: Morten Stevens <mstevens@fedoraproject.org>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 ++
 ipc/shm.c            |    2 +-
 mm/shmem.c           |    4 ++--
 3 files changed, 5 insertions(+), 3 deletions(-)

diff -puN fs/hugetlbfs/inode.c~ipc-use-private-shmem-or-hugetlbfs-inodes-for-shm-segments fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~ipc-use-private-shmem-or-hugetlbfs-inodes-for-shm-segments
+++ a/fs/hugetlbfs/inode.c
@@ -1010,6 +1010,8 @@ struct file *hugetlb_file_setup(const ch
 	inode = hugetlbfs_get_inode(sb, NULL, S_IFREG | S_IRWXUGO, 0);
 	if (!inode)
 		goto out_dentry;
+	if (creat_flags == HUGETLB_SHMFS_INODE)
+		inode->i_flags |= S_PRIVATE;
 
 	file = ERR_PTR(-ENOMEM);
 	if (hugetlb_reserve_pages(inode, 0,
diff -puN ipc/shm.c~ipc-use-private-shmem-or-hugetlbfs-inodes-for-shm-segments ipc/shm.c
--- a/ipc/shm.c~ipc-use-private-shmem-or-hugetlbfs-inodes-for-shm-segments
+++ a/ipc/shm.c
@@ -545,7 +545,7 @@ static int newseg(struct ipc_namespace *
 		if  ((shmflg & SHM_NORESERVE) &&
 				sysctl_overcommit_memory != OVERCOMMIT_NEVER)
 			acctflag = VM_NORESERVE;
-		file = shmem_file_setup(name, size, acctflag);
+		file = shmem_kernel_file_setup(name, size, acctflag);
 	}
 	error = PTR_ERR(file);
 	if (IS_ERR(file))
diff -puN mm/shmem.c~ipc-use-private-shmem-or-hugetlbfs-inodes-for-shm-segments mm/shmem.c
--- a/mm/shmem.c~ipc-use-private-shmem-or-hugetlbfs-inodes-for-shm-segments
+++ a/mm/shmem.c
@@ -3363,8 +3363,8 @@ put_path:
  * shmem_kernel_file_setup - get an unlinked file living in tmpfs which must be
  * 	kernel internal.  There will be NO LSM permission checks against the
  * 	underlying inode.  So users of this interface must do LSM checks at a
- * 	higher layer.  The one user is the big_key implementation.  LSM checks
- * 	are provided at the key level rather than the inode level.
+ *	higher layer.  The users are the big_key and shm implementations.  LSM
+ *	checks are provided at the key or shm level rather than the inode.
  * @name: name for dentry (to be seen in /proc/<pid>/maps
  * @size: size to be set for the file
  * @flags: VM_NORESERVE suppresses pre-accounting of the entire object size
_

Patches currently in -mm which might be from sds@tycho.nsa.gov are

origin.patch
linux-next.patch

