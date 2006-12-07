From: akpm@osdl.org
Subject: - cleanup-asm-setuph-userspace-visibility-v2.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:16:59 -0800
Message-ID: <200612072316.kB7NGxho030893@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54191 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163766AbWLGXUm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:20:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     cleanup asm/setup.h userspace visibility
has been removed from the -mm tree.  Its filename was
     cleanup-asm-setuph-userspace-visibility-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cleanup asm/setup.h userspace visibility
From: Adrian Bunk <bunk@stusta.de>

Make the contents of the userspace asm/setup.h header consistent on all
architectures:

- export setup.h to userspace on all architectures
- export only COMMAND_LINE_SIZE to userspace
- frv: move COMMAND_LINE_SIZE from param.h
- i386: remove duplicate COMMAND_LINE_SIZE from param.h
- arm:
  - export ATAGs to userspace
  - change u8/u16/u32 to __u8/__u16/__u32

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-arm/setup.h        |  104 ++++++++++++++++---------------
 include/asm-arm26/setup.h      |    4 +
 include/asm-avr32/setup.h      |    4 +
 include/asm-frv/param.h        |    1 
 include/asm-frv/setup.h        |    6 +
 include/asm-generic/Kbuild.asm |    1 
 include/asm-i386/Kbuild        |    1 
 include/asm-i386/param.h       |    1 
 include/asm-i386/setup.h       |    6 +
 include/asm-ia64/Kbuild        |    1 
 include/asm-m32r/setup.h       |    9 ++
 include/asm-m68k/setup.h       |    6 +
 include/asm-m68knommu/setup.h  |    5 +
 include/asm-mips/setup.h       |    2 
 include/asm-powerpc/setup.h    |    3 
 include/asm-s390/setup.h       |    3 
 include/asm-sh/setup.h         |    6 +
 include/asm-sh64/setup.h       |    6 +
 include/asm-x86_64/Kbuild      |    1 
 19 files changed, 102 insertions(+), 68 deletions(-)

diff -puN include/asm-arm/setup.h~cleanup-asm-setuph-userspace-visibility-v2 include/asm-arm/setup.h
--- a/include/asm-arm/setup.h~cleanup-asm-setuph-userspace-visibility-v2
+++ a/include/asm-arm/setup.h
@@ -14,55 +14,57 @@
 #ifndef __ASMARM_SETUP_H
 #define __ASMARM_SETUP_H
 
+#include <asm/types.h>
+
 #define COMMAND_LINE_SIZE 1024
 
 /* The list ends with an ATAG_NONE node. */
 #define ATAG_NONE	0x00000000
 
 struct tag_header {
-	u32 size;
-	u32 tag;
+	__u32 size;
+	__u32 tag;
 };
 
 /* The list must start with an ATAG_CORE node */
 #define ATAG_CORE	0x54410001
 
 struct tag_core {
-	u32 flags;		/* bit 0 = read-only */
-	u32 pagesize;
-	u32 rootdev;
+	__u32 flags;		/* bit 0 = read-only */
+	__u32 pagesize;
+	__u32 rootdev;
 };
 
 /* it is allowed to have multiple ATAG_MEM nodes */
 #define ATAG_MEM	0x54410002
 
 struct tag_mem32 {
-	u32	size;
-	u32	start;	/* physical start address */
+	__u32	size;
+	__u32	start;	/* physical start address */
 };
 
 /* VGA text type displays */
 #define ATAG_VIDEOTEXT	0x54410003
 
 struct tag_videotext {
-	u8		x;
-	u8		y;
-	u16		video_page;
-	u8		video_mode;
-	u8		video_cols;
-	u16		video_ega_bx;
-	u8		video_lines;
-	u8		video_isvga;
-	u16		video_points;
+	__u8		x;
+	__u8		y;
+	__u16		video_page;
+	__u8		video_mode;
+	__u8		video_cols;
+	__u16		video_ega_bx;
+	__u8		video_lines;
+	__u8		video_isvga;
+	__u16		video_points;
 };
 
 /* describes how the ramdisk will be used in kernel */
 #define ATAG_RAMDISK	0x54410004
 
 struct tag_ramdisk {
-	u32 flags;	/* bit 0 = load, bit 1 = prompt */
-	u32 size;	/* decompressed ramdisk size in _kilo_ bytes */
-	u32 start;	/* starting block of floppy-based RAM disk image */
+	__u32 flags;	/* bit 0 = load, bit 1 = prompt */
+	__u32 size;	/* decompressed ramdisk size in _kilo_ bytes */
+	__u32 start;	/* starting block of floppy-based RAM disk image */
 };
 
 /* describes where the compressed ramdisk image lives (virtual address) */
@@ -76,23 +78,23 @@ struct tag_ramdisk {
 #define ATAG_INITRD2	0x54420005
 
 struct tag_initrd {
-	u32 start;	/* physical start address */
-	u32 size;	/* size of compressed ramdisk image in bytes */
+	__u32 start;	/* physical start address */
+	__u32 size;	/* size of compressed ramdisk image in bytes */
 };
 
 /* board serial number. "64 bits should be enough for everybody" */
 #define ATAG_SERIAL	0x54410006
 
 struct tag_serialnr {
-	u32 low;
-	u32 high;
+	__u32 low;
+	__u32 high;
 };
 
 /* board revision */
 #define ATAG_REVISION	0x54410007
 
 struct tag_revision {
-	u32 rev;
+	__u32 rev;
 };
 
 /* initial values for vesafb-type framebuffers. see struct screen_info
@@ -101,20 +103,20 @@ struct tag_revision {
 #define ATAG_VIDEOLFB	0x54410008
 
 struct tag_videolfb {
-	u16		lfb_width;
-	u16		lfb_height;
-	u16		lfb_depth;
-	u16		lfb_linelength;
-	u32		lfb_base;
-	u32		lfb_size;
-	u8		red_size;
-	u8		red_pos;
-	u8		green_size;
-	u8		green_pos;
-	u8		blue_size;
-	u8		blue_pos;
-	u8		rsvd_size;
-	u8		rsvd_pos;
+	__u16		lfb_width;
+	__u16		lfb_height;
+	__u16		lfb_depth;
+	__u16		lfb_linelength;
+	__u32		lfb_base;
+	__u32		lfb_size;
+	__u8		red_size;
+	__u8		red_pos;
+	__u8		green_size;
+	__u8		green_pos;
+	__u8		blue_size;
+	__u8		blue_pos;
+	__u8		rsvd_size;
+	__u8		rsvd_pos;
 };
 
 /* command line: \0 terminated string */
@@ -128,17 +130,17 @@ struct tag_cmdline {
 #define ATAG_ACORN	0x41000101
 
 struct tag_acorn {
-	u32 memc_control_reg;
-	u32 vram_pages;
-	u8 sounddefault;
-	u8 adfsdrives;
+	__u32 memc_control_reg;
+	__u32 vram_pages;
+	__u8 sounddefault;
+	__u8 adfsdrives;
 };
 
 /* footbridge memory clock, see arch/arm/mach-footbridge/arch.c */
 #define ATAG_MEMCLK	0x41000402
 
 struct tag_memclk {
-	u32 fmemclk;
+	__u32 fmemclk;
 };
 
 struct tag {
@@ -167,24 +169,26 @@ struct tag {
 };
 
 struct tagtable {
-	u32 tag;
+	__u32 tag;
 	int (*parse)(const struct tag *);
 };
 
-#define __tag __attribute_used__ __attribute__((__section__(".taglist.init")))
-#define __tagtable(tag, fn) \
-static struct tagtable __tagtable_##fn __tag = { tag, fn }
-
 #define tag_member_present(tag,member)				\
 	((unsigned long)(&((struct tag *)0L)->member + 1)	\
 		<= (tag)->hdr.size * 4)
 
-#define tag_next(t)	((struct tag *)((u32 *)(t) + (t)->hdr.size))
+#define tag_next(t)	((struct tag *)((__u32 *)(t) + (t)->hdr.size))
 #define tag_size(type)	((sizeof(struct tag_header) + sizeof(struct type)) >> 2)
 
 #define for_each_tag(t,base)		\
 	for (t = base; t->hdr.size; t = tag_next(t))
 
+#ifdef __KERNEL__
+
+#define __tag __attribute_used__ __attribute__((__section__(".taglist.init")))
+#define __tagtable(tag, fn) \
+static struct tagtable __tagtable_##fn __tag = { tag, fn }
+
 /*
  * Memory map description
  */
@@ -217,4 +221,6 @@ struct early_params {
 static struct early_params __early_##fn __attribute_used__	\
 __attribute__((__section__(".early_param.init"))) = { name, fn }
 
+#endif  /*  __KERNEL__  */
+
 #endif
diff -puN include/asm-arm26/setup.h~cleanup-asm-setuph-userspace-visibility-v2 include/asm-arm26/setup.h
--- a/include/asm-arm26/setup.h~cleanup-asm-setuph-userspace-visibility-v2
+++ a/include/asm-arm26/setup.h
@@ -16,6 +16,8 @@
 
 #define COMMAND_LINE_SIZE 1024
 
+#ifdef __KERNEL__
+
 /* The list ends with an ATAG_NONE node. */
 #define ATAG_NONE	0x00000000
 
@@ -202,4 +204,6 @@ struct meminfo {
 
 extern struct meminfo meminfo;
 
+#endif  /*  __KERNEL__  */
+
 #endif
diff -puN include/asm-avr32/setup.h~cleanup-asm-setuph-userspace-visibility-v2 include/asm-avr32/setup.h
--- a/include/asm-avr32/setup.h~cleanup-asm-setuph-userspace-visibility-v2
+++ a/include/asm-avr32/setup.h
@@ -13,6 +13,8 @@
 
 #define COMMAND_LINE_SIZE 256
 
+#ifdef __KERNEL__
+
 /* Magic number indicating that a tag table is present */
 #define ATAG_MAGIC	0xa2a25441
 
@@ -138,4 +140,6 @@ void chip_enable_sdram(void);
 
 #endif /* !__ASSEMBLY__ */
 
+#endif  /*  __KERNEL__  */
+
 #endif /* __ASM_AVR32_SETUP_H__ */
diff -puN include/asm-frv/param.h~cleanup-asm-setuph-userspace-visibility-v2 include/asm-frv/param.h
--- a/include/asm-frv/param.h~cleanup-asm-setuph-userspace-visibility-v2
+++ a/include/asm-frv/param.h
@@ -18,6 +18,5 @@
 #endif
 
 #define MAXHOSTNAMELEN		64	/* max length of hostname */
-#define COMMAND_LINE_SIZE	512
 
 #endif /* _ASM_PARAM_H */
diff -puN include/asm-frv/setup.h~cleanup-asm-setuph-userspace-visibility-v2 include/asm-frv/setup.h
--- a/include/asm-frv/setup.h~cleanup-asm-setuph-userspace-visibility-v2
+++ a/include/asm-frv/setup.h
@@ -12,6 +12,10 @@
 #ifndef _ASM_SETUP_H
 #define _ASM_SETUP_H
 
+#define COMMAND_LINE_SIZE       512
+
+#ifdef __KERNEL__
+
 #include <linux/init.h>
 
 #ifndef __ASSEMBLY__
@@ -22,4 +26,6 @@ extern unsigned long __initdata num_mapp
 
 #endif /* !__ASSEMBLY__ */
 
+#endif  /*  __KERNEL__  */
+
 #endif /* _ASM_SETUP_H */
diff -puN include/asm-generic/Kbuild.asm~cleanup-asm-setuph-userspace-visibility-v2 include/asm-generic/Kbuild.asm
--- a/include/asm-generic/Kbuild.asm~cleanup-asm-setuph-userspace-visibility-v2
+++ a/include/asm-generic/Kbuild.asm
@@ -14,6 +14,7 @@ unifdef-y += posix_types.h
 unifdef-y += ptrace.h
 unifdef-y += resource.h
 unifdef-y += sembuf.h
+unifdef-y += setup.h
 unifdef-y += shmbuf.h
 unifdef-y += sigcontext.h
 unifdef-y += siginfo.h
diff -puN include/asm-i386/Kbuild~cleanup-asm-setuph-userspace-visibility-v2 include/asm-i386/Kbuild
--- a/include/asm-i386/Kbuild~cleanup-asm-setuph-userspace-visibility-v2
+++ a/include/asm-i386/Kbuild
@@ -7,5 +7,4 @@ header-y += ptrace-abi.h
 header-y += ucontext.h
 
 unifdef-y += mtrr.h
-unifdef-y += setup.h
 unifdef-y += vm86.h
diff -puN include/asm-i386/param.h~cleanup-asm-setuph-userspace-visibility-v2 include/asm-i386/param.h
--- a/include/asm-i386/param.h~cleanup-asm-setuph-userspace-visibility-v2
+++ a/include/asm-i386/param.h
@@ -18,6 +18,5 @@
 #endif
 
 #define MAXHOSTNAMELEN	64	/* max length of hostname */
-#define COMMAND_LINE_SIZE 256
 
 #endif
diff -puN include/asm-i386/setup.h~cleanup-asm-setuph-userspace-visibility-v2 include/asm-i386/setup.h
--- a/include/asm-i386/setup.h~cleanup-asm-setuph-userspace-visibility-v2
+++ a/include/asm-i386/setup.h
@@ -6,6 +6,8 @@
 #ifndef _i386_SETUP_H
 #define _i386_SETUP_H
 
+#define COMMAND_LINE_SIZE 256
+
 #ifdef __KERNEL__
 #include <linux/pfn.h>
 
@@ -14,10 +16,8 @@
  */
 #define MAXMEM_PFN	PFN_DOWN(MAXMEM)
 #define MAX_NONPAE_PFN	(1 << 20)
-#endif
 
 #define PARAM_SIZE 4096
-#define COMMAND_LINE_SIZE 256
 
 #define OLD_CL_MAGIC_ADDR	0x90020
 #define OLD_CL_MAGIC		0xA33F
@@ -78,4 +78,6 @@ void __init add_memory_region(unsigned l
 
 #endif /* __ASSEMBLY__ */
 
+#endif  /*  __KERNEL__  */
+
 #endif /* _i386_SETUP_H */
diff -puN include/asm-ia64/Kbuild~cleanup-asm-setuph-userspace-visibility-v2 include/asm-ia64/Kbuild
--- a/include/asm-ia64/Kbuild~cleanup-asm-setuph-userspace-visibility-v2
+++ a/include/asm-ia64/Kbuild
@@ -10,7 +10,6 @@ header-y += intrinsics.h
 header-y += perfmon_default_smpl.h
 header-y += ptrace_offsets.h
 header-y += rse.h
-header-y += setup.h
 header-y += ucontext.h
 
 unifdef-y += perfmon.h
diff -puN include/asm-m32r/setup.h~cleanup-asm-setuph-userspace-visibility-v2 include/asm-m32r/setup.h
--- a/include/asm-m32r/setup.h~cleanup-asm-setuph-userspace-visibility-v2
+++ a/include/asm-m32r/setup.h
@@ -1,6 +1,11 @@
 /*
  * This is set up by the setup-routine at boot-time
  */
+
+#define COMMAND_LINE_SIZE       512
+
+#ifdef __KERNEL__
+
 #define PARAM			((unsigned char *)empty_zero_page)
 
 #define MOUNT_ROOT_RDONLY	(*(unsigned long *) (PARAM+0x000))
@@ -18,8 +23,6 @@
 
 #define SCREEN_INFO		(*(struct screen_info *) (PARAM+0x200))
 
-#define COMMAND_LINE_SIZE	(512)
-
 #define RAMDISK_IMAGE_START_MASK	(0x07FF)
 #define RAMDISK_PROMPT_FLAG		(0x8000)
 #define RAMDISK_LOAD_FLAG		(0x4000)
@@ -27,3 +30,5 @@
 extern unsigned long memory_start;
 extern unsigned long memory_end;
 
+#endif  /*  __KERNEL__  */
+
diff -puN include/asm-m68k/setup.h~cleanup-asm-setuph-userspace-visibility-v2 include/asm-m68k/setup.h
--- a/include/asm-m68k/setup.h~cleanup-asm-setuph-userspace-visibility-v2
+++ a/include/asm-m68k/setup.h
@@ -41,8 +41,12 @@
 #define MACH_Q40     10
 #define MACH_SUN3X   11
 
+#define COMMAND_LINE_SIZE 256
+
 #ifdef __KERNEL__
 
+#define CL_SIZE COMMAND_LINE_SIZE
+
 #ifndef __ASSEMBLY__
 extern unsigned long m68k_machtype;
 #endif /* !__ASSEMBLY__ */
@@ -355,8 +359,6 @@ extern int m68k_is040or060;
      */
 
 #define NUM_MEMINFO	4
-#define CL_SIZE		256
-#define COMMAND_LINE_SIZE	CL_SIZE
 
 #ifndef __ASSEMBLY__
 struct mem_info {
diff -puN include/asm-m68knommu/setup.h~cleanup-asm-setuph-userspace-visibility-v2 include/asm-m68knommu/setup.h
--- a/include/asm-m68knommu/setup.h~cleanup-asm-setuph-userspace-visibility-v2
+++ a/include/asm-m68knommu/setup.h
@@ -1,5 +1,10 @@
+#ifdef __KERNEL__
+
 #include <asm-m68k/setup.h>
 
 /* We have a bigger command line buffer. */
 #undef COMMAND_LINE_SIZE
+
+#endif  /*  __KERNEL__  */
+
 #define COMMAND_LINE_SIZE	512
diff -puN include/asm-mips/setup.h~cleanup-asm-setuph-userspace-visibility-v2 include/asm-mips/setup.h
--- a/include/asm-mips/setup.h~cleanup-asm-setuph-userspace-visibility-v2
+++ a/include/asm-mips/setup.h
@@ -1,8 +1,6 @@
-#ifdef __KERNEL__
 #ifndef _MIPS_SETUP_H
 #define _MIPS_SETUP_H
 
 #define COMMAND_LINE_SIZE	256
 
 #endif /* __SETUP_H */
-#endif /* __KERNEL__ */
diff -puN include/asm-powerpc/setup.h~cleanup-asm-setuph-userspace-visibility-v2 include/asm-powerpc/setup.h
--- a/include/asm-powerpc/setup.h~cleanup-asm-setuph-userspace-visibility-v2
+++ a/include/asm-powerpc/setup.h
@@ -1,9 +1,6 @@
 #ifndef _ASM_POWERPC_SETUP_H
 #define _ASM_POWERPC_SETUP_H
 
-#ifdef __KERNEL__
-
 #define COMMAND_LINE_SIZE	512
 
-#endif	/* __KERNEL__ */
 #endif	/* _ASM_POWERPC_SETUP_H */
diff -puN include/asm-s390/setup.h~cleanup-asm-setuph-userspace-visibility-v2 include/asm-s390/setup.h
--- a/include/asm-s390/setup.h~cleanup-asm-setuph-userspace-visibility-v2
+++ a/include/asm-s390/setup.h
@@ -8,12 +8,13 @@
 #ifndef _ASM_S390_SETUP_H
 #define _ASM_S390_SETUP_H
 
+#define COMMAND_LINE_SIZE 	896
+
 #ifdef __KERNEL__
 
 #include <asm/types.h>
 
 #define PARMAREA		0x10400
-#define COMMAND_LINE_SIZE 	896
 #define MEMORY_CHUNKS		16	/* max 0x7fff */
 #define IPL_PARMBLOCK_ORIGIN	0x2000
 
diff -puN include/asm-sh/setup.h~cleanup-asm-setuph-userspace-visibility-v2 include/asm-sh/setup.h
--- a/include/asm-sh/setup.h~cleanup-asm-setuph-userspace-visibility-v2
+++ a/include/asm-sh/setup.h
@@ -1,10 +1,12 @@
-#ifdef __KERNEL__
 #ifndef _SH_SETUP_H
 #define _SH_SETUP_H
 
 #define COMMAND_LINE_SIZE 256
 
+#ifdef __KERNEL__
+
 int setup_early_printk(char *);
 
-#endif /* _SH_SETUP_H */
 #endif /* __KERNEL__ */
+
+#endif /* _SH_SETUP_H */
diff -puN include/asm-sh64/setup.h~cleanup-asm-setuph-userspace-visibility-v2 include/asm-sh64/setup.h
--- a/include/asm-sh64/setup.h~cleanup-asm-setuph-userspace-visibility-v2
+++ a/include/asm-sh64/setup.h
@@ -1,6 +1,10 @@
 #ifndef __ASM_SH64_SETUP_H
 #define __ASM_SH64_SETUP_H
 
+#define COMMAND_LINE_SIZE 256
+
+#ifdef __KERNEL__
+
 #define PARAM ((unsigned char *)empty_zero_page)
 #define MOUNT_ROOT_RDONLY (*(unsigned long *) (PARAM+0x000))
 #define RAMDISK_FLAGS (*(unsigned long *) (PARAM+0x004))
@@ -12,5 +16,7 @@
 #define COMMAND_LINE ((char *) (PARAM+256))
 #define COMMAND_LINE_SIZE 256
 
+#endif  /*  __KERNEL__  */
+
 #endif /* __ASM_SH64_SETUP_H */
 
diff -puN include/asm-x86_64/Kbuild~cleanup-asm-setuph-userspace-visibility-v2 include/asm-x86_64/Kbuild
--- a/include/asm-x86_64/Kbuild~cleanup-asm-setuph-userspace-visibility-v2
+++ a/include/asm-x86_64/Kbuild
@@ -12,7 +12,6 @@ header-y += ldt.h
 header-y += msr.h
 header-y += prctl.h
 header-y += ptrace-abi.h
-header-y += setup.h
 header-y += sigcontext32.h
 header-y += ucontext.h
 header-y += vsyscall32.h
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
make-drivers-acpi-eccec_ecdt-static.patch
drivers-acpi-oslc-fix-a-null-check.patch
git-alsa.patch
git-dvb.patch
fs-dlm-lowcomms-tcpc-remove-2-functions.patch
git-mtd.patch
remove-mtd-jffs2-userh.patch
net-uninline-skb_put-fix.patch
dont-export-device-ids-to-userspace.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
drivers-edac-make-code-static.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
make-ext2_get_blocks-static.patch
generic-bug-implementation-include-linux-bugh-must-always-include-linux-moduleh.patch
fsstack-introduce-fsstack_copy_attrinode_-fs-stackc-should-include-linux-fs_stackh.patch
i4l-remove-the-broken-hisax_amd7930-option.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
make-drivers-md-dm-snapcksnapd-static.patch
gtod-persistent-clock-support-core-remove-kernel-timercwall_jiffies.patch
gtod-persistent-clock-support-i386-i386-unexport-read_persistent_clock.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-make-kernel-timerc__next_timer_interrupt-static.patch
updated-i386-convert-to-clock-event-devices-arch-i386-kernel-apicc-make-a-function-static.patch
updated-i386-convert-to-clock-event-devices-remove-arch-i386-kernel-time_hpetchpet_reenable.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slab-cache-shrinker-statistics.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

