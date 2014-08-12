From: akpm@linux-foundation.org
Subject: [merged] fs-coda-use-linux-uaccessh.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:39:02 -0700
Message-ID: <53ea6d56.4Wk56oIM5Mg3+KfX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:36838 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbaHLTjD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:39:03 -0400
Received: by mail-vc0-f202.google.com with SMTP id hq11so1305473vcb.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:39:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jaharkes@cs.cmu.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/coda: use linux/uaccess.h
has been removed from the -mm tree.  Its filename was
     fs-coda-use-linux-uaccessh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/coda: use linux/uaccess.h

Fix checkpatch warning
WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/cache.c      |    2 +-
 fs/coda/coda_linux.c |    2 +-
 fs/coda/dir.c        |    3 +--
 fs/coda/file.c       |    2 +-
 fs/coda/inode.c      |    4 +---
 fs/coda/pioctl.c     |    2 +-
 fs/coda/psdev.c      |    2 +-
 fs/coda/upcall.c     |    2 +-
 8 files changed, 8 insertions(+), 11 deletions(-)

diff -puN fs/coda/cache.c~fs-coda-use-linux-uaccessh fs/coda/cache.c
--- a/fs/coda/cache.c~fs-coda-use-linux-uaccessh
+++ a/fs/coda/cache.c
@@ -13,7 +13,7 @@
 #include <linux/fs.h>
 #include <linux/stat.h>
 #include <linux/errno.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/string.h>
 #include <linux/list.h>
 #include <linux/sched.h>
diff -puN fs/coda/coda_linux.c~fs-coda-use-linux-uaccessh fs/coda/coda_linux.c
--- a/fs/coda/coda_linux.c~fs-coda-use-linux-uaccessh
+++ a/fs/coda/coda_linux.c
@@ -13,7 +13,7 @@
 #include <linux/fs.h>
 #include <linux/stat.h>
 #include <linux/errno.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/string.h>
 
 #include <linux/coda.h>
diff -puN fs/coda/dir.c~fs-coda-use-linux-uaccessh fs/coda/dir.c
--- a/fs/coda/dir.c~fs-coda-use-linux-uaccessh
+++ a/fs/coda/dir.c
@@ -19,8 +19,7 @@
 #include <linux/string.h>
 #include <linux/spinlock.h>
 #include <linux/namei.h>
-
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include <linux/coda.h>
 #include <linux/coda_psdev.h>
diff -puN fs/coda/file.c~fs-coda-use-linux-uaccessh fs/coda/file.c
--- a/fs/coda/file.c~fs-coda-use-linux-uaccessh
+++ a/fs/coda/file.c
@@ -18,7 +18,7 @@
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/slab.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include <linux/coda.h>
 #include <linux/coda_psdev.h>
diff -puN fs/coda/inode.c~fs-coda-use-linux-uaccessh fs/coda/inode.c
--- a/fs/coda/inode.c~fs-coda-use-linux-uaccessh
+++ a/fs/coda/inode.c
@@ -21,9 +21,7 @@
 #include <linux/vfs.h>
 #include <linux/slab.h>
 #include <linux/pid_namespace.h>
-
-#include <asm/uaccess.h>
-
+#include <linux/uaccess.h>
 #include <linux/fs.h>
 #include <linux/vmalloc.h>
 
diff -puN fs/coda/pioctl.c~fs-coda-use-linux-uaccessh fs/coda/pioctl.c
--- a/fs/coda/pioctl.c~fs-coda-use-linux-uaccessh
+++ a/fs/coda/pioctl.c
@@ -16,7 +16,7 @@
 #include <linux/string.h>
 #include <linux/namei.h>
 #include <linux/module.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include <linux/coda.h>
 #include <linux/coda_psdev.h>
diff -puN fs/coda/psdev.c~fs-coda-use-linux-uaccessh fs/coda/psdev.c
--- a/fs/coda/psdev.c~fs-coda-use-linux-uaccessh
+++ a/fs/coda/psdev.c
@@ -40,7 +40,7 @@
 #include <linux/pid_namespace.h>
 #include <asm/io.h>
 #include <asm/poll.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include <linux/coda.h>
 #include <linux/coda_psdev.h>
diff -puN fs/coda/upcall.c~fs-coda-use-linux-uaccessh fs/coda/upcall.c
--- a/fs/coda/upcall.c~fs-coda-use-linux-uaccessh
+++ a/fs/coda/upcall.c
@@ -27,7 +27,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/vmalloc.h>
 #include <linux/vfs.h>
 
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

