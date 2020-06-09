From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 88/93] maccess: always use strict semantics for
 probe_kernel_read
Date: Mon, 08 Jun 2020 21:34:50 -0700
Message-ID: <20200609043450.DnLndUZMB%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbgFIEey (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:34:54 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ast@kernel.org, daniel@iogearbox.net, hch@lst.de, hpa@zytor.com, linux-mm@kvack.org, mhiramat@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org

From: Christoph Hellwig <hch@lst.de>
Subject: maccess: always use strict semantics for probe_kernel_read

Except for historical confusion in the kprobes/uprobes and bpf tracers,
which has been fixed now, there is no good reason to ever allow user
memory accesses from probe_kernel_read.  Switch probe_kernel_read to only
read from kernel memory.

[akpm@linux-foundation.org: update it for "mm, dump_page(): do not crash with invalid mapping pointer"]
Link: http://lkml.kernel.org/r/20200521152301.2587579-17-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/lib/memcpy.c    |    2 -
 arch/um/kernel/maccess.c    |    2 -
 arch/x86/mm/maccess.c       |    9 +------
 include/linux/uaccess.h     |    4 ---
 kernel/trace/bpf_trace.c    |    2 -
 kernel/trace/trace_kprobe.c |    4 +--
 mm/debug.c                  |   10 ++++----
 mm/maccess.c                |   40 +++++-----------------------------
 8 files changed, 19 insertions(+), 54 deletions(-)

--- a/arch/parisc/lib/memcpy.c~maccess-always-use-strict-semantics-for-probe_kernel_read
+++ a/arch/parisc/lib/memcpy.c
@@ -57,7 +57,7 @@ void * memcpy(void * dst,const void *src
 EXPORT_SYMBOL(raw_copy_in_user);
 EXPORT_SYMBOL(memcpy);
 
-bool probe_kernel_read_allowed(const void *unsafe_src, size_t size, bool strict)
+bool probe_kernel_read_allowed(const void *unsafe_src, size_t size)
 {
 	if ((unsigned long)unsafe_src < PAGE_SIZE)
 		return false;
--- a/arch/um/kernel/maccess.c~maccess-always-use-strict-semantics-for-probe_kernel_read
+++ a/arch/um/kernel/maccess.c
@@ -7,7 +7,7 @@
 #include <linux/kernel.h>
 #include <os.h>
 
-bool probe_kernel_read_allowed(const void *src, size_t size, bool strict)
+bool probe_kernel_read_allowed(const void *src, size_t size)
 {
 	void *psrc = (void *)rounddown((unsigned long)src, PAGE_SIZE);
 
--- a/arch/x86/mm/maccess.c~maccess-always-use-strict-semantics-for-probe_kernel_read
+++ a/arch/x86/mm/maccess.c
@@ -9,13 +9,10 @@ static __always_inline u64 canonical_add
 	return ((s64)vaddr << (64 - vaddr_bits)) >> (64 - vaddr_bits);
 }
 
-bool probe_kernel_read_allowed(const void *unsafe_src, size_t size, bool strict)
+bool probe_kernel_read_allowed(const void *unsafe_src, size_t size)
 {
 	unsigned long vaddr = (unsigned long)unsafe_src;
 
-	if (!strict)
-		return true;
-
 	/*
 	 * Range covering the highest possible canonical userspace address
 	 * as well as non-canonical address range. For the canonical range
@@ -25,10 +22,8 @@ bool probe_kernel_read_allowed(const voi
 	       canonical_address(vaddr, boot_cpu_data.x86_virt_bits) == vaddr;
 }
 #else
-bool probe_kernel_read_allowed(const void *unsafe_src, size_t size, bool strict)
+bool probe_kernel_read_allowed(const void *unsafe_src, size_t size)
 {
-	if (!strict)
-		return true;
 	return (unsigned long)unsafe_src >= TASK_SIZE_MAX;
 }
 #endif
--- a/include/linux/uaccess.h~maccess-always-use-strict-semantics-for-probe_kernel_read
+++ a/include/linux/uaccess.h
@@ -301,11 +301,9 @@ copy_struct_from_user(void *dst, size_t
 	return 0;
 }
 
-bool probe_kernel_read_allowed(const void *unsafe_src, size_t size,
-		bool strict);
+bool probe_kernel_read_allowed(const void *unsafe_src, size_t size);
 
 extern long probe_kernel_read(void *dst, const void *src, size_t size);
-extern long probe_kernel_read_strict(void *dst, const void *src, size_t size);
 extern long probe_user_read(void *dst, const void __user *src, size_t size);
 
 extern long notrace probe_kernel_write(void *dst, const void *src, size_t size);
--- a/kernel/trace/bpf_trace.c~maccess-always-use-strict-semantics-for-probe_kernel_read
+++ a/kernel/trace/bpf_trace.c
@@ -196,7 +196,7 @@ bpf_probe_read_kernel_common(void *dst,
 
 	if (unlikely(ret < 0))
 		goto fail;
-	ret = probe_kernel_read_strict(dst, unsafe_ptr, size);
+	ret = probe_kernel_read(dst, unsafe_ptr, size);
 	if (unlikely(ret < 0))
 		goto fail;
 	return ret;
--- a/kernel/trace/trace_kprobe.c~maccess-always-use-strict-semantics-for-probe_kernel_read
+++ a/kernel/trace/trace_kprobe.c
@@ -1222,7 +1222,7 @@ fetch_store_strlen(unsigned long addr)
 #endif
 
 	do {
-		ret = probe_kernel_read_strict(&c, (u8 *)addr + len, 1);
+		ret = probe_kernel_read(&c, (u8 *)addr + len, 1);
 		len++;
 	} while (c && ret == 0 && len < MAX_STRING_SIZE);
 
@@ -1300,7 +1300,7 @@ probe_mem_read(void *dest, void *src, si
 	if ((unsigned long)src < TASK_SIZE)
 		return probe_mem_read_user(dest, src, size);
 #endif
-	return probe_kernel_read_strict(dest, src, size);
+	return probe_kernel_read(dest, src, size);
 }
 
 /* Note that we don't verify it, since the code does not come from user space */
--- a/mm/debug.c~maccess-always-use-strict-semantics-for-probe_kernel_read
+++ a/mm/debug.c
@@ -120,9 +120,9 @@ void __dump_page(struct page *page, cons
 		 * mapping can be invalid pointer and we don't want to crash
 		 * accessing it, so probe everything depending on it carefully
 		 */
-		if (probe_kernel_read_strict(&host, &mapping->host,
-						sizeof(struct inode *)) ||
-		    probe_kernel_read_strict(&a_ops, &mapping->a_ops,
+		if (probe_kernel_read(&host, &mapping->host,
+					sizeof(struct inode *)) ||
+		    probe_kernel_read(&a_ops, &mapping->a_ops,
 				sizeof(struct address_space_operations *))) {
 			pr_warn("failed to read mapping->host or a_ops, mapping not a valid kernel address?\n");
 			goto out_mapping;
@@ -133,7 +133,7 @@ void __dump_page(struct page *page, cons
 			goto out_mapping;
 		}
 
-		if (probe_kernel_read_strict(&dentry_first,
+		if (probe_kernel_read(&dentry_first,
 			&host->i_dentry.first, sizeof(struct hlist_node *))) {
 			pr_warn("mapping->a_ops:%ps with invalid mapping->host inode address %px\n",
 				a_ops, host);
@@ -146,7 +146,7 @@ void __dump_page(struct page *page, cons
 		}
 
 		dentry_ptr = container_of(dentry_first, struct dentry, d_u.d_alias);
-		if (probe_kernel_read_strict(&dentry, dentry_ptr,
+		if (probe_kernel_read(&dentry, dentry_ptr,
 							sizeof(struct dentry))) {
 			pr_warn("mapping->aops:%ps with invalid mapping->host->i_dentry.first %px\n",
 				a_ops, dentry_ptr);
--- a/mm/maccess.c~maccess-always-use-strict-semantics-for-probe_kernel_read
+++ a/mm/maccess.c
@@ -6,36 +6,13 @@
 #include <linux/mm.h>
 #include <linux/uaccess.h>
 
-static long __probe_kernel_read(void *dst, const void *src, size_t size,
-		bool strict);
-
-bool __weak probe_kernel_read_allowed(const void *unsafe_src, size_t size,
-		bool strict)
+bool __weak probe_kernel_read_allowed(const void *unsafe_src, size_t size)
 {
 	return true;
 }
 
 /**
- * probe_kernel_read(): safely attempt to read from any location
- * @dst: pointer to the buffer that shall take the data
- * @src: address to read from
- * @size: size of the data chunk
- *
- * Same as probe_kernel_read_strict() except that for architectures with
- * not fully separated user and kernel address spaces this function also works
- * for user address tanges.
- *
- * DO NOT USE THIS FUNCTION - it is broken on architectures with entirely
- * separate kernel and user address spaces, and also a bad idea otherwise.
- */
-long probe_kernel_read(void *dst, const void *src, size_t size)
-{
-	return __probe_kernel_read(dst, src, size, false);
-}
-EXPORT_SYMBOL_GPL(probe_kernel_read);
-
-/**
- * probe_kernel_read_strict(): safely attempt to read from kernel-space
+ * probe_kernel_read(): safely attempt to read from kernel-space
  * @dst: pointer to the buffer that shall take the data
  * @src: address to read from
  * @size: size of the data chunk
@@ -48,18 +25,12 @@ EXPORT_SYMBOL_GPL(probe_kernel_read);
  * probe_kernel_read() suitable for use within regions where the caller
  * already holds mmap_lock, or other locks which nest inside mmap_lock.
  */
-long probe_kernel_read_strict(void *dst, const void *src, size_t size)
-{
-	return __probe_kernel_read(dst, src, size, true);
-}
-
-static long __probe_kernel_read(void *dst, const void *src, size_t size,
-		bool strict)
+long probe_kernel_read(void *dst, const void *src, size_t size)
 {
 	long ret;
 	mm_segment_t old_fs = get_fs();
 
-	if (!probe_kernel_read_allowed(src, size, strict))
+	if (!probe_kernel_read_allowed(src, size))
 		return -EFAULT;
 
 	set_fs(KERNEL_DS);
@@ -73,6 +44,7 @@ static long __probe_kernel_read(void *ds
 		return -EFAULT;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(probe_kernel_read);
 
 /**
  * probe_user_read(): safely attempt to read from a user-space location
@@ -181,7 +153,7 @@ long strncpy_from_kernel_nofault(char *d
 
 	if (unlikely(count <= 0))
 		return 0;
-	if (!probe_kernel_read_allowed(unsafe_addr, count, true))
+	if (!probe_kernel_read_allowed(unsafe_addr, count))
 		return -EFAULT;
 
 	set_fs(KERNEL_DS);
_
