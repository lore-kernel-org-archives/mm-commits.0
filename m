From: akpm@linux-foundation.org
Subject: + fs-ufs-superc-use-va_format-instead-of-buffer-vsnprintf.patch
 added to -mm tree
Date: Fri, 20 Jun 2014 15:31:59 -0700
Message-ID: <53a4b65f.XU7R3q+Wbjztchfr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33313 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966271AbaFTWcA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 18:32:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dushistov@mail.ru, fabf@skynet.be


The patch titled
     Subject: fs/ufs/super.c: use va_format instead of buffer/vsnprintf
has been added to the -mm tree.  Its filename is
     fs-ufs-superc-use-va_format-instead-of-buffer-vsnprintf.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ufs-superc-use-va_format-instead-of-buffer-vsnprintf.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ufs-superc-use-va_format-instead-of-buffer-vsnprintf.patch

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
Subject: fs/ufs/super.c: use va_format instead of buffer/vsnprintf

Remove error_buffer and use %pV

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |   44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff -puN fs/ufs/super.c~fs-ufs-superc-use-va_format-instead-of-buffer-vsnprintf fs/ufs/super.c
--- a/fs/ufs/super.c~fs-ufs-superc-use-va_format-instead-of-buffer-vsnprintf
+++ a/fs/ufs/super.c
@@ -286,13 +286,12 @@ static void ufs_print_cylinder_stuff(str
 
 static const struct super_operations ufs_super_ops;
 
-static char error_buf[1024];
-
 void ufs_error (struct super_block * sb, const char * function,
 	const char * fmt, ...)
 {
 	struct ufs_sb_private_info * uspi;
 	struct ufs_super_block_first * usb1;
+	struct va_format vaf;
 	va_list args;
 
 	uspi = UFS_SB(sb)->s_uspi;
@@ -304,20 +303,21 @@ void ufs_error (struct super_block * sb,
 		ufs_mark_sb_dirty(sb);
 		sb->s_flags |= MS_RDONLY;
 	}
-	va_start (args, fmt);
-	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
-	va_end (args);
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
 	switch (UFS_SB(sb)->s_mount_opt & UFS_MOUNT_ONERROR) {
 	case UFS_MOUNT_ONERROR_PANIC:
-		panic("panic (device %s): %s: %s\n",
-			sb->s_id, function, error_buf);
+		panic("panic (device %s): %s: %pV\n",
+		      sb->s_id, function, &vaf);
 
 	case UFS_MOUNT_ONERROR_LOCK:
 	case UFS_MOUNT_ONERROR_UMOUNT:
 	case UFS_MOUNT_ONERROR_REPAIR:
-		pr_crit("error (device %s): %s: %s\n",
-			sb->s_id, function, error_buf);
-	}		
+		pr_crit("error (device %s): %s: %pV\n",
+			sb->s_id, function, &vaf);
+	}
+	va_end(args);
 }
 
 void ufs_panic (struct super_block * sb, const char * function,
@@ -325,6 +325,7 @@ void ufs_panic (struct super_block * sb,
 {
 	struct ufs_sb_private_info * uspi;
 	struct ufs_super_block_first * usb1;
+	struct va_format vaf;
 	va_list args;
 	
 	uspi = UFS_SB(sb)->s_uspi;
@@ -335,24 +336,27 @@ void ufs_panic (struct super_block * sb,
 		ubh_mark_buffer_dirty(USPI_UBH(uspi));
 		ufs_mark_sb_dirty(sb);
 	}
-	va_start (args, fmt);
-	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
-	va_end (args);
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
 	sb->s_flags |= MS_RDONLY;
-	pr_crit("panic (device %s): %s: %s\n",
-		sb->s_id, function, error_buf);
+	pr_crit("panic (device %s): %s: %pV\n",
+		sb->s_id, function, &vaf);
+	va_end(args);
 }
 
 void ufs_warning (struct super_block * sb, const char * function,
 	const char * fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 
-	va_start (args, fmt);
-	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
-	va_end (args);
-	pr_warn("warning (device %s): %s: %s\n",
-		sb->s_id, function, error_buf);
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	pr_warn("(device %s): %s: %pV\n",
+		sb->s_id, function, &vaf);
+	va_end(args);
 }
 
 enum {
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

