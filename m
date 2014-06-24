From: akpm@linux-foundation.org
Subject: + fs-reiserfs-replace-not-standard-%lu-%ld.patch added to -mm
 tree
Date: Tue, 24 Jun 2014 14:31:33 -0700
Message-ID: <53a9ee35.adjb5EnAeadDFAg6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaFXVbe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 17:31:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jeffm@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/reiserfs: replace not-standard %Lu/%Ld
has been added to the -mm tree.  Its filename is
     fs-reiserfs-replace-not-standard-%lu-%ld.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-reiserfs-replace-not-standard-%lu-%ld.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-reiserfs-replace-not-standard-%lu-%ld.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

revert-block-add-__init-to-blkcg_policy_register.patch
kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-squashfs-superc-logging-clean-up.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
mm-slabc-add-__init-to-init_lock_keys.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
include-linux-memblockh-add-__init-to-memblock_set_bottom_up.patch
mm-internalh-use-nth_page.patch
mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch
lib-test-kstrtoxc-use-array_size-instead-of-sizeof-sizeof.patch
fs-compatc-remove-unnecessary-test-on-unsigned-value.patch
kernel-test_kprobesc-use-current-logging-functions.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
fs-nilfs2-superc-remove-unnecessary-test-on-unsigned-value.patch
fs-ufs-convert-printk-to-pr_foo.patch
fs-ufs-use-pr_fmt.patch
fs-ufs-superc-use-__func__-in-logging.patch
fs-ufs-superc-use-va_format-instead-of-buffer-vsnprintf.patch
fs-ufs-convert-ufsd-printk-to-pr_debug.patch
fs-reiserfs-replace-not-standard-%lu-%ld.patch
fs-reiserfs-use-linux-uaccessh.patch
fs-reiserfs-xattrc-fix-blank-line-missing-after-declarations.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fs-adfs-dir_fplusc-use-array_size-instead-of-sizeof-sizeof.patch
drivers-parport-parport_ip32c-use-ptr_err_or_zero.patch
fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch
fs-cachefiles-bindc-remove-unnecessary-assertions.patch
fs-romfs-superc-convert-printk-to-pr_foo.patch
fs-romfs-superc-use-pr_fmt-in-logging.patch
fs-romfs-superc-add-blank-line-after-declarations.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

