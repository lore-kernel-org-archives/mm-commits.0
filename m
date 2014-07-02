From: akpm@linux-foundation.org
Subject: + fs-coda-use-linux-uaccessh.patch added to -mm tree
Date: Wed, 02 Jul 2014 13:06:43 -0700
Message-ID: <53b46653.C0cKxWOyYEUwabHl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:60114 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbaGBUGo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2014 16:06:44 -0400
Received: by mail-ie0-f202.google.com with SMTP id tr6so2697912ieb.1
        for <mm-commits@vger.kernel.org>; Wed, 02 Jul 2014 13:06:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jaharkes@cs.cmu.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/coda: use linux/uaccess.h
has been added to the -mm tree.  Its filename is
     fs-coda-use-linux-uaccessh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-coda-use-linux-uaccessh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-coda-use-linux-uaccessh.patch

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

kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
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
mm-hwpoison-injectc-remove-unnecessary-null-test-before-debugfs_remove_recursive.patch
mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch
lib-test-kstrtoxc-use-array_size-instead-of-sizeof-sizeof.patch
fs-compatc-remove-unnecessary-test-on-unsigned-value.patch
checkpatch-emit-fewer-kmalloc_array-kcalloc-conversion-warnings.patch
fs-ramfs-file-nommuc-replace-countsize-kzalloc-by-kcalloc.patch
kernel-test_kprobesc-use-current-logging-functions.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
fs-coda-use-linux-uaccessh.patch
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
proc-constify-seq_operations.patch
fs-exofs-ore_raidc-replace-countsize-kzalloc-by-kcalloc.patch
kernel-gcov-fsc-remove-unnecessary-null-test-before-debugfs_remove.patch
fs-adfs-dir_fplusc-use-array_size-instead-of-sizeof-sizeof.patch
fs-adfs-dir_fplusc-replace-countsize-kzalloc-by-kcalloc.patch
fs-bfs-use-bfs-prefix-for-dump_imap.patch
drivers-parport-parport_ip32c-use-ptr_err_or_zero.patch
fs-pstore-ram_corec-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch
fs-cachefiles-bindc-remove-unnecessary-assertions.patch
fs-omfs-inodec-replace-countsize-kzalloc-by-kcalloc.patch
fs-romfs-superc-convert-printk-to-pr_foo.patch
fs-romfs-superc-use-pr_fmt-in-logging.patch
fs-romfs-superc-add-blank-line-after-declarations.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
scripts-coccinelle-free-add-null-test-before-freeing-functions.patch
fs-dlm-debug_fsc-remove-unnecessary-null-test-before-debugfs_remove.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

