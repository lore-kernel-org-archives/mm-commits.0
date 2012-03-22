From: akpm@linux-foundation.org
Subject: [merged] hugetlbfs-return-error-code-when-initializing-module.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:19:13 -0700
Message-ID: <20120322201913.B92FAA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:48025 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964910Ab2CVUTQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:19:16 -0400
Received: by mail-we0-f202.google.com with SMTP id x9so134901wej.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:19:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhillf@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: return error code when initializing module
has been removed from the -mm tree.  Its filename was
     hugetlbfs-return-error-code-when-initializing-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: hugetlbfs: return error code when initializing module

Return an errno upon failure to create inode kmem cache, and unregister
the FS upon failure to mount.

[akpm@linux-foundation.org: remove unneeded test of `error']
Signed-off-by: Hillf Danton <dhillf@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-return-error-code-when-initializing-module fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-return-error-code-when-initializing-module
+++ a/fs/hugetlbfs/inode.c
@@ -1021,6 +1021,7 @@ static int __init init_hugetlbfs_fs(void
 	if (error)
 		return error;
 
+	error = -ENOMEM;
 	hugetlbfs_inode_cachep = kmem_cache_create("hugetlbfs_inode_cache",
 					sizeof(struct hugetlbfs_inode_info),
 					0, 0, init_once);
@@ -1039,10 +1040,10 @@ static int __init init_hugetlbfs_fs(void
 	}
 
 	error = PTR_ERR(vfsmount);
+	unregister_filesystem(&hugetlbfs_fs_type);
 
  out:
-	if (error)
-		kmem_cache_destroy(hugetlbfs_inode_cachep);
+	kmem_cache_destroy(hugetlbfs_inode_cachep);
  out2:
 	bdi_destroy(&hugetlbfs_backing_dev_info);
 	return error;
_

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch

