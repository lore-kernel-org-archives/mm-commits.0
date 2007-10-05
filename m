From: akpm@linux-foundation.org
Subject: + reiserfs-do-not-repair-wrong-journal-params.patch added to -mm tree
Date: Fri, 05 Oct 2007 16:46:22 -0700
Message-ID: <200710052346.l95NkMfd031175@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50984 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760290AbXJEXrF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 19:47:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward@namesys.com, chris.mason@oracle.com, jeffm@suse.com


The patch titled
     reiserfs: do not repair wrong journal params
has been added to the -mm tree.  Its filename is
     reiserfs-do-not-repair-wrong-journal-params.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiserfs: do not repair wrong journal params
From: Edward Shishkin <edward@namesys.com>

When mounting a file system with wrong journal params do not try to repair
them, suggest fsck instead.

Signed-off-by: Edward Shishkin <edward@namesys.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/reiserfs/journal.c~reiserfs-do-not-repair-wrong-journal-params fs/reiserfs/journal.c
--- a/fs/reiserfs/journal.c~reiserfs-do-not-repair-wrong-journal-params
+++ a/fs/reiserfs/journal.c
@@ -2649,6 +2649,61 @@ static int journal_init_dev(struct super
 	return result;
 }
 
+/**
+ * When creating/tuning a file system user can assign some
+ * journal params within boundaries which depend on the ratio
+ * blocksize/standard_blocksize.
+ *
+ * For blocks >= standard_blocksize transaction size should
+ * be not less then JOURNAL_TRANS_MIN_DEFAULT, and not more
+ * then JOURNAL_TRANS_MAX_DEFAULT.
+ *
+ * For blocks < standard_blocksize these boundaries should be
+ * decreased proportionally.
+ */
+#define REISERFS_STANDARD_BLKSIZE (4096)
+
+static int check_advise_trans_params(struct super_block *p_s_sb,
+				     struct reiserfs_journal *journal)
+{
+        if (journal->j_trans_max) {
+	        /* Non-default journal params.
+		   Do sanity check for them. */
+	        int ratio = 1;
+		if (p_s_sb->s_blocksize < REISERFS_STANDARD_BLKSIZE)
+		        ratio = REISERFS_STANDARD_BLKSIZE / p_s_sb->s_blocksize;
+
+		if (journal->j_trans_max > JOURNAL_TRANS_MAX_DEFAULT / ratio ||
+		    journal->j_trans_max < JOURNAL_TRANS_MIN_DEFAULT / ratio ||
+		    SB_ONDISK_JOURNAL_SIZE(p_s_sb) / journal->j_trans_max <
+		    JOURNAL_MIN_RATIO) {
+		        reiserfs_warning(p_s_sb,
+				 "sh-462: bad transaction max size (%u). FSCK?",
+				 journal->j_trans_max);
+			return 1;
+		}
+		if (journal->j_max_batch != (journal->j_trans_max) *
+		        JOURNAL_MAX_BATCH_DEFAULT/JOURNAL_TRANS_MAX_DEFAULT) {
+		        reiserfs_warning(p_s_sb,
+				"sh-463: bad transaction max batch (%u). FSCK?",
+				journal->j_max_batch);
+			return 1;
+		}
+	} else {
+		/* Default journal params.
+                   The file system was created by old version
+		   of mkreiserfs, so some fields contain zeros,
+		   and we need to advise proper values for them */
+	        if (p_s_sb->s_blocksize != REISERFS_STANDARD_BLKSIZE)
+	                reiserfs_panic(p_s_sb, "sh-464: bad blocksize (%u)",
+				       p_s_sb->s_blocksize);
+		journal->j_trans_max = JOURNAL_TRANS_MAX_DEFAULT;
+		journal->j_max_batch = JOURNAL_MAX_BATCH_DEFAULT;
+		journal->j_max_commit_age = JOURNAL_MAX_COMMIT_AGE;
+	}
+	return 0;
+}
+
 /*
 ** must be called once on fs mount.  calls journal_read for you
 */
@@ -2744,49 +2799,8 @@ int journal_init(struct super_block *p_s
 	    le32_to_cpu(jh->jh_journal.jp_journal_max_commit_age);
 	journal->j_max_trans_age = JOURNAL_MAX_TRANS_AGE;
 
-	if (journal->j_trans_max) {
-		/* make sure these parameters are available, assign it if they are not */
-		__u32 initial = journal->j_trans_max;
-		__u32 ratio = 1;
-
-		if (p_s_sb->s_blocksize < 4096)
-			ratio = 4096 / p_s_sb->s_blocksize;
-
-		if (SB_ONDISK_JOURNAL_SIZE(p_s_sb) / journal->j_trans_max <
-		    JOURNAL_MIN_RATIO)
-			journal->j_trans_max =
-			    SB_ONDISK_JOURNAL_SIZE(p_s_sb) / JOURNAL_MIN_RATIO;
-		if (journal->j_trans_max > JOURNAL_TRANS_MAX_DEFAULT / ratio)
-			journal->j_trans_max =
-			    JOURNAL_TRANS_MAX_DEFAULT / ratio;
-		if (journal->j_trans_max < JOURNAL_TRANS_MIN_DEFAULT / ratio)
-			journal->j_trans_max =
-			    JOURNAL_TRANS_MIN_DEFAULT / ratio;
-
-		if (journal->j_trans_max != initial)
-			reiserfs_warning(p_s_sb,
-					 "sh-461: journal_init: wrong transaction max size (%u). Changed to %u",
-					 initial, journal->j_trans_max);
-
-		journal->j_max_batch = journal->j_trans_max *
-		    JOURNAL_MAX_BATCH_DEFAULT / JOURNAL_TRANS_MAX_DEFAULT;
-	}
-
-	if (!journal->j_trans_max) {
-		/*we have the file system was created by old version of mkreiserfs 
-		   so this field contains zero value */
-		journal->j_trans_max = JOURNAL_TRANS_MAX_DEFAULT;
-		journal->j_max_batch = JOURNAL_MAX_BATCH_DEFAULT;
-		journal->j_max_commit_age = JOURNAL_MAX_COMMIT_AGE;
-
-		/* for blocksize >= 4096 - max transaction size is 1024. For block size < 4096
-		   trans max size is decreased proportionally */
-		if (p_s_sb->s_blocksize < 4096) {
-			journal->j_trans_max /= (4096 / p_s_sb->s_blocksize);
-			journal->j_max_batch = (journal->j_trans_max) * 9 / 10;
-		}
-	}
-
+	if (check_advise_trans_params(p_s_sb, journal) != 0)
+	        goto free_and_return;
 	journal->j_default_max_commit_age = journal->j_max_commit_age;
 
 	if (commit_max_age != 0) {
_

Patches currently in -mm which might be from edward@namesys.com are

reiserfs-do-not-repair-wrong-journal-params.patch
reiser4.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
reiser4-fix-null-dereference-in-__mnt_is_readonly-in-ftruncate.patch
reiser4-fix-extent2tail.patch
reiser4-fix-read_tail.patch
reiser4-fix-unix-file-readpages-filler.patch
reiser4-fix-readpage_unix_file.patch
reiser4-fix-for-new-aops-patches.patch
git-block-vs-reiser4.patch
reiser4-cryptcompress-misc-fixups.patch
reiser4-cryptcompress-misc-fixups-2.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
reiser4-change-error-code-base.patch
reiser4-use-lzo-library-functions.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
git-nfsd-broke-reiser4.patch
reiser4-do-not-allocate-struct-file-on-stack.patch
