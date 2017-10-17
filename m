From: akpm@linux-foundation.org
Subject: + shmem-convert-shmem_init_inodecache-to-void.patch added to -mm
 tree
Date: Tue, 17 Oct 2017 16:22:09 -0700
Message-ID: <59e690a1.XiaEsajGb5V1Xn4M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60770 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761365AbdJQXWK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 19:22:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhangweiping@didichuxing.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: convert shmem_init_inodecache() to void
has been added to the -mm tree.  Its filename is
     shmem-convert-shmem_init_inodecache-to-void.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/shmem-convert-shmem_init_inodecache-to-void.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/shmem-convert-shmem_init_inodecache-to-void.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -3860,12 +3860,11 @@ static void shmem_init_inode(void *foo)
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
@@ -3989,9 +3988,7 @@ int __init shmem_init(void)
 	if (shmem_inode_cachep)
 		return 0;
 
-	error = shmem_init_inodecache();
-	if (error)
-		goto out3;
+	shmem_init_inodecache();
 
 	error = register_filesystem(&shmem_fs_type);
 	if (error) {
@@ -4018,7 +4015,6 @@ out1:
 	unregister_filesystem(&shmem_fs_type);
 out2:
 	shmem_destroy_inodecache();
-out3:
 	shm_mnt = ERR_PTR(error);
 	return error;
 }
_

Patches currently in -mm which might be from zhangweiping@didichuxing.com are

shmem-convert-shmem_init_inodecache-to-void.patch

