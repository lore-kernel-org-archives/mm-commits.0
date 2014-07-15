From: akpm@linux-foundation.org
Subject: + fs-fscache-make-ctl_table-static.patch added to -mm tree
Date: Tue, 15 Jul 2014 14:00:41 -0700
Message-ID: <53c59679.QK8wj1PsuMenjmxJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:36117 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaGOVAm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Jul 2014 17:00:42 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so1309908oah.0
        for <mm-commits@vger.kernel.org>; Tue, 15 Jul 2014 14:00:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, dhowells@redhat.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/fscache: make ctl_table static
has been added to the -mm tree.  Its filename is
     fs-fscache-make-ctl_table-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-fscache-make-ctl_table-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-fscache-make-ctl_table-static.patch

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
Subject: fs/fscache: make ctl_table static

fscache_sysctls and fscache_sysctls_root are only used in main.c

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: David Howells <dhowells@redhat.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fscache/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/fscache/main.c~fs-fscache-make-ctl_table-static fs/fscache/main.c
--- a/fs/fscache/main.c~fs-fscache-make-ctl_table-static
+++ a/fs/fscache/main.c
@@ -67,7 +67,7 @@ static int fscache_max_active_sysctl(str
 	return ret;
 }
 
-struct ctl_table fscache_sysctls[] = {
+static struct ctl_table fscache_sysctls[] = {
 	{
 		.procname	= "object_max_active",
 		.data		= &fscache_object_max_active,
@@ -87,7 +87,7 @@ struct ctl_table fscache_sysctls[] = {
 	{}
 };
 
-struct ctl_table fscache_sysctls_root[] = {
+static struct ctl_table fscache_sysctls_root[] = {
 	{
 		.procname	= "fscache",
 		.mode		= 0555,
_

Patches currently in -mm which might be from fabf@skynet.be are

kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-logfs-readwritec-kernel-doc-warning-fixes.patch
ntfs-kernel-doc-warning-fixes.patch
arch-sh-mm-asids-debugfsc-use-ptr_err_or_zero.patch
arch-sh-kernel-timec-use-ptr_err_or_zero.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-squashfs-superc-logging-clean-up.patch
ubifs-kernel-doc-warning-fix.patch
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
fs-ufs-inodec-kernel-doc-warning-fixes.patch
fs-reiserfs-replace-not-standard-%lu-%ld.patch
fs-reiserfs-use-linux-uaccessh.patch
fs-reiserfs-xattrc-fix-blank-line-missing-after-declarations.patch
fs-hpfs-dnodec-fix-suspect-code-indent.patch
fs-quota-kernel-doc-warning-fixes.patch
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
fs-ubifs-superc-replace-seq_printf-by-seq_puts.patch
fs-ubifs-ioc-kernel-doc-warning-fix.patch
fs-fscache-make-ctl_table-static.patch

