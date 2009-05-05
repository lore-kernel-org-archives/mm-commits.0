From: akpm@linux-foundation.org
Subject: + mtd-remove-pmcmsp-ramrootc.patch added to -mm tree
Date: Tue, 05 May 2009 12:18:27 -0700
Message-ID: <200905051918.n45JIRPY001792@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491AbZEETUu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 15:20:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcdonald.shane@gmail.com, dwmw2@infradead.org


The patch titled
     mtd: remove pmcmsp-ramroot.c
has been added to the -mm tree.  Its filename is
     mtd-remove-pmcmsp-ramrootc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: remove pmcmsp-ramroot.c
From: Shane McDonald <mcdonald.shane@gmail.com>

The RAMROOT function was a successful but non-portable attempt to append
the root filesystem to the end of the kernel image.  The preferred and
portable solution is to use an initramfs instead.

The only user of this function was the msp71xx configuration in the MIPS
architecture; as the use of the RAMROOT has been removed from that
configuration, there are no more users, so this code can be removed.

Signed-off-by: Shane McDonald <mcdonald.shane@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/Kconfig          |    9 --
 drivers/mtd/maps/Makefile         |    1 
 drivers/mtd/maps/pmcmsp-ramroot.c |  104 ----------------------------
 3 files changed, 114 deletions(-)

diff -puN drivers/mtd/maps/Kconfig~mtd-remove-pmcmsp-ramrootc drivers/mtd/maps/Kconfig
--- a/drivers/mtd/maps/Kconfig~mtd-remove-pmcmsp-ramrootc
+++ a/drivers/mtd/maps/Kconfig
@@ -105,15 +105,6 @@ config MSP_FLASH_MAP_LIMIT
 	default "0x02000000"
 	depends on MSP_FLASH_MAP_LIMIT_32M
 
-config MTD_PMC_MSP_RAMROOT
-	tristate "Embedded RAM block device for root on PMC-Sierra MSP"
-	depends on PMC_MSP_EMBEDDED_ROOTFS && \
-			(MTD_BLOCK || MTD_BLOCK_RO) && \
-			MTD_RAM
-	help
-	  This provides support for the embedded root file system
-          on PMC MSP devices.  This memory is mapped as a MTD block device.
-
 config MTD_SUN_UFLASH
 	tristate "Sun Microsystems userflash support"
 	depends on SPARC && MTD_CFI && PCI
diff -puN drivers/mtd/maps/Makefile~mtd-remove-pmcmsp-ramrootc drivers/mtd/maps/Makefile
--- a/drivers/mtd/maps/Makefile~mtd-remove-pmcmsp-ramrootc
+++ a/drivers/mtd/maps/Makefile
@@ -25,7 +25,6 @@ obj-$(CONFIG_MTD_OCTAGON)	+= octagon-506
 obj-$(CONFIG_MTD_PHYSMAP)	+= physmap.o
 obj-$(CONFIG_MTD_PHYSMAP_OF)	+= physmap_of.o
 obj-$(CONFIG_MTD_PMC_MSP_EVM)   += pmcmsp-flash.o
-obj-$(CONFIG_MTD_PMC_MSP_RAMROOT)+= pmcmsp-ramroot.o
 obj-$(CONFIG_MTD_PCMCIA)	+= pcmciamtd.o
 obj-$(CONFIG_MTD_RPXLITE)	+= rpxlite.o
 obj-$(CONFIG_MTD_TQM8XXL)	+= tqm8xxl.o
diff -puN drivers/mtd/maps/pmcmsp-ramroot.c~mtd-remove-pmcmsp-ramrootc /dev/null
--- a/drivers/mtd/maps/pmcmsp-ramroot.c
+++ /dev/null
@@ -1,104 +0,0 @@
-/*
- * Mapping of the rootfs in a physical region of memory
- *
- * Copyright (C) 2005-2007 PMC-Sierra Inc.
- * Author: Andrew Hughes, Andrew_Hughes@pmc-sierra.com
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- *
- *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
- *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
- *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
- *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
- *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
- *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
- *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
- *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
- *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
- *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *  You should have received a copy of the  GNU General Public License along
- *  with this program; if not, write  to the Free Software Foundation, Inc.,
- *  675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/fs.h>
-#include <linux/root_dev.h>
-#include <linux/mtd/mtd.h>
-#include <linux/mtd/map.h>
-
-#include <asm/io.h>
-
-#include <msp_prom.h>
-
-static struct mtd_info *rr_mtd;
-
-struct map_info rr_map = {
-	.name = "ramroot",
-	.bankwidth = 4,
-};
-
-static int __init init_rrmap(void)
-{
-	void *ramroot_start;
-	unsigned long ramroot_size;
-
-	/* Check for supported rootfs types */
-	if (get_ramroot(&ramroot_start, &ramroot_size)) {
-		rr_map.phys = CPHYSADDR(ramroot_start);
-		rr_map.size = ramroot_size;
-
-		printk(KERN_NOTICE
-			"PMC embedded root device: 0x%08lx @ 0x%08lx\n",
-			rr_map.size, (unsigned long)rr_map.phys);
-	} else {
-		printk(KERN_ERR
-			"init_rrmap: no supported embedded rootfs detected!\n");
-		return -ENXIO;
-	}
-
-	/* Map rootfs to I/O space for block device driver */
-	rr_map.virt = ioremap(rr_map.phys, rr_map.size);
-	if (!rr_map.virt) {
-		printk(KERN_ERR "Failed to ioremap\n");
-		return -EIO;
-	}
-
-	simple_map_init(&rr_map);
-
-	rr_mtd = do_map_probe("map_ram", &rr_map);
-	if (rr_mtd) {
-		rr_mtd->owner = THIS_MODULE;
-
-		add_mtd_device(rr_mtd);
-
-		return 0;
-	}
-
-	iounmap(rr_map.virt);
-	return -ENXIO;
-}
-
-static void __exit cleanup_rrmap(void)
-{
-	del_mtd_device(rr_mtd);
-	map_destroy(rr_mtd);
-
-	iounmap(rr_map.virt);
-	rr_map.virt = NULL;
-}
-
-MODULE_AUTHOR("PMC-Sierra, Inc");
-MODULE_DESCRIPTION("MTD map driver for embedded PMC-Sierra MSP filesystem");
-MODULE_LICENSE("GPL");
