From: akpm@linux-foundation.org
Subject: + fs-ufs-use-pr_fmt.patch added to -mm tree
Date: Fri, 20 Jun 2014 15:31:57 -0700
Message-ID: <53a4b65d.vpX6Xk4DQ3b9EqXG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33307 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196AbaFTWb6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 18:31:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dushistov@mail.ru, fabf@skynet.be


The patch titled
     Subject: fs/ufs: use pr_fmt
has been added to the -mm tree.  Its filename is
     fs-ufs-use-pr_fmt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ufs-use-pr_fmt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ufs-use-pr_fmt.patch

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
Subject: fs/ufs: use pr_fmt

Replace UFS-fs, UFS-fs: and UFS: by pr_fmt with module name "ufs: "

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |   15 +++++++--------
 fs/ufs/ufs.h   |    6 ++++++
 2 files changed, 13 insertions(+), 8 deletions(-)

diff -puN fs/ufs/super.c~fs-ufs-use-pr_fmt fs/ufs/super.c
--- a/fs/ufs/super.c~fs-ufs-use-pr_fmt
+++ a/fs/ufs/super.c
@@ -65,7 +65,6 @@
  * Evgeniy Dushistov <dushistov@mail.ru>, 2007
  */
 
-
 #include <linux/exportfs.h>
 #include <linux/module.h>
 #include <linux/bitops.h>
@@ -310,13 +309,13 @@ void ufs_error (struct super_block * sb,
 	va_end (args);
 	switch (UFS_SB(sb)->s_mount_opt & UFS_MOUNT_ONERROR) {
 	case UFS_MOUNT_ONERROR_PANIC:
-		panic ("UFS-fs panic (device %s): %s: %s\n", 
+		panic("panic (device %s): %s: %s\n",
 			sb->s_id, function, error_buf);
 
 	case UFS_MOUNT_ONERROR_LOCK:
 	case UFS_MOUNT_ONERROR_UMOUNT:
 	case UFS_MOUNT_ONERROR_REPAIR:
-		pr_crit("UFS-fs error (device %s): %s: %s\n",
+		pr_crit("error (device %s): %s: %s\n",
 			sb->s_id, function, error_buf);
 	}		
 }
@@ -340,7 +339,7 @@ void ufs_panic (struct super_block * sb,
 	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
 	va_end (args);
 	sb->s_flags |= MS_RDONLY;
-	pr_crit("UFS-fs panic (device %s): %s: %s\n",
+	pr_crit("panic (device %s): %s: %s\n",
 		sb->s_id, function, error_buf);
 }
 
@@ -352,7 +351,7 @@ void ufs_warning (struct super_block * s
 	va_start (args, fmt);
 	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
 	va_end (args);
-	pr_warn("UFS-fs warning (device %s): %s: %s\n",
+	pr_warn("warning (device %s): %s: %s\n",
 		sb->s_id, function, error_buf);
 }
 
@@ -464,12 +463,12 @@ static int ufs_parse_options (char * opt
 			ufs_set_opt (*mount_options, ONERROR_UMOUNT);
 			break;
 		case Opt_onerror_repair:
-			pr_err("UFS-fs: Unable to do repair on error, will lock lock instead\n");
+			pr_err("Unable to do repair on error, will lock lock instead\n");
 			ufs_clear_opt (*mount_options, ONERROR);
 			ufs_set_opt (*mount_options, ONERROR_REPAIR);
 			break;
 		default:
-			pr_err("UFS-fs: Invalid option: \"%s\" or missing value\n", p);
+			pr_err("Invalid option: \"%s\" or missing value\n", p);
 			return 0;
 		}
 	}
@@ -972,7 +971,7 @@ static int ufs_fill_super(struct super_b
 	
 again:	
 	if (!sb_set_blocksize(sb, block_size)) {
-		pr_err("UFS: failed to set blocksize\n");
+		pr_err("failed to set blocksize\n");
 		goto failed;
 	}
 
diff -puN fs/ufs/ufs.h~fs-ufs-use-pr_fmt fs/ufs/ufs.h
--- a/fs/ufs/ufs.h~fs-ufs-use-pr_fmt
+++ a/fs/ufs/ufs.h
@@ -1,6 +1,12 @@
 #ifndef _UFS_UFS_H
 #define _UFS_UFS_H 1
 
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define UFS_MAX_GROUP_LOADED 8
 #define UFS_CGNO_EMPTY ((unsigned)-1)
 
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

