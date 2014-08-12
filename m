From: akpm@linux-foundation.org
Subject: [merged] fs-reiserfs-use-linux-uaccessh.patch removed from -mm
 tree
Date: Tue, 12 Aug 2014 12:39:36 -0700
Message-ID: <53ea6d78.KuwlTtGqP4notb05%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:44480 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000AbaHLTjh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:39:37 -0400
Received: by mail-qa0-f74.google.com with SMTP id j15so1312720qaq.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:39:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jeffm@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/reiserfs: use linux/uaccess.h
has been removed from the -mm tree.  Its filename was
     fs-reiserfs-use-linux-uaccessh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

