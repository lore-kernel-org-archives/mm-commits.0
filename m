From: akpm@linux-foundation.org
Subject: [merged] maccess-clarify-kerneldoc-comments.patch removed
 from -mm tree
Date: Tue, 09 Jun 2020 17:39:59 -0700
Message-ID: <20200610003959.8FhgtzNDX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbgFJAkB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:40:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net, hch@lst.de, hpa@zytor.com, mhiramat@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: maccess: clarify kerneldoc comments
has been removed from the -mm tree.  Its filename was
     maccess-clarify-kerneldoc-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: maccess: clarify kerneldoc comments

Add proper kerneldoc comments for probe_kernel_read_strict and
probe_kernel_read strncpy_from_unsafe_strict and explain the different
versus the non-strict version.

Link: http://lkml.kernel.org/r/20200521152301.2587579-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/maccess.c |   60 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 43 insertions(+), 17 deletions(-)

--- a/mm/maccess.c~maccess-clarify-kerneldoc-comments
+++ a/mm/maccess.c
@@ -31,29 +31,36 @@ probe_write_common(void __user *dst, con
 }
 
 /**
- * probe_kernel_read(): safely attempt to read from a kernel-space location
+ * probe_kernel_read(): safely attempt to read from any location
  * @dst: pointer to the buffer that shall take the data
  * @src: address to read from
  * @size: size of the data chunk
  *
- * Safely read from address @src to the buffer at @dst.  If a kernel fault
- * happens, handle that and return -EFAULT.
+ * Same as probe_kernel_read_strict() except that for architectures with
+ * not fully separated user and kernel address spaces this function also works
+ * for user address tanges.
+ *
+ * DO NOT USE THIS FUNCTION - it is broken on architectures with entirely
+ * separate kernel and user address spaces, and also a bad idea otherwise.
+ */
+long __weak probe_kernel_read(void *dst, const void *src, size_t size)
+    __attribute__((alias("__probe_kernel_read")));
+
+/**
+ * probe_kernel_read_strict(): safely attempt to read from kernel-space
+ * @dst: pointer to the buffer that shall take the data
+ * @src: address to read from
+ * @size: size of the data chunk
+ *
+ * Safely read from kernel address @src to the buffer at @dst.  If a kernel
+ * fault happens, handle that and return -EFAULT.
  *
  * We ensure that the copy_from_user is executed in atomic context so that
  * do_page_fault() doesn't attempt to take mmap_lock.  This makes
  * probe_kernel_read() suitable for use within regions where the caller
  * already holds mmap_lock, or other locks which nest inside mmap_lock.
- *
- * probe_kernel_read_strict() is the same as probe_kernel_read() except for
- * the case where architectures have non-overlapping user and kernel address
- * ranges: probe_kernel_read_strict() will additionally return -EFAULT for
- * probing memory on a user address range where probe_user_read() is supposed
- * to be used instead.
  */
 
-long __weak probe_kernel_read(void *dst, const void *src, size_t size)
-    __attribute__((alias("__probe_kernel_read")));
-
 long __weak probe_kernel_read_strict(void *dst, const void *src, size_t size)
     __attribute__((alias("__probe_kernel_read")));
 
@@ -154,15 +161,34 @@ EXPORT_SYMBOL_GPL(probe_user_write);
  * If @count is smaller than the length of the string, copies @count-1 bytes,
  * sets the last byte of @dst buffer to NUL and returns @count.
  *
- * strncpy_from_unsafe_strict() is the same as strncpy_from_unsafe() except
- * for the case where architectures have non-overlapping user and kernel address
- * ranges: strncpy_from_unsafe_strict() will additionally return -EFAULT for
- * probing memory on a user address range where strncpy_from_unsafe_user() is
- * supposed to be used instead.
+ * Same as strncpy_from_unsafe_strict() except that for architectures with
+ * not fully separated user and kernel address spaces this function also works
+ * for user address tanges.
+ *
+ * DO NOT USE THIS FUNCTION - it is broken on architectures with entirely
+ * separate kernel and user address spaces, and also a bad idea otherwise.
  */
 long __weak strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
     __attribute__((alias("__strncpy_from_unsafe")));
 
+/**
+ * strncpy_from_unsafe_strict: - Copy a NUL terminated string from unsafe
+ *				 address.
+ * @dst:   Destination address, in kernel space.  This buffer must be at
+ *         least @count bytes long.
+ * @unsafe_addr: Unsafe address.
+ * @count: Maximum number of bytes to copy, including the trailing NUL.
+ *
+ * Copies a NUL-terminated string from unsafe address to kernel buffer.
+ *
+ * On success, returns the length of the string INCLUDING the trailing NUL.
+ *
+ * If access fails, returns -EFAULT (some data may have been copied
+ * and the trailing NUL added).
+ *
+ * If @count is smaller than the length of the string, copies @count-1 bytes,
+ * sets the last byte of @dst buffer to NUL and returns @count.
+ */
 long __weak strncpy_from_unsafe_strict(char *dst, const void *unsafe_addr,
 				       long count)
     __attribute__((alias("__strncpy_from_unsafe")));
_

Patches currently in -mm which might be from hch@lst.de are

amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch
kernel-move-use_mm-unuse_mm-to-kthreadc.patch
kernel-move-use_mm-unuse_mm-to-kthreadc-v2.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-v2.patch
kernel-set-user_ds-in-kthread_use_mm.patch
