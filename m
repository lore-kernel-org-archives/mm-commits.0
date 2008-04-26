From: akpm@linux-foundation.org
Subject: - mtd-replace-remaining-__function__-occurrences.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:41:21 -0700
Message-ID: <200804261641.m3QGfLR3031118@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757689AbYDZQtf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:49:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     mtd-replace-remaining-__function__-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/chips/cfi_cmdset_0001.c |   12 ++++++------
 drivers/mtd/chips/cfi_cmdset_0020.c |   12 ++++++------
 drivers/mtd/devices/lart.c          |   16 ++++++++--------
 drivers/mtd/devices/m25p80.c        |    8 ++++----
 drivers/mtd/maps/bast-flash.c       |    4 ++--
 drivers/mtd/maps/pcmciamtd.c        |    2 +-
 drivers/mtd/maps/pmcmsp-flash.c     |    2 +-
 drivers/mtd/maps/tqm8xxl.c          |    6 +++---
 drivers/mtd/ubi/debug.h             |    2 +-
 drivers/mtd/ubi/ubi.h               |    4 ++--
 10 files changed, 34 insertions(+), 34 deletions(-)

diff -puN drivers/mtd/chips/cfi_cmdset_0001.c~mtd-replace-remaining-__function__-occurrences drivers/mtd/chips/cfi_cmdset_0001.c
--- a/drivers/mtd/chips/cfi_cmdset_0001.c~mtd-replace-remaining-__function__-occurrences
+++ a/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -384,7 +384,7 @@ read_pri_intelext(struct map_info *map, 
 			if (extp_size > 4096) {
 				printk(KERN_ERR
 					"%s: cfi_pri_intelext is too fat\n",
-					__FUNCTION__);
+					__func__);
 				return NULL;
 			}
 			goto again;
@@ -641,7 +641,7 @@ static int cfi_intelext_partition_fixup(
 		if ((1 << partshift) < mtd->erasesize) {
 			printk( KERN_ERR
 				"%s: bad number of hw partitions (%d)\n",
-				__FUNCTION__, numparts);
+				__func__, numparts);
 			return -EINVAL;
 		}
 
@@ -2013,7 +2013,7 @@ static int cfi_intelext_lock(struct mtd_
 
 #ifdef DEBUG_LOCK_BITS
 	printk(KERN_DEBUG "%s: lock status before, ofs=0x%08llx, len=0x%08X\n",
-	       __FUNCTION__, ofs, len);
+	       __func__, ofs, len);
 	cfi_varsize_frob(mtd, do_printlockstatus_oneblock,
 		ofs, len, NULL);
 #endif
@@ -2023,7 +2023,7 @@ static int cfi_intelext_lock(struct mtd_
 
 #ifdef DEBUG_LOCK_BITS
 	printk(KERN_DEBUG "%s: lock status after, ret=%d\n",
-	       __FUNCTION__, ret);
+	       __func__, ret);
 	cfi_varsize_frob(mtd, do_printlockstatus_oneblock,
 		ofs, len, NULL);
 #endif
@@ -2037,7 +2037,7 @@ static int cfi_intelext_unlock(struct mt
 
 #ifdef DEBUG_LOCK_BITS
 	printk(KERN_DEBUG "%s: lock status before, ofs=0x%08llx, len=0x%08X\n",
-	       __FUNCTION__, ofs, len);
+	       __func__, ofs, len);
 	cfi_varsize_frob(mtd, do_printlockstatus_oneblock,
 		ofs, len, NULL);
 #endif
@@ -2047,7 +2047,7 @@ static int cfi_intelext_unlock(struct mt
 
 #ifdef DEBUG_LOCK_BITS
 	printk(KERN_DEBUG "%s: lock status after, ret=%d\n",
-	       __FUNCTION__, ret);
+	       __func__, ret);
 	cfi_varsize_frob(mtd, do_printlockstatus_oneblock,
 		ofs, len, NULL);
 #endif
diff -puN drivers/mtd/chips/cfi_cmdset_0020.c~mtd-replace-remaining-__function__-occurrences drivers/mtd/chips/cfi_cmdset_0020.c
--- a/drivers/mtd/chips/cfi_cmdset_0020.c~mtd-replace-remaining-__function__-occurrences
+++ a/drivers/mtd/chips/cfi_cmdset_0020.c
@@ -445,7 +445,7 @@ static inline int do_write_buffer(struct
  retry:
 
 #ifdef DEBUG_CFI_FEATURES
-       printk("%s: chip->state[%d]\n", __FUNCTION__, chip->state);
+       printk("%s: chip->state[%d]\n", __func__, chip->state);
 #endif
 	spin_lock_bh(chip->mutex);
 
@@ -463,7 +463,7 @@ static inline int do_write_buffer(struct
 		map_write(map, CMD(0x70), cmd_adr);
                 chip->state = FL_STATUS;
 #ifdef DEBUG_CFI_FEATURES
-        printk("%s: 1 status[%x]\n", __FUNCTION__, map_read(map, cmd_adr));
+	printk("%s: 1 status[%x]\n", __func__, map_read(map, cmd_adr));
 #endif
 
 	case FL_STATUS:
@@ -591,7 +591,7 @@ static inline int do_write_buffer(struct
         /* check for errors: 'lock bit', 'VPP', 'dead cell'/'unerased cell' or 'incorrect cmd' -- saw */
         if (map_word_bitsset(map, status, CMD(0x3a))) {
 #ifdef DEBUG_CFI_FEATURES
-		printk("%s: 2 status[%lx]\n", __FUNCTION__, status.x[0]);
+		printk("%s: 2 status[%lx]\n", __func__, status.x[0]);
 #endif
 		/* clear status */
 		map_write(map, CMD(0x50), cmd_adr);
@@ -625,9 +625,9 @@ static int cfi_staa_write_buffers (struc
 	ofs = to  - (chipnum << cfi->chipshift);
 
 #ifdef DEBUG_CFI_FEATURES
-        printk("%s: map_bankwidth(map)[%x]\n", __FUNCTION__, map_bankwidth(map));
-        printk("%s: chipnum[%x] wbufsize[%x]\n", __FUNCTION__, chipnum, wbufsize);
-        printk("%s: ofs[%x] len[%x]\n", __FUNCTION__, ofs, len);
+	printk("%s: map_bankwidth(map)[%x]\n", __func__, map_bankwidth(map));
+	printk("%s: chipnum[%x] wbufsize[%x]\n", __func__, chipnum, wbufsize);
+	printk("%s: ofs[%x] len[%x]\n", __func__, ofs, len);
 #endif
 
         /* Write buffer is worth it only if more than one word to write... */
diff -puN drivers/mtd/devices/lart.c~mtd-replace-remaining-__function__-occurrences drivers/mtd/devices/lart.c
--- a/drivers/mtd/devices/lart.c~mtd-replace-remaining-__function__-occurrences
+++ a/drivers/mtd/devices/lart.c
@@ -275,7 +275,7 @@ static __u8 read8 (__u32 offset)
 {
    volatile __u8 *data = (__u8 *) (FLASH_OFFSET + offset);
 #ifdef LART_DEBUG
-   printk (KERN_DEBUG "%s(): 0x%.8x -> 0x%.2x\n",__FUNCTION__,offset,*data);
+   printk (KERN_DEBUG "%s(): 0x%.8x -> 0x%.2x\n", __func__, offset, *data);
 #endif
    return (*data);
 }
@@ -284,7 +284,7 @@ static __u32 read32 (__u32 offset)
 {
    volatile __u32 *data = (__u32 *) (FLASH_OFFSET + offset);
 #ifdef LART_DEBUG
-   printk (KERN_DEBUG "%s(): 0x%.8x -> 0x%.8x\n",__FUNCTION__,offset,*data);
+   printk (KERN_DEBUG "%s(): 0x%.8x -> 0x%.8x\n", __func__, offset, *data);
 #endif
    return (*data);
 }
@@ -294,7 +294,7 @@ static void write32 (__u32 x,__u32 offse
    volatile __u32 *data = (__u32 *) (FLASH_OFFSET + offset);
    *data = x;
 #ifdef LART_DEBUG
-   printk (KERN_DEBUG "%s(): 0x%.8x <- 0x%.8x\n",__FUNCTION__,offset,*data);
+   printk (KERN_DEBUG "%s(): 0x%.8x <- 0x%.8x\n", __func__, offset, *data);
 #endif
 }
 
@@ -337,7 +337,7 @@ static inline int erase_block (__u32 off
    __u32 status;
 
 #ifdef LART_DEBUG
-   printk (KERN_DEBUG "%s(): 0x%.8x\n",__FUNCTION__,offset);
+   printk (KERN_DEBUG "%s(): 0x%.8x\n", __func__, offset);
 #endif
 
    /* erase and confirm */
@@ -371,7 +371,7 @@ static int flash_erase (struct mtd_info 
    int i,first;
 
 #ifdef LART_DEBUG
-   printk (KERN_DEBUG "%s(addr = 0x%.8x, len = %d)\n",__FUNCTION__,instr->addr,instr->len);
+   printk (KERN_DEBUG "%s(addr = 0x%.8x, len = %d)\n", __func__, instr->addr, instr->len);
 #endif
 
    /* sanity checks */
@@ -442,7 +442,7 @@ static int flash_erase (struct mtd_info 
 static int flash_read (struct mtd_info *mtd,loff_t from,size_t len,size_t *retlen,u_char *buf)
 {
 #ifdef LART_DEBUG
-   printk (KERN_DEBUG "%s(from = 0x%.8x, len = %d)\n",__FUNCTION__,(__u32) from,len);
+   printk (KERN_DEBUG "%s(from = 0x%.8x, len = %d)\n", __func__, (__u32)from, len);
 #endif
 
    /* sanity checks */
@@ -488,7 +488,7 @@ static inline int write_dword (__u32 off
    __u32 status;
 
 #ifdef LART_DEBUG
-   printk (KERN_DEBUG "%s(): 0x%.8x <- 0x%.8x\n",__FUNCTION__,offset,x);
+   printk (KERN_DEBUG "%s(): 0x%.8x <- 0x%.8x\n", __func__, offset, x);
 #endif
 
    /* setup writing */
@@ -524,7 +524,7 @@ static int flash_write (struct mtd_info 
    int i,n;
 
 #ifdef LART_DEBUG
-   printk (KERN_DEBUG "%s(to = 0x%.8x, len = %d)\n",__FUNCTION__,(__u32) to,len);
+   printk (KERN_DEBUG "%s(to = 0x%.8x, len = %d)\n", __func__, (__u32)to, len);
 #endif
 
    *retlen = 0;
diff -puN drivers/mtd/devices/m25p80.c~mtd-replace-remaining-__function__-occurrences drivers/mtd/devices/m25p80.c
--- a/drivers/mtd/devices/m25p80.c~mtd-replace-remaining-__function__-occurrences
+++ a/drivers/mtd/devices/m25p80.c
@@ -151,7 +151,7 @@ static int wait_till_ready(struct m25p *
 static int erase_sector(struct m25p *flash, u32 offset)
 {
 	DEBUG(MTD_DEBUG_LEVEL3, "%s: %s %dKiB at 0x%08x\n",
-			flash->spi->dev.bus_id, __FUNCTION__,
+			flash->spi->dev.bus_id, __func__,
 			flash->mtd.erasesize / 1024, offset);
 
 	/* Wait until finished previous write command. */
@@ -188,7 +188,7 @@ static int m25p80_erase(struct mtd_info 
 	u32 addr,len;
 
 	DEBUG(MTD_DEBUG_LEVEL2, "%s: %s %s 0x%08x, len %d\n",
-			flash->spi->dev.bus_id, __FUNCTION__, "at",
+			flash->spi->dev.bus_id, __func__, "at",
 			(u32)instr->addr, instr->len);
 
 	/* sanity checks */
@@ -240,7 +240,7 @@ static int m25p80_read(struct mtd_info *
 	struct spi_message m;
 
 	DEBUG(MTD_DEBUG_LEVEL2, "%s: %s %s 0x%08x, len %zd\n",
-			flash->spi->dev.bus_id, __FUNCTION__, "from",
+			flash->spi->dev.bus_id, __func__, "from",
 			(u32)from, len);
 
 	/* sanity checks */
@@ -308,7 +308,7 @@ static int m25p80_write(struct mtd_info 
 	struct spi_message m;
 
 	DEBUG(MTD_DEBUG_LEVEL2, "%s: %s %s 0x%08x, len %zd\n",
-			flash->spi->dev.bus_id, __FUNCTION__, "to",
+			flash->spi->dev.bus_id, __func__, "to",
 			(u32)to, len);
 
 	if (retlen)
diff -puN drivers/mtd/maps/bast-flash.c~mtd-replace-remaining-__function__-occurrences drivers/mtd/maps/bast-flash.c
--- a/drivers/mtd/maps/bast-flash.c~mtd-replace-remaining-__function__-occurrences
+++ a/drivers/mtd/maps/bast-flash.c
@@ -137,7 +137,7 @@ static int bast_flash_probe(struct platf
 	if (info->map.size > AREA_MAXSIZE)
 		info->map.size = AREA_MAXSIZE;
 
-	pr_debug("%s: area %08lx, size %ld\n", __FUNCTION__,
+	pr_debug("%s: area %08lx, size %ld\n", __func__,
 		 info->map.phys, info->map.size);
 
 	info->area = request_mem_region(res->start, info->map.size,
@@ -149,7 +149,7 @@ static int bast_flash_probe(struct platf
 	}
 
 	info->map.virt = ioremap(res->start, info->map.size);
-	pr_debug("%s: virt at %08x\n", __FUNCTION__, (int)info->map.virt);
+	pr_debug("%s: virt at %08x\n", __func__, (int)info->map.virt);
 
 	if (info->map.virt == 0) {
 		printk(KERN_ERR PFX "failed to ioremap() region\n");
diff -puN drivers/mtd/maps/pcmciamtd.c~mtd-replace-remaining-__function__-occurrences drivers/mtd/maps/pcmciamtd.c
--- a/drivers/mtd/maps/pcmciamtd.c~mtd-replace-remaining-__function__-occurrences
+++ a/drivers/mtd/maps/pcmciamtd.c
@@ -33,7 +33,7 @@ MODULE_PARM_DESC(debug, "Set Debug Level
 #undef DEBUG
 #define DEBUG(n, format, arg...) \
 	if (n <= debug) {	 \
-		printk(KERN_DEBUG __FILE__ ":%s(): " format "\n", __FUNCTION__ , ## arg); \
+		printk(KERN_DEBUG __FILE__ ":%s(): " format "\n", __func__ , ## arg); \
 	}
 
 #else
diff -puN drivers/mtd/maps/pmcmsp-flash.c~mtd-replace-remaining-__function__-occurrences drivers/mtd/maps/pmcmsp-flash.c
--- a/drivers/mtd/maps/pmcmsp-flash.c~mtd-replace-remaining-__function__-occurrences
+++ a/drivers/mtd/maps/pmcmsp-flash.c
@@ -46,7 +46,7 @@ static struct mtd_partition **msp_parts;
 static struct map_info *msp_maps;
 static int fcnt;
 
-#define DEBUG_MARKER printk(KERN_NOTICE "%s[%d]\n",__FUNCTION__,__LINE__)
+#define DEBUG_MARKER printk(KERN_NOTICE "%s[%d]\n", __func__, __LINE__)
 
 int __init init_msp_flash(void)
 {
diff -puN drivers/mtd/maps/tqm8xxl.c~mtd-replace-remaining-__function__-occurrences drivers/mtd/maps/tqm8xxl.c
--- a/drivers/mtd/maps/tqm8xxl.c~mtd-replace-remaining-__function__-occurrences
+++ a/drivers/mtd/maps/tqm8xxl.c
@@ -124,7 +124,7 @@ int __init init_tqm_mtd(void)
 	//request maximum flash size address space
 	start_scan_addr = ioremap(flash_addr, flash_size);
 	if (!start_scan_addr) {
-		printk(KERN_WARNING "%s:Failed to ioremap address:0x%x\n", __FUNCTION__, flash_addr);
+		printk(KERN_WARNING "%s:Failed to ioremap address:0x%x\n", __func__, flash_addr);
 		return -EIO;
 	}
 
@@ -132,7 +132,7 @@ int __init init_tqm_mtd(void)
 		if(mtd_size >= flash_size)
 			break;
 
-		printk(KERN_INFO "%s: chip probing count %d\n", __FUNCTION__, idx);
+		printk(KERN_INFO "%s: chip probing count %d\n", __func__, idx);
 
 		map_banks[idx] = kzalloc(sizeof(struct map_info), GFP_KERNEL);
 		if(map_banks[idx] == NULL) {
@@ -178,7 +178,7 @@ int __init init_tqm_mtd(void)
 			mtd_size += mtd_banks[idx]->size;
 			num_banks++;
 
-			printk(KERN_INFO "%s: bank%d, name:%s, size:%dbytes \n", __FUNCTION__, num_banks,
+			printk(KERN_INFO "%s: bank%d, name:%s, size:%dbytes \n", __func__, num_banks,
 			mtd_banks[idx]->name, mtd_banks[idx]->size);
 		}
 	}
diff -puN drivers/mtd/ubi/debug.h~mtd-replace-remaining-__function__-occurrences drivers/mtd/ubi/debug.h
--- a/drivers/mtd/ubi/debug.h~mtd-replace-remaining-__function__-occurrences
+++ a/drivers/mtd/ubi/debug.h
@@ -41,7 +41,7 @@
 /* Generic debugging message */
 #define dbg_msg(fmt, ...)                                    \
 	printk(KERN_DEBUG "UBI DBG (pid %d): %s: " fmt "\n", \
-	       current->pid, __FUNCTION__, ##__VA_ARGS__)
+	       current->pid, __func__, ##__VA_ARGS__)
 
 #define ubi_dbg_dump_stack() dump_stack()
 
diff -puN drivers/mtd/ubi/ubi.h~mtd-replace-remaining-__function__-occurrences drivers/mtd/ubi/ubi.h
--- a/drivers/mtd/ubi/ubi.h~mtd-replace-remaining-__function__-occurrences
+++ a/drivers/mtd/ubi/ubi.h
@@ -54,10 +54,10 @@
 #define ubi_msg(fmt, ...) printk(KERN_NOTICE "UBI: " fmt "\n", ##__VA_ARGS__)
 /* UBI warning messages */
 #define ubi_warn(fmt, ...) printk(KERN_WARNING "UBI warning: %s: " fmt "\n", \
-				  __FUNCTION__, ##__VA_ARGS__)
+				  __func__, ##__VA_ARGS__)
 /* UBI error messages */
 #define ubi_err(fmt, ...) printk(KERN_ERR "UBI error: %s: " fmt "\n", \
-				 __FUNCTION__, ##__VA_ARGS__)
+				 __func__, ##__VA_ARGS__)
 
 /* Lowest number PEBs reserved for bad PEB handling */
 #define MIN_RESEVED_PEBS 2
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
git-agpgart.patch
cifs-remove-global_extern-macro.patch
git-dvb.patch
git-kvm.patch
git-mips.patch
git-nfsd.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
input-replace-remaining-__function__-occurrences.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
alpha-replace-__inline-with-inline.patch
power-replace-remaining-__function__-occurrences.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
char-make-functions-static-in-synclinkmpc.patch
spi-replace-remaining-__function__-occurrences.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
isdn-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
rtc-replace-remaining-__function__-occurrences.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
video-replace-remaining-__function__-occurrences.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
md-replace-remaining-__function__-occurrences.patch
ext2-replace-remaining-__function__-occurrences.patch
ext3-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
ufs-replace-__inline-with-inline.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
reiserfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
kernel-add-common-infrastructure-for-unaligned-access.patch
kernel-move-arches-to-use-common-unaligned-access.patch
drivers-block-use-get_unaligned_-helpers.patch
hid-core-use-get_unaligned_-helpers.patch
char-use-get_unaligned_-helpers.patch
input-use-get_unaligned_-helpers.patch
mmc-use-get-put_unaligned_-helpers.patch
net-use-get-put_unaligned_-helpers.patch
wireless-use-get-put_unaligned_-helpers.patch
pcmcia-use-get-put_unaligned_-helpers.patch
usb-use-get-put_unaligned_-helpers.patch
video-use-get-put_unaligned_-helpers.patch
fat-use-get-put_unaligned_-helpers.patch
hfsplus-use-get-put_unaligned_-helpers.patch
isofs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

