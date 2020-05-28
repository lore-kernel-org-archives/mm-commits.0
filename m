From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 maccess-always-use-strict-semantics-for-probe_kernel_read.patch added to
 -mm tree
Date: Wed, 27 May 2020 17:37:34 -0700
Message-ID: <20200528003734.ESp3enZst%akpm@linux-foundation.org>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbgE1Ahg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 May 2020 20:37:36 -0400
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net, hch@lst.de, hpa@zytor.com, mhiramat@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: maccess: always use strict semantics for probe_kernel_read
has been added to the -mm tree.  Its filename is
     maccess-always-use-strict-semantics-for-probe_kernel_read.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maccess-always-use-strict-semantics-for-probe_kernel_read.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maccess-always-use-strict-semantics-for-probe_kernel_read.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: maccess: always use strict semantics for probe_kernel_read

Except for historical confusion in the kprobes/uprobes and bpf tracers,
which has been fixed now, there is no good reason to ever allow user
memory accesses from probe_kernel_read.  Switch probe_kernel_read to only
read from kernel memory.

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
 mm/maccess.c                |   40 +++++-----------------------------
 7 files changed, 14 insertions(+), 49 deletions(-)

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
 	return (unsigned long)vaddr >= TASK_SIZE_MAX;
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
@@ -180,7 +152,7 @@ long strncpy_from_kernel_nofault(char *d
 
 	if (unlikely(count <= 0))
 		return 0;
-	if (!probe_kernel_read_allowed(unsafe_addr, count, true))
+	if (!probe_kernel_read_allowed(unsafe_addr, count))
 		return -EFAULT;
 
 	set_fs(KERNEL_DS);
_

Patches currently in -mm which might be from hch@lst.de are

x86-hyperv-use-vmalloc_exec-for-the-hypercall-page.patch
x86-fix-vmap-arguments-in-map_irq_stack.patch
staging-android-ion-use-vmap-instead-of-vm_map_ram.patch
staging-media-ipu3-use-vmap-instead-of-reimplementing-it.patch
dma-mapping-use-vmap-insted-of-reimplementing-it.patch
powerpc-add-an-ioremap_phb-helper.patch
powerpc-remove-__ioremap_at-and-__iounmap_at.patch
mm-remove-__get_vm_area.patch
mm-unexport-unmap_kernel_range_noflush.patch
mm-rename-config_pgtable_mapping-to-config_zsmalloc_pgtable_mapping.patch
mm-only-allow-page-table-mappings-for-built-in-zsmalloc.patch
mm-pass-addr-as-unsigned-long-to-vb_free.patch
mm-remove-vmap_page_range_noflush-and-vunmap_page_range.patch
mm-rename-vmap_page_range-to-map_kernel_range.patch
mm-dont-return-the-number-of-pages-from-map_kernel_range_noflush.patch
mm-remove-map_vm_range.patch
mm-remove-unmap_vmap_area.patch
mm-remove-the-prot-argument-from-vm_map_ram.patch
mm-enforce-that-vmap-cant-map-pages-executable.patch
gpu-drm-remove-the-powerpc-hack-in-drm_legacy_sg_alloc.patch
mm-remove-the-pgprot-argument-to-__vmalloc.patch
mm-remove-the-prot-argument-to-__vmalloc_node.patch
mm-remove-both-instances-of-__vmalloc_node_flags.patch
mm-remove-__vmalloc_node_flags_caller.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node.patch
mm-remove-vmalloc_user_node_flags.patch
arm64-use-__vmalloc_node-in-arch_alloc_vmap_stack.patch
powerpc-use-__vmalloc_node-in-alloc_vm_stack.patch
s390-use-__vmalloc_node-in-stack_alloc.patch
exec-simplify-the-copy_strings_kernel-calling-convention.patch
exec-open-code-copy_string_kernel.patch
amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch
kernel-move-use_mm-unuse_mm-to-kthreadc.patch
kernel-move-use_mm-unuse_mm-to-kthreadc-v2.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-v2.patch
kernel-set-user_ds-in-kthread_use_mm.patch
arm-fix-the-flush_icache_range-arguments-in-set_fiq_handler.patch
nds32-unexport-flush_icache_page.patch
powerpc-unexport-flush_icache_user_range.patch
unicore32-remove-flush_cache_user_range.patch
asm-generic-fix-the-inclusion-guards-for-cacheflushh.patch
asm-generic-dont-include-linux-mmh-in-cacheflushh.patch
asm-generic-dont-include-linux-mmh-in-cacheflushh-fix.patch
asm-generic-improve-the-flush_dcache_page-stub.patch
alpha-use-asm-generic-cacheflushh.patch
arm64-use-asm-generic-cacheflushh.patch
c6x-use-asm-generic-cacheflushh.patch
hexagon-use-asm-generic-cacheflushh.patch
ia64-use-asm-generic-cacheflushh.patch
microblaze-use-asm-generic-cacheflushh.patch
m68knommu-use-asm-generic-cacheflushh.patch
openrisc-use-asm-generic-cacheflushh.patch
powerpc-use-asm-generic-cacheflushh.patch
riscv-use-asm-generic-cacheflushh.patch
armsparcunicore32-remove-flush_icache_user_range.patch
mm-rename-flush_icache_user_range-to-flush_icache_user_page.patch
asm-generic-add-a-flush_icache_user_range-stub.patch
sh-implement-flush_icache_user_range.patch
xtensa-implement-flush_icache_user_range.patch
arm-rename-flush_cache_user_range-to-flush_icache_user_range.patch
m68k-implement-flush_icache_user_range.patch
exec-only-build-read_code-when-needed.patch
exec-use-flush_icache_user_range-in-read_code.patch
binfmt_flat-use-flush_icache_user_range.patch
nommu-use-flush_icache_user_range-in-brk-and-mmap.patch
module-move-the-set_fs-hack-for-flush_icache_range-to-m68k.patch
maccess-unexport-probe_kernel_write-and-probe_user_write.patch
maccess-remove-various-unused-weak-aliases.patch
maccess-remove-duplicate-kerneldoc-comments.patch
maccess-clarify-kerneldoc-comments.patch
maccess-update-the-top-of-file-comment.patch
maccess-rename-strncpy_from_unsafe_user-to-strncpy_from_user_nofault.patch
maccess-rename-strncpy_from_unsafe_strict-to-strncpy_from_kernel_nofault.patch
maccess-rename-strnlen_unsafe_user-to-strnlen_user_nofault.patch
maccess-remove-probe_read_common-and-probe_write_common.patch
maccess-unify-the-probe-kernel-arch-hooks.patch
bpf-factor-out-a-bpf_trace_copy_string-helper.patch
bpf-handle-the-compat-string-in-bpf_trace_copy_string-better.patch
bpf-rework-the-compat-kernel-probe-handling.patch
tracing-kprobes-handle-mixed-kernel-userspace-probes-better.patch
maccess-remove-strncpy_from_unsafe.patch
maccess-always-use-strict-semantics-for-probe_kernel_read.patch
maccess-move-user-access-routines-together.patch
maccess-allow-architectures-to-provide-kernel-probing-directly.patch
x86-use-non-set_fs-based-maccess-routines.patch
maccess-return-erange-when-copy_from_kernel_nofault_allowed-fails.patch
