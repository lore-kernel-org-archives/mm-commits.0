From: akpm@linux-foundation.org
Subject: + fs-ufs-convert-ufsd-printk-to-pr_debug.patch added to -mm tree
Date: Fri, 20 Jun 2014 15:32:00 -0700
Message-ID: <53a4b660.DF2k/MJcuygbZkie%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33316 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966271AbaFTWcB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 18:32:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dushistov@mail.ru, fabf@skynet.be


The patch titled
     Subject: fs/ufs: convert UFSD printk to pr_debug
has been added to the -mm tree.  Its filename is
     fs-ufs-convert-ufsd-printk-to-pr_debug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ufs-convert-ufsd-printk-to-pr_debug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ufs-convert-ufsd-printk-to-pr_debug.patch

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
Subject: fs/ufs: convert UFSD printk to pr_debug

Convert no level printk to pr_debug in UFSD.  DEBUG is defined with
CONFIG_UFS_DEBUG so pr_debug are emitted here.

Also fixing call to UFSD (add;)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |    2 +-
 fs/ufs/ufs.h   |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ufs/super.c~fs-ufs-convert-ufsd-printk-to-pr_debug fs/ufs/super.c
--- a/fs/ufs/super.c~fs-ufs-convert-ufsd-printk-to-pr_debug
+++ a/fs/ufs/super.c
@@ -868,7 +868,7 @@ static int ufs_fill_super(struct super_b
 		break;
 
 	case UFS_MOUNT_UFSTYPE_SUNOS:
-		UFSD(("ufstype=sunos\n"))
+		UFSD("ufstype=sunos\n");
 		uspi->s_fsize = block_size = 1024;
 		uspi->s_fmask = ~(1024 - 1);
 		uspi->s_fshift = 10;
diff -puN fs/ufs/ufs.h~fs-ufs-convert-ufsd-printk-to-pr_debug fs/ufs/ufs.h
--- a/fs/ufs/ufs.h~fs-ufs-convert-ufsd-printk-to-pr_debug
+++ a/fs/ufs/ufs.h
@@ -77,9 +77,9 @@ struct ufs_inode_info {
  */
 #ifdef CONFIG_UFS_DEBUG
 #	define UFSD(f, a...)	{					\
-		printk ("UFSD (%s, %d): %s:",				\
+		pr_debug("UFSD (%s, %d): %s:",				\
 			__FILE__, __LINE__, __func__);		\
-		printk (f, ## a);					\
+		pr_debug(f, ## a);					\
 	}
 #else
 #	define UFSD(f, a...)	/**/
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-squashfs-superc-logging-clean-up.patch
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
fs-ufs-convert-printk-to-pr_foo.patch
fs-ufs-use-pr_fmt.patch
fs-ufs-superc-use-__func__-in-logging.patch
fs-ufs-superc-use-va_format-instead-of-buffer-vsnprintf.patch
fs-ufs-convert-ufsd-printk-to-pr_debug.patch
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

