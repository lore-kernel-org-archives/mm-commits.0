From: akpm@linux-foundation.org
Subject: [merged]
 sh-convert-ins-outs-macros-to-inline-functions-checkpatch-fixes.patch
 removed from -mm tree
Date: Fri, 05 Jun 2020 13:21:25 -0700
Message-ID: <20200605202125.XQA0Ghvs7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727087AbgFEUV0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:21:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, amodra@gmail.com, bin.meng@windriver.com, chenzhou10@huawei.com, dalias@libc.org, geert+renesas@glider.be, glaubitz@physik.fu-berlin.de, krzk@kernel.org, kuninori.morimoto.gx@renesas.com, mm-commits@vger.kernel.org, romain.naour@gmail.com, sam@ravnborg.org, ysato@users.sourceforge.jp


The patch titled
     Subject: sh-convert-ins-outs-macros-to-inline-functions-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     sh-convert-ins-outs-macros-to-inline-functions-checkpatch-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-git-rejects.patch
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
maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
