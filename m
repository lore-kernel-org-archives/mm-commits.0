From: akpm@linux-foundation.org
Subject: [patch 114/131] shmem: convert shmem_init_inodecache() to
 void
Date: Wed, 15 Nov 2017 17:38:18 -0800
Message-ID: <20171116013818.6Iw8LsJVV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40464 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933653AbdKPBiU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:38:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, zhangweiping@didichuxing.com

From: weiping zhang <zhangweiping@didichuxing.com>
Subject: shmem: convert shmem_init_inodecache() to void

shmem_inode_cachep was created with SLAB_PANIC flag and
shmem_init_inodecache() never returns non-zero, so convert this function
to return void.

Link: http://lkml.kernel.org/r/20170909124542.GA35224@bogon.didichuxing.com
Signed-off-by: weiping zhang <zhangweiping@didichuxing.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN mm/shmem.c~shmem-convert-shmem_init_inodecache-to-void mm/shmem.c
--- a/mm/shmem.c~shmem-convert-shmem_init_inodecache-to-void
+++ a/mm/shmem.c
@@ -3862,12 +3862,11 @@ static void shmem_init_inode(void *foo)
 	inode_init_once(&info->vfs_inode);
 }
 
-static int shmem_init_inodecache(void)
+static void shmem_init_inodecache(void)
 {
 	shmem_inode_cachep = kmem_cache_create("shmem_inode_cache",
 				sizeof(struct shmem_inode_info),
 				0, SLAB_PANIC|SLAB_ACCOUNT, shmem_init_inode);
-	return 0;
 }
 
 static void shmem_destroy_inodecache(void)
@@ -3991,9 +3990,7 @@ int __init shmem_init(void)
 	if (shmem_inode_cachep)
 		return 0;
 
-	error = shmem_init_inodecache();
-	if (error)
-		goto out3;
+	shmem_init_inodecache();
 
 	error = register_filesystem(&shmem_fs_type);
 	if (error) {
@@ -4020,7 +4017,6 @@ out1:
 	unregister_filesystem(&shmem_fs_type);
 out2:
 	shmem_destroy_inodecache();
-out3:
 	shm_mnt = ERR_PTR(error);
 	return error;
 }
_
