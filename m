From: akpm@linux-foundation.org
Subject: [merged] maccess-remove-strncpy_from_unsafe.patch removed
 from -mm tree
Date: Tue, 09 Jun 2020 17:40:27 -0700
Message-ID: <20200610004027.FhClVNgMk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgFJAk3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:40:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net, hch@lst.de, hpa@zytor.com, mhiramat@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: maccess: remove strncpy_from_unsafe
has been removed from the -mm tree.  Its filename was
     maccess-remove-strncpy_from_unsafe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: maccess: remove strncpy_from_unsafe

All users are gone now.

Link: http://lkml.kernel.org/r/20200521152301.2587579-16-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uaccess.h |    1 
 mm/maccess.c            |   39 --------------------------------------
 2 files changed, 1 insertion(+), 39 deletions(-)

--- a/include/linux/uaccess.h~maccess-remove-strncpy_from_unsafe
+++ a/include/linux/uaccess.h
@@ -311,7 +311,6 @@ extern long probe_user_read(void *dst, c
 extern long notrace probe_kernel_write(void *dst, const void *src, size_t size);
 extern long notrace probe_user_write(void __user *dst, const void *src, size_t size);
 
-extern long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
 long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr,
 		long count);
 
--- a/mm/maccess.c~maccess-remove-strncpy_from_unsafe
+++ a/mm/maccess.c
@@ -8,8 +8,6 @@
 
 static long __probe_kernel_read(void *dst, const void *src, size_t size,
 		bool strict);
-static long __strncpy_from_unsafe(char *dst, const void *unsafe_addr,
-		long count, bool strict);
 
 bool __weak probe_kernel_read_allowed(const void *unsafe_src, size_t size,
 		bool strict)
@@ -158,35 +156,6 @@ long probe_user_write(void __user *dst,
 EXPORT_SYMBOL_GPL(probe_user_write);
 
 /**
- * strncpy_from_unsafe: - Copy a NUL terminated string from unsafe address.
- * @dst:   Destination address, in kernel space.  This buffer must be at
- *         least @count bytes long.
- * @unsafe_addr: Unsafe address.
- * @count: Maximum number of bytes to copy, including the trailing NUL.
- *
- * Copies a NUL-terminated string from unsafe address to kernel buffer.
- *
- * On success, returns the length of the string INCLUDING the trailing NUL.
- *
- * If access fails, returns -EFAULT (some data may have been copied
- * and the trailing NUL added).
- *
- * If @count is smaller than the length of the string, copies @count-1 bytes,
- * sets the last byte of @dst buffer to NUL and returns @count.
- *
- * Same as strncpy_from_kernel_nofault() except that for architectures with
- * not fully separated user and kernel address spaces this function also works
- * for user address tanges.
- *
- * DO NOT USE THIS FUNCTION - it is broken on architectures with entirely
- * separate kernel and user address spaces, and also a bad idea otherwise.
- */
-long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
-{
-	return __strncpy_from_unsafe(dst, unsafe_addr, count, false);
-}
-
-/**
  * strncpy_from_kernel_nofault: - Copy a NUL terminated string from unsafe
  *				 address.
  * @dst:   Destination address, in kernel space.  This buffer must be at
@@ -206,19 +175,13 @@ long strncpy_from_unsafe(char *dst, cons
  */
 long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
 {
-	return __strncpy_from_unsafe(dst, unsafe_addr, count, true);
-}
