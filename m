From: akpm@linux-foundation.org
Subject: + hugetlbfs-remove-unregister_filesystem-when-initializing-module.patch added to -mm tree
Date: Wed, 28 Mar 2012 12:22:52 -0700
Message-ID: <20120328192254.9CF34A00AA@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:62239 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab2C1TW4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Mar 2012 15:22:56 -0400
Received: by ghbz15 with SMTP id z15so175382ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Mar 2012 12:22:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhillf@gmail.com, rientjes@google.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: hugetlbfs: remove unregister_filesystem() when initializing module
has been added to the -mm tree.  Its filename is
     hugetlbfs-remove-unregister_filesystem-when-initializing-module.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: hugetlbfs: remove unregister_filesystem() when initializing module

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
hugetlbfs-remove-unregister_filesystem-when-initializing-module.patch

