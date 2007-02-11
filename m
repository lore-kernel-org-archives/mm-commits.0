From: akpm@linux-foundation.org
Subject: - remove-final-references-to-deprecated-map_anon-page-protection-flag.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:46:02 -0800
Message-ID: <200702112246.l1BMk2DM015461@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59458 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932609AbXBKWqF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:46:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     Remove final references to deprecated "MAP_ANON" page protection flag
has been removed from the -mm tree.  Its filename was
     remove-final-references-to-deprecated-map_anon-page-protection-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove final references to deprecated "MAP_ANON" page protection flag
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the last vestiges of the long-deprecated "MAP_ANON" page protection
flag: use "MAP_ANONYMOUS" instead.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c                   |    2 +-
 fs/binfmt_elf_fdpic.c      |    2 +-
 include/asm-alpha/mman.h   |    1 -
 include/asm-generic/mman.h |    1 -
 include/asm-mips/mman.h    |    1 -
 include/asm-parisc/mman.h  |    1 -
 include/asm-xtensa/mman.h  |    1 -
 7 files changed, 2 insertions(+), 7 deletions(-)

diff -puN fs/aio.c~remove-final-references-to-deprecated-map_anon-page-protection-flag fs/aio.c
--- a/fs/aio.c~remove-final-references-to-deprecated-map_anon-page-protection-flag
+++ a/fs/aio.c
@@ -132,7 +132,7 @@ static int aio_setup_ring(struct kioctx 
 	dprintk("attempting mmap of %lu bytes\n", info->mmap_size);
 	down_write(&ctx->mm->mmap_sem);
 	info->mmap_base = do_mmap(NULL, 0, info->mmap_size, 
-				  PROT_READ|PROT_WRITE, MAP_ANON|MAP_PRIVATE,
+				  PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE,
 				  0);
 	if (IS_ERR((void *)info->mmap_base)) {
 		up_write(&ctx->mm->mmap_sem);
diff -puN fs/binfmt_elf_fdpic.c~remove-final-references-to-deprecated-map_anon-page-protection-flag fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~remove-final-references-to-deprecated-map_anon-page-protection-flag
+++ a/fs/binfmt_elf_fdpic.c
@@ -372,7 +372,7 @@ static int load_elf_fdpic_binary(struct 
 	down_write(&current->mm->mmap_sem);
 	current->mm->start_brk = do_mmap(NULL, 0, stack_size,
 					 PROT_READ | PROT_WRITE | PROT_EXEC,
-					 MAP_PRIVATE | MAP_ANON | MAP_GROWSDOWN,
+					 MAP_PRIVATE | MAP_ANONYMOUS | MAP_GROWSDOWN,
 					 0);
 
 	if (IS_ERR_VALUE(current->mm->start_brk)) {
diff -puN include/asm-alpha/mman.h~remove-final-references-to-deprecated-map_anon-page-protection-flag include/asm-alpha/mman.h
--- a/include/asm-alpha/mman.h~remove-final-references-to-deprecated-map_anon-page-protection-flag
+++ a/include/asm-alpha/mman.h
@@ -49,7 +49,6 @@
 #define MADV_DOFORK	11		/* do inherit across fork */
 
 /* compatibility flags */
-#define MAP_ANON	MAP_ANONYMOUS
 #define MAP_FILE	0
 
 #endif /* __ALPHA_MMAN_H__ */
diff -puN include/asm-generic/mman.h~remove-final-references-to-deprecated-map_anon-page-protection-flag include/asm-generic/mman.h
--- a/include/asm-generic/mman.h~remove-final-references-to-deprecated-map_anon-page-protection-flag
+++ a/include/asm-generic/mman.h
@@ -36,7 +36,6 @@
 #define MADV_DOFORK	11		/* do inherit across fork */
 
 /* compatibility flags */
-#define MAP_ANON	MAP_ANONYMOUS
 #define MAP_FILE	0
 
 #endif
diff -puN include/asm-mips/mman.h~remove-final-references-to-deprecated-map_anon-page-protection-flag include/asm-mips/mman.h
--- a/include/asm-mips/mman.h~remove-final-references-to-deprecated-map_anon-page-protection-flag
+++ a/include/asm-mips/mman.h
@@ -72,7 +72,6 @@
 #define MADV_DOFORK	11		/* do inherit across fork */
 
 /* compatibility flags */
-#define MAP_ANON	MAP_ANONYMOUS
 #define MAP_FILE	0
 
 #endif /* _ASM_MMAN_H */
diff -puN include/asm-parisc/mman.h~remove-final-references-to-deprecated-map_anon-page-protection-flag include/asm-parisc/mman.h
--- a/include/asm-parisc/mman.h~remove-final-references-to-deprecated-map_anon-page-protection-flag
+++ a/include/asm-parisc/mman.h
@@ -55,7 +55,6 @@
 #define MADV_64M_PAGES  26              /* Use 64 Megabyte pages */
 
 /* compatibility flags */
-#define MAP_ANON	MAP_ANONYMOUS
 #define MAP_FILE	0
 #define MAP_VARIABLE	0
 
diff -puN include/asm-xtensa/mman.h~remove-final-references-to-deprecated-map_anon-page-protection-flag include/asm-xtensa/mman.h
--- a/include/asm-xtensa/mman.h~remove-final-references-to-deprecated-map_anon-page-protection-flag
+++ a/include/asm-xtensa/mman.h
@@ -79,7 +79,6 @@
 #define MADV_DOFORK	11		/* do inherit across fork */
 
 /* compatibility flags */
-#define MAP_ANON	MAP_ANONYMOUS
 #define MAP_FILE	0
 
 #endif /* _XTENSA_MMAN_H */
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-avr32.patch
git-dvb.patch
kbuild-remove-references-to-deprecated-prepare-all-target.patch
git-mips.patch
git-netdev-all.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
fix-apparent-typo-config_usb_cdcether.patch
ntfs-rename-incorrect-check-of-ntfs_debug-with-just-debug.patch
quota-have-linux-quotah-include-linux-rwsemh-explicitly.patch
isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro.patch
isdn-rename-some-debugging-macros-to-not-resemble-config.patch
isdn-rename-debug-option-config_serial_nopause_io.patch
isdn-remove-defunct-test-emulator.patch
isdn-rename-special-macro-config_hisax_hfc4s8s_pcimem.patch
correct-apparent-typo-config_aty_ct-in-aty-video.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
