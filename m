From: akpm@linux-foundation.org
Subject: + spi-replace-remaining-__function__-occurrences.patch added to -mm tree
Date: Wed, 05 Mar 2008 19:50:18 -0800
Message-ID: <200803060350.m263oI7j007347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751329AbYCFD6Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 22:58:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, dbrownell@users.sourceforge.net


The patch titled
     spi: replace remaining __FUNCTION__ occurrences
has been added to the -mm tree.  Its filename is
     spi-replace-remaining-__function__-occurrences.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/omap_uwire.c  |    4 ++--
 drivers/spi/spi_bitbang.c |    2 +-
 drivers/spi/spi_mpc83xx.c |    2 +-
 drivers/spi/spi_s3c24xx.c |    2 +-
 drivers/spi/xilinx_spi.c  |    8 ++++----
 5 files changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/spi/omap_uwire.c~spi-replace-remaining-__function__-occurrences drivers/spi/omap_uwire.c
--- a/drivers/spi/omap_uwire.c~spi-replace-remaining-__function__-occurrences
+++ a/drivers/spi/omap_uwire.c
@@ -151,7 +151,7 @@ static int wait_uwire_csr_flag(u16 mask,
 		if (time_after(jiffies, max_jiffies)) {
 			printk(KERN_ERR "%s: timeout. reg=%#06x "
 					"mask=%#06x val=%#06x\n",
-			       __FUNCTION__, w, mask, val);
+			       __func__, w, mask, val);
 			return -1;
 		}
 		c++;
@@ -437,7 +437,7 @@ static int uwire_setup_transfer(struct s
 	}
 	omap_uwire_configure_mode(spi->chip_select, flags);
 	pr_debug("%s: uwire flags %02x, armxor %lu KHz, SCK %lu KHz\n",
-			__FUNCTION__, flags,
+			__func__, flags,
 			clk_get_rate(uwire->ck) / 1000,
 			rate / 1000);
 	status = 0;
diff -puN drivers/spi/spi_bitbang.c~spi-replace-remaining-__function__-occurrences drivers/spi/spi_bitbang.c
--- a/drivers/spi/spi_bitbang.c~spi-replace-remaining-__function__-occurrences
+++ a/drivers/spi/spi_bitbang.c
@@ -214,7 +214,7 @@ int spi_bitbang_setup(struct spi_device 
 		return retval;
 
 	dev_dbg(&spi->dev, "%s, mode %d, %u bits/w, %u nsec/bit\n",
-			__FUNCTION__, spi->mode & (SPI_CPOL | SPI_CPHA),
+			__func__, spi->mode & (SPI_CPOL | SPI_CPHA),
 			spi->bits_per_word, 2 * cs->nsecs);
 
 	/* NOTE we _need_ to call chipselect() early, ideally with adapter
diff -puN drivers/spi/spi_mpc83xx.c~spi-replace-remaining-__function__-occurrences drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi-replace-remaining-__function__-occurrences
+++ a/drivers/spi/spi_mpc83xx.c
@@ -310,7 +310,7 @@ static int mpc83xx_spi_setup(struct spi_
 		return retval;
 
 	dev_dbg(&spi->dev, "%s, mode %d, %u bits/w, %u nsec\n",
-		__FUNCTION__, spi->mode & (SPI_CPOL | SPI_CPHA),
+		__func__, spi->mode & (SPI_CPOL | SPI_CPHA),
 		spi->bits_per_word, 2 * mpc83xx_spi->nsecs);
 
 	/* NOTE we _need_ to call chipselect() early, ideally with adapter
diff -puN drivers/spi/spi_s3c24xx.c~spi-replace-remaining-__function__-occurrences drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~spi-replace-remaining-__function__-occurrences
+++ a/drivers/spi/spi_s3c24xx.c
@@ -169,7 +169,7 @@ static int s3c24xx_spi_setup(struct spi_
 	}
 
 	dev_dbg(&spi->dev, "%s: mode %d, %u bpw, %d hz\n",
-		__FUNCTION__, spi->mode, spi->bits_per_word,
+		__func__, spi->mode, spi->bits_per_word,
 		spi->max_speed_hz);
 
 	return 0;
diff -puN drivers/spi/xilinx_spi.c~spi-replace-remaining-__function__-occurrences drivers/spi/xilinx_spi.c
--- a/drivers/spi/xilinx_spi.c~spi-replace-remaining-__function__-occurrences
+++ a/drivers/spi/xilinx_spi.c
@@ -151,13 +151,13 @@ static int xilinx_spi_setup_transfer(str
 	hz = (t) ? t->speed_hz : spi->max_speed_hz;
 	if (bits_per_word != 8) {
 		dev_err(&spi->dev, "%s, unsupported bits_per_word=%d\n",
-			__FUNCTION__, bits_per_word);
+			__func__, bits_per_word);
 		return -EINVAL;
 	}
 
 	if (hz && xspi->speed_hz > hz) {
 		dev_err(&spi->dev, "%s, unsupported clock rate %uHz\n",
-			__FUNCTION__, hz);
+			__func__, hz);
 		return -EINVAL;
 	}
 
@@ -181,7 +181,7 @@ static int xilinx_spi_setup(struct spi_d
 
 	if (spi->mode & ~MODEBITS) {
 		dev_err(&spi->dev, "%s, unsupported mode bits %x\n",
-			__FUNCTION__, spi->mode & ~MODEBITS);
+			__func__, spi->mode & ~MODEBITS);
 		return -EINVAL;
 	}
 
@@ -190,7 +190,7 @@ static int xilinx_spi_setup(struct spi_d
 		return retval;
 
 	dev_dbg(&spi->dev, "%s, mode %d, %u bits/w, %u nsec/bit\n",
-		__FUNCTION__, spi->mode & MODEBITS, spi->bits_per_word, 0);
+		__func__, spi->mode & MODEBITS, spi->bits_per_word, 0);
 
 	return 0;
 }
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

git-x86.patch
git-alsa.patch
sound-replace-remaining-__function__-occurences.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
arm-replace-remaining-__function__-occurences.patch
cifs-remove-global_extern-macro.patch
cifs-replace-remaining-__function__-occurrences.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
drivers-base-replace-remaining-__function__-occurrences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
ia64-remove-remaining-__function__-occurences.patch
infiniband-replace-remaining-__function__-occurrences.patch
input-replace-remaining-__function__-occurrences.patch
jfs-replace-__inline-with-inline.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
mips-replace-remaining-__function__-occurences.patch
mips-replace-__inline-with-inline.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
net-replace-__inline-with-inline.patch
irda-replace-__inline-with-inline.patch
blackfin-replace-remaining-__function__-occurences.patch
nfs-replace-remaining-__function__-occurrences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
drivers-s390-replace-remaining-__function__-occurrences.patch
sh-replace-remaining-__function__-occurences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-stc-make-class-attributes-static.patch
scsi-osstc-make-class-attributes-static.patch
scsi-chc-fix-shadowed-variable-warnings.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
xfs-replace-remaining-__function__-occurrences.patch
xfs-replace-__inline-with-inline.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
alpha-replace-__inline-with-inline.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
kernel-add-clamp-and-clamp_t-macros.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
isdn-replace-remaining-__function__-occurrences.patch
isdn-replace-__inline-with-inline.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
rtc-replace-remaining-__function__-occurrences.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
video-replace-remaining-__function__-occurrences.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
ext2-replace-remaining-__function__-occurrences.patch
jbd-sparse-warnings-in-revokec-journalc.patch
ext3-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
ufs-replace-__inline-with-inline.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
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
security-replace-remaining-__function__-occurences.patch
security-replace-remaining-__function__-occurences-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch
acpi-replace-remaining-__function__-occurrences.patch
ata-replace-remaining-__function__-occurrences.patch
block-replace-remaining-__function__-occurrences.patch
iop-admac-replace-remaining-__function__-occurrences.patch
ieee1394-replace-remaining-__function__-occurrences.patch
firmware-replace-remaining-__function__-occurrences.patch
mtd-replace-remaining-__function__-occurrences.patch
md-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
ioc3c-replace-remaining-__function__-occurrences.patch
watchdog-replace-remaining-__function__-occurrences.patch
spi-replace-remaining-__function__-occurrences.patch
power-replace-remaining-__function__-occurrences.patch
drivers-replace-remaining-__function__-occurrences.patch

