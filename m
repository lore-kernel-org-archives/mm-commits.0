From: akpm@linux-foundation.org
Subject: + cobalt-remove-all-references-to-cobalt-nvram.patch added to -mm tree
Date: Mon, 11 Jun 2007 11:54:58 -0700
Message-ID: <200706111854.l5BIswH9026489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60748 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480AbXFKSzh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2007 14:55:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, thockin@hockin.org


The patch titled
     COBALT: remove all references to Cobalt NVRAM
has been added to the -mm tree.  Its filename is
     cobalt-remove-all-references-to-cobalt-nvram.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: COBALT: remove all references to Cobalt NVRAM
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove not only the references to Cobalt NVRAM, but the header file as
well.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Tim Hockin <thockin@hockin.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/nvram.c         |  192 ---------------------------------
 include/linux/cobalt-nvram.h |  109 ------------------
 2 files changed, 1 insertion(+), 300 deletions(-)

diff -puN drivers/char/nvram.c~cobalt-remove-all-references-to-cobalt-nvram drivers/char/nvram.c
--- a/drivers/char/nvram.c~cobalt-remove-all-references-to-cobalt-nvram
+++ a/drivers/char/nvram.c
@@ -42,19 +42,12 @@
 
 #define PC		1
 #define ATARI		2
-#define COBALT		3
 
 /* select machine configuration */
 #if defined(CONFIG_ATARI)
 #  define MACH ATARI
 #elif defined(__i386__) || defined(__x86_64__) || defined(__arm__)  /* and others?? */
-#define MACH PC
-#  if defined(CONFIG_COBALT)
-#    include <linux/cobalt-nvram.h>
-#    define MACH COBALT
-#  else
-#    define MACH PC
-#  endif
+#  define MACH PC
 #else
 #  error Cannot build nvram driver for this machine configuration.
 #endif
@@ -76,18 +69,6 @@
 
 #endif
 
-#if MACH == COBALT
-
-#define CHECK_DRIVER_INIT()     1
-
-#define NVRAM_BYTES		(128-NVRAM_FIRST_BYTE)
-
-#define mach_check_checksum	cobalt_check_checksum
-#define mach_set_checksum	cobalt_set_checksum
-#define mach_proc_infos		cobalt_proc_infos
-
-#endif
-
 #if MACH == ATARI
 
 /* Special parameters for RTC in Atari machines */
@@ -604,177 +585,6 @@ pc_proc_infos(unsigned char *nvram, char
 
 #endif /* MACH == PC */
 
-#if MACH == COBALT
-
-/* the cobalt CMOS has a wider range of its checksum */
-static int cobalt_check_checksum(void)
-{
-	int i;
-	unsigned short sum = 0;
-	unsigned short expect;
-
-	for (i = COBT_CMOS_CKS_START; i <= COBT_CMOS_CKS_END; ++i) {
-		if ((i == COBT_CMOS_CHECKSUM) || (i == (COBT_CMOS_CHECKSUM+1)))
-			continue;
-
-		sum += __nvram_read_byte(i);
-	}
-	expect = __nvram_read_byte(COBT_CMOS_CHECKSUM) << 8 |
-	    __nvram_read_byte(COBT_CMOS_CHECKSUM+1);
-	return ((sum & 0xffff) == expect);
-}
-
-static void cobalt_set_checksum(void)
-{
-	int i;
-	unsigned short sum = 0;
-
-	for (i = COBT_CMOS_CKS_START; i <= COBT_CMOS_CKS_END; ++i) {
-		if ((i == COBT_CMOS_CHECKSUM) || (i == (COBT_CMOS_CHECKSUM+1)))
-			continue;
-
-		sum += __nvram_read_byte(i);
-	}
-
-	__nvram_write_byte(sum >> 8, COBT_CMOS_CHECKSUM);
-	__nvram_write_byte(sum & 0xff, COBT_CMOS_CHECKSUM+1);
-}
-
-#ifdef CONFIG_PROC_FS
-
-static int cobalt_proc_infos(unsigned char *nvram, char *buffer, int *len,
-	off_t *begin, off_t offset, int size)
-{
-	int i;
-	unsigned int checksum;
-	unsigned int flags;
-	char sernum[14];
-	char *key = "cNoEbTaWlOtR!";
-	unsigned char bto_csum;
-
-	spin_lock_irq(&rtc_lock);
-	checksum = __nvram_check_checksum();
-	spin_unlock_irq(&rtc_lock);
-
-	PRINT_PROC("Checksum status: %svalid\n", checksum ? "" : "not ");
-
-	flags = nvram[COBT_CMOS_FLAG_BYTE_0] << 8 
-	    | nvram[COBT_CMOS_FLAG_BYTE_1];
-
-	PRINT_PROC("Console: %s\n",
-		flags & COBT_CMOS_CONSOLE_FLAG ?  "on": "off");
-
-	PRINT_PROC("Firmware Debug Messages: %s\n",
-		flags & COBT_CMOS_DEBUG_FLAG ? "on": "off");
-
-	PRINT_PROC("Auto Prompt: %s\n",
-		flags & COBT_CMOS_AUTO_PROMPT_FLAG ? "on": "off");
-
-	PRINT_PROC("Shutdown Status: %s\n",
-		flags & COBT_CMOS_CLEAN_BOOT_FLAG ? "clean": "dirty");
-
-	PRINT_PROC("Hardware Probe: %s\n",
-		flags & COBT_CMOS_HW_NOPROBE_FLAG ? "partial": "full");
-
-	PRINT_PROC("System Fault: %sdetected\n",
-		flags & COBT_CMOS_SYSFAULT_FLAG ? "": "not ");
-
-	PRINT_PROC("Panic on OOPS: %s\n",
-		flags & COBT_CMOS_OOPSPANIC_FLAG ? "yes": "no");
-
-	PRINT_PROC("Delayed Cache Initialization: %s\n",
-		flags & COBT_CMOS_DELAY_CACHE_FLAG ? "yes": "no");
-
-	PRINT_PROC("Show Logo at Boot: %s\n",
-		flags & COBT_CMOS_NOLOGO_FLAG ? "no": "yes");
-
-	PRINT_PROC("Boot Method: ");
-	switch (nvram[COBT_CMOS_BOOT_METHOD]) {
-	case COBT_CMOS_BOOT_METHOD_DISK:
-		PRINT_PROC("disk\n");
-		break;
-
-	case COBT_CMOS_BOOT_METHOD_ROM:
-		PRINT_PROC("rom\n");
-		break;
-
-	case COBT_CMOS_BOOT_METHOD_NET:
-		PRINT_PROC("net\n");
-		break;
-
-	default:
-		PRINT_PROC("unknown\n");
-		break;
-	}
-
-	PRINT_PROC("Primary Boot Device: %d:%d\n",
-		nvram[COBT_CMOS_BOOT_DEV0_MAJ],
-		nvram[COBT_CMOS_BOOT_DEV0_MIN] );
-	PRINT_PROC("Secondary Boot Device: %d:%d\n",
-		nvram[COBT_CMOS_BOOT_DEV1_MAJ],
-		nvram[COBT_CMOS_BOOT_DEV1_MIN] );
-	PRINT_PROC("Tertiary Boot Device: %d:%d\n",
-		nvram[COBT_CMOS_BOOT_DEV2_MAJ],
-		nvram[COBT_CMOS_BOOT_DEV2_MIN] );
-
-	PRINT_PROC("Uptime: %d\n",
-		nvram[COBT_CMOS_UPTIME_0] << 24 |
-		nvram[COBT_CMOS_UPTIME_1] << 16 |
-		nvram[COBT_CMOS_UPTIME_2] << 8  |
-		nvram[COBT_CMOS_UPTIME_3]);
-
-	PRINT_PROC("Boot Count: %d\n",
-		nvram[COBT_CMOS_BOOTCOUNT_0] << 24 |
-		nvram[COBT_CMOS_BOOTCOUNT_1] << 16 |
-		nvram[COBT_CMOS_BOOTCOUNT_2] << 8  |
-		nvram[COBT_CMOS_BOOTCOUNT_3]);
-
-	/* 13 bytes of serial num */
-	for (i=0 ; i<13 ; i++) {
-		sernum[i] = nvram[COBT_CMOS_SYS_SERNUM_0 + i];
-	}
-	sernum[13] = '\0';
-
-	checksum = 0;
-	for (i=0 ; i<13 ; i++) {
-		checksum += sernum[i] ^ key[i];
-	}
-	checksum = ((checksum & 0x7f) ^ (0xd6)) & 0xff;
-
-	PRINT_PROC("Serial Number: %s", sernum);
-	if (checksum != nvram[COBT_CMOS_SYS_SERNUM_CSUM]) {
-		PRINT_PROC(" (invalid checksum)");
-	}
-	PRINT_PROC("\n");
-
-	PRINT_PROC("Rom Revison: %d.%d.%d\n", nvram[COBT_CMOS_ROM_REV_MAJ],
-		nvram[COBT_CMOS_ROM_REV_MIN], nvram[COBT_CMOS_ROM_REV_REV]);
-
-	PRINT_PROC("BTO Server: %d.%d.%d.%d", nvram[COBT_CMOS_BTO_IP_0],
-		nvram[COBT_CMOS_BTO_IP_1], nvram[COBT_CMOS_BTO_IP_2],
-		nvram[COBT_CMOS_BTO_IP_3]);
-	bto_csum = nvram[COBT_CMOS_BTO_IP_0] + nvram[COBT_CMOS_BTO_IP_1]
-		+ nvram[COBT_CMOS_BTO_IP_2] + nvram[COBT_CMOS_BTO_IP_3];
-	if (bto_csum != nvram[COBT_CMOS_BTO_IP_CSUM]) {
-		PRINT_PROC(" (invalid checksum)");
-	}
-	PRINT_PROC("\n");
-
-	if (flags & COBT_CMOS_VERSION_FLAG
-	 && nvram[COBT_CMOS_VERSION] >= COBT_CMOS_VER_BTOCODE) {
-		PRINT_PROC("BTO Code: 0x%x\n",
-			nvram[COBT_CMOS_BTO_CODE_0] << 24 |
-			nvram[COBT_CMOS_BTO_CODE_1] << 16 |
-			nvram[COBT_CMOS_BTO_CODE_2] << 8 |
-			nvram[COBT_CMOS_BTO_CODE_3]);
-	}
-
-	return 1;
-}
-#endif /* CONFIG_PROC_FS */
-
-#endif /* MACH == COBALT */
-
 #if MACH == ATARI
 
 static int
diff -puN include/linux/cobalt-nvram.h~cobalt-remove-all-references-to-cobalt-nvram /dev/null
--- a/include/linux/cobalt-nvram.h
+++ /dev/null
@@ -1,109 +0,0 @@
-/*
- * $Id: cobalt-nvram.h,v 1.20 2001/10/17 23:16:55 thockin Exp $
- * cobalt-nvram.h : defines for the various fields in the cobalt NVRAM
- *
- * Copyright 2001,2002 Sun Microsystems, Inc.
- */
-
-#ifndef COBALT_NVRAM_H
-#define COBALT_NVRAM_H
-
-#include <linux/nvram.h>
-
-#define COBT_CMOS_INFO_MAX		0x7f	/* top address allowed */
-#define COBT_CMOS_BIOS_DRIVE_INFO	0x12	/* drive info would go here */
-
-#define COBT_CMOS_CKS_START		NVRAM_OFFSET(0x0e)
-#define COBT_CMOS_CKS_END		NVRAM_OFFSET(0x7f)
-
-/* flag bytes - 16 flags for now, leave room for more */
-#define COBT_CMOS_FLAG_BYTE_0		NVRAM_OFFSET(0x10)
-#define COBT_CMOS_FLAG_BYTE_1		NVRAM_OFFSET(0x11)
-
-/* flags in flag bytes - up to 16 */
-#define COBT_CMOS_FLAG_MIN		0x0001
-#define COBT_CMOS_CONSOLE_FLAG		0x0001 /* console on/off */
-#define COBT_CMOS_DEBUG_FLAG		0x0002 /* ROM debug messages */
-#define COBT_CMOS_AUTO_PROMPT_FLAG	0x0004 /* boot to ROM prompt? */
-#define COBT_CMOS_CLEAN_BOOT_FLAG	0x0008 /* set by a clean shutdown */
-#define COBT_CMOS_HW_NOPROBE_FLAG	0x0010 /* go easy on the probing */
-#define COBT_CMOS_SYSFAULT_FLAG		0x0020 /* system fault detected */
-#define COBT_CMOS_OOPSPANIC_FLAG	0x0040 /* panic on oops */
-#define COBT_CMOS_DELAY_CACHE_FLAG	0x0080 /* delay cache initialization */
-#define COBT_CMOS_NOLOGO_FLAG		0x0100 /* hide "C" logo @ boot */
-#define COBT_CMOS_VERSION_FLAG		0x0200 /* the version field is valid */
-#define COBT_CMOS_FLAG_MAX		0x0200
-
-/* leave byte 0x12 blank - Linux looks for drive info here */
-
-/* CMOS structure version, valid if COBT_CMOS_VERSION_FLAG is true */
-#define COBT_CMOS_VERSION		NVRAM_OFFSET(0x13)
-#define COBT_CMOS_VER_BTOCODE		1 /* min. version needed for btocode */
-
-/* index of default boot method */
-#define COBT_CMOS_BOOT_METHOD		NVRAM_OFFSET(0x20)
-#define COBT_CMOS_BOOT_METHOD_DISK	0
-#define COBT_CMOS_BOOT_METHOD_ROM	1
-#define COBT_CMOS_BOOT_METHOD_NET	2
-
-#define COBT_CMOS_BOOT_DEV_MIN		NVRAM_OFFSET(0x21)
-/* major #, minor # of first through fourth boot device */
-#define COBT_CMOS_BOOT_DEV0_MAJ		NVRAM_OFFSET(0x21)
-#define COBT_CMOS_BOOT_DEV0_MIN		NVRAM_OFFSET(0x22)
-#define COBT_CMOS_BOOT_DEV1_MAJ		NVRAM_OFFSET(0x23)
-#define COBT_CMOS_BOOT_DEV1_MIN		NVRAM_OFFSET(0x24)
-#define COBT_CMOS_BOOT_DEV2_MAJ		NVRAM_OFFSET(0x25)
-#define COBT_CMOS_BOOT_DEV2_MIN		NVRAM_OFFSET(0x26)
-#define COBT_CMOS_BOOT_DEV3_MAJ		NVRAM_OFFSET(0x27)
-#define COBT_CMOS_BOOT_DEV3_MIN		NVRAM_OFFSET(0x28)
-#define COBT_CMOS_BOOT_DEV_MAX		NVRAM_OFFSET(0x28)
-
-/* checksum of bytes 0xe-0x7f */
-#define COBT_CMOS_CHECKSUM		NVRAM_OFFSET(0x2e)
-
-/* running uptime counter, units of 5 minutes (32 bits =~ 41000 years) */
-#define COBT_CMOS_UPTIME_0		NVRAM_OFFSET(0x30)
-#define COBT_CMOS_UPTIME_1		NVRAM_OFFSET(0x31)
-#define COBT_CMOS_UPTIME_2		NVRAM_OFFSET(0x32)
-#define COBT_CMOS_UPTIME_3		NVRAM_OFFSET(0x33)
-
-/* count of successful boots (32 bits) */
-#define COBT_CMOS_BOOTCOUNT_0		NVRAM_OFFSET(0x38)
-#define COBT_CMOS_BOOTCOUNT_1		NVRAM_OFFSET(0x39)
-#define COBT_CMOS_BOOTCOUNT_2		NVRAM_OFFSET(0x3a)
-#define COBT_CMOS_BOOTCOUNT_3		NVRAM_OFFSET(0x3b)
-
-/* 13 bytes: system serial number, same as on the back of the system */
-#define COBT_CMOS_SYS_SERNUM_LEN	13
-#define COBT_CMOS_SYS_SERNUM_0		NVRAM_OFFSET(0x40)
-#define COBT_CMOS_SYS_SERNUM_1		NVRAM_OFFSET(0x41)
-#define COBT_CMOS_SYS_SERNUM_2		NVRAM_OFFSET(0x42)
-#define COBT_CMOS_SYS_SERNUM_3		NVRAM_OFFSET(0x43)
-#define COBT_CMOS_SYS_SERNUM_4		NVRAM_OFFSET(0x44)
-#define COBT_CMOS_SYS_SERNUM_5		NVRAM_OFFSET(0x45)
-#define COBT_CMOS_SYS_SERNUM_6		NVRAM_OFFSET(0x46)
-#define COBT_CMOS_SYS_SERNUM_7		NVRAM_OFFSET(0x47)
-#define COBT_CMOS_SYS_SERNUM_8		NVRAM_OFFSET(0x48)
-#define COBT_CMOS_SYS_SERNUM_9		NVRAM_OFFSET(0x49)
-#define COBT_CMOS_SYS_SERNUM_10		NVRAM_OFFSET(0x4a)
-#define COBT_CMOS_SYS_SERNUM_11		NVRAM_OFFSET(0x4b)
-#define COBT_CMOS_SYS_SERNUM_12		NVRAM_OFFSET(0x4c)
-/* checksum for serial num - 1 byte */
-#define COBT_CMOS_SYS_SERNUM_CSUM	NVRAM_OFFSET(0x4f)
-
-#define COBT_CMOS_ROM_REV_MAJ		NVRAM_OFFSET(0x50)
-#define COBT_CMOS_ROM_REV_MIN		NVRAM_OFFSET(0x51)
-#define COBT_CMOS_ROM_REV_REV		NVRAM_OFFSET(0x52)
-
-#define COBT_CMOS_BTO_CODE_0		NVRAM_OFFSET(0x53)
-#define COBT_CMOS_BTO_CODE_1		NVRAM_OFFSET(0x54)
-#define COBT_CMOS_BTO_CODE_2		NVRAM_OFFSET(0x55)
-#define COBT_CMOS_BTO_CODE_3		NVRAM_OFFSET(0x56)
-
-#define COBT_CMOS_BTO_IP_CSUM		NVRAM_OFFSET(0x57)
-#define COBT_CMOS_BTO_IP_0		NVRAM_OFFSET(0x58)
-#define COBT_CMOS_BTO_IP_1		NVRAM_OFFSET(0x59)
-#define COBT_CMOS_BTO_IP_2		NVRAM_OFFSET(0x5a)
-#define COBT_CMOS_BTO_IP_3		NVRAM_OFFSET(0x5b)
-
-#endif /* COBALT_NVRAM_H */
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
protect-linux-console_structh-from-multiple-inclusion.patch
ppc-remove-dead-code-for-preventing-pread-and-pwrite-calls.patch
viotape-use-designated-initializers-for-fops-member.patch
git-dvb.patch
git-ieee1394.patch
input-delete-useless-reference-to-dead-module_parm-macro.patch
git-kbuild.patch
git-kvm.patch
git-mmc.patch
bluetooth-remove-the-redundant-non-seekable-llseek-method.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-s390.patch
git-scsi-misc.patch
remove-dead-references-to-module_parm-macro.patch
git-watchdog.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
cris-replace-old-style-member-inits-with-designated-inits.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
drop-an-empty-isicomh-from-being-exported-to-user-space.patch
remove-apparently-useless-commented-apm_get_battery_status.patch
cobalt-remove-all-references-to-cobalt-nvram.patch
