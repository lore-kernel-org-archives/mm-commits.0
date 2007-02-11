From: akpm@linux-foundation.org
Subject: - get-rid-of-double-zeroing-of-allocated-pages.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:53:08 -0800
Message-ID: <200702112253.l1BMr8O2016079@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60372 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932799AbXBKWxg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:53:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, James.Bottomley@steeleye.com, chas@cmf.nrl.navy.mil, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Get rid of "double zeroing" of allocated pages
has been removed from the -mm tree.  Its filename was
     get-rid-of-double-zeroing-of-allocated-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Get rid of "double zeroing" of allocated pages
From: "Robert P. J. Day" <rpjday@mindspring.com>

Simplify the few instances where a call to "get_zeroed_page()" is closely
followed by an unnecessary call to memset() to clear that page.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: chas williams <chas@cmf.nrl.navy.mil>
Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/eni.c                  |    1 -
 drivers/media/video/zoran_driver.c |    1 -
 drivers/scsi/53c7xx.c              |    1 -
 3 files changed, 3 deletions(-)

diff -puN drivers/atm/eni.c~get-rid-of-double-zeroing-of-allocated-pages drivers/atm/eni.c
--- a/drivers/atm/eni.c~get-rid-of-double-zeroing-of-allocated-pages
+++ a/drivers/atm/eni.c
@@ -912,7 +912,6 @@ static int start_rx(struct atm_dev *dev)
 		free_page((unsigned long) eni_dev->free_list);
 		return -ENOMEM;
 	}
-	memset(eni_dev->rx_map,0,PAGE_SIZE);
 	eni_dev->rx_mult = DEFAULT_RX_MULT;
 	eni_dev->fast = eni_dev->last_fast = NULL;
 	eni_dev->slow = eni_dev->last_slow = NULL;
diff -puN drivers/media/video/zoran_driver.c~get-rid-of-double-zeroing-of-allocated-pages drivers/media/video/zoran_driver.c
--- a/drivers/media/video/zoran_driver.c~get-rid-of-double-zeroing-of-allocated-pages
+++ a/drivers/media/video/zoran_driver.c
@@ -562,7 +562,6 @@ jpg_fbuffer_alloc (struct file *file)
 			jpg_fbuffer_free(file);
 			return -ENOBUFS;
 		}
-		memset((void *) mem, 0, PAGE_SIZE);
 		fh->jpg_buffers.buffer[i].frag_tab = (u32 *) mem;
 		fh->jpg_buffers.buffer[i].frag_tab_bus =
 		    virt_to_bus((void *) mem);
diff -puN drivers/scsi/53c7xx.c~get-rid-of-double-zeroing-of-allocated-pages drivers/scsi/53c7xx.c
--- a/drivers/scsi/53c7xx.c~get-rid-of-double-zeroing-of-allocated-pages
+++ a/drivers/scsi/53c7xx.c
@@ -3099,7 +3099,6 @@ allocate_cmd (Scsi_Cmnd *cmd) {
         real = get_zeroed_page(GFP_ATOMIC);
         if (real == 0)
         	return NULL;
-        memset((void *)real, 0, 4096);
         cache_push(virt_to_phys((void *)real), 4096);
         cache_clear(virt_to_phys((void *)real), 4096);
         kernel_set_cachemode((void *)real, 4096, IOMAP_NOCACHE_SER);
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
