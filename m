From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 vfs-xattr-mm-shmem-kernfs-release-simple-xattr-entry-in-a-right-way.patch
 added to -mm tree
Date: Mon, 06 Jul 2020 16:50:22 -0700
Message-ID: <20200706235022.Xujoc1zol%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726280AbgGFXuZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Jul 2020 19:50:25 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adilger@dilger.ca, cgxu519@mykernel.net, chris@chrisdown.name, dxu@dxuuu.xyz, gregkh@linuxfoundation.org, hughd@google.com, mm-commits@vger.kernel.org, stable@vger.kernel.org, tj@kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: vfs/xattr: mm/shmem: kernfs: release simple xattr entry in a right way
has been added to the -mm tree.  Its filename is
     vfs-xattr-mm-shmem-kernfs-release-simple-xattr-entry-in-a-right-way.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vfs-xattr-mm-shmem-kernfs-release-simple-xattr-entry-in-a-right-way.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vfs-xattr-mm-shmem-kernfs-release-simple-xattr-entry-in-a-right-way.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chengguang Xu <cgxu519@mykernel.net>
Subject: vfs/xattr: mm/shmem: kernfs: release simple xattr entry in a right way

After commit fdc85222d58e ("kernfs: kvmalloc xattr value instead of
kmalloc"), simple xattr entry is allocated with kvmalloc() instead of
kmalloc(), so we should release it with kvfree() instead of kfree().

Link: http://lkml.kernel.org/r/20200704051608.15043-1-cgxu519@mykernel.net
Fixes: fdc85222d58e ("kernfs: kvmalloc xattr value instead of kmalloc")
Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Daniel Xu <dxu@dxuuu.xyz>
Cc: Chris Down <chris@chrisdown.name>
Cc: Andreas Dilger <adilger@dilger.ca>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>	[5.7]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/xattr.h |    3 ++-
 mm/shmem.c            |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/xattr.h~vfs-xattr-mm-shmem-kernfs-release-simple-xattr-entry-in-a-right-way
+++ a/include/linux/xattr.h
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/spinlock.h>
+#include <linux/mm.h>
 #include <uapi/linux/xattr.h>
 
 struct inode;
@@ -94,7 +95,7 @@ static inline void simple_xattrs_free(st
 
 	list_for_each_entry_safe(xattr, node, &xattrs->head, list) {
 		kfree(xattr->name);
-		kfree(xattr);
+		kvfree(xattr);
 	}
 }
 
--- a/mm/shmem.c~vfs-xattr-mm-shmem-kernfs-release-simple-xattr-entry-in-a-right-way
+++ a/mm/shmem.c
@@ -3178,7 +3178,7 @@ static int shmem_initxattrs(struct inode
 		new_xattr->name = kmalloc(XATTR_SECURITY_PREFIX_LEN + len,
 					  GFP_KERNEL);
 		if (!new_xattr->name) {
-			kfree(new_xattr);
+			kvfree(new_xattr);
 			return -ENOMEM;
 		}
 
_

Patches currently in -mm which might be from cgxu519@mykernel.net are

vfs-xattr-mm-shmem-kernfs-release-simple-xattr-entry-in-a-right-way.patch
mm-shmem-fix-freeing-new_attr-in-shmem_initxattrs.patch
