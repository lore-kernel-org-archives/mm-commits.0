From: akpm@linux-foundation.org
Subject: +
 fs-adfs-dir_fplusc-use-array_size-instead-of-sizeof-sizeof.patch added to
 -mm tree
Date: Wed, 18 Jun 2014 13:32:31 -0700
Message-ID: <53a1f75f.PGSQzYjJpK8iSoj/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41464 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbaFRUcb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jun 2014 16:32:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be


The patch titled
     Subject: fs/adfs/dir_fplus.c: use ARRAY_SIZE instead of sizeof/sizeof[0]
has been added to the -mm tree.  Its filename is
     fs-adfs-dir_fplusc-use-array_size-instead-of-sizeof-sizeof.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-adfs-dir_fplusc-use-array_size-instead-of-sizeof-sizeof.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-adfs-dir_fplusc-use-array_size-instead-of-sizeof-sizeof.patch

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
Subject: fs/adfs/dir_fplus.c: use ARRAY_SIZE instead of sizeof/sizeof[0]

Use kernel.h definition.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/dir_fplus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/adfs/dir_fplus.c~fs-adfs-dir_fplusc-use-array_size-instead-of-sizeof-sizeof fs/adfs/dir_fplus.c
--- a/fs/adfs/dir_fplus.c~fs-adfs-dir_fplusc-use-array_size-instead-of-sizeof-sizeof
+++ a/fs/adfs/dir_fplus.c
@@ -55,7 +55,7 @@ adfs_fplus_read(struct super_block *sb,
 	}
 
 	size >>= sb->s_blocksize_bits;
-	if (size > sizeof(dir->bh)/sizeof(dir->bh[0])) {
+	if (size > ARRAY_SIZE(dir->bh)) {
 		/* this directory is too big for fixed bh set, must allocate */
 		struct buffer_head **bh_fplus =
 			kzalloc(size * sizeof(struct buffer_head *),
_

Patches currently in -mm which might be from fabf@skynet.be are

kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
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
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

