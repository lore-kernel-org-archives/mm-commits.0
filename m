From: akpm@linux-foundation.org
Subject: [merged] arch-sh-mm-asids-debugfsc-use-ptr_err_or_zero.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:02:27 -0700
Message-ID: <53e3db53.VadUvGGmtWYWdpDy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:45924 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbaHGUC2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:02:28 -0400
Received: by mail-ie0-f201.google.com with SMTP id tr6so842336ieb.0
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:02:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/sh/mm/asids-debugfs.c: use PTR_ERR_OR_ZERO
has been removed from the -mm tree.  Its filename was
     arch-sh-mm-asids-debugfsc-use-ptr_err_or_zero.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: arch/sh/mm/asids-debugfs.c: use PTR_ERR_OR_ZERO

Replace IS_ERR/PTR_ERR.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/asids-debugfs.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/sh/mm/asids-debugfs.c~arch-sh-mm-asids-debugfsc-use-ptr_err_or_zero arch/sh/mm/asids-debugfs.c
--- a/arch/sh/mm/asids-debugfs.c~arch-sh-mm-asids-debugfsc-use-ptr_err_or_zero
+++ a/arch/sh/mm/asids-debugfs.c
@@ -67,10 +67,8 @@ static int __init asids_debugfs_init(voi
 					   NULL, &asids_debugfs_fops);
 	if (!asids_dentry)
 		return -ENOMEM;
-	if (IS_ERR(asids_dentry))
-		return PTR_ERR(asids_dentry);
 
-	return 0;
+	return PTR_ERR_OR_ZERO(asids_dentry);
 }
 module_init(asids_debugfs_init);
 
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch
fs-compatc-remove-unnecessary-test-on-unsigned-value.patch
fs-efs-nameic-return-is-not-a-function.patch
fs-ramfs-file-nommuc-replace-countsize-kzalloc-by-kcalloc.patch
kernel-test_kprobesc-use-current-logging-functions.patch
fs-befs-linuxvfsc-check-superblock-before-dump-operation.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
fs-coda-use-linux-uaccessh.patch
fs-nilfs2-superc-remove-unnecessary-test-on-unsigned-value.patch
fs-ufs-convert-printk-to-pr_foo.patch
fs-ufs-use-pr_fmt.patch
fs-ufs-superc-use-__func__-in-logging.patch
fs-ufs-superc-use-va_format-instead-of-buffer-vsnprintf.patch
fs-ufs-convert-ufsd-printk-to-pr_debug.patch
fs-ufs-inodec-kernel-doc-warning-fixes.patch
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
fs-cramfs-convert-printk-to-pr_foo.patch
fs-cramfs-use-pr_fmt.patch
fs-cramfs-code-clean-up.patch
fs-cramfs-inodec-use-linux-uaccessh.patch
fs-romfs-superc-convert-printk-to-pr_foo.patch
fs-romfs-superc-use-pr_fmt-in-logging.patch
fs-romfs-superc-add-blank-line-after-declarations.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
scripts-coccinelle-free-add-null-test-before-freeing-functions.patch
scripts-coccinelle-free-ifnullfreecocci-add-copyright-information.patch
fs-dlm-debug_fsc-remove-unnecessary-null-test-before-debugfs_remove.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

