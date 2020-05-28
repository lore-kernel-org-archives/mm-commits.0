From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 tracing-kprobes-handle-mixed-kernel-userspace-probes-better.patch added to
 -mm tree
Date: Wed, 27 May 2020 17:37:28 -0700
Message-ID: <20200528003728.gCVFq-klQ%akpm@linux-foundation.org>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbgE1Ahb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 May 2020 20:37:31 -0400
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net, hch@lst.de, hpa@zytor.com, mhiramat@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: tracing/kprobes: handle mixed kernel/userspace probes better
has been added to the -mm tree.  Its filename is
     tracing-kprobes-handle-mixed-kernel-userspace-probes-better.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tracing-kprobes-handle-mixed-kernel-userspace-probes-better.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tracing-kprobes-handle-mixed-kernel-userspace-probes-better.patch

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
Subject: tracing/kprobes: handle mixed kernel/userspace probes better

Instead of using the dangerous probe_kernel_read and strncpy_from_unsafe
helpers, rework probes to try a user probe based on the address if the
architecture has a common address space for kernel and userspace.

Link: http://lkml.kernel.org/r/20200521152301.2587579-15-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/trace_kprobe.c |   72 ++++++++++++++++++++--------------
 1 file changed, 43 insertions(+), 29 deletions(-)

--- a/kernel/trace/trace_kprobe.c~tracing-kprobes-handle-mixed-kernel-userspace-probes-better
+++ a/kernel/trace/trace_kprobe.c
@@ -1202,35 +1202,41 @@ static const struct file_operations kpro
 
 /* Return the length of string -- including null terminal byte */
 static nokprobe_inline int
+fetch_store_strlen_user(unsigned long addr)
+{
+	const void __user *uaddr =  (__force const void __user *)addr;
+
+	return strnlen_user_nofault(uaddr, MAX_STRING_SIZE);
+}
+
+/* Return the length of string -- including null terminal byte */
+static nokprobe_inline int
 fetch_store_strlen(unsigned long addr)
 {
 	int ret, len = 0;
 	u8 c;
 
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+	if (addr < TASK_SIZE)
+		return fetch_store_strlen_user(addr);
+#endif
+
 	do {
-		ret = probe_kernel_read(&c, (u8 *)addr + len, 1);
+		ret = probe_kernel_read_strict(&c, (u8 *)addr + len, 1);
 		len++;
 	} while (c && ret == 0 && len < MAX_STRING_SIZE);
 
 	return (ret < 0) ? ret : len;
 }
 
-/* Return the length of string -- including null terminal byte */
-static nokprobe_inline int
-fetch_store_strlen_user(unsigned long addr)
-{
-	const void __user *uaddr =  (__force const void __user *)addr;
-
-	return strnlen_user_nofault(uaddr, MAX_STRING_SIZE);
-}
-
 /*
- * Fetch a null-terminated string. Caller MUST set *(u32 *)buf with max
- * length and relative data location.
+ * Fetch a null-terminated string from user. Caller MUST set *(u32 *)buf
+ * with max length and relative data location.
  */
 static nokprobe_inline int
-fetch_store_string(unsigned long addr, void *dest, void *base)
+fetch_store_string_user(unsigned long addr, void *dest, void *base)
 {
+	const void __user *uaddr =  (__force const void __user *)addr;
 	int maxlen = get_loc_len(*(u32 *)dest);
 	void *__dest;
 	long ret;
@@ -1240,11 +1246,7 @@ fetch_store_string(unsigned long addr, v
 
 	__dest = get_loc_data(dest, base);
 
-	/*
-	 * Try to get string again, since the string can be changed while
-	 * probing.
-	 */
-	ret = strncpy_from_unsafe(__dest, (void *)addr, maxlen);
+	ret = strncpy_from_user_nofault(__dest, uaddr, maxlen);
 	if (ret >= 0)
 		*(u32 *)dest = make_data_loc(ret, __dest - base);
 
@@ -1252,23 +1254,31 @@ fetch_store_string(unsigned long addr, v
 }
 
 /*
- * Fetch a null-terminated string from user. Caller MUST set *(u32 *)buf
- * with max length and relative data location.
+ * Fetch a null-terminated string. Caller MUST set *(u32 *)buf with max
+ * length and relative data location.
  */
 static nokprobe_inline int
-fetch_store_string_user(unsigned long addr, void *dest, void *base)
+fetch_store_string(unsigned long addr, void *dest, void *base)
 {
-	const void __user *uaddr =  (__force const void __user *)addr;
 	int maxlen = get_loc_len(*(u32 *)dest);
 	void *__dest;
 	long ret;
 
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+	if ((unsigned long)addr < TASK_SIZE)
+		return fetch_store_string_user(addr, dest, base);
+#endif
+
 	if (unlikely(!maxlen))
 		return -ENOMEM;
 
 	__dest = get_loc_data(dest, base);
 
-	ret = strncpy_from_user_nofault(__dest, uaddr, maxlen);
+	/*
+	 * Try to get string again, since the string can be changed while
+	 * probing.
+	 */
+	ret = strncpy_from_user_nofault(__dest, (void *)addr, maxlen);
 	if (ret >= 0)
 		*(u32 *)dest = make_data_loc(ret, __dest - base);
 
@@ -1276,12 +1286,6 @@ fetch_store_string_user(unsigned long ad
 }
 
 static nokprobe_inline int
-probe_mem_read(void *dest, void *src, size_t size)
-{
-	return probe_kernel_read(dest, src, size);
-}
-
-static nokprobe_inline int
 probe_mem_read_user(void *dest, void *src, size_t size)
 {
 	const void __user *uaddr =  (__force const void __user *)src;
@@ -1289,6 +1293,16 @@ probe_mem_read_user(void *dest, void *sr
 	return probe_user_read(dest, uaddr, size);
 }
 
+static nokprobe_inline int
+probe_mem_read(void *dest, void *src, size_t size)
+{
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+	if ((unsigned long)src < TASK_SIZE)
+		return probe_mem_read_user(dest, src, size);
+#endif
+	return probe_kernel_read_strict(dest, src, size);
+}
+
 /* Note that we don't verify it, since the code does not come from user space */
 static int
 process_fetch_insn(struct fetch_insn *code, struct pt_regs *regs, void *dest,
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
