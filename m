From: akpm@linux-foundation.org
Subject: [failures]
 revert-x86-vdso-remove-some-redundant-in-memory-section-headers.patch
 removed from -mm tree
Date: Wed, 02 Jul 2014 15:03:41 -0700
Message-ID: <53b481bd.XIK7Vz5o2aoaY/DX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:40388 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaGBWDm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2014 18:03:42 -0400
Received: by mail-pd0-f202.google.com with SMTP id r10so2026974pdi.3
        for <mm-commits@vger.kernel.org>; Wed, 02 Jul 2014 15:03:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: revert "x86/vdso: Remove some redundant in-memory section headers"
has been removed from the -mm tree.  Its filename was
     revert-x86-vdso-remove-some-redundant-in-memory-section-headers.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "x86/vdso: Remove some redundant in-memory section headers"

getting some work done here..




Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/vdso/vdso-fakesections.c |    3 +
 arch/x86/vdso/vdso-layout.lds.S   |   43 +++++++++++++---------------
 arch/x86/vdso/vdso2c.h            |    4 --
 3 files changed, 24 insertions(+), 26 deletions(-)

diff -puN arch/x86/vdso/vdso-fakesections.c~revert-x86-vdso-remove-some-redundant-in-memory-section-headers arch/x86/vdso/vdso-fakesections.c
--- a/arch/x86/vdso/vdso-fakesections.c~revert-x86-vdso-remove-some-redundant-in-memory-section-headers
+++ a/arch/x86/vdso/vdso-fakesections.c
@@ -16,6 +16,9 @@ const char fake_shstrtab[] __attribute__
 	".rodata\0"
 	".fake_shstrtab\0"  /* Yay, self-referential code. */
 	".note\0"
+	".data\0"
+	".altinstructions\0"
+	".altinstr_replacement\0"
 	".eh_frame_hdr\0"
 	".eh_frame\0"
 	".text";
diff -puN arch/x86/vdso/vdso-layout.lds.S~revert-x86-vdso-remove-some-redundant-in-memory-section-headers arch/x86/vdso/vdso-layout.lds.S
--- a/arch/x86/vdso/vdso-layout.lds.S~revert-x86-vdso-remove-some-redundant-in-memory-section-headers
+++ a/arch/x86/vdso/vdso-layout.lds.S
@@ -14,7 +14,7 @@
 # error unknown VDSO target
 #endif
 
-#define NUM_FAKE_SHDRS 13
+#define NUM_FAKE_SHDRS 16
 
 SECTIONS
 {
@@ -28,17 +28,15 @@ SECTIONS
 	.gnu.version_d	: { *(.gnu.version_d) }
 	.gnu.version_r	: { *(.gnu.version_r) }
 
+	.note		: { *(.note.*) }		:text	:note
+
+	.eh_frame_hdr	: { *(.eh_frame_hdr) }		:text	:eh_frame_hdr
+	.eh_frame	: { KEEP (*(.eh_frame)) }	:text
+
 	.dynamic	: { *(.dynamic) }		:text	:dynamic
 
 	.rodata		: {
 		*(.rodata*)
-		*(.data*)
-		*(.sdata*)
-		*(.got.plt) *(.got)
-		*(.gnu.linkonce.d.*)
-		*(.bss*)
-		*(.dynbss*)
-		*(.gnu.linkonce.b.*)
 
 		/*
 		 * Ideally this would live in a C file, but that won't
@@ -52,29 +50,28 @@ SECTIONS
 
 	.fake_shstrtab	: { *(.fake_shstrtab) }		:text
 
+	.data		: {
+		*(.data*)
+		*(.sdata*)
+		*(.got.plt) *(.got)
+		*(.gnu.linkonce.d.*)
+		*(.bss*)
+		*(.dynbss*)
+		*(.gnu.linkonce.b.*)
+	}
 
-	.note		: { *(.note.*) }		:text	:note
-
-	.eh_frame_hdr	: { *(.eh_frame_hdr) }		:text	:eh_frame_hdr
-	.eh_frame	: { KEEP (*(.eh_frame)) }	:text
-
+	.altinstructions	: { *(.altinstructions) }
+	.altinstr_replacement	: { *(.altinstr_replacement) }
 
 	/*
-	 * Text is well-separated from actual data: there's plenty of
-	 * stuff that isn't used at runtime in between.
+	 * Align the actual code well away from the non-instruction data.
+	 * This is the best thing for the I-cache.
 	 */
+	. = ALIGN(0x100);
 
 	.text		: { *(.text*) }			:text	=0x90909090,
 
 	/*
-	 * At the end so that eu-elflint stays happy when vdso2c strips
-	 * these.  A better implementation would avoid allocating space
-	 * for these.
-	 */
-	.altinstructions	: { *(.altinstructions) }	:text
-	.altinstr_replacement	: { *(.altinstr_replacement) }	:text
-
-	/*
 	 * The remainder of the vDSO consists of special pages that are
 	 * shared between the kernel and userspace.  It needs to be at the
 	 * end so that it doesn't overlap the mapping of the actual
diff -puN arch/x86/vdso/vdso2c.h~revert-x86-vdso-remove-some-redundant-in-memory-section-headers arch/x86/vdso/vdso2c.h
--- a/arch/x86/vdso/vdso2c.h~revert-x86-vdso-remove-some-redundant-in-memory-section-headers
+++ a/arch/x86/vdso/vdso2c.h
@@ -92,9 +92,7 @@ static void BITSFUNC(copy_section)(struc
 {
 	uint64_t flags = GET_LE(&in->sh_flags);
 
-	bool copy = flags & SHF_ALLOC &&
-		strcmp(name, ".altinstructions") &&
-		strcmp(name, ".altinstr_replacement");
+	bool copy = flags & SHF_ALLOC;
 
 	if (!copy)
 		return;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
kernel-printk-printkc-revert-printk-enable-interrupts-before-calling-console_trylock_for_printk.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function-checkpatch-fixes.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc-fix.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
fs-isofs-logging-clean-up-fix.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
drivers-staging-emxx_udc-emxx_udcc-replace-strict_strto-with-kstrto.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

