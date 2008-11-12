From: akpm@linux-foundation.org
Subject: + vfs-correct-wrong-function-name-of-d_put-in-kernel-document-and-source-comment.patch added to -mm tree
Date: Wed, 12 Nov 2008 14:27:28 -0800
Message-ID: <200811122227.mACMRStn024738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752822AbYKLW1u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 17:27:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhaolei@cn.fujitsu.com, rdunlap@xenotime.net, zhaolei@cn.fuijtsu.com


The patch titled
     vfs: correct wrong function name of d_put in kernel document and source comment
has been added to the -mm tree.  Its filename is
     vfs-correct-wrong-function-name-of-d_put-in-kernel-document-and-source-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: correct wrong function name of d_put in kernel document and source comment
From: Zhaolei <zhaolei@cn.fujitsu.com>

no function named d_put(), it should be dput().

Impact: fix document and comment, no functionality changed

Signed-off-by: Zhao Lei <zhaolei@cn.fuijtsu.com>
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfs.txt |    2 +-
 fs/dcache.c                       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/filesystems/vfs.txt~vfs-correct-wrong-function-name-of-d_put-in-kernel-document-and-source-comment Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~vfs-correct-wrong-function-name-of-d_put-in-kernel-document-and-source-comment
+++ a/Documentation/filesystems/vfs.txt
@@ -931,7 +931,7 @@ manipulate dentries:
   d_lookup: look up a dentry given its parent and path name component
 	It looks up the child of that given name from the dcache
 	hash table. If it is found, the reference count is incremented
-	and the dentry is returned. The caller must use d_put()
+	and the dentry is returned. The caller must use dput()
 	to free the dentry when it finishes using it.
 
 For further information on dentry locking, please refer to the document
diff -puN fs/dcache.c~vfs-correct-wrong-function-name-of-d_put-in-kernel-document-and-source-comment fs/dcache.c
--- a/fs/dcache.c~vfs-correct-wrong-function-name-of-d_put-in-kernel-document-and-source-comment
+++ a/fs/dcache.c
@@ -1337,7 +1337,7 @@ err_out:
  *
  * Searches the children of the parent dentry for the name in question. If
  * the dentry is found its reference count is incremented and the dentry
- * is returned. The caller must use d_put to free the entry when it has
+ * is returned. The caller must use dput to free the entry when it has
  * finished using it. %NULL is returned on failure.
  *
  * __d_lookup is dcache_lock free. The hash list is protected using RCU.
_

Patches currently in -mm which might be from zhaolei@cn.fujitsu.com are

linux-next.patch
vfs-correct-wrong-function-name-of-d_put-in-kernel-document-and-source-comment.patch
forkc-cleanup-for-copy_sighand.patch

