From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 81/93] maccess: unify the probe kernel arch hooks
Date: Mon, 08 Jun 2020 21:34:27 -0700
Message-ID: <20200609043427.1U65oTC8H%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726449AbgFIEeb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:34:31 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ast@kernel.org, daniel@iogearbox.net, hch@lst.de, hpa@zytor.com, linux-mm@kvack.org, mhiramat@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org

From: Christoph Hellwig <hch@lst.de>
Subject: maccess: unify the probe kernel arch hooks

Currently architectures have to override every routine that probes
kernel memory, which includes a pure read and strcpy, both in strict
and not strict variants.  Just provide a single arch hooks instead to
make sure all architectures cover all the cases.

[akpm@linux-foundation.org: fix !CONFIG_X86_64 build]
Link: http://lkml.kernel.org/r/20200521152301.2587579-11-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/lib/memcpy.c |   12 ++------
 arch/um/kernel/maccess.c |   10 ++-----
 arch/x86/mm/maccess.c    |   33 ++++++++----------------
 include/linux/uaccess.h  |    6 ++--
 mm/maccess.c             |   50 +++++++++++++++++++++++++++----------
 5 files changed, 61 insertions(+), 50 deletions(-)

--- a/arch/parisc/lib/memcpy.c~maccess-unify-the-probe-kernel-arch-hooks
+++ a/arch/parisc/lib/memcpy.c
@@ -57,14 +57,10 @@ void * memcpy(void * dst,const void *src
 EXPORT_SYMBOL(raw_copy_in_user);
 EXPORT_SYMBOL(memcpy);
 
-long probe_kernel_read(void *dst, const void *src, size_t size)
+bool probe_kernel_read_allowed(const void *unsafe_src, size_t size, bool strict)
 {
-	unsigned long addr = (unsigned long)src;
-
-	if (addr < PAGE_SIZE)
-		return -EFAULT;
-
+	if ((unsigned long)unsafe_src < PAGE_SIZE)
+		return false;
 	/* check for I/O space F_EXTEND(0xfff00000) access as well? */
-
-	return __probe_kernel_read(dst, src, size);
+	return true;
 }
--- a/arch/um/kernel/maccess.c~maccess-unify-the-probe-kernel-arch-hooks
+++ a/arch/um/kernel/maccess.c
@@ -7,15 +7,13 @@
 #include <linux/kernel.h>
 #include <os.h>
 
-long probe_kernel_read(void *dst, const void *src, size_t size)
+bool probe_kernel_read_allowed(const void *src, size_t size, bool strict)
 {
 	void *psrc = (void *)rounddown((unsigned long)src, PAGE_SIZE);
 
 	if ((unsigned long)src < PAGE_SIZE || size <= 0)
-		return -EFAULT;
-
+		return false;
 	if (os_mincore(psrc, size + src - psrc) <= 0)
-		return -EFAULT;
-
-	return __probe_kernel_read(dst, src, size);
+		return false;
+	return true;
 }
--- a/arch/x86/mm/maccess.c~maccess-unify-the-probe-kernel-arch-hooks
+++ a/arch/x86/mm/maccess.c
@@ -9,35 +9,26 @@ static __always_inline u64 canonical_add
 	return ((s64)vaddr << (64 - vaddr_bits)) >> (64 - vaddr_bits);
 }
 
-static __always_inline bool invalid_probe_range(u64 vaddr)
+bool probe_kernel_read_allowed(const void *unsafe_src, size_t size, bool strict)
 {
+	unsigned long vaddr = (unsigned long)unsafe_src;
+
+	if (!strict)
+		return true;
+
 	/*
 	 * Range covering the highest possible canonical userspace address
 	 * as well as non-canonical address range. For the canonical range
 	 * we also need to include the userspace guard page.
 	 */
-	return vaddr < TASK_SIZE_MAX + PAGE_SIZE ||
-	       canonical_address(vaddr, boot_cpu_data.x86_virt_bits) != vaddr;
+	return vaddr >= TASK_SIZE_MAX + PAGE_SIZE &&
+	       canonical_address(vaddr, boot_cpu_data.x86_virt_bits) == vaddr;
 }
 #else
-static __always_inline bool invalid_probe_range(u64 vaddr)
+bool probe_kernel_read_allowed(const void *unsafe_src, size_t size, bool strict)
 {
-	return vaddr < TASK_SIZE_MAX;
+	if (!strict)
+		return true;
+	return (unsigned long)unsafe_src >= TASK_SIZE_MAX;
 }
 #endif
-
-long probe_kernel_read_strict(void *dst, const void *src, size_t size)
-{
-	if (unlikely(invalid_probe_range((unsigned long)src)))
-		return -EFAULT;
-
-	return __probe_kernel_read(dst, src, size);
-}
-
-long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
-{
-	if (unlikely(invalid_probe_range((unsigned long)unsafe_addr)))
-		return -EFAULT;
-
-	return __strncpy_from_unsafe(dst, unsafe_addr, count);
-}
--- a/include/linux/uaccess.h~maccess-unify-the-probe-kernel-arch-hooks
+++ a/include/linux/uaccess.h
@@ -301,9 +301,11 @@ copy_struct_from_user(void *dst, size_t
 	return 0;
 }
 
+bool probe_kernel_read_allowed(const void *unsafe_src, size_t size,
+		bool strict);
+
 extern long probe_kernel_read(void *dst, const void *src, size_t size);
 extern long probe_kernel_read_strict(void *dst, const void *src, size_t size);
-extern long __probe_kernel_read(void *dst, const void *src, size_t size);
 extern long probe_user_read(void *dst, const void __user *src, size_t size);
 
 extern long notrace probe_kernel_write(void *dst, const void *src, size_t size);
@@ -312,7 +314,7 @@ extern long notrace probe_user_write(voi
 extern long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
 long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr,
 		long count);
-extern long __strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
+
 long strncpy_from_user_nofault(char *dst, const void __user *unsafe_addr,
 		long count);
 long strnlen_user_nofault(const void __user *unsafe_addr, long count);
--- a/mm/maccess.c~maccess-unify-the-probe-kernel-arch-hooks
+++ a/mm/maccess.c
@@ -6,6 +6,17 @@
 #include <linux/mm.h>
 #include <linux/uaccess.h>
 
+static long __probe_kernel_read(void *dst, const void *src, size_t size,
+		bool strict);
+static long __strncpy_from_unsafe(char *dst, const void *unsafe_addr,
+		long count, bool strict);
+
+bool __weak probe_kernel_read_allowed(const void *unsafe_src, size_t size,
+		bool strict)
+{
+	return true;
+}
+
 /**
  * probe_kernel_read(): safely attempt to read from any location
  * @dst: pointer to the buffer that shall take the data
@@ -19,8 +30,11 @@
  * DO NOT USE THIS FUNCTION - it is broken on architectures with entirely
  * separate kernel and user address spaces, and also a bad idea otherwise.
  */
-long __weak probe_kernel_read(void *dst, const void *src, size_t size)
-    __attribute__((alias("__probe_kernel_read")));
+long probe_kernel_read(void *dst, const void *src, size_t size)
+{
+	return __probe_kernel_read(dst, src, size, false);
+}
+EXPORT_SYMBOL_GPL(probe_kernel_read);
 
 /**
  * probe_kernel_read_strict(): safely attempt to read from kernel-space
@@ -36,15 +50,20 @@ long __weak probe_kernel_read(void *dst,
  * probe_kernel_read() suitable for use within regions where the caller
  * already holds mmap_lock, or other locks which nest inside mmap_lock.
  */
+long probe_kernel_read_strict(void *dst, const void *src, size_t size)
+{
+	return __probe_kernel_read(dst, src, size, true);
+}
 
-long __weak probe_kernel_read_strict(void *dst, const void *src, size_t size)
-    __attribute__((alias("__probe_kernel_read")));
-
-long __probe_kernel_read(void *dst, const void *src, size_t size)
+static long __probe_kernel_read(void *dst, const void *src, size_t size,
+		bool strict)
 {
 	long ret;
 	mm_segment_t old_fs = get_fs();
 
+	if (!probe_kernel_read_allowed(src, size, strict))
+		return -EFAULT;
+
 	set_fs(KERNEL_DS);
 	pagefault_disable();
 	ret = __copy_from_user_inatomic(dst, (__force const void __user *)src,
@@ -56,7 +75,6 @@ long __probe_kernel_read(void *dst, cons
 		return -EFAULT;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(probe_kernel_read);
 
 /**
  * probe_user_read(): safely attempt to read from a user-space location
@@ -163,8 +181,10 @@ EXPORT_SYMBOL_GPL(probe_user_write);
  * DO NOT USE THIS FUNCTION - it is broken on architectures with entirely
  * separate kernel and user address spaces, and also a bad idea otherwise.
  */
-long __weak strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
-    __attribute__((alias("__strncpy_from_unsafe")));
+long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
+{
+	return __strncpy_from_unsafe(dst, unsafe_addr, count, false);
+}
 
 /**
  * strncpy_from_kernel_nofault: - Copy a NUL terminated string from unsafe
@@ -184,11 +204,13 @@ long __weak strncpy_from_unsafe(char *ds
  * If @count is smaller than the length of the string, copies @count-1 bytes,
  * sets the last byte of @dst buffer to NUL and returns @count.
  */
-long __weak strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr,
-				       long count)
-    __attribute__((alias("__strncpy_from_unsafe")));
+long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
+{
+	return __strncpy_from_unsafe(dst, unsafe_addr, count, true);
+}
 
-long __strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
+static long __strncpy_from_unsafe(char *dst, const void *unsafe_addr,
+		long count, bool strict)
 {
 	mm_segment_t old_fs = get_fs();
 	const void *src = unsafe_addr;
@@ -196,6 +218,8 @@ long __strncpy_from_unsafe(char *dst, co
 
 	if (unlikely(count <= 0))
 		return 0;
+	if (!probe_kernel_read_allowed(unsafe_addr, count, strict))
+		return -EFAULT;
 
 	set_fs(KERNEL_DS);
 	pagefault_disable();
_
