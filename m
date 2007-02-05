From: akpm@linux-foundation.org
Subject: + remove-final-references-to-deprecated-map_anon-page-protection-flag.patch added to -mm tree
Date: Mon, 05 Feb 2007 13:10:41 -0800
Message-ID: <200702052110.l15LAfoJ031241@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33766 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933456AbXBEVKp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 16:10:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com


The patch titled
     Remove final references to deprecated "MAP_ANON" page protection flag
has been added to the -mm tree.  Its filename is
     remove-final-references-to-deprecated-map_anon-page-protection-flag.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove final references to deprecated "MAP_ANON" page protection flag
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the last vestiges of the long-deprecated "MAP_ANON" page protection
flag: use "MAP_ANONYMOUS" instead.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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

git-acpi.patch
git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
fix-apparent-typo-config_serial_cpm_smc.patch
remove-the-unused-kernel-config-option-video_videobuf.patch
change-incorrect-config_input_atixl-to-config_mouse_atixl.patch
kbuild-remove-references-to-deprecated-prepare-all-target.patch
git-mips.patch
remove-unused-kernel-config-option-dlci_count.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
fix-apparent-typo-config_usb_cdcether.patch
git-wireless.patch
replace-incorrect-macro-name-wireless_ext-with.patch
remove-unused-kernel-config-option-x86_xadd.patch
remove-final-references-to-deprecated-map_anon-page-protection-flag.patch
uml-fix-apparent-config_64_bit-typo.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
get-rid-of-double-zeroing-of-allocated-pages.patch
remove-unnecessary-memset0-calls-after-kzalloc-calls.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
numerous-fixes-to-kernel-doc-info-in-source-files.patch
remove-a-couple-final-references-to-obsolete-verify_area.patch
remove-the-last-reference-to-rwlock_is_locked-macro.patch
extend-the-set-of-__attribute__-shortcut-macros.patch
remove-final-reference-to-superfluous-smp_commence.patch
replace-regular-code-with-appropriate-calls-to-container_of.patch
remove-dead-kernel-config-option-aedsp16_mpu401.patch
remove-references-to-obsolete-kernel-config-option-debug_rwsems.patch
remove-unused-kernel-config-option-zisofs_fs.patch
remove-unused-kernel-config-option-lcd_device.patch
remove-unused-kernel-config-option-paride_parport.patch
fix-apparent-typo-config_lockdep_debug.patch
add-is_power_of_2-checking-to-log2h.patch
ntfs-rename-incorrect-check-of-ntfs_debug-with-just-debug.patch
isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro.patch
isdn-rename-some-debugging-macros-to-not-resemble-config.patch
isdn-rename-debug-option-config_serial_nopause_io.patch
isdn-remove-defunct-test-emulator.patch
isdn-rename-special-macro-config_hisax_hfc4s8s_pcimem.patch
correct-apparent-typo-config_aty_ct-in-aty-video.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
