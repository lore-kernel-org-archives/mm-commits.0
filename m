From: akpm@linux-foundation.org
Subject: - fix-dynreloc-miscount-link-error-on-powerpc.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:12:13 -0700
Message-ID: <200707290612.l6T6CDYH011109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53771 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759393AbXG2GXw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:23:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, benh@kernel.crashing.org, ntl@pobox.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     fix 'dynreloc miscount' link error on Powerpc
has been removed from the -mm tree.  Its filename was
     fix-dynreloc-miscount-link-error-on-powerpc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix 'dynreloc miscount' link error on Powerpc
From: Sam Ravnborg <sam@ravnborg.org>

Nathan Lynch <ntl@pobox.com> reported:
2.6.23-rc1 breaks the build for 64-bit powerpc for me (using
maple_defconfig):

  LD      vmlinux.o
powerpc64-unknown-linux-gnu-ld: dynreloc miscount for
kernel/built-in.o, section .opd
powerpc64-unknown-linux-gnu-ld: can not edit opd Bad value
make: *** [vmlinux.o] Error 1

However, I see a possibly related binutils patch:
http://article.gmane.org/gmane.comp.gnu.binutils/33650

It was tracked down to be caused by the weak prototype
declaration in mm.h:
__attribute__((weak)) const char *arch_vma_name(struct vm_area_struct *vma);

But there is no need to make the declaration weak - only the definition
needs to be marked weak.  So drop the weak declaration.  And in the process
drop the duplicate definition in page.h for powerpc.

Note: the arch_vma_name fix for x86_64 needs to be applied first to avoid
breaking x86_64

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Nathan Lynch <ntl@pobox.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-powerpc/page.h |    1 -
 include/linux/mm.h         |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN include/asm-powerpc/page.h~fix-dynreloc-miscount-link-error-on-powerpc include/asm-powerpc/page.h
--- a/include/asm-powerpc/page.h~fix-dynreloc-miscount-link-error-on-powerpc
+++ a/include/asm-powerpc/page.h
@@ -190,7 +190,6 @@ extern void copy_user_page(void *to, voi
 extern int page_is_ram(unsigned long pfn);
 
 struct vm_area_struct;
-extern const char *arch_vma_name(struct vm_area_struct *vma);
 
 #include <asm-generic/memory_model.h>
 #endif /* __ASSEMBLY__ */
diff -puN include/linux/mm.h~fix-dynreloc-miscount-link-error-on-powerpc include/linux/mm.h
--- a/include/linux/mm.h~fix-dynreloc-miscount-link-error-on-powerpc
+++ a/include/linux/mm.h
@@ -1246,7 +1246,7 @@ void drop_slab(void);
 extern int randomize_va_space;
 #endif
 
-__attribute__((weak)) const char *arch_vma_name(struct vm_area_struct *vma);
+const char * arch_vma_name(struct vm_area_struct *vma);
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
x86-64-calgary-fix-section-mismatch-warnings-in-tce.patch
powerpc-vdso-install-unstripped-copies-on-disk.patch
pass-g-to-assembler-under-config_debug_info.patch
mkmakefile-include-arch-on-o=-builds.patch
i386-vdso-install-unstripped-copies-on-disk.patch
i386-vdso-install-unstripped-copies-on-disk-fix.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
whitelist-references-from-__dbe_table-to-init.patch
broken-lilo-check-on-make-install.patch
kconfig-remove-top-level-menu-code-maturity-level-options.patch
