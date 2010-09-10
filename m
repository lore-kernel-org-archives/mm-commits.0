From: akpm@linux-foundation.org
Subject: + btrfs-only-bug_on-when-the-errno-is-not-enoent.patch added to -mm tree
Date: Fri, 10 Sep 2010 16:06:09 -0700
Message-ID: <201009102306.o8AN69X3008391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991Ab0IJXGV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Sep 2010 19:06:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kitayama@cl.bb4u.ne.jp, andi@firstfloor.org, chris.mason@oracle.com, vivian.zhang@intel.com, zhu.yanhai@gmail.com


The patch titled
     btrfs: only BUG_ON when the errno is not ENOENT
has been added to the -mm tree.  Its filename is
     btrfs-only-bug_on-when-the-errno-is-not-enoent.patch

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
Subject: btrfs: only BUG_ON when the errno is not ENOENT
From: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>

As Andi Kleen's commit 018db35864fd8d307066485a2753866240c3dace makes
btrfs_del_dir_entries_in_log() able to return the real errno instead of a
zero, we should only BUG_ON it when it's non-zero and not -ENOENT.

Signed-off-by: Zhu Yanhai <zhu.yanhai@gmail.com>
Cc: <zhu.yanhai@gmail.com>
Cc: <vivian.zhang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/btrfs/inode.c~btrfs-only-bug_on-when-the-errno-is-not-enoent fs/btrfs/inode.c
--- a/fs/btrfs/inode.c~btrfs-only-bug_on-when-the-errno-is-not-enoent
+++ a/fs/btrfs/inode.c
@@ -2639,7 +2639,7 @@ int btrfs_unlink_inode(struct btrfs_tran
 
 	ret = btrfs_del_dir_entries_in_log(trans, root, name, name_len,
 					   dir, index);
-	BUG_ON(ret);
+	BUG_ON(ret != 0 && ret != -ENOENT);
 err:
 	btrfs_free_path(path);
 	if (ret)
_

Patches currently in -mm which might be from kitayama@cl.bb4u.ne.jp are

btrfs-only-bug_on-when-the-errno-is-not-enoent.patch

