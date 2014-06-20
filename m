From: akpm@linux-foundation.org
Subject: + fs-ufs-superc-use-__func__-in-logging.patch added to -mm tree
Date: Fri, 20 Jun 2014 15:31:58 -0700
Message-ID: <53a4b65e.KMzZUpCR4SIX6FDO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33310 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965046AbaFTWb7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 18:31:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dushistov@mail.ru, fabf@skynet.be


The patch titled
     Subject: fs/ufs/super.c: use __func__ in logging
has been added to the -mm tree.  Its filename is
     fs-ufs-superc-use-__func__-in-logging.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ufs-superc-use-__func__-in-logging.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ufs-superc-use-__func__-in-logging.patch

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
Subject: fs/ufs/super.c: use __func__ in logging

Replace approximate function name by __func__ using standard format
"function():"

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff -puN fs/ufs/super.c~fs-ufs-superc-use-__func__-in-logging fs/ufs/super.c
--- a/fs/ufs/super.c~fs-ufs-superc-use-__func__-in-logging
+++ a/fs/ufs/super.c
@@ -1030,7 +1030,7 @@ again:
 		goto again;
 	}
 	if (!silent)
-		pr_err("ufs_read_super: bad magic number\n");
+		pr_err("%s(): bad magic number\n", __func__);
 	goto failed;
 
 magic_found:
@@ -1044,33 +1044,33 @@ magic_found:
 	uspi->s_fshift = fs32_to_cpu(sb, usb1->fs_fshift);
 
 	if (!is_power_of_2(uspi->s_fsize)) {
-		pr_err("ufs_read_super: fragment size %u is not a power of 2\n",
-		       uspi->s_fsize);
+		pr_err("%s(): fragment size %u is not a power of 2\n",
+		       __func__, uspi->s_fsize);
 		goto failed;
 	}
 	if (uspi->s_fsize < 512) {
-		pr_err("ufs_read_super: fragment size %u is too small\n",
-		       uspi->s_fsize);
+		pr_err("%s(): fragment size %u is too small\n",
+		       __func__, uspi->s_fsize);
 		goto failed;
 	}
 	if (uspi->s_fsize > 4096) {
-		pr_err("ufs_read_super: fragment size %u is too large\n",
-		       uspi->s_fsize);
+		pr_err("%s(): fragment size %u is too large\n",
+		       __func__, uspi->s_fsize);
 		goto failed;
 	}
 	if (!is_power_of_2(uspi->s_bsize)) {
-		pr_err("ufs_read_super: block size %u is not a power of 2\n",
-		       uspi->s_bsize);
+		pr_err("%s(): block size %u is not a power of 2\n",
+		       __func__, uspi->s_bsize);
 		goto failed;
 	}
 	if (uspi->s_bsize < 4096) {
-		pr_err("ufs_read_super: block size %u is too small\n",
-		       uspi->s_bsize);
+		pr_err("%s(): block size %u is too small\n",
+		       __func__, uspi->s_bsize);
 		goto failed;
 	}
 	if (uspi->s_bsize / uspi->s_fsize > 8) {
-		pr_err("ufs_read_super: too many fragments per block (%u)\n",
-		       uspi->s_bsize / uspi->s_fsize);
+		pr_err("%s(): too many fragments per block (%u)\n",
+		       __func__, uspi->s_bsize / uspi->s_fsize);
 		goto failed;
 	}
 	if (uspi->s_fsize != block_size || uspi->s_sbsize != super_block_size) {
@@ -1109,21 +1109,21 @@ magic_found:
 			UFSD("fs is DEC OSF/1\n");
 			break;
 		case UFS_FSACTIVE:
-			pr_err("ufs_read_super: fs is active\n");
+			pr_err("%s(): fs is active\n", __func__);
 			sb->s_flags |= MS_RDONLY;
 			break;
 		case UFS_FSBAD:
-			pr_err("ufs_read_super: fs is bad\n");
+			pr_err("%s(): fs is bad\n", __func__);
 			sb->s_flags |= MS_RDONLY;
 			break;
 		default:
-			pr_err("ufs_read_super: can't grok fs_clean 0x%x\n",
-			       usb1->fs_clean);
+			pr_err("%s(): can't grok fs_clean 0x%x\n",
+			       __func__, usb1->fs_clean);
 			sb->s_flags |= MS_RDONLY;
 			break;
 		}
 	} else {
-		pr_err("ufs_read_super: fs needs fsck\n");
+		pr_err("%s(): fs needs fsck\n", __func__);
 		sb->s_flags |= MS_RDONLY;
 	}
 
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

