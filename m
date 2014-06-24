From: akpm@linux-foundation.org
Subject: + fs-reiserfs-use-linux-uaccessh.patch added to -mm tree
Date: Tue, 24 Jun 2014 14:31:34 -0700
Message-ID: <53a9ee36.voNGRyocvnqw9rZ0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaFXVbf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 17:31:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jeffm@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/reiserfs: use linux/uaccess.h
has been added to the -mm tree.  Its filename is
     fs-reiserfs-use-linux-uaccessh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-reiserfs-use-linux-uaccessh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-reiserfs-use-linux-uaccessh.patch

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
Subject: fs/reiserfs: use linux/uaccess.h

Fix checkpatch warning
WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/dir.c            |    2 +-
 fs/reiserfs/do_balan.c       |    2 +-
 fs/reiserfs/file.c           |    2 +-
 fs/reiserfs/ibalance.c       |    2 +-
 fs/reiserfs/inode.c          |    2 +-
 fs/reiserfs/ioctl.c          |    2 +-
 fs/reiserfs/lbalance.c       |    2 +-
 fs/reiserfs/procfs.c         |    2 +-
 fs/reiserfs/super.c          |    2 +-
 fs/reiserfs/xattr.c          |    2 +-
 fs/reiserfs/xattr_acl.c      |    2 +-
 fs/reiserfs/xattr_security.c |    2 +-
 fs/reiserfs/xattr_trusted.c  |    2 +-
 fs/reiserfs/xattr_user.c     |    2 +-
 14 files changed, 14 insertions(+), 14 deletions(-)

diff -puN fs/reiserfs/dir.c~fs-reiserfs-use-linux-uaccessh fs/reiserfs/dir.c
--- a/fs/reiserfs/dir.c~fs-reiserfs-use-linux-uaccessh
+++ a/fs/reiserfs/dir.c
@@ -9,7 +9,7 @@
 #include <linux/stat.h>
 #include <linux/buffer_head.h>
 #include <linux/slab.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 extern const struct reiserfs_key MIN_KEY;
 
diff -puN fs/reiserfs/do_balan.c~fs-reiserfs-use-linux-uaccessh fs/reiserfs/do_balan.c
--- a/fs/reiserfs/do_balan.c~fs-reiserfs-use-linux-uaccessh
+++ a/fs/reiserfs/do_balan.c
@@ -10,7 +10,7 @@
  * and using buffers obtained after all above.
  */
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/time.h>
 #include "reiserfs.h"
 #include <linux/buffer_head.h>
diff -puN fs/reiserfs/file.c~fs-reiserfs-use-linux-uaccessh fs/reiserfs/file.c
--- a/fs/reiserfs/file.c~fs-reiserfs-use-linux-uaccessh
+++ a/fs/reiserfs/file.c
@@ -6,7 +6,7 @@
 #include "reiserfs.h"
 #include "acl.h"
 #include "xattr.h"
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
 #include <linux/writeback.h>
diff -puN fs/reiserfs/ibalance.c~fs-reiserfs-use-linux-uaccessh fs/reiserfs/ibalance.c
--- a/fs/reiserfs/ibalance.c~fs-reiserfs-use-linux-uaccessh
+++ a/fs/reiserfs/ibalance.c
@@ -2,7 +2,7 @@
  * Copyright 2000 by Hans Reiser, licensing governed by reiserfs/README
  */
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/string.h>
 #include <linux/time.h>
 #include "reiserfs.h"
diff -puN fs/reiserfs/inode.c~fs-reiserfs-use-linux-uaccessh fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~fs-reiserfs-use-linux-uaccessh
+++ a/fs/reiserfs/inode.c
@@ -11,7 +11,7 @@
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
 #include <linux/slab.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/unaligned.h>
 #include <linux/buffer_head.h>
 #include <linux/mpage.h>
diff -puN fs/reiserfs/ioctl.c~fs-reiserfs-use-linux-uaccessh fs/reiserfs/ioctl.c
--- a/fs/reiserfs/ioctl.c~fs-reiserfs-use-linux-uaccessh
+++ a/fs/reiserfs/ioctl.c
@@ -7,7 +7,7 @@
 #include <linux/mount.h>
 #include "reiserfs.h"
 #include <linux/time.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/pagemap.h>
 #include <linux/compat.h>
 
diff -puN fs/reiserfs/lbalance.c~fs-reiserfs-use-linux-uaccessh fs/reiserfs/lbalance.c
--- a/fs/reiserfs/lbalance.c~fs-reiserfs-use-linux-uaccessh
+++ a/fs/reiserfs/lbalance.c
@@ -2,7 +2,7 @@
  * Copyright 2000 by Hans Reiser, licensing governed by reiserfs/README
  */
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/string.h>
 #include <linux/time.h>
 #include "reiserfs.h"
diff -puN fs/reiserfs/procfs.c~fs-reiserfs-use-linux-uaccessh fs/reiserfs/procfs.c
--- a/fs/reiserfs/procfs.c~fs-reiserfs-use-linux-uaccessh
+++ a/fs/reiserfs/procfs.c
@@ -11,7 +11,7 @@
 #include <linux/module.h>
 #include <linux/time.h>
 #include <linux/seq_file.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include "reiserfs.h"
 #include <linux/init.h>
 #include <linux/proc_fs.h>
diff -puN fs/reiserfs/super.c~fs-reiserfs-use-linux-uaccessh fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~fs-reiserfs-use-linux-uaccessh
+++ a/fs/reiserfs/super.c
@@ -15,7 +15,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/time.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include "reiserfs.h"
 #include "acl.h"
 #include "xattr.h"
diff -puN fs/reiserfs/xattr.c~fs-reiserfs-use-linux-uaccessh fs/reiserfs/xattr.c
--- a/fs/reiserfs/xattr.c~fs-reiserfs-use-linux-uaccessh
+++ a/fs/reiserfs/xattr.c
@@ -45,7 +45,7 @@
 #include <linux/xattr.h>
 #include "xattr.h"
 #include "acl.h"
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <net/checksum.h>
 #include <linux/stat.h>
 #include <linux/quotaops.h>
diff -puN fs/reiserfs/xattr_acl.c~fs-reiserfs-use-linux-uaccessh fs/reiserfs/xattr_acl.c
--- a/fs/reiserfs/xattr_acl.c~fs-reiserfs-use-linux-uaccessh
+++ a/fs/reiserfs/xattr_acl.c
@@ -9,7 +9,7 @@
 #include <linux/posix_acl_xattr.h>
 #include "xattr.h"
 #include "acl.h"
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 static int __reiserfs_set_acl(struct reiserfs_transaction_handle *th,
 			    struct inode *inode, int type,
diff -puN fs/reiserfs/xattr_security.c~fs-reiserfs-use-linux-uaccessh fs/reiserfs/xattr_security.c
--- a/fs/reiserfs/xattr_security.c~fs-reiserfs-use-linux-uaccessh
+++ a/fs/reiserfs/xattr_security.c
@@ -6,7 +6,7 @@
 #include <linux/slab.h>
 #include "xattr.h"
 #include <linux/security.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 static int
 security_get(struct dentry *dentry, const char *name, void *buffer, size_t size,
diff -puN fs/reiserfs/xattr_trusted.c~fs-reiserfs-use-linux-uaccessh fs/reiserfs/xattr_trusted.c
--- a/fs/reiserfs/xattr_trusted.c~fs-reiserfs-use-linux-uaccessh
+++ a/fs/reiserfs/xattr_trusted.c
@@ -5,7 +5,7 @@
 #include <linux/pagemap.h>
 #include <linux/xattr.h>
 #include "xattr.h"
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 static int
 trusted_get(struct dentry *dentry, const char *name, void *buffer, size_t size,
diff -puN fs/reiserfs/xattr_user.c~fs-reiserfs-use-linux-uaccessh fs/reiserfs/xattr_user.c
--- a/fs/reiserfs/xattr_user.c~fs-reiserfs-use-linux-uaccessh
+++ a/fs/reiserfs/xattr_user.c
@@ -4,7 +4,7 @@
 #include <linux/pagemap.h>
 #include <linux/xattr.h>
 #include "xattr.h"
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 static int
 user_get(struct dentry *dentry, const char *name, void *buffer, size_t size,
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

