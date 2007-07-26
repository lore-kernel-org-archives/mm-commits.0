From: akpm@linux-foundation.org
Subject: + fix-dynreloc-miscount-link-error-on-powerpc.patch added to -mm tree
Date: Wed, 25 Jul 2007 23:01:43 -0700
Message-ID: <200707260601.l6Q61hYd017023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42190 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754163AbXGZGCe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 02:02:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, benh@kernel.crashing.org, ntl@pobox.com, paulus@samba.org


The patch titled
     fix 'dynreloc miscount' link error on Powerpc
has been added to the -mm tree.  Its filename is
     fix-dynreloc-miscount-link-error-on-powerpc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
x86_64-fix-arch_vma_name.patch
fix-dynreloc-miscount-link-error-on-powerpc.patch
powerpc-vdso-install-unstripped-copies-on-disk.patch
pass-g-to-assembler-under-config_debug_info.patch
mkmakefile-include-arch-on-o=-builds.patch
i386-vdso-install-unstripped-copies-on-disk.patch
i386-vdso-install-unstripped-copies-on-disk-fix.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
whitelist-references-from-__dbe_table-to-init.patch
broken-lilo-check-on-make-install.patch
kconfig-remove-top-level-menu-code-maturity-level-options.patch
