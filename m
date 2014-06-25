From: akpm@linux-foundation.org
Subject: + shmem-fix-double-uncharge-in-__shmem_file_setup.patch added to
 -mm tree
Date: Wed, 25 Jun 2014 15:04:10 -0700
Message-ID: <53ab475a.8JPVAuibvU8r19yU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48373 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbaFYWEL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jun 2014 18:04:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: fix double uncharge in __shmem_file_setup()
has been added to the -mm tree.  Its filename is
     shmem-fix-double-uncharge-in-__shmem_file_setup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/shmem-fix-double-uncharge-in-__shmem_file_setup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/shmem-fix-double-uncharge-in-__shmem_file_setup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: shmem: fix double uncharge in __shmem_file_setup()

If __shmem_file_setup() fails on struct file allocation it uncharges
memory commitment twice: first by shmem_unacct_size() and second time
implicitly in shmem_evict_inode() when it kills the newly created inode.

This patch removes shmem_unacct_size() from error path if the inode was
already there.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/shmem.c~shmem-fix-double-uncharge-in-__shmem_file_setup mm/shmem.c
--- a/mm/shmem.c~shmem-fix-double-uncharge-in-__shmem_file_setup
+++ a/mm/shmem.c
@@ -2899,16 +2899,16 @@ static struct file *__shmem_file_setup(c
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
@@ -2916,19 +2916,19 @@ static struct file *__shmem_file_setup(c
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
mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch
shmem-fix-double-uncharge-in-__shmem_file_setup.patch
shmem-update-memory-reservation-on-truncate.patch
mm-catch-memory-commitment-underflow.patch
lib-idr-fix-out-of-bounds-pointer-dereference.patch

