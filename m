From: akpm@linux-foundation.org
Subject: + jbd-fix-commit-block-write.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:15:10 -0800
Message-ID: <200801270515.m0R5F73m031037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55050 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751196AbYA0FPL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:15:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz


The patch titled
     jbd: fix commit block write
has been added to the -mm tree.  Its filename is
     jbd-fix-commit-block-write.patch

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
Subject: jbd: fix commit block write
From: Jan Kara <jack@suse.cz>

Commit block is expected to have several copies of the header.  Fix the bug
Andrew has spotted ages ago.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/commit.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/jbd/commit.c~jbd-fix-commit-block-write fs/jbd/commit.c
--- a/fs/jbd/commit.c~jbd-fix-commit-block-write
+++ a/fs/jbd/commit.c
@@ -116,9 +116,8 @@ static int journal_write_commit_record(j
 
 	bh = jh2bh(descriptor);
 
-	/* AKPM: buglet - add `i' to tmp! */
 	for (i = 0; i < bh->b_size; i += 512) {
-		journal_header_t *tmp = (journal_header_t*)bh->b_data;
+		journal_header_t *tmp = (journal_header_t*)(bh->b_data+i);
 		tmp->h_magic = cpu_to_be32(JFS_MAGIC_NUMBER);
 		tmp->h_blocktype = cpu_to_be32(JFS_COMMIT_BLOCK);
 		tmp->h_sequence = cpu_to_be32(commit_transaction->t_tid);
_

Patches currently in -mm which might be from jack@suse.cz are

git-ocfs2.patch
inotify-send-in_attrib-events-when-link-count-changes.patch
inotify-send-in_attrib-events-when-link-count-changes-fix.patch
quota-improve-inode-list-scanning-in-add_dquot_ref.patch
quota-improve-inode-list-scanning-in-add_dquot_ref-fix.patch
jbd-fix-commit-block-write.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
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
isofs-implement-dmode-option.patch
