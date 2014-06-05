From: akpm@linux-foundation.org
Subject: [merged] ntfs-remove-null-value-assignments.patch removed from
 -mm tree
Date: Thu, 05 Jun 2014 12:42:17 -0700
Message-ID: <5390c819.9Yyp+RCtYK6uRpCB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55535 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaFETmR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:42:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, anton@tuxera.com, fabf@skynet.be

Subject: [merged] ntfs-remove-null-value-assignments.patch removed from -mm tree
To: fabf@skynet.be,anton@tuxera.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:42:17 -0700


The patch titled
     Subject: ntfs: remove NULL value assignments
has been removed from the -mm tree.  Its filename was
     ntfs-remove-null-value-assignments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: ntfs: remove NULL value assignments

Static values are automatically initialized to NULL.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Acked-by: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/compress.c |    2 +-
 fs/ntfs/super.c    |    4 ++--
 fs/ntfs/sysctl.c   |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/ntfs/compress.c~ntfs-remove-null-value-assignments fs/ntfs/compress.c
--- a/fs/ntfs/compress.c~ntfs-remove-null-value-assignments
+++ a/fs/ntfs/compress.c
@@ -58,7 +58,7 @@ typedef enum {
 /**
  * ntfs_compression_buffer - one buffer for the decompression engine
  */
-static u8 *ntfs_compression_buffer = NULL;
+static u8 *ntfs_compression_buffer;
 
 /**
  * ntfs_cb_lock - spinlock which protects ntfs_compression_buffer
diff -puN fs/ntfs/super.c~ntfs-remove-null-value-assignments fs/ntfs/super.c
--- a/fs/ntfs/super.c~ntfs-remove-null-value-assignments
+++ a/fs/ntfs/super.c
@@ -50,8 +50,8 @@
 static unsigned long ntfs_nr_compression_users;
 
 /* A global default upcase table and a corresponding reference count. */
-static ntfschar *default_upcase = NULL;
-static unsigned long ntfs_nr_upcase_users = 0;
+static ntfschar *default_upcase;
+static unsigned long ntfs_nr_upcase_users;
 
 /* Error constants/strings used in inode.c::ntfs_show_options(). */
 typedef enum {
diff -puN fs/ntfs/sysctl.c~ntfs-remove-null-value-assignments fs/ntfs/sysctl.c
--- a/fs/ntfs/sysctl.c~ntfs-remove-null-value-assignments
+++ a/fs/ntfs/sysctl.c
@@ -56,7 +56,7 @@ static ctl_table sysctls_root[] = {
 };
 
 /* Storage for the sysctls header. */
-static struct ctl_table_header *sysctls_root_table = NULL;
+static struct ctl_table_header *sysctls_root_table;
 
 /**
  * ntfs_sysctl - add or remove the debug sysctl
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-coda-replace-printk-by-pr_foo.patch
fs-coda-logging-prefix-uniformization.patch
fs-coda-use-__func__.patch
fs-hfsplus-bnodec-replace-min-casting-by-min_t.patch
fs-hfsplus-optionsc-replace-seq_printf-by-seq_puts.patch
fs-hfsplus-wrapperc-replace-min-casting-by-min_t.patch
fs-hfsplus-wrapperc-replace-shift-loop-by-ilog2.patch
fs-hfsplus-fix-pr_foo-and-hfs_dbg-formats.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-hpfs-convert-printk-to-pr_foo.patch
fs-hpfs-use-pr_fmt-for-logging.patch
fs-hpfs-use-__func__-for-logging.patch
fs-hpfs-increase-pr_warn-level.patch
documentation-filesystems-seq_filetxt-create_proc_entry-deprecated.patch
fs-proc-task_mmuc-replace-seq_printf-by-seq_puts.patch
fs-proc-vmcorec-remove-null-assignment-on-static.patch
kernel-kexecc-convert-printk-to-pr_foo.patch
kernel-user_namespacec-kernel-doc-checkpatch-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
kernel-profilec-convert-printk-to-pr_foo.patch
kernel-profilec-use-static-const-char-instead-of-static-char.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
fs-cachefiles-convert-printk-to-pr_foo.patch
fs-cachefiles-replace-kerror-by-pr_err.patch
fs-devpts-inodec-convert-printk-to-pr_foo.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
kernel-seccompc-kernel-doc-warning-fix.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
fs-dlm-configc-convert-simple_str-to-kstr.patch
fs-dlm-lockspacec-convert-simple_str-to-kstr.patch
fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts.patch
mm-kmemleak-testc-use-pr_fmt-for-logging.patch
ufs-sb-mutex-merge-mutex_destroy.patch

