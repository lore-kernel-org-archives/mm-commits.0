From: akpm@linux-foundation.org
Subject: +
 fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
 added to -mm tree
Date: Wed, 18 Jun 2014 14:31:41 -0700
Message-ID: <53a2053d.Ab5uKIVeJAeLAVdi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588AbaFRVbm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jun 2014 17:31:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, phillip@squashfs.org.uk, joe@perches.com, fabf@skynet.be


The patch titled
     Subject: fs/squashfs/file_direct.c: replace count*size kmalloc by  kmalloc_array
has been added to the -mm tree.  Its filename is
     fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch

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
Subject: fs/squashfs/file_direct.c: replace count*size kmalloc by  kmalloc_array

kmalloc_array() manages count*sizeof overflow.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file_direct.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/squashfs/file_direct.c~fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array fs/squashfs/file_direct.c
--- a/fs/squashfs/file_direct.c~fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array
+++ a/fs/squashfs/file_direct.c
@@ -44,7 +44,7 @@ int squashfs_readpage_block(struct page
 
 	pages = end_index - start_index + 1;
 
-	page = kmalloc(sizeof(void *) * pages, GFP_KERNEL);
+	page = kmalloc_array(pages, sizeof(void *), GFP_KERNEL);
 	if (page == NULL)
 		return res;
 
_

Patches currently in -mm which might be from fabf@skynet.be are

kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
mm-slabc-add-__init-to-init_lock_keys.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
include-linux-memblockh-add-__init-to-memblock_set_bottom_up.patch
mm-internalh-use-nth_page.patch
mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch
fs-compatc-remove-unnecessary-test-on-unsigned-value.patch
kernel-test_kprobesc-use-current-logging-functions.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
fs-nilfs2-superc-remove-unnecessary-test-on-unsigned-value.patch
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

