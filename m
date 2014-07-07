From: akpm@linux-foundation.org
Subject: + ntfs-kernel-doc-warning-fixes.patch added to -mm tree
Date: Mon, 07 Jul 2014 15:14:48 -0700
Message-ID: <53bb1bd8.Gca2fQiJPrKtEFxP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:41848 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaGGWOt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 18:14:49 -0400
Received: by mail-qc0-f202.google.com with SMTP id x13so711653qcv.5
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 15:14:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, anton@tuxera.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ntfs: kernel-doc warning fixes
has been added to the -mm tree.  Its filename is
     ntfs-kernel-doc-warning-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ntfs-kernel-doc-warning-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ntfs-kernel-doc-warning-fixes.patch

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
Subject: ntfs: kernel-doc warning fixes

cached_page and lru_pvec were removed from ntfs_attr_extend_initialized in
commit 2ec93b0bf35f ("ntfs: clean up ntfs_attr_extend_initialized")

lru_pvec has been removed from __ntfs_grab_cache_pages in commit
4c99000ac47c ("ntfs: use add_to_page_cache_lru()")

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Acked-by: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/file.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/ntfs/file.c~ntfs-kernel-doc-warning-fixes fs/ntfs/file.c
--- a/fs/ntfs/file.c~ntfs-kernel-doc-warning-fixes
+++ a/fs/ntfs/file.c
@@ -74,8 +74,6 @@ static int ntfs_file_open(struct inode *
  * ntfs_attr_extend_initialized - extend the initialized size of an attribute
  * @ni:			ntfs inode of the attribute to extend
  * @new_init_size:	requested new initialized size in bytes
- * @cached_page:	store any allocated but unused page here
- * @lru_pvec:		lru-buffering pagevec of the caller
  *
  * Extend the initialized size of an attribute described by the ntfs inode @ni
  * to @new_init_size bytes.  This involves zeroing any non-sparse space between
@@ -395,7 +393,6 @@ static inline void ntfs_fault_in_pages_r
  * @nr_pages:	number of page cache pages to obtain
  * @pages:	array of pages in which to return the obtained page cache pages
  * @cached_page: allocated but as yet unused page
- * @lru_pvec:	lru-buffering pagevec of caller
  *
  * Obtain @nr_pages locked page cache pages from the mapping @mapping and
  * starting at index @index.
_

Patches currently in -mm which might be from fabf@skynet.be are

kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
arch-sh-mm-asids-debugfsc-use-ptr_err_or_zero.patch
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
mm-hwpoison-injectc-remove-unnecessary-null-test-before-debugfs_remove_recursive.patch
mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch
lib-test-kstrtoxc-use-array_size-instead-of-sizeof-sizeof.patch
fs-compatc-remove-unnecessary-test-on-unsigned-value.patch
checkpatch-emit-fewer-kmalloc_array-kcalloc-conversion-warnings.patch
fs-efs-nameic-return-is-not-a-function.patch
fs-ramfs-file-nommuc-replace-countsize-kzalloc-by-kcalloc.patch
kernel-test_kprobesc-use-current-logging-functions.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
fs-coda-use-linux-uaccessh.patch
fs-nilfs2-superc-remove-unnecessary-test-on-unsigned-value.patch
fs-ufs-convert-printk-to-pr_foo.patch
fs-ufs-use-pr_fmt.patch
fs-ufs-superc-use-__func__-in-logging.patch
fs-ufs-superc-use-va_format-instead-of-buffer-vsnprintf.patch
fs-ufs-convert-ufsd-printk-to-pr_debug.patch
fs-reiserfs-replace-not-standard-%lu-%ld.patch
fs-reiserfs-use-linux-uaccessh.patch
fs-reiserfs-xattrc-fix-blank-line-missing-after-declarations.patch
fs-hpfs-dnodec-fix-suspect-code-indent.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
proc-constify-seq_operations.patch
fs-exofs-ore_raidc-replace-countsize-kzalloc-by-kcalloc.patch
kernel-gcov-fsc-remove-unnecessary-null-test-before-debugfs_remove.patch
fs-adfs-dir_fplusc-use-array_size-instead-of-sizeof-sizeof.patch
fs-adfs-dir_fplusc-replace-countsize-kzalloc-by-kcalloc.patch
fs-bfs-use-bfs-prefix-for-dump_imap.patch
drivers-parport-parport_ip32c-use-ptr_err_or_zero.patch
fs-pstore-ram_corec-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch
fs-cachefiles-bindc-remove-unnecessary-assertions.patch
fs-omfs-inodec-replace-countsize-kzalloc-by-kcalloc.patch
fs-romfs-superc-convert-printk-to-pr_foo.patch
fs-romfs-superc-use-pr_fmt-in-logging.patch
fs-romfs-superc-add-blank-line-after-declarations.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
scripts-coccinelle-free-add-null-test-before-freeing-functions.patch
fs-dlm-debug_fsc-remove-unnecessary-null-test-before-debugfs_remove.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
arch-sh-kernel-timec-use-ptr_err_or_zero.patch
fs-quota-kernel-doc-warning-fixes.patch
kernfs-kernel-doc-warning-fix.patch
ntfs-kernel-doc-warning-fixes.patch
ubifs-kernel-doc-warning-fix.patch

