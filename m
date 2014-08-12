From: akpm@linux-foundation.org
Subject: [merged] fs-reiserfs-replace-not-standard-%lu-%ld.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:39:34 -0700
Message-ID: <53ea6d76.WbKEl1z5FQKjC8yu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:46255 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbaHLTjf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:39:35 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so1918999oah.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:39:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jeffm@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/reiserfs: replace not-standard %Lu/%Ld
has been removed from the -mm tree.  Its filename was
     fs-reiserfs-replace-not-standard-%lu-%ld.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/reiserfs: replace not-standard %Lu/%Ld

Fixes checkpatch warnings:

"WARNING: %Ld/%Lu are not-standard C, use %lld/%llu"

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/item_ops.c |    4 ++--
 fs/reiserfs/prints.c   |    4 ++--
 fs/reiserfs/stree.c    |    2 +-
 fs/reiserfs/super.c    |    7 +++----
 4 files changed, 8 insertions(+), 9 deletions(-)

diff -puN fs/reiserfs/item_ops.c~fs-reiserfs-replace-not-standard-%lu-%ld fs/reiserfs/item_ops.c
--- a/fs/reiserfs/item_ops.c~fs-reiserfs-replace-not-standard-%lu-%ld
+++ a/fs/reiserfs/item_ops.c
@@ -54,7 +54,7 @@ static void sd_print_item(struct item_he
 	} else {
 		struct stat_data *sd = (struct stat_data *)item;
 
-		printk("\t0%-6o | %6Lu | %2u | %d | %s\n", sd_v2_mode(sd),
+		printk("\t0%-6o | %6llu | %2u | %d | %s\n", sd_v2_mode(sd),
 		       (unsigned long long)sd_v2_size(sd), sd_v2_nlink(sd),
 		       sd_v2_rdev(sd), print_time(sd_v2_mtime(sd)));
 	}
@@ -408,7 +408,7 @@ static void direntry_print_item(struct i
 			namebuf[namelen + 2] = 0;
 		}
 
-		printk("%d:  %-15s%-15d%-15d%-15Ld%-15Ld(%s)\n",
+		printk("%d:  %-15s%-15d%-15d%-15lld%-15lld(%s)\n",
 		       i, namebuf,
 		       deh_dir_id(deh), deh_objectid(deh),
 		       GET_HASH_VALUE(deh_offset(deh)),
diff -puN fs/reiserfs/prints.c~fs-reiserfs-replace-not-standard-%lu-%ld fs/reiserfs/prints.c
--- a/fs/reiserfs/prints.c~fs-reiserfs-replace-not-standard-%lu-%ld
+++ a/fs/reiserfs/prints.c
@@ -17,7 +17,7 @@ static char off_buf[80];
 static char *reiserfs_cpu_offset(struct cpu_key *key)
 {
 	if (cpu_key_k_type(key) == TYPE_DIRENTRY)
-		sprintf(off_buf, "%Lu(%Lu)",
+		sprintf(off_buf, "%llu(%llu)",
 			(unsigned long long)
 			GET_HASH_VALUE(cpu_key_k_offset(key)),
 			(unsigned long long)
@@ -34,7 +34,7 @@ static char *le_offset(struct reiserfs_k
 
 	version = le_key_version(key);
 	if (le_key_k_type(version, key) == TYPE_DIRENTRY)
-		sprintf(off_buf, "%Lu(%Lu)",
+		sprintf(off_buf, "%llu(%llu)",
 			(unsigned long long)
 			GET_HASH_VALUE(le_key_k_offset(version, key)),
 			(unsigned long long)
diff -puN fs/reiserfs/stree.c~fs-reiserfs-replace-not-standard-%lu-%ld fs/reiserfs/stree.c
--- a/fs/reiserfs/stree.c~fs-reiserfs-replace-not-standard-%lu-%ld
+++ a/fs/reiserfs/stree.c
@@ -2006,7 +2006,7 @@ int reiserfs_do_truncate(struct reiserfs
 					    &s_search_path) == POSITION_FOUND);
 
 	RFALSE(file_size > ROUND_UP(new_file_size),
-	       "PAP-5680: truncate did not finish: new_file_size %Ld, current %Ld, oid %d",
+	       "PAP-5680: truncate did not finish: new_file_size %lld, current %lld, oid %d",
 	       new_file_size, file_size, s_item_key.on_disk_key.k_objectid);
 
 update_and_out:
diff -puN fs/reiserfs/super.c~fs-reiserfs-replace-not-standard-%lu-%ld fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~fs-reiserfs-replace-not-standard-%lu-%ld
+++ a/fs/reiserfs/super.c
@@ -331,7 +331,7 @@ static int finish_unfinished(struct supe
 			 * not completed truncate found. New size was
 			 * committed together with "save" link
 			 */
-			reiserfs_info(s, "Truncating %k to %Ld ..",
+			reiserfs_info(s, "Truncating %k to %lld ..",
 				      INODE_PKEY(inode), inode->i_size);
 
 			/* don't update modification time */
@@ -1577,7 +1577,7 @@ static int read_super_block(struct super
 	rs = (struct reiserfs_super_block *)bh->b_data;
 	if (sb_blocksize(rs) != s->s_blocksize) {
 		reiserfs_warning(s, "sh-2011", "can't find a reiserfs "
-				 "filesystem on (dev %s, block %Lu, size %lu)",
+				 "filesystem on (dev %s, block %llu, size %lu)",
 				 s->s_id,
 				 (unsigned long long)bh->b_blocknr,
 				 s->s_blocksize);
@@ -2441,8 +2441,7 @@ static ssize_t reiserfs_quota_write(stru
 	struct buffer_head tmp_bh, *bh;
 
 	if (!current->journal_info) {
-		printk(KERN_WARNING "reiserfs: Quota write (off=%Lu, len=%Lu)"
-			" cancelled because transaction is not started.\n",
+		printk(KERN_WARNING "reiserfs: Quota write (off=%llu, len=%llu) cancelled because transaction is not started.\n",
 			(unsigned long long)off, (unsigned long long)len);
 		return -EIO;
 	}
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

