From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bpf-factor-out-a-bpf_trace_copy_string-helper.patch
 added to -mm tree
Date: Wed, 27 May 2020 17:37:19 -0700
Message-ID: <20200528003719.mBKW3bPdW%akpm@linux-foundation.org>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbgE1AhU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 May 2020 20:37:20 -0400
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net, hch@lst.de, hpa@zytor.com, mhiramat@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: bpf: factor out a bpf_trace_copy_string helper
has been added to the -mm tree.  Its filename is
     bpf-factor-out-a-bpf_trace_copy_string-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bpf-factor-out-a-bpf_trace_copy_string-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bpf-factor-out-a-bpf_trace_copy_string-helper.patch

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
Subject: bpf: factor out a bpf_trace_copy_string helper

Split out a helper to do the fault free access to the string pointer
to get it out of a crazy indentation level.

Link: http://lkml.kernel.org/r/20200521152301.2587579-12-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/bpf_trace.c |   42 +++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 18 deletions(-)

--- a/kernel/trace/bpf_trace.c~bpf-factor-out-a-bpf_trace_copy_string-helper
+++ a/kernel/trace/bpf_trace.c
@@ -324,6 +324,28 @@ static const struct bpf_func_proto *bpf_
 	return &bpf_probe_write_user_proto;
 }
 
+static void bpf_trace_copy_string(char *buf, void *unsafe_ptr, char fmt_ptype,
+		size_t bufsz)
+{
+	void __user *user_ptr = (__force void __user *)unsafe_ptr;
+
+	buf[0] = 0;
+
+	switch (fmt_ptype) {
+	case 's':
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+		strncpy_from_unsafe(buf, unsafe_ptr, bufsz);
+		break;
+#endif
+	case 'k':
+		strncpy_from_kernel_nofault(buf, unsafe_ptr, bufsz);
+		break;
+	case 'u':
+		strncpy_from_user_nofault(buf, user_ptr, bufsz);
+		break;
+	}
+}
+
 /*
  * Only limited trace_printk() conversion specifiers allowed:
  * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %pks %pus %s
@@ -406,24 +428,8 @@ fmt_str:
 				break;
 			}
 
-			buf[0] = 0;
-			switch (fmt_ptype) {
-			case 's':
-#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
-				strncpy_from_unsafe(buf, unsafe_ptr,
-						    sizeof(buf));
-				break;
-#endif
-			case 'k':
-				strncpy_from_kernel_nofault(buf, unsafe_ptr,
-							   sizeof(buf));
-				break;
-			case 'u':
-				strncpy_from_user_nofault(buf,
-					(__force void __user *)unsafe_ptr,
-							 sizeof(buf));
-				break;
-			}
+			bpf_trace_copy_string(buf, unsafe_ptr, fmt_ptype,
+					sizeof(buf));
 			goto fmt_next;
 		}
 
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
