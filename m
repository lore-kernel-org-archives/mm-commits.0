From: akpm@linux-foundation.org
Subject: [merged] soc-fix-i2c-build-errors.patch removed from -mm tree
Date: Wed, 12 Aug 2009 12:54:46 -0700
Message-ID: <200908121954.n7CJskfJ032385@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45628 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753969AbZHLTzK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Aug 2009 15:55:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, broonie@opensource.wolfsonmicro.com, timur@freescale.com, mm-commits@vger.kernel.org


The patch titled
     soc: fix I2C build errors
has been removed from the -mm tree.  Its filename was
     soc-fix-i2c-build-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: soc: fix I2C build errors
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix soc build errors when I2C is built as a loadable module:

(.text+0x5d26b): undefined reference to `i2c_master_send'
soc-cache.c:(.text+0x5d32d): undefined reference to `i2c_transfer'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Timur Tabi <timur@freescale.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/soc/soc-cache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN sound/soc/soc-cache.c~soc-fix-i2c-build-errors sound/soc/soc-cache.c
--- a/sound/soc/soc-cache.c~soc-fix-i2c-build-errors
+++ a/sound/soc/soc-cache.c
@@ -108,7 +108,7 @@ static unsigned int snd_soc_8_16_read(st
 		return cache[reg];
 }
 
-#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
+#if defined(CONFIG_I2C) || (defined(CONFIG_I2C_MODULE) && defined(MODULE))
 static unsigned int snd_soc_8_16_read_i2c(struct snd_soc_codec *codec,
 					  unsigned int r)
 {
@@ -200,7 +200,7 @@ int snd_soc_codec_set_cache_io(struct sn
 		break;
 
 	case SND_SOC_I2C:
-#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
+#if defined(CONFIG_I2C) || (defined(CONFIG_I2C_MODULE) && defined(MODULE))
 		codec->hw_write = (hw_write_t)i2c_master_send;
 #endif
 		if (io_types[i].i2c_read)
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
kernel-hacking-move-strip_asm_syms-from-general.patch
mtd-make-onenand-genericc-more-generic-fix.patch
isdn-fix-netjet-build-errors.patch
usb-otg-fix-twl4030-usb-build.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
page_alloc-fix-kernel-doc-warning.patch
ksm-add-some-documentation.patch
lis3-add-power-management-functions-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
spih-add-missing-kernel-doc-for-struct-spi_master.patch
gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix.patch
doc-filesystems-remove-smount-program.patch
doc-filesystems-more-mount-cleanups.patch
documentation-update-stale-definition-of-file-nr-in-fstxt.patch
reiser4-export-remove_from_page_cache-fix.patch

