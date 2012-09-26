From: akpm@linux-foundation.org
Subject: + fs-debugsfs-remove-unnecessary-inode-i_private-initialization.patch added to -mm tree
Date: Wed, 26 Sep 2012 13:17:59 -0700
Message-ID: <20120926201800.0C5065C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:56270 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2IZUSC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Sep 2012 16:18:02 -0400
Received: by eekb57 with SMTP id b57so75741eek.1
        for <mm-commits@vger.kernel.org>; Wed, 26 Sep 2012 13:18:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clouds.yan@gmail.com, greg@kroah.com


The patch titled
     Subject: fs/debugsfs: remove unnecessary inode->i_private initialization
has been added to the -mm tree.  Its filename is
     fs-debugsfs-remove-unnecessary-inode-i_private-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yan Hong <clouds.yan@gmail.com>
Subject: fs/debugsfs: remove unnecessary inode->i_private initialization

inode->i_private is promised to be NULL on allocation, no need to set it
explicitly.

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/debugfs/inode.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/debugfs/inode.c~fs-debugsfs-remove-unnecessary-inode-i_private-initialization fs/debugfs/inode.c
--- a/fs/debugfs/inode.c~fs-debugsfs-remove-unnecessary-inode-i_private-initialization
+++ a/fs/debugfs/inode.c
@@ -59,7 +59,6 @@ static struct inode *debugfs_get_inode(s
 		case S_IFDIR:
 			inode->i_op = &simple_dir_inode_operations;
 			inode->i_fop = &simple_dir_operations;
-			inode->i_private = NULL;
 
 			/* directory inodes start off with i_nlink == 2
 			 * (for "." entry) */
_

Patches currently in -mm which might be from clouds.yan@gmail.com are

fs-debugsfs-remove-unnecessary-inode-i_private-initialization.patch
fs-block_devc-need-not-to-check-inode-i_bdev-in-bd_forget.patch
proc-return-enomem-when-inode-allocation-failed.patch
proc-no-need-to-initialize-proc_inode-fd-in-proc_get_inode.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch

