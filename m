From: akpm@linux-foundation.org
Subject: [merged] shmem-fix-double-uncharge-in-__shmem_file_setup.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:05:05 -0700
Message-ID: <53e3dbf1.uT/tqvAg5FR5ecqT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:64210 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaHGUFG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:05:06 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so843675obc.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:05:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: fix double uncharge in __shmem_file_setup()
has been removed from the -mm tree.  Its filename was
     shmem-fix-double-uncharge-in-__shmem_file_setup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: shmem: fix double uncharge in __shmem_file_setup()

If __shmem_file_setup() fails on struct file allocation it uncharges
memory commitment twice: first by shmem_unacct_size() and second time
implicitly in shmem_evict_inode() when it kills the newly created inode.

This patch removes shmem_unacct_size() from error path if the inode was
already there.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/shmem.c~shmem-fix-double-uncharge-in-__shmem_file_setup mm/shmem.c
--- a/mm/shmem.c~shmem-fix-double-uncharge-in-__shmem_file_setup
+++ a/mm/shmem.c
@@ -2932,16 +2932,16 @@ static struct file *__shmem_file_setup(c
 	this.len = strlen(name);
 	this.hash = 0; /* will go */
 	sb = shm_mnt->mnt_sb;
+	path.mnt = mntget(shm_mnt);
 	path.dentry = d_alloc_pseudo(sb, &this);
 	if (!path.dentry)
 		goto put_memory;
 	d_set_d_op(path.dentry, &anon_ops);
-	path.mnt = mntget(shm_mnt);
 
 	res = ERR_PTR(-ENOSPC);
 	inode = shmem_get_inode(sb, NULL, S_IFREG | S_IRWXUGO, 0, flags);
 	if (!inode)
-		goto put_dentry;
+		goto put_memory;
 
 	inode->i_flags |= i_flags;
 	d_instantiate(path.dentry, inode);
@@ -2949,19 +2949,19 @@ static struct file *__shmem_file_setup(c
 	clear_nlink(inode);	/* It is unlinked */
 	res = ERR_PTR(ramfs_nommu_expand_for_mapping(inode, size));
 	if (IS_ERR(res))
-		goto put_dentry;
+		goto put_path;
 
 	res = alloc_file(&path, FMODE_WRITE | FMODE_READ,
 		  &shmem_file_operations);
 	if (IS_ERR(res))
-		goto put_dentry;
+		goto put_path;
 
 	return res;
 
-put_dentry:
-	path_put(&path);
 put_memory:
 	shmem_unacct_size(flags, size);
+put_path:
+	path_put(&path);
 	return res;
 }
 
_

Patches currently in -mm which might be from koct9i@gmail.com are

origin.patch
lib-idr-fix-out-of-bounds-pointer-dereference.patch
scripts-checkstackpl-automatically-handle-32-bit-and-64-bit-mode-for-arch=x86.patch

