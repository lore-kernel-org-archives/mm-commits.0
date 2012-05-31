From: akpm@linux-foundation.org
Subject: [merged] mm-move-readahead-syscall-to-mm-readaheadc.patch removed from -mm tree
Date: Thu, 31 May 2012 12:15:56 -0700
Message-ID: <20120531191556.64F3AA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:42243 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932743Ab2EaTP5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:15:57 -0400
Received: by mail-qa0-f74.google.com with SMTP id g24so154247qab.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:15:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, fengguang.wu@intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move readahead syscall to mm/readahead.c
has been removed from the -mm tree.  Its filename was
     mm-move-readahead-syscall-to-mm-readaheadc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: mm: move readahead syscall to mm/readahead.c

It is better to define readahead(2) in mm/readahead.c than in
mm/filemap.c.

Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c   |   39 ---------------------------------------
 mm/readahead.c |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 39 deletions(-)

diff -puN mm/filemap.c~mm-move-readahead-syscall-to-mm-readaheadc mm/filemap.c
--- a/mm/filemap.c~mm-move-readahead-syscall-to-mm-readaheadc
+++ a/mm/filemap.c
@@ -29,7 +29,6 @@
 #include <linux/pagevec.h>
 #include <linux/blkdev.h>
 #include <linux/security.h>
-#include <linux/syscalls.h>
 #include <linux/cpuset.h>
 #include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
 #include <linux/memcontrol.h>
@@ -1478,44 +1477,6 @@ out:
 }
 EXPORT_SYMBOL(generic_file_aio_read);
 
-static ssize_t
-do_readahead(struct address_space *mapping, struct file *filp,
-	     pgoff_t index, unsigned long nr)
-{
-	if (!mapping || !mapping->a_ops || !mapping->a_ops->readpage)
-		return -EINVAL;
-
-	force_page_cache_readahead(mapping, filp, index, nr);
-	return 0;
-}
-
-SYSCALL_DEFINE(readahead)(int fd, loff_t offset, size_t count)
-{
-	ssize_t ret;
-	struct file *file;
-
-	ret = -EBADF;
-	file = fget(fd);
-	if (file) {
-		if (file->f_mode & FMODE_READ) {
-			struct address_space *mapping = file->f_mapping;
-			pgoff_t start = offset >> PAGE_CACHE_SHIFT;
-			pgoff_t end = (offset + count - 1) >> PAGE_CACHE_SHIFT;
-			unsigned long len = end - start + 1;
-			ret = do_readahead(mapping, file, start, len);
-		}
-		fput(file);
-	}
-	return ret;
-}
-#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
-asmlinkage long SyS_readahead(long fd, loff_t offset, long count)
-{
-	return SYSC_readahead((int) fd, offset, (size_t) count);
-}
-SYSCALL_ALIAS(sys_readahead, SyS_readahead);
-#endif
-
 #ifdef CONFIG_MMU
 /**
  * page_cache_read - adds requested page to the page cache if not already there
diff -puN mm/readahead.c~mm-move-readahead-syscall-to-mm-readaheadc mm/readahead.c
--- a/mm/readahead.c~mm-move-readahead-syscall-to-mm-readaheadc
+++ a/mm/readahead.c
@@ -17,6 +17,8 @@
 #include <linux/task_io_accounting_ops.h>
 #include <linux/pagevec.h>
 #include <linux/pagemap.h>
+#include <linux/syscalls.h>
+#include <linux/file.h>
 
 /*
  * Initialise a struct file's readahead state.  Assumes that the caller has
@@ -562,3 +564,41 @@ page_cache_async_readahead(struct addres
 	ondemand_readahead(mapping, ra, filp, true, offset, req_size);
 }
 EXPORT_SYMBOL_GPL(page_cache_async_readahead);
+
+static ssize_t
+do_readahead(struct address_space *mapping, struct file *filp,
+	     pgoff_t index, unsigned long nr)
+{
+	if (!mapping || !mapping->a_ops || !mapping->a_ops->readpage)
+		return -EINVAL;
+
+	force_page_cache_readahead(mapping, filp, index, nr);
+	return 0;
+}
+
+SYSCALL_DEFINE(readahead)(int fd, loff_t offset, size_t count)
+{
+	ssize_t ret;
+	struct file *file;
+
+	ret = -EBADF;
+	file = fget(fd);
+	if (file) {
+		if (file->f_mode & FMODE_READ) {
+			struct address_space *mapping = file->f_mapping;
+			pgoff_t start = offset >> PAGE_CACHE_SHIFT;
+			pgoff_t end = (offset + count - 1) >> PAGE_CACHE_SHIFT;
+			unsigned long len = end - start + 1;
+			ret = do_readahead(mapping, file, start, len);
+		}
+		fput(file);
+	}
+	return ret;
+}
+#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
+asmlinkage long SyS_readahead(long fd, loff_t offset, long count)
+{
+	return SYSC_readahead((int) fd, offset, (size_t) count);
+}
+SYSCALL_ALIAS(sys_readahead, SyS_readahead);
+#endif
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
fs-move-file_remove_suid-to-fs-inodec.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-use-is_err_or_null.patch

