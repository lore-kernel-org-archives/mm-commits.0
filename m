From: akpm@linux-foundation.org
Subject: + vfs-use-the-predefined-d_unhashed-inline-function-instead.patch added to -mm tree
Date: Wed, 26 Sep 2007 13:20:05 -0700
Message-ID: <200709262020.l8QKK5Li002070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38722 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754115AbXIZUUh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 16:20:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: crquan@gmail.com


The patch titled
     vfs: use the predefined d_unhashed inline function instead
has been added to the -mm tree.  Its filename is
     vfs-use-the-predefined-d_unhashed-inline-function-instead.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vfs: use the predefined d_unhashed inline function instead
From: Denis Cheng <crquan@gmail.com>

Signed-off-by: Denis Cheng <crquan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/dcache.c~vfs-use-the-predefined-d_unhashed-inline-function-instead fs/dcache.c
--- a/fs/dcache.c~vfs-use-the-predefined-d_unhashed-inline-function-instead
+++ a/fs/dcache.c
@@ -1546,7 +1546,7 @@ static void d_move_locked(struct dentry 
 	}
 
 	/* Move the dentry to the target hash queue, if on different bucket */
-	if (dentry->d_flags & DCACHE_UNHASHED)
+	if (d_unhashed(dentry))
 		goto already_unhashed;
 
 	hlist_del_rcu(&dentry->d_hash);
_

Patches currently in -mm which might be from crquan@gmail.com are

git-gfs2-nmw.patch
git-net.patch
nbd-use-list_for_each_entry_safe-to-make-it-more-consolidated-and-readable.patch
nbd-change-a-parameters-type-to-remove-a-memcpy-call.patch
fs-use-kmem_cache_zalloc-instead.patch
fs-remove-the-unused-mempages-parameter.patch
vfs-use-the-predefined-d_unhashed-inline-function-instead.patch
documentation-add-entries-to-filesystems-00-index-for-several-untracked-files.patch
