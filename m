From: akpm@linux-foundation.org
Subject: + mm-shmem-fix-freeing-new_attr-in-shmem_initxattrs.patch
 added to -mm tree
Date: Fri, 03 Jul 2020 12:20:46 -0700
Message-ID: <20200703192046.vw7STmQB6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbgGCTUr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Jul 2020 15:20:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cgxu519@mykernel.net, mm-commits@vger.kernel.org, stable@vger.kernel.org


The patch titled
     Subject: mm/shmem: fix freeing new_attr in shmem_initxattrs()
has been added to the -mm tree.  Its filename is
     mm-shmem-fix-freeing-new_attr-in-shmem_initxattrs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-shmem-fix-freeing-new_attr-in-shmem_initxattrs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem-fix-freeing-new_attr-in-shmem_initxattrs.patch

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

mm-shmem-fix-freeing-new_attr-in-shmem_initxattrs.patch
