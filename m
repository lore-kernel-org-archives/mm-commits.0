From: akpm@linux-foundation.org
Subject: + nilfs2-remove-references-to-long-gone-super-operations.patch added to -mm tree
Date: Mon, 16 Jul 2012 14:29:30 -0700
Message-ID: <20120716212931.8F8A020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:51894 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab2GPV3d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jul 2012 17:29:33 -0400
Received: by mail-ee0-f74.google.com with SMTP id b47so4174eek.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Jul 2012 14:29:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fernando@oss.ntt.co.jp, konishi.ryusuke@lab.ntt.co.jp


The patch titled
     Subject: nilfs2: remove references to long gone super operations
has been added to the -mm tree.  Its filename is
     nilfs2-remove-references-to-long-gone-super-operations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Subject: nilfs2: remove references to long gone super operations

->delete_inode(), ->write_super_lockfs(), ->unlockfs() are gone so remove
references to them in the NTFS code.  Noticed while cleaning up the
fsfreeze mess.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/super.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/nilfs2/super.c~nilfs2-remove-references-to-long-gone-super-operations fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-remove-references-to-long-gone-super-operations
+++ a/fs/nilfs2/super.c
@@ -677,7 +677,6 @@ static const struct super_operations nil
 	.destroy_inode  = nilfs_destroy_inode,
 	.dirty_inode    = nilfs_dirty_inode,
 	/* .write_inode    = nilfs_write_inode, */
-	/* .put_inode      = nilfs_put_inode, */
 	/* .drop_inode	  = nilfs_drop_inode, */
 	.evict_inode    = nilfs_evict_inode,
 	.put_super      = nilfs_put_super,
@@ -685,8 +684,6 @@ static const struct super_operations nil
 	.sync_fs        = nilfs_sync_fs,
 	.freeze_fs	= nilfs_freeze,
 	.unfreeze_fs	= nilfs_unfreeze,
-	/* .write_super_lockfs */
-	/* .unlockfs */
 	.statfs         = nilfs_statfs,
 	.remount_fs     = nilfs_remount,
 	/* .umount_begin */
_
Subject: Subject: nilfs2: remove references to long gone super operations

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

nilfs2-remove-references-to-long-gone-super-operations.patch
nilfs2-fix-timing-issue-between-rmcp-and-chcp-ioctls.patch
nilfs2-fix-deadlock-issue-between-chcp-and-thaw-ioctls.patch

