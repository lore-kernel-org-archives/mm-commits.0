From: akpm@linux-foundation.org
Subject: + proc-constify-seq_operations.patch added to -mm tree
Date: Mon, 30 Jun 2014 13:57:55 -0700
Message-ID: <53b1cf53.bttsM0y828NhoxMh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:35941 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbaF3U54 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jun 2014 16:57:56 -0400
Received: by mail-qc0-f201.google.com with SMTP id c9so875976qcz.2
        for <mm-commits@vger.kernel.org>; Mon, 30 Jun 2014 13:57:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: constify seq_operations
has been added to the -mm tree.  Its filename is
     proc-constify-seq_operations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-constify-seq_operations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-constify-seq_operations.patch

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
Subject: proc: constify seq_operations

proc_uid_seq_operations, proc_gid_seq_operations and
proc_projid_seq_operations are only called in proc_id_map_open with
seq_open as const struct seq_operations so we can constify the 3
structures and update proc_id_map_open prototype.

   text    data     bss     dec     hex filename
   6817     404    1984    9205    23f5 kernel/user_namespace.o-before
   6913     308    1984    9205    23f5 kernel/user_namespace.o-after

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c                 |    2 +-
 include/linux/user_namespace.h |    6 +++---
 kernel/user_namespace.c        |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/proc/base.c~proc-constify-seq_operations fs/proc/base.c
--- a/fs/proc/base.c~proc-constify-seq_operations
+++ a/fs/proc/base.c
@@ -2449,7 +2449,7 @@ static int proc_tgid_io_accounting(struc
 
 #ifdef CONFIG_USER_NS
 static int proc_id_map_open(struct inode *inode, struct file *file,
-	struct seq_operations *seq_ops)
+	const struct seq_operations *seq_ops)
 {
 	struct user_namespace *ns = NULL;
 	struct task_struct *task;
diff -puN include/linux/user_namespace.h~proc-constify-seq_operations include/linux/user_namespace.h
--- a/include/linux/user_namespace.h~proc-constify-seq_operations
+++ a/include/linux/user_namespace.h
@@ -57,9 +57,9 @@ static inline void put_user_ns(struct us
 }
 
 struct seq_operations;
-extern struct seq_operations proc_uid_seq_operations;
-extern struct seq_operations proc_gid_seq_operations;
-extern struct seq_operations proc_projid_seq_operations;
+extern const struct seq_operations proc_uid_seq_operations;
+extern const struct seq_operations proc_gid_seq_operations;
+extern const struct seq_operations proc_projid_seq_operations;
 extern ssize_t proc_uid_map_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t proc_gid_map_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t proc_projid_map_write(struct file *, const char __user *, size_t, loff_t *);
diff -puN kernel/user_namespace.c~proc-constify-seq_operations kernel/user_namespace.c
--- a/kernel/user_namespace.c~proc-constify-seq_operations
+++ a/kernel/user_namespace.c
@@ -526,21 +526,21 @@ static void m_stop(struct seq_file *seq,
 	return;
 }
 
-struct seq_operations proc_uid_seq_operations = {
+const struct seq_operations proc_uid_seq_operations = {
 	.start = uid_m_start,
 	.stop = m_stop,
 	.next = m_next,
 	.show = uid_m_show,
 };
 
-struct seq_operations proc_gid_seq_operations = {
+const struct seq_operations proc_gid_seq_operations = {
 	.start = gid_m_start,
 	.stop = m_stop,
 	.next = m_next,
 	.show = gid_m_show,
 };
 
-struct seq_operations proc_projid_seq_operations = {
+const struct seq_operations proc_projid_seq_operations = {
 	.start = projid_m_start,
 	.stop = m_stop,
 	.next = m_next,
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
proc-constify-seq_operations.patch
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

