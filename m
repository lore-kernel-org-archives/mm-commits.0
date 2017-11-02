From: akpm@linux-foundation.org
Subject: + fs-fuse-account-fuse_inode-slab-memory-as-reclaimable.patch
 added to -mm tree
Date: Thu, 02 Nov 2017 13:58:01 -0700
Message-ID: <59fb86d9.p3be6w6x6TaVB7PT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59546 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934407AbdKBU6C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Nov 2017 16:58:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mszeredi@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: fuse: account fuse_inode slab memory as reclaimable
has been added to the -mm tree.  Its filename is
     fs-fuse-account-fuse_inode-slab-memory-as-reclaimable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-fuse-account-fuse_inode-slab-memory-as-reclaimable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-fuse-account-fuse_inode-slab-memory-as-reclaimable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from hannes@cmpxchg.org are

fs-fuse-account-fuse_inode-slab-memory-as-reclaimable.patch

