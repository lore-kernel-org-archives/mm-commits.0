From: akpm@linux-foundation.org
Subject: [merged]
 maccess-return-erange-when-copy_from_kernel_nofault_allowed-fails.patch
 removed from -mm tree
Date: Tue, 09 Jun 2020 17:40:40 -0700
Message-ID: <20200610004040.4SZ6OqL65%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgFJAkl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:40:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net, hch@lst.de, hpa@zytor.com, mhiramat@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: maccess: return -ERANGE when probe_kernel_read() fails
has been removed from the -mm tree.  Its filename was
     maccess-return-erange-when-copy_from_kernel_nofault_allowed-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: maccess: return -ERANGE when probe_kernel_read() fails

Allow the callers to distinguish a real unmapped address vs a range
that can't be probed.

Link: http://lkml.kernel.org/r/20200521152301.2587579-24-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Masami Hiramatsu <mhiramat@kernel.org>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/maccess.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/mm/maccess.c~maccess-return-erange-when-copy_from_kernel_nofault_allowed-fails
+++ a/mm/maccess.c
@@ -24,7 +24,7 @@ bool __weak probe_kernel_read_allowed(co
 long probe_kernel_read(void *dst, const void *src, size_t size)
 {
 	if (!probe_kernel_read_allowed(src, size))
-		return -EFAULT;
+		return -ERANGE;
 
 	pagefault_disable();
 	probe_kernel_read_loop(dst, src, size, u64, Efault);
@@ -68,7 +68,7 @@ long strncpy_from_kernel_nofault(char *d
 	if (unlikely(count <= 0))
 		return 0;
 	if (!probe_kernel_read_allowed(unsafe_addr, count))
-		return -EFAULT;
+		return -ERANGE;
 
 	pagefault_disable();
 	do {
@@ -93,7 +93,8 @@ Efault:
  * @size: size of the data chunk
  *
  * Safely read from kernel address @src to the buffer at @dst.  If a kernel
- * fault happens, handle that and return -EFAULT.
+ * fault happens, handle that and return -EFAULT.  If @src is not a valid kernel
+ * address, return -ERANGE.
  *
  * We ensure that the copy_from_user is executed in atomic context so that
  * do_page_fault() doesn't attempt to take mmap_lock.  This makes
@@ -106,7 +107,7 @@ long probe_kernel_read(void *dst, const
 	mm_segment_t old_fs = get_fs();
 
 	if (!probe_kernel_read_allowed(src, size))
-		return -EFAULT;
+		return -ERANGE;
 
 	set_fs(KERNEL_DS);
 	pagefault_disable();
@@ -158,8 +159,9 @@ long probe_kernel_write(void *dst, const
  *
  * On success, returns the length of the string INCLUDING the trailing NUL.
  *
- * If access fails, returns -EFAULT (some data may have been copied
- * and the trailing NUL added).
+ * If access fails, returns -EFAULT (some data may have been copied and the
+ * trailing NUL added).  If @unsafe_addr is not a valid kernel address, return
+ * -ERANGE.
  *
  * If @count is smaller than the length of the string, copies @count-1 bytes,
  * sets the last byte of @dst buffer to NUL and returns @count.
@@ -173,7 +175,7 @@ long strncpy_from_kernel_nofault(char *d
 	if (unlikely(count <= 0))
 		return 0;
 	if (!probe_kernel_read_allowed(unsafe_addr, count))
-		return -EFAULT;
+		return -ERANGE;
 
 	set_fs(KERNEL_DS);
 	pagefault_disable();
_

Patches currently in -mm which might be from hch@lst.de are

amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch
kernel-move-use_mm-unuse_mm-to-kthreadc.patch
kernel-move-use_mm-unuse_mm-to-kthreadc-v2.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-v2.patch
kernel-set-user_ds-in-kthread_use_mm.patch
