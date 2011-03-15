From: akpm@linux-foundation.org
Subject: + vfs-fix-null-pointer-oops-in-sync_inodes_sb.patch added to -mm tree
Date: Tue, 15 Mar 2011 15:03:06 -0700
Message-ID: <201103152203.p2FM36ue014637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756163Ab1COWDk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Mar 2011 18:03:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axboe@kernel.dk, aia21@cam.ac.uk, biessmann@corscience.de, hch@lst.de, linux@horizon.com, sergey.senozhatsky@gmail.com, stable@kernel.org, torsten.hilbrich@secunet.com


The patch titled
     vfs: fix null pointer OOPS in sync_inodes_sb()
has been added to the -mm tree.  Its filename is
     vfs-fix-null-pointer-oops-in-sync_inodes_sb.patch

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
Subject: vfs: fix null pointer OOPS in sync_inodes_sb()
From: Jens Axboe <axboe@kernel.dk>

When we move the potential dirty list entries to the
default_backing_dev_info, reassign the sb->s_bdi as well. 
default_backing_dev_info will always be around.  I hope this can fix it up
for 2.6.38 and we can add the proper ref counting for .39.

Cc: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: George Spelvin <linux@horizon.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Andreas Biemann <biessmann@corscience.de>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Tested-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Cc: <stable@kernel.org>		[2.6.38.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c       |    2 ++
 fs/sync.c        |    4 ++--
 mm/backing-dev.c |    2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff -puN fs/super.c~vfs-fix-null-pointer-oops-in-sync_inodes_sb fs/super.c
--- a/fs/super.c~vfs-fix-null-pointer-oops-in-sync_inodes_sb
+++ a/fs/super.c
@@ -72,6 +72,7 @@ static struct super_block *alloc_super(s
 #else
 		INIT_LIST_HEAD(&s->s_files);
 #endif
+		s->s_bdi = &default_backing_dev_info;
 		INIT_LIST_HEAD(&s->s_instances);
 		INIT_HLIST_BL_HEAD(&s->s_anon);
 		INIT_LIST_HEAD(&s->s_inodes);
@@ -1006,6 +1007,7 @@ vfs_kern_mount(struct file_system_type *
 	}
 	BUG_ON(!mnt->mnt_sb);
 	WARN_ON(!mnt->mnt_sb->s_bdi);
+	WARN_ON(mnt->mnt_sb->s_bdi == &default_backing_dev_info);
 	mnt->mnt_sb->s_flags |= MS_BORN;
 
 	error = security_sb_kern_mount(mnt->mnt_sb, flags, secdata);
diff -puN fs/sync.c~vfs-fix-null-pointer-oops-in-sync_inodes_sb fs/sync.c
--- a/fs/sync.c~vfs-fix-null-pointer-oops-in-sync_inodes_sb
+++ a/fs/sync.c
@@ -33,7 +33,7 @@ static int __sync_filesystem(struct supe
 	 * This should be safe, as we require bdi backing to actually
 	 * write out data in the first place
 	 */
-	if (!sb->s_bdi || sb->s_bdi == &noop_backing_dev_info)
+	if (sb->s_bdi == &noop_backing_dev_info)
 		return 0;
 
 	if (sb->s_qcop && sb->s_qcop->quota_sync)
@@ -79,7 +79,7 @@ EXPORT_SYMBOL_GPL(sync_filesystem);
 
 static void sync_one_sb(struct super_block *sb, void *arg)
 {
-	if (!(sb->s_flags & MS_RDONLY) && sb->s_bdi)
+	if (!(sb->s_flags & MS_RDONLY))
 		__sync_filesystem(sb, *(int *)arg);
 }
 /*
diff -puN mm/backing-dev.c~vfs-fix-null-pointer-oops-in-sync_inodes_sb mm/backing-dev.c
--- a/mm/backing-dev.c~vfs-fix-null-pointer-oops-in-sync_inodes_sb
+++ a/mm/backing-dev.c
@@ -598,7 +598,7 @@ static void bdi_prune_sb(struct backing_
 	spin_lock(&sb_lock);
 	list_for_each_entry(sb, &super_blocks, s_list) {
 		if (sb->s_bdi == bdi)
-			sb->s_bdi = NULL;
+			sb->s_bdi = &default_backing_dev_info;
 	}
 	spin_unlock(&sb_lock);
 }
_

Patches currently in -mm which might be from axboe@kernel.dk are

linux-next.patch
vfs-fix-null-pointer-oops-in-sync_inodes_sb.patch
drbd-fix-warning.patch
fs-use-appropriate-printk-priority-level.patch
fsh-remove-8-bytes-of-padding-from-block_device-on-64bit-builds.patch
scatterlist-new-helper-functions.patch

