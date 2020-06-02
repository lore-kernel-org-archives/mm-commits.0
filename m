From: akpm@linux-foundation.org
Subject: +
 sh-convert-ins-outs-macros-to-inline-functions-checkpatch-fixes.patch added
 to -mm tree
Date: Mon, 01 Jun 2020 17:55:49 -0700
Message-ID: <20200602005549.k06E1M-Vc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgFBAzv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Jun 2020 20:55:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, amodra@gmail.com, bin.meng@windriver.com, chenzhou10@huawei.com, dalias@libc.org, geert+renesas@glider.be, glaubitz@physik.fu-berlin.de, krzk@kernel.org, kuninori.morimoto.gx@renesas.com, mm-commits@vger.kernel.org, romain.naour@gmail.com, sam@ravnborg.org, ysato@users.sourceforge.jp


The patch titled
     Subject: sh-convert-ins-outs-macros-to-inline-functions-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     sh-convert-ins-outs-macros-to-inline-functions-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-convert-ins-outs-macros-to-inline-functions-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-convert-ins-outs-macros-to-inline-functions-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sh-convert-ins-outs-macros-to-inline-functions-checkpatch-fixes

WARNING: space prohibited between function name and open parenthesis '('
#46: FILE: arch/sh/include/asm/io_noioport.h:56:
+static inline void insb (unsigned long port, void *dst, unsigned long count)

WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
#48: FILE: arch/sh/include/asm/io_noioport.h:58:
+	BUG();

WARNING: space prohibited between function name and open parenthesis '('
#51: FILE: arch/sh/include/asm/io_noioport.h:61:
+static inline void insw (unsigned long port, void *dst, unsigned long count)

WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
#53: FILE: arch/sh/include/asm/io_noioport.h:63:
+	BUG();

WARNING: space prohibited between function name and open parenthesis '('
#56: FILE: arch/sh/include/asm/io_noioport.h:66:
+static inline void insl (unsigned long port, void *dst, unsigned long count)

WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
#58: FILE: arch/sh/include/asm/io_noioport.h:68:
+	BUG();

WARNING: space prohibited between function name and open parenthesis '('
#61: FILE: arch/sh/include/asm/io_noioport.h:71:
+static inline void outsb (unsigned long port, const void *src, unsigned long count)

WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
#63: FILE: arch/sh/include/asm/io_noioport.h:73:
+	BUG();

WARNING: space prohibited between function name and open parenthesis '('
#66: FILE: arch/sh/include/asm/io_noioport.h:76:
+static inline void outsw (unsigned long port, const void *src, unsigned long count)

WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
#68: FILE: arch/sh/include/asm/io_noioport.h:78:
+	BUG();

WARNING: space prohibited between function name and open parenthesis '('
#71: FILE: arch/sh/include/asm/io_noioport.h:81:
+static inline void outsl (unsigned long port, const void *src, unsigned long count)

WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
#73: FILE: arch/sh/include/asm/io_noioport.h:83:
+	BUG();

total: 0 errors, 12 warnings, 41 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/sh-convert-ins-outs-macros-to-inline-functions.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alan Modra <amodra@gmail.com>
Cc: Bin Meng <bin.meng@windriver.com>
Cc: Chen Zhou <chenzhou10@huawei.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Romain Naour <romain.naour@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/io_noioport.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/sh/include/asm/io_noioport.h~sh-convert-ins-outs-macros-to-inline-functions-checkpatch-fixes
+++ a/arch/sh/include/asm/io_noioport.h
@@ -53,32 +53,32 @@ static inline void ioport_unmap(void __i
 #define outw_p(x, addr)	outw((x), (addr))
 #define outl_p(x, addr)	outl((x), (addr))
 
-static inline void insb (unsigned long port, void *dst, unsigned long count)
+static inline void insb(unsigned long port, void *dst, unsigned long count)
 {
 	BUG();
 }
 
-static inline void insw (unsigned long port, void *dst, unsigned long count)
+static inline void insw(unsigned long port, void *dst, unsigned long count)
 {
 	BUG();
 }
 
-static inline void insl (unsigned long port, void *dst, unsigned long count)
+static inline void insl(unsigned long port, void *dst, unsigned long count)
 {
 	BUG();
 }
 
-static inline void outsb (unsigned long port, const void *src, unsigned long count)
+static inline void outsb(unsigned long port, const void *src, unsigned long count)
 {
 	BUG();
 }
 
-static inline void outsw (unsigned long port, const void *src, unsigned long count)
+static inline void outsw(unsigned long port, const void *src, unsigned long count)
 {
 	BUG();
 }
 
-static inline void outsl (unsigned long port, const void *src, unsigned long count)
+static inline void outsl(unsigned long port, const void *src, unsigned long count)
 {
 	BUG();
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-ptdump-expand-type-of-val-in-note_page-fix.patch
sh-convert-ins-outs-macros-to-inline-functions-checkpatch-fixes.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
arch-parisc-include-asm-pgtableh-remove-unused-old_pte.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
mm-slub-add-panic_on_error-to-the-debug-facilities-fix.patch
mm-migratec-call-detach_page_private-to-cleanup-code-fix.patch
mm-migratec-call-detach_page_private-to-cleanup-code-fix-fix.patch
mm-replace-pf_less_throttle-with-pf_local_throttle-checkpatch-fixes.patch
mm-discard-nr_unstable_nfs-use-nr_writeback-instead-fix.patch
mm-gupc-updating-the-documentation-fix.patch
mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
mm-vmalloc-track-which-page-table-levels-were-modified-fix.patch
mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix-2-fix.patch
mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations-fix.patch
arch-kunmap-remove-duplicate-kunmap-implementations-fix.patch
arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
arch-kunmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
kmap-consolidate-kmap_prot-definitions-checkpatch-fixes.patch
mm-add-debug_wx-support-fix.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
lib-make-a-test-module-with-get_count_order-long-fix.patch
seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-pre.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
linux-next-post.patch
kernel-add-panic_on_taint-fix.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix.patch
mmap-locking-api-rename-mmap_sem-to-mmap_lock-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
maccess-unify-the-probe-kernel-arch-hooks-fix.patch
bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better.patch
bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better-fix.patch
maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
