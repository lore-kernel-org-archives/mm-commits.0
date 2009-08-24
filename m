From: akpm@linux-foundation.org
Subject: + fs-improve-remountro-vs-buffercache-coherency.patch added to -mm tree
Date: Mon, 24 Aug 2009 14:59:35 -0700
Message-ID: <200908242159.n7OLxZlL026178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753495AbZHXV7l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 17:59:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, jorge@dti2.net, viro@zeniv.linux.org.uk


The patch titled
     fs: improve remount,ro vs buffercache coherency
has been added to the -mm tree.  Its filename is
     fs-improve-remountro-vs-buffercache-coherency.patch

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
Subject: fs: improve remount,ro vs buffercache coherency
From: Nick Piggin <npiggin@suse.de>

Invalidate sb->s_bdev on remount,ro.

Fixes a problem reported by Jorge Boncompte who is seeing corruption
trying to snapshot a minix filesystem image.  Some filesystems modify
their metadata via a path other than the bdev buffer cache (eg.  they may
use a private linear mapping for their metadata, or implement directories
in pagecache, etc).  Also, file data modifications usually go to the bdev
via their own mappings.

These updates are not coherent with buffercache IO (eg.  via /dev/bdev)
and never have been.  However there could be a reasonable expectation that
after a mount -oremount,ro operation then the buffercache should
subsequently be coherent with previous filesystem modifications.

So invalidate the bdev mappings on a remount,ro operation to provide a
coherency point.

The problem was exposed when we switched the old rd to brd because old rd
didn't really function like a normal block device and updates to rd via
mappings other than the buffercache would still end up going into its
buffercache.  But the same problem has always affected other "normal"
block devices, including loop.

Reported-by: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
Tested-by: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff -puN fs/super.c~fs-improve-remountro-vs-buffercache-coherency fs/super.c
--- a/fs/super.c~fs-improve-remountro-vs-buffercache-coherency
+++ a/fs/super.c
@@ -527,7 +527,7 @@ out:
 int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 {
 	int retval;
-	int remount_rw;
+	int remount_rw, remount_ro;
 	
 #ifdef CONFIG_BLOCK
 	if (!(flags & MS_RDONLY) && bdev_read_only(sb->s_bdev))
@@ -538,9 +538,12 @@ int do_remount_sb(struct super_block *sb
 	shrink_dcache_sb(sb);
 	sync_filesystem(sb);
 
+	remount_ro = (flags & MS_RDONLY) && !(sb->s_flags & MS_RDONLY);
+	remount_rw = !(flags & MS_RDONLY) && (sb->s_flags & MS_RDONLY);
+
 	/* If we are remounting RDONLY and current sb is read/write,
 	   make sure there are no rw files opened */
-	if ((flags & MS_RDONLY) && !(sb->s_flags & MS_RDONLY)) {
+	if (remount_ro) {
 		if (force)
 			mark_files_ro(sb);
 		else if (!fs_may_remount_ro(sb))
@@ -549,7 +552,6 @@ int do_remount_sb(struct super_block *sb
 		if (retval < 0 && retval != -ENOSYS)
 			return -EBUSY;
 	}
-	remount_rw = !(flags & MS_RDONLY) && (sb->s_flags & MS_RDONLY);
 
 	if (sb->s_op->remount_fs) {
 		retval = sb->s_op->remount_fs(sb, &flags, data);
@@ -559,6 +561,14 @@ int do_remount_sb(struct super_block *sb
 	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
 	if (remount_rw)
 		vfs_dq_quota_on_remount(sb);
+	 /* Some filesystems modify their metadata via some other path
+	    than the bdev buffer cache (eg. use a private mapping, or
+	    directories in pagecache, etc). Also file data modifications
+	    go via their own mappings. So If we try to mount readonly
+	    then copy the filesystem from bdev, we could get stale data,
+	    so invalidate it to give a best effort at coherency. */
+	if (remount_ro && sb->s_bdev)
+		invalidate_bdev(sb->s_bdev);
 	return 0;
 }
 
_

Patches currently in -mm which might be from npiggin@suse.de are

linux-next.patch
fs-remove-unneeded-dcache_unhashed-tricks.patch
fs-improve-remountro-vs-buffercache-coherency.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention-fix.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
ksm-no-debug-in-page_dup_rmap.patch
fs-turn-iprune_mutex-into-rwsem.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

