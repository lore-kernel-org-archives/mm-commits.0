From: akpm@linux-foundation.org
Subject: +
 fs-dlm-debug_fsc-remove-unnecessary-null-test-before-debugfs_remove.patch
 added to -mm tree
Date: Thu, 26 Jun 2014 13:12:51 -0700
Message-ID: <53ac7ec3.QvKMFuGNCyHeK0MK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59427 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaFZUMw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jun 2014 16:12:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, ccaulfie@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/dlm/debug_fs.c: remove unnecessary null test before debugfs_remove
has been added to the -mm tree.  Its filename is
     fs-dlm-debug_fsc-remove-unnecessary-null-test-before-debugfs_remove.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-dlm-debug_fsc-remove-unnecessary-null-test-before-debugfs_remove.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-dlm-debug_fsc-remove-unnecessary-null-test-before-debugfs_remove.patch

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
Subject: fs/dlm/debug_fs.c: remove unnecessary null test before debugfs_remove

This fixes checkpatch warning:

"WARNING: debugfs_remove(NULL) is safe this check is probably not required"

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dlm/debug_fs.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN fs/dlm/debug_fs.c~fs-dlm-debug_fsc-remove-unnecessary-null-test-before-debugfs_remove fs/dlm/debug_fs.c
--- a/fs/dlm/debug_fs.c~fs-dlm-debug_fsc-remove-unnecessary-null-test-before-debugfs_remove
+++ a/fs/dlm/debug_fs.c
@@ -718,16 +718,11 @@ static const struct file_operations wait
 
 void dlm_delete_debug_file(struct dlm_ls *ls)
 {
-	if (ls->ls_debug_rsb_dentry)
-		debugfs_remove(ls->ls_debug_rsb_dentry);
-	if (ls->ls_debug_waiters_dentry)
-		debugfs_remove(ls->ls_debug_waiters_dentry);
-	if (ls->ls_debug_locks_dentry)
-		debugfs_remove(ls->ls_debug_locks_dentry);
-	if (ls->ls_debug_all_dentry)
-		debugfs_remove(ls->ls_debug_all_dentry);
-	if (ls->ls_debug_toss_dentry)
-		debugfs_remove(ls->ls_debug_toss_dentry);
+	debugfs_remove(ls->ls_debug_rsb_dentry);
+	debugfs_remove(ls->ls_debug_waiters_dentry);
+	debugfs_remove(ls->ls_debug_locks_dentry);
+	debugfs_remove(ls->ls_debug_all_dentry);
+	debugfs_remove(ls->ls_debug_toss_dentry);
 }
 
 int dlm_create_debug_file(struct dlm_ls *ls)
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
fs-binfmt_elfc-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-ramfs-file-nommuc-replace-countsize-kzalloc-by-kcalloc.patch
kernel-test_kprobesc-use-current-logging-functions.patch
fs-jbd-replace-countsize-kmalloc-by-kmalloc_array.patch
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
kernel-gcov-fsc-remove-unnecessary-null-test-before-debugfs_remove.patch
fs-adfs-dir_fplusc-use-array_size-instead-of-sizeof-sizeof.patch
fs-adfs-dir_fplusc-replace-countsize-kzalloc-by-kcalloc.patch
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
fs-dlm-debug_fsc-remove-unnecessary-null-test-before-debugfs_remove.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

