From: akpm@linux-foundation.org
Subject: + fs-ramfs-file-nommuc-replace-countsize-kzalloc-by-kcalloc.patch added to -mm tree
Date: Tue, 24 Jun 2014 14:39:47 -0700
Message-ID: <53a9f023.ldXV3PYwdIBsqpbl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37051 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbaFXVjr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 17:39:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, axel.lin@ingics.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ramfs/file-nommu.c: replace count*size kzalloc by kcalloc
has been added to the -mm tree.  Its filename is
     fs-ramfs-file-nommuc-replace-countsize-kzalloc-by-kcalloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ramfs-file-nommuc-replace-countsize-kzalloc-by-kcalloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ramfs-file-nommuc-replace-countsize-kzalloc-by-kcalloc.patch

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
Subject: fs/ramfs/file-nommu.c: replace count*size kzalloc by kcalloc

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ramfs/file-nommu.c~fs-ramfs-file-nommuc-replace-countsize-kzalloc-by-kcalloc fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~fs-ramfs-file-nommuc-replace-countsize-kzalloc-by-kcalloc
+++ a/fs/ramfs/file-nommu.c
@@ -222,7 +222,7 @@ static unsigned long ramfs_nommu_get_unm
 
 	/* gang-find the pages */
 	ret = -ENOMEM;
-	pages = kzalloc(lpages * sizeof(struct page *), GFP_KERNEL);
+	pages = kcalloc(lpages, sizeof(struct page *), GFP_KERNEL);
 	if (!pages)
 		goto out_free;
 
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

