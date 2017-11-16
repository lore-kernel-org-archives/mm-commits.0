From: akpm@linux-foundation.org
Subject: [patch 118/131] fs: fuse: account fuse_inode slab memory
 as reclaimable
Date: Wed, 15 Nov 2017 17:38:34 -0800
Message-ID: <20171116013834._ZuGrFRhX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40542 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933675AbdKPBif (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:38:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mm-commits@vger.kernel.org, mszeredi@redhat.com, torvalds@linux-foundation.org

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: fs: fuse: account fuse_inode slab memory as reclaimable

Fuse inodes are currently included in the unreclaimable slab counts -
SUnreclaim in /proc/meminfo, slab_unreclaimable in /proc/vmstat and the
per-cgroup memory.stat.  But they are reclaimable just like other
filesystems' inodes, and /proc/sys/vm/drop_caches frees them easily.

Mark the slab cache reclaimable.

Link: http://lkml.kernel.org/r/20171102202727.12539-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/inode.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/fuse/inode.c~fs-fuse-account-fuse_inode-slab-memory-as-reclaimable fs/fuse/inode.c
--- a/fs/fuse/inode.c~fs-fuse-account-fuse_inode-slab-memory-as-reclaimable
+++ a/fs/fuse/inode.c
@@ -1273,9 +1273,9 @@ static int __init fuse_fs_init(void)
 	int err;
 
 	fuse_inode_cachep = kmem_cache_create("fuse_inode",
-					      sizeof(struct fuse_inode), 0,
-					      SLAB_HWCACHE_ALIGN|SLAB_ACCOUNT,
-					      fuse_inode_init_once);
+			sizeof(struct fuse_inode), 0,
+			SLAB_HWCACHE_ALIGN|SLAB_ACCOUNT|SLAB_RECLAIM_ACCOUNT,
+			fuse_inode_init_once);
 	err = -ENOMEM;
 	if (!fuse_inode_cachep)
 		goto out;
_
