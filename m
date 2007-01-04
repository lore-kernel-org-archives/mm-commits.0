From: akpm@osdl.org
Subject: + get-rid-of-double-zeroing-of-allocated-pages.patch added to -mm tree
Date: Thu, 04 Jan 2007 10:57:51 -0800
Message-ID: <200701041857.l04Ivprf027857@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43870 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932086AbXADS61 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 13:58:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, James.Bottomley@steeleye.com, chas@cmf.nrl.navy.mil, mchehab@infradead.org


The patch titled
     Get rid of "double zeroing" of allocated pages
has been added to the -mm tree.  Its filename is
     get-rid-of-double-zeroing-of-allocated-pages.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Get rid of "double zeroing" of allocated pages
From: "Robert P. J. Day" <rpjday@mindspring.com>

Simplify the few instances where a call to "get_zeroed_page()" is closely
followed by an unnecessary call to memset() to clear that page.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: chas williams <chas@cmf.nrl.navy.mil>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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

git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
simplify-some-code-to-use-the-container_of-macro.patch
get-rid-of-double-zeroing-of-allocated-pages.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
