From: akpm@linux-foundation.org
Subject: - spi-replace-remaining-__function__-occurrences.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:55:53 -0700
Message-ID: <200804282155.m3SLtrvA018163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934016AbYD1V4C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:56:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     spi-replace-remaining-__function__-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
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
power-replace-remaining-__function__-occurrences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
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

