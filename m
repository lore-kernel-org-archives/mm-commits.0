Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 534BECCA47A
	for <mm-commits@archiver.kernel.org>; Wed,  8 Jun 2022 19:21:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbiFHTV5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Jun 2022 15:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbiFHTV4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2022 15:21:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC4E1BBAC3
        for <mm-commits@vger.kernel.org>; Wed,  8 Jun 2022 12:21:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3796160DE5
        for <mm-commits@vger.kernel.org>; Wed,  8 Jun 2022 19:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8603AC34116;
        Wed,  8 Jun 2022 19:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654716113;
        bh=R+F8miEDOjVfnEMLhpsZB6G8Il5jIMA6DubM7LZVh5E=;
        h=Date:To:From:Subject:From;
        b=KePyCN4mcu8Pvungg7H41DR7sZpUkNXfIPWWnilMIt5sA5xYxtyiW5NyeT48gbr0v
         nROAEMrI/CThXAYQazy2hrr+GPGIeFk0eYBPS3fvatvJ0WJzQzIy8aXISXI3PHxtu/
         w5ML8/xwvtD9BV0KGqkCJLTsMI9DeVZZEfHITMpw=
Date:   Wed, 08 Jun 2022 12:21:52 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        sashal@kernel.org, gthelen@google.com, ebiederm@xmission.com,
        bhe@redhat.com, pasha.tatashin@soleen.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-kernel_read_file-allow-to-read-files-up-to-ssize_t.patch added to mm-nonmm-unstable branch
Message-Id: <20220608192153.8603AC34116@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/kernel_read_file: allow to read files up-to ssize_t
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-kernel_read_file-allow-to-read-files-up-to-ssize_t.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-kernel_read_file-allow-to-read-files-up-to-ssize_t.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: fs/kernel_read_file: allow to read files up-to ssize_t
Date: Fri, 27 May 2022 02:55:34 +0000

Patch series "Allow to kexec with initramfs larger than 2G", v2.

Currently, the largest initramfs that is supported by kexec_file_load()
syscall is 2G.

This is because kernel_read_file() returns int, and is limited to INT_MAX
or 2G.

On the other hand, there are kexec based boot loaders (i.e.  u-root), that
may need to boot netboot images that might be larger than 2G.

The first patch changes the return type from int to ssize_t in
kernel_read_file* functions.

The second patch increases the maximum initramfs file size to 4G.

Tested: verified that can kexec_file_load() works with 4G initramfs
on x86_64.


This patch (of 2):

Currently, the maximum file size that is supported is 2G.  This may be too
small in some cases.  For example, kexec_file_load() system call loads
initramfs.  In some netboot cases initramfs can be rather large.

Allow to use up-to ssize_t bytes.  The callers still can limit the maximum
file size via buf_size.

Link: https://lkml.kernel.org/r/20220527025535.3953665-1-pasha.tatashin@soleen.com
Link: https://lkml.kernel.org/r/20220527025535.3953665-2-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baoquan He <bhe@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/kernel_read_file.c            |   38 ++++++++++++++---------------
 include/linux/kernel_read_file.h |   32 ++++++++++++------------
 include/linux/limits.h           |    1 
 3 files changed, 36 insertions(+), 35 deletions(-)

--- a/fs/kernel_read_file.c~fs-kernel_read_file-allow-to-read-files-up-to-ssize_t
+++ a/fs/kernel_read_file.c
@@ -29,15 +29,15 @@
  * change between calls to kernel_read_file().
  *
  * Returns number of bytes read (no single read will be bigger
- * than INT_MAX), or negative on error.
+ * than SSIZE_MAX), or negative on error.
  *
  */
-int kernel_read_file(struct file *file, loff_t offset, void **buf,
-		     size_t buf_size, size_t *file_size,
-		     enum kernel_read_file_id id)
+ssize_t kernel_read_file(struct file *file, loff_t offset, void **buf,
+			 size_t buf_size, size_t *file_size,
+			 enum kernel_read_file_id id)
 {
 	loff_t i_size, pos;
-	size_t copied;
+	ssize_t copied;
 	void *allocated = NULL;
 	bool whole_file;
 	int ret;
@@ -58,7 +58,7 @@ int kernel_read_file(struct file *file,
 		goto out;
 	}
 	/* The file is too big for sane activities. */
-	if (i_size > INT_MAX) {
+	if (i_size > SSIZE_MAX) {
 		ret = -EFBIG;
 		goto out;
 	}
@@ -124,12 +124,12 @@ out:
 }
 EXPORT_SYMBOL_GPL(kernel_read_file);
 
-int kernel_read_file_from_path(const char *path, loff_t offset, void **buf,
-			       size_t buf_size, size_t *file_size,
-			       enum kernel_read_file_id id)
+ssize_t kernel_read_file_from_path(const char *path, loff_t offset, void **buf,
+				   size_t buf_size, size_t *file_size,
+				   enum kernel_read_file_id id)
 {
 	struct file *file;
-	int ret;
+	ssize_t ret;
 
 	if (!path || !*path)
 		return -EINVAL;
@@ -144,14 +144,14 @@ int kernel_read_file_from_path(const cha
 }
 EXPORT_SYMBOL_GPL(kernel_read_file_from_path);
 
-int kernel_read_file_from_path_initns(const char *path, loff_t offset,
-				      void **buf, size_t buf_size,
-				      size_t *file_size,
-				      enum kernel_read_file_id id)
+ssize_t kernel_read_file_from_path_initns(const char *path, loff_t offset,
+					  void **buf, size_t buf_size,
+					  size_t *file_size,
+					  enum kernel_read_file_id id)
 {
 	struct file *file;
 	struct path root;
-	int ret;
+	ssize_t ret;
 
 	if (!path || !*path)
 		return -EINVAL;
@@ -171,12 +171,12 @@ int kernel_read_file_from_path_initns(co
 }
 EXPORT_SYMBOL_GPL(kernel_read_file_from_path_initns);
 
-int kernel_read_file_from_fd(int fd, loff_t offset, void **buf,
-			     size_t buf_size, size_t *file_size,
-			     enum kernel_read_file_id id)
+ssize_t kernel_read_file_from_fd(int fd, loff_t offset, void **buf,
+				 size_t buf_size, size_t *file_size,
+				 enum kernel_read_file_id id)
 {
 	struct fd f = fdget(fd);
-	int ret = -EBADF;
+	ssize_t ret = -EBADF;
 
 	if (!f.file || !(f.file->f_mode & FMODE_READ))
 		goto out;
--- a/include/linux/kernel_read_file.h~fs-kernel_read_file-allow-to-read-files-up-to-ssize_t
+++ a/include/linux/kernel_read_file.h
@@ -35,21 +35,21 @@ static inline const char *kernel_read_fi
 	return kernel_read_file_str[id];
 }
 
-int kernel_read_file(struct file *file, loff_t offset,
-		     void **buf, size_t buf_size,
-		     size_t *file_size,
-		     enum kernel_read_file_id id);
-int kernel_read_file_from_path(const char *path, loff_t offset,
-			       void **buf, size_t buf_size,
-			       size_t *file_size,
-			       enum kernel_read_file_id id);
-int kernel_read_file_from_path_initns(const char *path, loff_t offset,
-				      void **buf, size_t buf_size,
-				      size_t *file_size,
-				      enum kernel_read_file_id id);
-int kernel_read_file_from_fd(int fd, loff_t offset,
-			     void **buf, size_t buf_size,
-			     size_t *file_size,
-			     enum kernel_read_file_id id);
+ssize_t kernel_read_file(struct file *file, loff_t offset,
+			 void **buf, size_t buf_size,
+			 size_t *file_size,
+			 enum kernel_read_file_id id);
+ssize_t kernel_read_file_from_path(const char *path, loff_t offset,
+				   void **buf, size_t buf_size,
+				   size_t *file_size,
+				   enum kernel_read_file_id id);
+ssize_t kernel_read_file_from_path_initns(const char *path, loff_t offset,
+					  void **buf, size_t buf_size,
+					  size_t *file_size,
+					  enum kernel_read_file_id id);
+ssize_t kernel_read_file_from_fd(int fd, loff_t offset,
+				 void **buf, size_t buf_size,
+				 size_t *file_size,
+				 enum kernel_read_file_id id);
 
 #endif /* _LINUX_KERNEL_READ_FILE_H */
--- a/include/linux/limits.h~fs-kernel_read_file-allow-to-read-files-up-to-ssize_t
+++ a/include/linux/limits.h
@@ -7,6 +7,7 @@
 #include <vdso/limits.h>
 
 #define SIZE_MAX	(~(size_t)0)
+#define SSIZE_MAX	((ssize_t)(SIZE_MAX >> 1))
 #define PHYS_ADDR_MAX	(~(phys_addr_t)0)
 
 #define U8_MAX		((u8)~0U)
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

fs-kernel_read_file-allow-to-read-files-up-to-ssize_t.patch
kexec_file-increase-maximum-file-size-to-4g.patch

