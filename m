From: akpm@linux-foundation.org
Subject: + reiserfs-replace-remaining-__function__-occurrences.patch added to -mm tree
Date: Wed, 05 Mar 2008 14:20:38 -0800
Message-ID: <200803052220.m25MKcaE024025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758535AbYCEWah (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 17:30:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, chris.mason@oracle.com, jeffm@suse.com


The patch titled
     reiserfs: replace remaining __FUNCTION__ occurrences
has been added to the -mm tree.  Its filename is
     reiserfs-replace-remaining-__function__-occurrences.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-x86.patch
git-alsa.patch
sound-replace-remaining-__function__-occurences.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
arm-replace-remaining-__function__-occurences.patch
cifs-remove-global_extern-macro.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
ia64-remove-remaining-__function__-occurences.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
mips-replace-remaining-__function__-occurences.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
blackfin-replace-remaining-__function__-occurences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
sh-replace-remaining-__function__-occurences.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
kernel-add-clamp-and-clamp_t-macros.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
xen-make-blkif_getgeo-static.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
security-replace-remaining-__function__-occurences.patch
security-replace-remaining-__function__-occurences-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
ext2-replace-remaining-__function__-occurrences.patch
ext3-replace-remaining-__function__-occurrences.patch
ext4-replace-remaining-__function__-occurrences.patch
nfs-replace-remaining-__function__-occurrences.patch
xfs-replace-remaining-__function__-occurrences.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
cifs-replace-remaining-__function__-occurrences.patch
reiserfs-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch

