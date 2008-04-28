From: akpm@linux-foundation.org
Subject: - reiserfs-replace-remaining-__function__-occurrences.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:01:21 -0700
Message-ID: <200804282201.m3SM1LX3018854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965787AbYD1WBg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:01:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, chris.mason@oracle.com, jeffm@suse.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     reiserfs-replace-remaining-__function__-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/bitmap.c   |    8 ++++----
 fs/reiserfs/journal.c  |    8 ++++----
 fs/reiserfs/namei.c    |    8 ++++----
 fs/reiserfs/objectid.c |    2 +-
 4 files changed, 13 insertions(+), 13 deletions(-)

diff -puN fs/reiserfs/bitmap.c~reiserfs-replace-remaining-__function__-occurrences fs/reiserfs/bitmap.c
--- a/fs/reiserfs/bitmap.c~reiserfs-replace-remaining-__function__-occurrences
+++ a/fs/reiserfs/bitmap.c
@@ -479,7 +479,7 @@ static void __discard_prealloc(struct re
 	if (ei->i_prealloc_count < 0)
 		reiserfs_warning(th->t_super,
 				 "zam-4001:%s: inode has negative prealloc blocks count.",
-				 __FUNCTION__);
+				 __func__);
 #endif
 	while (ei->i_prealloc_count > 0) {
 		reiserfs_free_prealloc_block(th, inode, ei->i_prealloc_block);
@@ -517,7 +517,7 @@ void reiserfs_discard_all_prealloc(struc
 		if (!ei->i_prealloc_count) {
 			reiserfs_warning(th->t_super,
 					 "zam-4001:%s: inode is in prealloc list but has no preallocated blocks.",
-					 __FUNCTION__);
+					 __func__);
 		}
 #endif
 		__discard_prealloc(th, ei);
@@ -632,7 +632,7 @@ int reiserfs_parse_alloc_options(struct 
 		}
 
 		reiserfs_warning(s, "zam-4001: %s : unknown option - %s",
-				 __FUNCTION__, this_char);
+				 __func__, this_char);
 		return 1;
 	}
 
@@ -1254,7 +1254,7 @@ struct buffer_head *reiserfs_read_bitmap
 	bh = sb_bread(sb, block);
 	if (bh == NULL)
 		reiserfs_warning(sb, "sh-2029: %s: bitmap block (#%u) "
-		                 "reading failed", __FUNCTION__, block);
+		                 "reading failed", __func__, block);
 	else {
 		if (buffer_locked(bh)) {
 			PROC_INFO_INC(sb, scan_bitmap.wait);
diff -puN fs/reiserfs/journal.c~reiserfs-replace-remaining-__function__-occurrences fs/reiserfs/journal.c
--- a/fs/reiserfs/journal.c~reiserfs-replace-remaining-__function__-occurrences
+++ a/fs/reiserfs/journal.c
@@ -1187,7 +1187,7 @@ static int flush_commit_list(struct supe
 
 	if (retval)
 		reiserfs_abort(s, retval, "Journal write error in %s",
-			       __FUNCTION__);
+			       __func__);
 	put_fs_excl();
 	return retval;
 }
@@ -1534,7 +1534,7 @@ static int flush_journal_list(struct sup
 			reiserfs_warning(s,
 					 "clm-2082: Unable to flush buffer %llu in %s",
 					 (unsigned long long)saved_bh->
-					 b_blocknr, __FUNCTION__);
+					 b_blocknr, __func__);
 		}
 	      free_cnode:
 		last = cn;
@@ -1586,7 +1586,7 @@ static int flush_journal_list(struct sup
 	if (err)
 		reiserfs_abort(s, -EIO,
 			       "Write error while pushing transaction to disk in %s",
-			       __FUNCTION__);
+			       __func__);
       flush_older_and_return:
 
 	/* before we can update the journal header block, we _must_ flush all 
@@ -1616,7 +1616,7 @@ static int flush_journal_list(struct sup
 		if (err)
 			reiserfs_abort(s, -EIO,
 				       "Write error while updating journal header in %s",
-				       __FUNCTION__);
+				       __func__);
 	}
 	remove_all_from_journal_list(s, jl, 0);
 	list_del_init(&jl->j_list);
diff -puN fs/reiserfs/namei.c~reiserfs-replace-remaining-__function__-occurrences fs/reiserfs/namei.c
--- a/fs/reiserfs/namei.c~reiserfs-replace-remaining-__function__-occurrences
+++ a/fs/reiserfs/namei.c
@@ -301,7 +301,7 @@ static int reiserfs_find_entry(struct in
 					path_to_entry, de);
 		if (retval == IO_ERROR) {
 			reiserfs_warning(dir->i_sb, "zam-7001: io error in %s",
-					 __FUNCTION__);
+					 __func__);
 			return IO_ERROR;
 		}
 
@@ -496,7 +496,7 @@ static int reiserfs_add_entry(struct rei
 			reiserfs_warning(dir->i_sb,
 					 "zam-7002:%s: \"reiserfs_find_entry\" "
 					 "has returned unexpected value (%d)",
-					 __FUNCTION__, retval);
+					 __func__, retval);
 		}
 
 		return -EEXIST;
@@ -907,7 +907,7 @@ static int reiserfs_rmdir(struct inode *
 
 	if (inode->i_nlink != 2 && inode->i_nlink != 1)
 		reiserfs_warning(inode->i_sb, "%s: empty directory has nlink "
-				 "!= 2 (%d)", __FUNCTION__, inode->i_nlink);
+				 "!= 2 (%d)", __func__, inode->i_nlink);
 
 	clear_nlink(inode);
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME_SEC;
@@ -984,7 +984,7 @@ static int reiserfs_unlink(struct inode 
 
 	if (!inode->i_nlink) {
 		reiserfs_warning(inode->i_sb, "%s: deleting nonexistent file "
-				 "(%s:%lu), %d", __FUNCTION__,
+				 "(%s:%lu), %d", __func__,
 				 reiserfs_bdevname(inode->i_sb), inode->i_ino,
 				 inode->i_nlink);
 		inode->i_nlink = 1;
diff -puN fs/reiserfs/objectid.c~reiserfs-replace-remaining-__function__-occurrences fs/reiserfs/objectid.c
--- a/fs/reiserfs/objectid.c~reiserfs-replace-remaining-__function__-occurrences
+++ a/fs/reiserfs/objectid.c
@@ -61,7 +61,7 @@ __u32 reiserfs_get_unused_objectid(struc
 	/* comment needed -Hans */
 	unused_objectid = le32_to_cpu(map[1]);
 	if (unused_objectid == U32_MAX) {
-		reiserfs_warning(s, "%s: no more object ids", __FUNCTION__);
+		reiserfs_warning(s, "%s: no more object ids", __func__);
 		reiserfs_restore_prepared_buffer(s, SB_BUFFER_WITH_SB(s));
 		return 0;
 	}
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
git-nfsd.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
power-replace-remaining-__function__-occurrences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
kernel-add-common-infrastructure-for-unaligned-access.patch
kernel-move-arches-to-use-common-unaligned-access.patch
drivers-block-use-get_unaligned_-helpers.patch
hid-core-use-get_unaligned_-helpers.patch
char-use-get_unaligned_-helpers.patch
input-use-get_unaligned_-helpers.patch
mmc-use-get-put_unaligned_-helpers.patch
net-use-get-put_unaligned_-helpers.patch
wireless-use-get-put_unaligned_-helpers.patch
pcmcia-use-get-put_unaligned_-helpers.patch
usb-use-get-put_unaligned_-helpers.patch
video-use-get-put_unaligned_-helpers.patch
fat-use-get-put_unaligned_-helpers.patch
hfsplus-use-get-put_unaligned_-helpers.patch
isofs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

