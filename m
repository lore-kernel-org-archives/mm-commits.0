From: akpm@linux-foundation.org
Subject: + fs-reiserfs-move-prototype-declaration-to-header-file.patch
 added to -mm tree
Date: Tue, 11 Feb 2014 14:29:16 -0800
Message-ID: <52faa43c.Ga93cHcGIPJr7krI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaBKW3R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 17:29:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, josh@joshtriplett.org, rashika.kheria@gmail.com

Subject: + fs-reiserfs-move-prototype-declaration-to-header-file.patch added to -mm tree
To: rashika.kheria@gmail.com,josh@joshtriplett.org
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 14:29:16 -0800


The patch titled
     Subject: fs/reiserfs: move prototype declaration to header file
has been added to the -mm tree.  Its filename is
     fs-reiserfs-move-prototype-declaration-to-header-file.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-reiserfs-move-prototype-declaration-to-header-file.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-reiserfs-move-prototype-declaration-to-header-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: fs/reiserfs: move prototype declaration to header file

Move prototype declaration to header file reiserfs/reiserfs.h from
reiserfs/super.c because they are used by more than one file.

This eliminates the following warning in reiserfs/bitmap.c:
fs/reiserfs/bitmap.c:647:6: warning: no previous prototype for `show_alloc_options' [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/reiserfs.h |    1 +
 fs/reiserfs/super.c    |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiserfs/reiserfs.h~fs-reiserfs-move-prototype-declaration-to-header-file fs/reiserfs/reiserfs.h
--- a/fs/reiserfs/reiserfs.h~fs-reiserfs-move-prototype-declaration-to-header-file
+++ a/fs/reiserfs/reiserfs.h
@@ -2831,6 +2831,7 @@ void reiserfs_init_alloc_options(struct
  */
 __le32 reiserfs_choose_packing(struct inode *dir);
 
+void show_alloc_options(struct seq_file *seq, struct super_block *s);
 int reiserfs_init_bitmap_cache(struct super_block *sb);
 void reiserfs_free_bitmap_cache(struct super_block *sb);
 void reiserfs_cache_bitmap_metadata(struct super_block *sb, struct buffer_head *bh, struct reiserfs_bitmap_info *info);
diff -puN fs/reiserfs/super.c~fs-reiserfs-move-prototype-declaration-to-header-file fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~fs-reiserfs-move-prototype-declaration-to-header-file
+++ a/fs/reiserfs/super.c
@@ -62,7 +62,6 @@ static int is_any_reiserfs_magic_string(
 
 static int reiserfs_remount(struct super_block *s, int *flags, char *data);
 static int reiserfs_statfs(struct dentry *dentry, struct kstatfs *buf);
-void show_alloc_options(struct seq_file *seq, struct super_block *s);
 
 static int reiserfs_sync_fs(struct super_block *s, int wait)
 {
_

Patches currently in -mm which might be from rashika.kheria@gmail.com are

mm-compactionc-mark-function-as-static.patch
mm-memoryc-mark-functions-as-static.patch
mm-mmapc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static.patch
mm-page_cgroupc-mark-functions-as-static.patch
mm-nobootmemc-mark-function-as-static.patch
include-linux-mmh-remove-ifdef-condition.patch
fs-reiserfs-move-prototype-declaration-to-header-file.patch
linux-next.patch
fs-move-prototype-declaration-to-appropriate-header-file.patch

