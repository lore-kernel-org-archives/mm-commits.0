From: akpm@linux-foundation.org
Subject: + fs-jbd-replace-countsize-kmalloc-by-kmalloc_array.patch added
 to -mm tree
Date: Wed, 25 Jun 2014 14:24:06 -0700
Message-ID: <53ab3df6.fivjswGmhE5rILbI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47880 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730AbaFYVYH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jun 2014 17:24:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: FS/JBD:replace count*size kmalloc by kmalloc_array
has been added to the -mm tree.  Its filename is
     fs-jbd-replace-countsize-kmalloc-by-kmalloc_array.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-jbd-replace-countsize-kmalloc-by-kmalloc_array.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-jbd-replace-countsize-kmalloc-by-kmalloc_array.patch

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
Subject: FS/JBD:replace count*size kmalloc by kmalloc_array

kmalloc_array manages count*sizeof overflow.

This patch also fixes checkpatch warnings:
ERROR: "(foo*)" should be "(foo *)"

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/journal.c |    6 ++++--
 fs/jbd/revoke.c  |    2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN fs/jbd/journal.c~fs-jbd-replace-countsize-kmalloc-by-kmalloc_array fs/jbd/journal.c
--- a/fs/jbd/journal.c~fs-jbd-replace-countsize-kmalloc-by-kmalloc_array
+++ a/fs/jbd/journal.c
@@ -810,7 +810,8 @@ journal_t * journal_init_dev(struct bloc
 	journal->j_blocksize = blocksize;
 	n = journal->j_blocksize / sizeof(journal_block_tag_t);
 	journal->j_wbufsize = n;
-	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_KERNEL);
+	journal->j_wbuf = kmalloc_array(n, sizeof(struct buffer_head *),
+					GFP_KERNEL);
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Can't allocate bhs for commit thread\n",
 			__func__);
@@ -871,7 +872,8 @@ journal_t * journal_init_inode (struct i
 	/* journal descriptor can store up to n blocks -bzzz */
 	n = journal->j_blocksize / sizeof(journal_block_tag_t);
 	journal->j_wbufsize = n;
-	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_KERNEL);
+	journal->j_wbuf = kmalloc_array(n, sizeof(struct buffer_head *),
+					GFP_KERNEL);
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Can't allocate bhs for commit thread\n",
 			__func__);
diff -puN fs/jbd/revoke.c~fs-jbd-replace-countsize-kmalloc-by-kmalloc_array fs/jbd/revoke.c
--- a/fs/jbd/revoke.c~fs-jbd-replace-countsize-kmalloc-by-kmalloc_array
+++ a/fs/jbd/revoke.c
@@ -241,7 +241,7 @@ static struct jbd_revoke_table_s *journa
 	table->hash_size = hash_size;
 	table->hash_shift = ilog2(hash_size);
 	table->hash_table =
-		kmalloc(hash_size * sizeof(struct list_head), GFP_KERNEL);
+		kmalloc_array(hash_size, sizeof(struct list_head), GFP_KERNEL);
 	if (!table->hash_table) {
 		kmem_cache_free(revoke_table_cache, table);
 		table = NULL;
_

Patches currently in -mm which might be from fabf@skynet.be are

kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-squashfs-superc-logging-clean-up.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-ocfs2-slot_mapc-replace-countsize-kzalloc-by-kcalloc.patch
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
fs-ramfs-file-nommuc-replace-countsize-kzalloc-by-kcalloc.patch
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
fs-exofs-ore_raidc-replace-countsize-kzalloc-by-kcalloc.patch
fs-adfs-dir_fplusc-use-array_size-instead-of-sizeof-sizeof.patch
fs-adfs-dir_fplusc-replace-countsize-kzalloc-by-kcalloc.patch
drivers-parport-parport_ip32c-use-ptr_err_or_zero.patch
fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch
fs-cachefiles-bindc-remove-unnecessary-assertions.patch
fs-omfs-inodec-replace-countsize-kzalloc-by-kcalloc.patch
fs-romfs-superc-convert-printk-to-pr_foo.patch
fs-romfs-superc-use-pr_fmt-in-logging.patch
fs-romfs-superc-add-blank-line-after-declarations.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
fs-binfmt_elfc-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-pstore-ram_corec-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-jbd-replace-countsize-kmalloc-by-kmalloc_array.patch

