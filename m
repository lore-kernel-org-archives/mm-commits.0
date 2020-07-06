From: akpm@linux-foundation.org
Subject: [alternative-merged]
 mm-shmem-fix-freeing-new_attr-in-shmem_initxattrs.patch removed from -mm
 tree
Date: Mon, 06 Jul 2020 16:52:15 -0700
Message-ID: <20200706235215.m_7BOmk4N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726805AbgGFXwP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Jul 2020 19:52:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cgxu519@mykernel.net, mm-commits@vger.kernel.org, stable@vger.kernel.org


The patch titled
     Subject: mm/shmem: fix freeing new_attr in shmem_initxattrs()
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-freeing-new_attr-in-shmem_initxattrs.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Chengguang Xu <cgxu519@mykernel.net>
Subject: mm/shmem: fix freeing new_attr in shmem_initxattrs()

new_attr is allocated with kvmalloc() so should be freed
with kvfree().

Link: http://lkml.kernel.org/r/20200703065636.20897-1-cgxu519@mykernel.net
Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-fix-freeing-new_attr-in-shmem_initxattrs
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
