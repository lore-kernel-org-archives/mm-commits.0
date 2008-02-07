From: akpm@linux-foundation.org
Subject: + quota-turn-quotas-off-when-remounting-read-only.patch added to -mm tree
Date: Thu, 07 Feb 2008 10:37:07 -0800
Message-ID: <200802071836.m17IamGl015778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41103 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752306AbYBGShF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Feb 2008 13:37:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, stable@kernel.org


The patch titled
     quota: turn quotas off when remounting read-only
has been added to the -mm tree.  Its filename is
     quota-turn-quotas-off-when-remounting-read-only.patch

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
Subject: quota: turn quotas off when remounting read-only
From: Jan Kara <jack@suse.cz>

Turn off quotas before filesystem is remounted read only.  Otherwise quota
will try to write to read-only filesystem which does no good...  We could
also just refuse to remount ro when quota is enabled but turning quota off
is consistent with what we do on umount.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/super.c~quota-turn-quotas-off-when-remounting-read-only fs/super.c
--- a/fs/super.c~quota-turn-quotas-off-when-remounting-read-only
+++ a/fs/super.c
@@ -603,6 +603,7 @@ int do_remount_sb(struct super_block *sb
 			mark_files_ro(sb);
 		else if (!fs_may_remount_ro(sb))
 			return -EBUSY;
+		DQUOT_OFF(sb);
 	}
 
 	if (sb->s_op->remount_fs) {
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
use-pgoff_t-instead-of-unsigned-long.patch
write_inode_now-avoid-unnecessary-synchronous-write.patch
udf-fix-coding-style-of-superc.patch
udf-remove-some-ugly-macros.patch
udf-convert-udf_sb_alloc_partmaps-macro-to-udf_sb_alloc_partition_maps-function.patch
udf-check-if-udf_load_logicalvol-failed.patch
udf-convert-macros-related-to-bitmaps-to-functions.patch
udf-move-calculating-of-nr_groups-into-helper-function.patch
udf-fix-sparse-warnings-shadowing-mismatch-between-declaration-and-definition.patch
udf-fix-coding-style.patch
udf-create-common-function-for-tag-checksumming.patch
udf-create-common-function-for-changing-free-space-counter.patch
udf-replace-loops-coded-with-goto-to-real-loops.patch
udf-convert-byte-order-of-constant-instead-of-variable.patch
udf-remove-udf_i_-macros-and-open-code-them.patch
udf-cache-struct-udf_inode_info.patch
udf-fix-udf_debug-macro.patch
udf-improve-readability-of-udf_load_partition.patch
udf-remove-wrong-prototype-of-udf_readdir.patch
udf-fix-3-signedness-1-unitialized-variable-warnings.patch
udf-fix-signedness-issue.patch
udf-avoid-unnecessary-synchronous-writes.patch
udf-cleanup-directory-offset-handling.patch
udf-fix-adding-entry-to-a-directory.patch
change-udf-maintainer.patch
isofs-implement-dmode-option.patch
isofs-implement-dmode-option-fix.patch
mount-options-fix-ext2.patch
mount-options-fix-isofs.patch
mount-options-fix-udf.patch
buffer_head-fix-private_list-handling.patch
quota-turn-quotas-off-when-remounting-read-only.patch
