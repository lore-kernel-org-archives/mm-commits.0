From: akpm@linux-foundation.org
Subject: + mm-move-readahead-syscall-to-mm-readaheadc.patch added to -mm tree
Date: Tue, 15 May 2012 14:21:51 -0700
Message-ID: <20120515212151.59767A028F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:36448 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966208Ab2EOVVw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 May 2012 17:21:52 -0400
Received: by yenl3 with SMTP id l3so8659yen.1
        for <mm-commits@vger.kernel.org>; Tue, 15 May 2012 14:21:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, fengguang.wu@intel.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: mm: move readahead syscall to mm/readahead.c
has been added to the -mm tree.  Its filename is
     mm-move-readahead-syscall-to-mm-readaheadc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: mm: move readahead syscall to mm/readahead.c

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

linux-next.patch
cris-select-generic_atomic64.patch
bug-introduce-build_bug_on_invalid-macro.patch
bug-completely-remove-code-generated-by-disabled-vm_bug_on.patch
tmpfs-enable-nosec-optimization.patch
mm-move-readahead-syscall-to-mm-readaheadc.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-use-is_err_or_null.patch
fs-move-file_remove_suid-to-fs-inodec.patch

