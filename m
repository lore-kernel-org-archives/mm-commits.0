From: akpm@linux-foundation.org
Subject: [merged] hugetlbfs-remove-unregister_filesystem-when-initializing-module.patch removed from -mm tree
Date: Fri, 06 Apr 2012 11:48:55 -0700
Message-ID: <20120406184855.8F1CEA0443@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:51472 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab2DFSs5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Apr 2012 14:48:57 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so142012wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 06 Apr 2012 11:48:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhillf@gmail.com, rientjes@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: remove unregister_filesystem() when initializing module
has been removed from the -mm tree.  Its filename was
     hugetlbfs-remove-unregister_filesystem-when-initializing-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: hugetlbfs: remove unregister_filesystem() when initializing module

It was introduced by d1d5e05ffd ("hugetlbfs: return error code when
initializing module") but as Al pointed out, is a bad idea.

Quoted comments from Al.
Note that unregister_filesystem() in module init is *always* wrong; it's not
an issue here (it's done too early to care about and realistically the box
is not going anywhere - it'll panic when attempt to exec /sbin/init fails,
if not earlier), but it's a damn bad example.

Consider a normal fs module.  Somebody loads it and in parallel with that
we get a mount attempt on that fs type.  It comes between register and
failure exits that causes unregister; at that point we are screwed since
grabbing a reference to module as done by mount is enough to prevent
exit, but not to prevent the failure of init.  As the result, module will
get freed when init fails, mounted fs of that type be damned.
end of quote

So remove it.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-remove-unregister_filesystem-when-initializing-module fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-remove-unregister_filesystem-when-initializing-module
+++ a/fs/hugetlbfs/inode.c
@@ -1031,7 +1031,6 @@ static int __init init_hugetlbfs_fs(void
 	}
 
 	error = PTR_ERR(vfsmount);
-	unregister_filesystem(&hugetlbfs_fs_type);
 
  out:
 	kmem_cache_destroy(hugetlbfs_inode_cachep);
_

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
linux-next.patch
mm-hugetlbc-cleanup-to-use-long-vars-instead-of-int-in-region_count.patch

