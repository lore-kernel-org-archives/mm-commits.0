From: akpm@osdl.org
Subject: + getting-rid-of-all-casts-of-kalloc-calls.patch added to -mm tree
Date: Sun, 10 Dec 2006 11:22:04 -0800
Message-ID: <200612101922.kBAJM4KY000681@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54170 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762410AbWLJTjL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 14:39:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, James.Bottomley@steeleye.com, alan@lxorguk.ukuu.org.uk, benh@kernel.crashing.org, davem@davemloft.net, dwmw2@infradead.org, geert@linux-m68k.org, greg@kroah.com, jdike@addtoit.com, jeff@garzik.org, jens.axboe@oracle.com, kkeil@suse.de, kyle@mcmartin.ca, mchehab@infradead.org, neilb@cse.unsw.edu.au, paulkf@microgate.com, paulus@samba.org, perex@suse.cz, ralf@linux-mips.org, raven@themaw.net, rmk@arm.linux.org.uk, schwidefsky@de.ibm.com, sfrench@us.ibm.com, spyro@f2s.com, starvik@axis.com, tiwai@suse.de, ysato@users.sourceforge.jp, zippel@linux-m68k.org


The patch titled
     getting rid of all casts of k[cmz]alloc() calls
has been added to the -mm tree.  Its filename is
     getting-rid-of-all-casts-of-kalloc-calls.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: getting rid of all casts of k[cmz]alloc() calls
From: "Robert P. J. Day" <rpjday@mindspring.com>

Run this:

============== cut here ==============
#!/bin/sh

for f in $(grep -Erl "\([^\)]*\) *k[cmz]alloc" *) ; do
  echo "De-casting $f..."
  perl -pi -e "s/ ?= ?\([^\)]*\) *(k[cmz]alloc) *\(/ = \1\(/" $f
done

And then drop a few hunks which conflicted with outstanding work.

Cc: Russell King <rmk@arm.linux.org.uk>, Ian Molton <spyro@f2s.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Greg KH <greg@kroah.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Paul Fulghum <paulkf@microgate.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Karsten Keil <kkeil@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Ian Kent <raven@themaw.net>
Cc: Steven French <sfrench@us.ibm.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/arm/kernel/apm.c                         |    2 +-
 arch/arm/kernel/ecard.c                       |    2 +-
 arch/arm26/kernel/ecard.c                     |    2 +-
 arch/arm26/kernel/irq.c                       |    2 +-
 arch/cris/arch-v10/drivers/axisflashmap.c     |    2 +-
 arch/cris/arch-v10/drivers/gpio.c             |    2 +-
 arch/cris/arch-v32/drivers/axisflashmap.c     |    2 +-
 arch/cris/arch-v32/drivers/gpio.c             |    2 +-
 arch/cris/arch-v32/kernel/signal.c            |    2 +-
 arch/cris/kernel/profile.c                    |    2 +-
 arch/h8300/kernel/ints.c                      |    2 +-
 arch/h8300/platform/h8s/ints.c                |    2 +-
 arch/i386/kernel/apm.c                        |    2 +-
 arch/ia64/sn/kernel/sn2/sn_hwperf.c           |    2 +-
 arch/m68k/mm/kmap.c                           |    2 +-
 arch/mips/au1000/common/dbdma.c               |    4 ++--
 arch/mips/kernel/apm.c                        |    2 +-
 arch/parisc/hpux/sys_hpux.c                   |    2 +-
 arch/parisc/kernel/unwind.c                   |    2 +-
 arch/powerpc/kernel/nvram_64.c                |    4 ++--
 arch/powerpc/kernel/pci_32.c                  |    2 +-
 arch/powerpc/mm/imalloc.c                     |    6 +++---
 arch/powerpc/platforms/pseries/eeh_cache.c    |    2 +-
 arch/ppc/8260_io/fcc_enet.c                   |    4 ++--
 arch/ppc/8xx_io/cs4218_tdm.c                  |    2 +-
 arch/s390/kernel/debug.c                      |    8 ++++----
 arch/s390/kernel/s390_ext.c                   |    2 +-
 arch/sparc/kernel/irq.c                       |    4 ++--
 arch/sparc/kernel/sun4d_irq.c                 |    4 ++--
 arch/sparc64/kernel/sys_sunos32.c             |    4 ++--
 arch/um/sys-i386/ldt.c                        |    4 ++--
 drivers/acorn/block/fd1772.c                  |    4 ++--
 drivers/atm/eni.c                             |    4 ++--
 drivers/atm/he.c                              |    2 +-
 drivers/atm/lanai.c                           |    2 +-
 drivers/atm/nicstar.c                         |    4 ++--
 drivers/atm/zatm.c                            |    4 ++--
 drivers/base/dmapool.c                        |    2 +-
 drivers/block/cciss.c                         |    2 +-
 drivers/block/cpqarray.c                      |   10 +++++-----
 drivers/cdrom/cdrom.c                         |    8 ++++----
 drivers/cdrom/cm206.c                         |    2 +-
 drivers/char/consolemap.c                     |    2 +-
 drivers/char/lcd.c                            |    2 +-
 drivers/char/lp.c                             |    2 +-
 drivers/char/pcmcia/synclink_cs.c             |    2 +-
 drivers/char/rio/riocmd.c                     |    2 +-
 drivers/char/synclink.c                       |    2 +-
 drivers/char/synclinkmp.c                     |    4 ++--
 drivers/char/vt.c                             |    2 +-
 drivers/char/vt_ioctl.c                       |    4 ++--
 drivers/fc4/fc.c                              |   10 +++++-----
 drivers/ide/ide-floppy.c                      |    2 +-
 drivers/ide/ide-tape.c                        |    8 ++++----
 drivers/isdn/act2000/act2000_isa.c            |    2 +-
 drivers/isdn/capi/capidrv.c                   |    2 +-
 drivers/isdn/divert/divert_procfs.c           |    2 +-
 drivers/isdn/divert/isdn_divert.c             |    6 +++---
 drivers/isdn/hysdn/hysdn_procconf.c           |    2 +-
 drivers/isdn/hysdn/hysdn_proclog.c            |    2 +-
 drivers/isdn/i4l/isdn_audio.c                 |    6 +++---
 drivers/isdn/i4l/isdn_net.c                   |    2 +-
 drivers/isdn/i4l/isdn_ppp.c                   |    2 +-
 drivers/isdn/pcbit/layer2.c                   |    2 +-
 drivers/macintosh/adb.c                       |    2 +-
 drivers/macintosh/apm_emu.c                   |    2 +-
 drivers/macintosh/via-pmu68k.c                |    2 +-
 drivers/media/dvb/bt8xx/dst_ca.c              |    2 +-
 drivers/media/dvb/bt8xx/dvb-bt8xx.c           |    2 +-
 drivers/media/dvb/ttusb-dec/ttusbdecfe.c      |    4 ++--
 drivers/media/video/dabusb.c                  |    4 ++--
 drivers/media/video/planb.c                   |    2 +-
 drivers/media/video/usbvideo/usbvideo.c       |    2 +-
 drivers/media/video/videocodec.c              |    2 +-
 drivers/message/i2o/i2o_config.c              |    4 ++--
 drivers/mtd/devices/mtd_dataflash.c           |    2 +-
 drivers/net/appletalk/ipddp.c                 |    2 +-
 drivers/net/bsd_comp.c                        |    2 +-
 drivers/net/irda/donauboe.c                   |    2 +-
 drivers/net/irda/irda-usb.c                   |    2 +-
 drivers/net/irda/irport.c                     |    2 +-
 drivers/net/lance.c                           |    2 +-
 drivers/net/lp486e.c                          |    4 ++--
 drivers/net/ppp_deflate.c                     |    4 ++--
 drivers/net/ppp_mppe.c                        |    2 +-
 drivers/net/sgiseeq.c                         |    4 ++--
 drivers/net/slip.c                            |    6 +++---
 drivers/net/wan/hostess_sv11.c                |    2 +-
 drivers/net/wan/pc300_drv.c                   |    2 +-
 drivers/net/wan/pc300_tty.c                   |    2 +-
 drivers/net/wan/x25_asy.c                     |    8 ++++----
 drivers/net/wireless/hostap/hostap_ap.c       |    2 +-
 drivers/net/wireless/hostap/hostap_download.c |    2 +-
 drivers/net/wireless/hostap/hostap_hw.c       |    2 +-
 drivers/net/wireless/hostap/hostap_ioctl.c    |    2 +-
 drivers/net/wireless/hostap/hostap_main.c     |    2 +-
 drivers/net/wireless/ipw2100.c                |    2 +-
 drivers/net/wireless/prism54/isl_ioctl.c      |    2 +-
 drivers/net/wireless/wavelan_cs.c             |    2 +-
 drivers/net/wireless/zd1211rw/zd_chip.c       |    2 +-
 drivers/parisc/iosapic.c                      |    4 ++--
 drivers/pci/hotplug/cpqphp_nvram.c            |    8 ++++----
 drivers/pci/hotplug/pciehp_hpc.c              |    2 +-
 drivers/pci/pcie/aer/aerdrv.c                 |    2 +-
 drivers/pci/rom.c                             |    2 +-
 drivers/pnp/pnpbios/core.c                    |    2 +-
 drivers/s390/char/con3215.c                   |    2 +-
 drivers/s390/char/keyboard.c                  |    2 +-
 drivers/s390/char/sclp_cpi.c                  |    2 +-
 drivers/s390/crypto/zcrypt_cex2a.c            |    4 ++--
 drivers/s390/crypto/zcrypt_pcica.c            |    4 ++--
 drivers/s390/crypto/zcrypt_pcixcc.c           |    2 +-
 drivers/s390/net/ctcmain.c                    |    6 +++---
 drivers/s390/net/iucv.c                       |    2 +-
 drivers/s390/scsi/zfcp_aux.c                  |    2 +-
 drivers/sbus/char/vfc_dev.c                   |    2 +-
 drivers/scsi/aacraid/aachba.c                 |    2 +-
 drivers/scsi/aacraid/comminit.c               |    2 +-
 drivers/scsi/aha1542.c                        |    2 +-
 drivers/scsi/aic7xxx_old.c                    |    2 +-
 drivers/scsi/dc395x.c                         |    2 +-
 drivers/scsi/dpt_i2o.c                        |   10 +++++-----
 drivers/scsi/initio.c                         |    2 +-
 drivers/scsi/osst.c                           |    2 +-
 drivers/scsi/pluto.c                          |    2 +-
 drivers/scsi/sr_ioctl.c                       |    2 +-
 drivers/scsi/sr_vendor.c                      |    4 ++--
 drivers/usb/gadget/serial.c                   |    2 +-
 drivers/usb/host/hc_crisv10.c                 |    2 +-
 drivers/usb/misc/auerswald.c                  |    4 ++--
 drivers/usb/serial/cypress_m8.c               |    2 +-
 drivers/usb/serial/digi_acceleport.c          |    4 ++--
 drivers/usb/serial/io_ti.c                    |    2 +-
 drivers/usb/serial/ipaq.c                     |    2 +-
 drivers/usb/serial/kobil_sct.c                |    4 ++--
 drivers/usb/serial/pl2303.c                   |    2 +-
 drivers/usb/serial/ti_usb_3410_5052.c         |    2 +-
 drivers/usb/serial/whiteheat.c                |    4 ++--
 drivers/usb/storage/sddr09.c                  |    2 +-
 drivers/video/amba-clcd.c                     |    2 +-
 drivers/video/matrox/i2c-matroxfb.c           |    2 +-
 drivers/video/matrox/matroxfb_base.c          |    2 +-
 drivers/video/matrox/matroxfb_crtc2.c         |    2 +-
 fs/autofs4/inode.c                            |    2 +-
 fs/befs/btree.c                               |    2 +-
 fs/befs/debug.c                               |    6 +++---
 fs/binfmt_misc.c                              |    2 +-
 fs/cifs/cifssmb.c                             |    2 +-
 fs/jffs/inode-v23.c                           |    4 ++--
 fs/jffs/intrep.c                              |   14 +++++++-------
 fs/jfs/jfs_dtree.c                            |    4 ++--
 fs/jfs/jfs_imap.c                             |    2 +-
 fs/lockd/svcshare.c                           |    2 +-
 fs/nfs/nfs4proc.c                             |    2 +-
 fs/reiserfs/xattr_acl.c                       |    2 +-
 include/asm-avr32/pgalloc.h                   |    2 +-
 include/asm-sh64/pgalloc.h                    |    2 +-
 include/linux/coda_linux.h                    |    2 +-
 ipc/msgutil.c                                 |    4 ++--
 net/tipc/config.c                             |    2 +-
 sound/core/oss/mixer_oss.c                    |    2 +-
 sound/oss/ad1848.c                            |    2 +-
 sound/oss/cs4232.c                            |    2 +-
 sound/oss/emu10k1/audio.c                     |    6 +++---
 sound/oss/emu10k1/cardmi.c                    |    2 +-
 sound/oss/emu10k1/cardmo.c                    |    2 +-
 sound/oss/emu10k1/midi.c                      |   10 +++++-----
 sound/oss/emu10k1/mixer.c                     |    2 +-
 sound/oss/hal2.c                              |    2 +-
 sound/oss/mpu401.c                            |    2 +-
 sound/oss/opl3.c                              |    2 +-
 sound/oss/sb_common.c                         |    2 +-
 sound/oss/sb_midi.c                           |    4 ++--
 sound/oss/sb_mixer.c                          |    2 +-
 sound/oss/v_midi.c                            |    2 +-
 sound/oss/waveartist.c                        |    2 +-
 176 files changed, 258 insertions(+), 258 deletions(-)

diff -puN arch/arm/kernel/apm.c~getting-rid-of-all-casts-of-kalloc-calls arch/arm/kernel/apm.c
--- a/arch/arm/kernel/apm.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/arm/kernel/apm.c
@@ -423,7 +423,7 @@ static int apm_open(struct inode * inode
 {
 	struct apm_user *as;
 
-	as = (struct apm_user *)kzalloc(sizeof(*as), GFP_KERNEL);
+	as = kzalloc(sizeof(*as), GFP_KERNEL);
 	if (as) {
 		/*
 		 * XXX - this is a tiny bit broken, when we consider BSD
diff -puN arch/arm/kernel/ecard.c~getting-rid-of-all-casts-of-kalloc-calls arch/arm/kernel/ecard.c
--- a/arch/arm/kernel/ecard.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/arm/kernel/ecard.c
@@ -353,7 +353,7 @@ int ecard_readchunk(struct in_chunk_dir 
 		}
 		if (c_id(&excd) == 0x80) { /* loader */
 			if (!ec->loader) {
-				ec->loader = (loader_t)kmalloc(c_len(&excd),
+				ec->loader = kmalloc(c_len(&excd),
 							       GFP_KERNEL);
 				if (ec->loader)
 					ecard_readbytes(ec->loader, ec,
diff -puN arch/arm26/kernel/ecard.c~getting-rid-of-all-casts-of-kalloc-calls arch/arm26/kernel/ecard.c
--- a/arch/arm26/kernel/ecard.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/arm26/kernel/ecard.c
@@ -215,7 +215,7 @@ int ecard_readchunk(struct in_chunk_dir 
 		}
 		if (c_id(&excd) == 0x80) { /* loader */
 			if (!ec->loader) {
-				ec->loader = (loader_t)kmalloc(c_len(&excd),
+				ec->loader = kmalloc(c_len(&excd),
 							       GFP_KERNEL);
 				if (ec->loader)
 					ecard_readbytes(ec->loader, ec,
diff -puN arch/arm26/kernel/irq.c~getting-rid-of-all-casts-of-kalloc-calls arch/arm26/kernel/irq.c
--- a/arch/arm26/kernel/irq.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/arm26/kernel/irq.c
@@ -545,7 +545,7 @@ int request_irq(unsigned int irq, irqret
 	    (irq_flags & IRQF_SHARED && !dev_id))
 		return -EINVAL;
 
-	action = (struct irqaction *)kmalloc(sizeof(struct irqaction), GFP_KERNEL);
+	action = kmalloc(sizeof(struct irqaction), GFP_KERNEL);
 	if (!action)
 		return -ENOMEM;
 
diff -puN arch/cris/arch-v10/drivers/axisflashmap.c~getting-rid-of-all-casts-of-kalloc-calls arch/cris/arch-v10/drivers/axisflashmap.c
--- a/arch/cris/arch-v10/drivers/axisflashmap.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/cris/arch-v10/drivers/axisflashmap.c
@@ -516,7 +516,7 @@ static int __init init_axis_flash(void)
 #else
 		struct mtd_info *mtd_ram;
 
-		mtd_ram = (struct mtd_info *)kmalloc(sizeof(struct mtd_info),
+		mtd_ram = kmalloc(sizeof(struct mtd_info),
 						     GFP_KERNEL);
 		if (!mtd_ram) {
 			panic("axisflashmap couldn't allocate memory for "
diff -puN arch/cris/arch-v10/drivers/gpio.c~getting-rid-of-all-casts-of-kalloc-calls arch/cris/arch-v10/drivers/gpio.c
--- a/arch/cris/arch-v10/drivers/gpio.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/cris/arch-v10/drivers/gpio.c
@@ -440,7 +440,7 @@ gpio_open(struct inode *inode, struct fi
 	if (p > GPIO_MINOR_LAST)
 		return -EINVAL;
 
-	priv = (struct gpio_private *)kmalloc(sizeof(struct gpio_private), 
+	priv = kmalloc(sizeof(struct gpio_private),
 					      GFP_KERNEL);
 
 	if (!priv)
diff -puN arch/cris/arch-v32/drivers/axisflashmap.c~getting-rid-of-all-casts-of-kalloc-calls arch/cris/arch-v32/drivers/axisflashmap.c
--- a/arch/cris/arch-v32/drivers/axisflashmap.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/cris/arch-v32/drivers/axisflashmap.c
@@ -427,7 +427,7 @@ static int __init init_axis_flash(void)
 #else
 		struct mtd_info *mtd_ram;
 
-		mtd_ram = (struct mtd_info *)kmalloc(sizeof(struct mtd_info),
+		mtd_ram = kmalloc(sizeof(struct mtd_info),
 						     GFP_KERNEL);
 		if (!mtd_ram) {
 			panic("axisflashmap couldn't allocate memory for "
diff -puN arch/cris/arch-v32/drivers/gpio.c~getting-rid-of-all-casts-of-kalloc-calls arch/cris/arch-v32/drivers/gpio.c
--- a/arch/cris/arch-v32/drivers/gpio.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/cris/arch-v32/drivers/gpio.c
@@ -423,7 +423,7 @@ gpio_open(struct inode *inode, struct fi
 	if (p > GPIO_MINOR_LAST)
 		return -EINVAL;
 
-	priv = (struct gpio_private *)kmalloc(sizeof(struct gpio_private),
+	priv = kmalloc(sizeof(struct gpio_private),
 					      GFP_KERNEL);
 
 	if (!priv)
diff -puN arch/cris/arch-v32/kernel/signal.c~getting-rid-of-all-casts-of-kalloc-calls arch/cris/arch-v32/kernel/signal.c
--- a/arch/cris/arch-v32/kernel/signal.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/cris/arch-v32/kernel/signal.c
@@ -686,7 +686,7 @@ keep_debug_flags(unsigned long oldccs, u
 int __init
 cris_init_signal(void)
 {
-	u16* data = (u16*)kmalloc(PAGE_SIZE, GFP_KERNEL);
+	u16* data = kmalloc(PAGE_SIZE, GFP_KERNEL);
 
 	/* This is movu.w __NR_sigreturn, r9; break 13; */
 	data[0] = 0x9c5f;
diff -puN arch/cris/kernel/profile.c~getting-rid-of-all-casts-of-kalloc-calls arch/cris/kernel/profile.c
--- a/arch/cris/kernel/profile.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/cris/kernel/profile.c
@@ -59,7 +59,7 @@ static int
 __init init_cris_profile(void)
 {
   struct proc_dir_entry *entry;
-  sample_buffer = (char*)kmalloc(SAMPLE_BUFFER_SIZE, GFP_KERNEL);
+  sample_buffer = kmalloc(SAMPLE_BUFFER_SIZE, GFP_KERNEL);
   sample_buffer_pos = sample_buffer;
   entry = create_proc_entry("system_profile", S_IWUSR | S_IRUGO, NULL);
   if (entry) {
diff -puN arch/h8300/kernel/ints.c~getting-rid-of-all-casts-of-kalloc-calls arch/h8300/kernel/ints.c
--- a/arch/h8300/kernel/ints.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/h8300/kernel/ints.c
@@ -141,7 +141,7 @@ int request_irq(unsigned int irq, 
 		return -EBUSY;
 
 	if (use_kmalloc)
-		irq_handle = (irq_handler_t *)kmalloc(sizeof(irq_handler_t), GFP_ATOMIC);
+		irq_handle = kmalloc(sizeof(irq_handler_t), GFP_ATOMIC);
 	else {
 		/* use bootmem allocater */
 		irq_handle = (irq_handler_t *)alloc_bootmem(sizeof(irq_handler_t));
diff -puN arch/h8300/platform/h8s/ints.c~getting-rid-of-all-casts-of-kalloc-calls arch/h8300/platform/h8s/ints.c
--- a/arch/h8300/platform/h8s/ints.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/h8300/platform/h8s/ints.c
@@ -176,7 +176,7 @@ int request_irq(unsigned int irq,
 	}		
 
 	if (use_kmalloc)
-		irq_handle = (irq_handler_t *)kmalloc(sizeof(irq_handler_t), GFP_ATOMIC);
+		irq_handle = kmalloc(sizeof(irq_handler_t), GFP_ATOMIC);
 	else {
 		/* use bootmem allocater */
 		irq_handle = (irq_handler_t *)alloc_bootmem(sizeof(irq_handler_t));
diff -puN arch/i386/kernel/apm.c~getting-rid-of-all-casts-of-kalloc-calls arch/i386/kernel/apm.c
--- a/arch/i386/kernel/apm.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/i386/kernel/apm.c
@@ -1560,7 +1560,7 @@ static int do_open(struct inode * inode,
 {
 	struct apm_user *	as;
 
-	as = (struct apm_user *)kmalloc(sizeof(*as), GFP_KERNEL);
+	as = kmalloc(sizeof(*as), GFP_KERNEL);
 	if (as == NULL) {
 		printk(KERN_ERR "apm: cannot allocate struct of size %d bytes\n",
 		       sizeof(*as));
diff -puN arch/ia64/sn/kernel/sn2/sn_hwperf.c~getting-rid-of-all-casts-of-kalloc-calls arch/ia64/sn/kernel/sn2/sn_hwperf.c
--- a/arch/ia64/sn/kernel/sn2/sn_hwperf.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/ia64/sn/kernel/sn2/sn_hwperf.c
@@ -189,7 +189,7 @@ static void print_pci_topology(struct se
 	int e;
 
 	for (sz = PAGE_SIZE; sz < 16 * PAGE_SIZE; sz += PAGE_SIZE) {
-		if (!(p = (char *)kmalloc(sz, GFP_KERNEL)))
+		if (!(p = kmalloc(sz, GFP_KERNEL)))
 			break;
 		e = ia64_sn_ioif_get_pci_topology(__pa(p), sz);
 		if (e == SALRET_OK)
diff -puN arch/m68k/mm/kmap.c~getting-rid-of-all-casts-of-kalloc-calls arch/m68k/mm/kmap.c
--- a/arch/m68k/mm/kmap.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/m68k/mm/kmap.c
@@ -59,7 +59,7 @@ static struct vm_struct *get_io_area(uns
 	unsigned long addr;
 	struct vm_struct **p, *tmp, *area;
 
-	area = (struct vm_struct *)kmalloc(sizeof(*area), GFP_KERNEL);
+	area = kmalloc(sizeof(*area), GFP_KERNEL);
 	if (!area)
 		return NULL;
 	addr = KMAP_START;
diff -puN arch/mips/au1000/common/dbdma.c~getting-rid-of-all-casts-of-kalloc-calls arch/mips/au1000/common/dbdma.c
--- a/arch/mips/au1000/common/dbdma.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/mips/au1000/common/dbdma.c
@@ -396,7 +396,7 @@ au1xxx_dbdma_ring_alloc(u32 chanid, int 
 	 * and if we try that first we are likely to not waste larger
 	 * slabs of memory.
 	 */
-	desc_base = (u32)kmalloc(entries * sizeof(au1x_ddma_desc_t),
+	desc_base = kmalloc(entries * sizeof(au1x_ddma_desc_t),
 			GFP_KERNEL|GFP_DMA);
 	if (desc_base == 0)
 		return 0;
@@ -408,7 +408,7 @@ au1xxx_dbdma_ring_alloc(u32 chanid, int 
 		kfree((const void *)desc_base);
 		i = entries * sizeof(au1x_ddma_desc_t);
 		i += (sizeof(au1x_ddma_desc_t) - 1);
-		if ((desc_base = (u32)kmalloc(i, GFP_KERNEL|GFP_DMA)) == 0)
+		if ((desc_base = kmalloc(i, GFP_KERNEL|GFP_DMA)) == 0)
 			return 0;
 
 		desc_base = ALIGN_ADDR(desc_base, sizeof(au1x_ddma_desc_t));
diff -puN arch/mips/kernel/apm.c~getting-rid-of-all-casts-of-kalloc-calls arch/mips/kernel/apm.c
--- a/arch/mips/kernel/apm.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/mips/kernel/apm.c
@@ -356,7 +356,7 @@ static int apm_open(struct inode * inode
 {
 	struct apm_user *as;
 
-	as = (struct apm_user *)kzalloc(sizeof(*as), GFP_KERNEL);
+	as = kzalloc(sizeof(*as), GFP_KERNEL);
 	if (as) {
 		/*
 		 * XXX - this is a tiny bit broken, when we consider BSD
diff -puN arch/parisc/hpux/sys_hpux.c~getting-rid-of-all-casts-of-kalloc-calls arch/parisc/hpux/sys_hpux.c
--- a/arch/parisc/hpux/sys_hpux.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/parisc/hpux/sys_hpux.c
@@ -475,7 +475,7 @@ int hpux_sysfs(int opcode, unsigned long
 		printk(KERN_DEBUG "len of arg1 = %d\n", len);
 		if (len == 0)
 			return 0;
-		fsname = (char *) kmalloc(len, GFP_KERNEL);
+		fsname = kmalloc(len, GFP_KERNEL);
 		if ( !fsname ) {
 			printk(KERN_DEBUG "failed to kmalloc fsname\n");
 			return 0;
diff -puN arch/parisc/kernel/unwind.c~getting-rid-of-all-casts-of-kalloc-calls arch/parisc/kernel/unwind.c
--- a/arch/parisc/kernel/unwind.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/parisc/kernel/unwind.c
@@ -343,7 +343,7 @@ void unwind_frame_init_from_blocked_task
 	struct pt_regs *r = &t->thread.regs;
 	struct pt_regs *r2;
 
-	r2 = (struct pt_regs *)kmalloc(sizeof(struct pt_regs), GFP_KERNEL);
+	r2 = kmalloc(sizeof(struct pt_regs), GFP_KERNEL);
 	if (!r2)
 		return;
 	*r2 = *r;
diff -puN arch/powerpc/kernel/nvram_64.c~getting-rid-of-all-casts-of-kalloc-calls arch/powerpc/kernel/nvram_64.c
--- a/arch/powerpc/kernel/nvram_64.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/powerpc/kernel/nvram_64.c
@@ -505,7 +505,7 @@ static int nvram_scan_partitions(void)
 		return -ENODEV;
 	total_size = ppc_md.nvram_size();
 	
-	header = (char *) kmalloc(NVRAM_HEADER_LEN, GFP_KERNEL);
+	header = kmalloc(NVRAM_HEADER_LEN, GFP_KERNEL);
 	if (!header) {
 		printk(KERN_ERR "nvram_scan_partitions: Failed kmalloc\n");
 		return -ENOMEM;
@@ -574,7 +574,7 @@ static int __init nvram_init(void)
 	}
   	
   	/* initialize our anchor for the nvram partition list */
-  	nvram_part = (struct nvram_partition *) kmalloc(sizeof(struct nvram_partition), GFP_KERNEL);
+  	nvram_part = kmalloc(sizeof(struct nvram_partition), GFP_KERNEL);
   	if (!nvram_part) {
   		printk(KERN_ERR "nvram_init: Failed kmalloc\n");
   		return -ENOMEM;
diff -puN arch/powerpc/kernel/pci_32.c~getting-rid-of-all-casts-of-kalloc-calls arch/powerpc/kernel/pci_32.c
--- a/arch/powerpc/kernel/pci_32.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/powerpc/kernel/pci_32.c
@@ -670,7 +670,7 @@ pcibios_make_OF_bus_map(void)
 	struct pci_controller* hose;
 	struct property *map_prop;
 
-	pci_to_OF_bus_map = (u8*)kmalloc(pci_bus_count, GFP_KERNEL);
+	pci_to_OF_bus_map = kmalloc(pci_bus_count, GFP_KERNEL);
 	if (!pci_to_OF_bus_map) {
 		printk(KERN_ERR "Can't allocate OF bus map !\n");
 		return;
diff -puN arch/powerpc/mm/imalloc.c~getting-rid-of-all-casts-of-kalloc-calls arch/powerpc/mm/imalloc.c
--- a/arch/powerpc/mm/imalloc.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/powerpc/mm/imalloc.c
@@ -138,7 +138,7 @@ static struct vm_struct * split_im_regio
 	struct vm_struct *vm2 = NULL;
 	struct vm_struct *new_vm = NULL;
 	
-	vm1 = (struct vm_struct *) kmalloc(sizeof(*vm1), GFP_KERNEL);
+	vm1 = kmalloc(sizeof(*vm1), GFP_KERNEL);
 	if (vm1	== NULL) {
 		printk(KERN_ERR "%s() out of memory\n", __FUNCTION__);
 		return NULL;
@@ -172,7 +172,7 @@ static struct vm_struct * split_im_regio
 		 * uppermost remainder, and use existing parent one for the
 		 * lower remainder of parent range
 		 */
-		vm2 = (struct vm_struct *) kmalloc(sizeof(*vm2), GFP_KERNEL);
+		vm2 = kmalloc(sizeof(*vm2), GFP_KERNEL);
 		if (vm2 == NULL) {
 			printk(KERN_ERR "%s() out of memory\n", __FUNCTION__);
 			kfree(vm1);
@@ -206,7 +206,7 @@ static struct vm_struct * __add_new_im_a
 			break;
 	}
 	
-	area = (struct vm_struct *) kmalloc(sizeof(*area), GFP_KERNEL);
+	area = kmalloc(sizeof(*area), GFP_KERNEL);
 	if (!area)
 		return NULL;
 	area->flags = 0;
diff -puN arch/powerpc/platforms/pseries/eeh_cache.c~getting-rid-of-all-casts-of-kalloc-calls arch/powerpc/platforms/pseries/eeh_cache.c
--- a/arch/powerpc/platforms/pseries/eeh_cache.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/powerpc/platforms/pseries/eeh_cache.c
@@ -153,7 +153,7 @@ pci_addr_cache_insert(struct pci_dev *de
 			return piar;
 		}
 	}
-	piar = (struct pci_io_addr_range *)kmalloc(sizeof(struct pci_io_addr_range), GFP_ATOMIC);
+	piar = kmalloc(sizeof(struct pci_io_addr_range), GFP_ATOMIC);
 	if (!piar)
 		return NULL;
 
diff -puN arch/ppc/8260_io/fcc_enet.c~getting-rid-of-all-casts-of-kalloc-calls arch/ppc/8260_io/fcc_enet.c
--- a/arch/ppc/8260_io/fcc_enet.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/ppc/8260_io/fcc_enet.c
@@ -1892,10 +1892,10 @@ init_fcc_param(fcc_info_t *fip, struct n
 	/* Allocate space for the buffer descriptors from regular memory.
 	 * Initialize base addresses for the buffer descriptors.
 	 */
-	cep->rx_bd_base = (cbd_t *)kmalloc(sizeof(cbd_t) * RX_RING_SIZE,
+	cep->rx_bd_base = kmalloc(sizeof(cbd_t) * RX_RING_SIZE,
 			GFP_KERNEL | GFP_DMA);
 	ep->fen_genfcc.fcc_rbase = __pa(cep->rx_bd_base);
-	cep->tx_bd_base = (cbd_t *)kmalloc(sizeof(cbd_t) * TX_RING_SIZE,
+	cep->tx_bd_base = kmalloc(sizeof(cbd_t) * TX_RING_SIZE,
 			GFP_KERNEL | GFP_DMA);
 	ep->fen_genfcc.fcc_tbase = __pa(cep->tx_bd_base);
 
diff -puN arch/ppc/8xx_io/cs4218_tdm.c~getting-rid-of-all-casts-of-kalloc-calls arch/ppc/8xx_io/cs4218_tdm.c
--- a/arch/ppc/8xx_io/cs4218_tdm.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/ppc/8xx_io/cs4218_tdm.c
@@ -2600,7 +2600,7 @@ int __init tdm8xx_sound_init(void)
 	/* Initialize beep stuff */
 	orig_mksound = kd_mksound;
 	kd_mksound = cs_mksound;
-	beep_buf = (short *) kmalloc(BEEP_BUFLEN * 4, GFP_KERNEL);
+	beep_buf = kmalloc(BEEP_BUFLEN * 4, GFP_KERNEL);
 	if (beep_buf == NULL)
 		printk(KERN_WARNING "dmasound: no memory for "
 		       "beep buffer\n");
diff -puN arch/s390/kernel/debug.c~getting-rid-of-all-casts-of-kalloc-calls arch/s390/kernel/debug.c
--- a/arch/s390/kernel/debug.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/s390/kernel/debug.c
@@ -191,13 +191,13 @@ debug_areas_alloc(int pages_per_area, in
 	debug_entry_t*** areas;
 	int i,j;
 
-	areas = (debug_entry_t ***) kmalloc(nr_areas *
+	areas = kmalloc(nr_areas *
 					sizeof(debug_entry_t**),
 					GFP_KERNEL);
 	if (!areas)
 		goto fail_malloc_areas;
 	for (i = 0; i < nr_areas; i++) {
-		areas[i] = (debug_entry_t**) kmalloc(pages_per_area *
+		areas[i] = kmalloc(pages_per_area *
 				sizeof(debug_entry_t*),GFP_KERNEL);
 		if (!areas[i]) {
 			goto fail_malloc_areas2;
@@ -242,7 +242,7 @@ debug_info_alloc(char *name, int pages_p
 
 	/* alloc everything */
 
-	rc = (debug_info_t*) kmalloc(sizeof(debug_info_t), GFP_KERNEL);
+	rc = kmalloc(sizeof(debug_info_t), GFP_KERNEL);
 	if(!rc)
 		goto fail_malloc_rc;
 	rc->active_entries = kcalloc(nr_areas, sizeof(int), GFP_KERNEL);
@@ -634,7 +634,7 @@ found:
 		rc = -ENOMEM;
 		goto out;
 	}
-	p_info = (file_private_info_t *) kmalloc(sizeof(file_private_info_t),
+	p_info = kmalloc(sizeof(file_private_info_t),
 						GFP_KERNEL);
 	if(!p_info){
 		if(debug_info_snapshot)
diff -puN arch/s390/kernel/s390_ext.c~getting-rid-of-all-casts-of-kalloc-calls arch/s390/kernel/s390_ext.c
--- a/arch/s390/kernel/s390_ext.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/s390/kernel/s390_ext.c
@@ -37,7 +37,7 @@ int register_external_interrupt(__u16 co
         ext_int_info_t *p;
         int index;
 
-	p = (ext_int_info_t *) kmalloc(sizeof(ext_int_info_t), GFP_ATOMIC);
+	p = kmalloc(sizeof(ext_int_info_t), GFP_ATOMIC);
         if (p == NULL)
                 return -ENOMEM;
         p->code = code;
diff -puN arch/sparc/kernel/irq.c~getting-rid-of-all-casts-of-kalloc-calls arch/sparc/kernel/irq.c
--- a/arch/sparc/kernel/irq.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/sparc/kernel/irq.c
@@ -425,7 +425,7 @@ int request_fast_irq(unsigned int irq,
 	}
 	
 	if (action == NULL)
-	    action = (struct irqaction *)kmalloc(sizeof(struct irqaction),
+	    action = kmalloc(sizeof(struct irqaction),
 						 GFP_ATOMIC);
 	
 	if (!action) { 
@@ -528,7 +528,7 @@ int request_irq(unsigned int irq,
 	}
 	
 	if (action == NULL)
-		action = (struct irqaction *)kmalloc(sizeof(struct irqaction),
+		action = kmalloc(sizeof(struct irqaction),
 						     GFP_ATOMIC);
 	
 	if (!action) { 
diff -puN arch/sparc/kernel/sun4d_irq.c~getting-rid-of-all-casts-of-kalloc-calls arch/sparc/kernel/sun4d_irq.c
--- a/arch/sparc/kernel/sun4d_irq.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/sparc/kernel/sun4d_irq.c
@@ -327,7 +327,7 @@ int sun4d_request_irq(unsigned int irq,
 	}
 	
 	if (action == NULL)
-		action = (struct irqaction *)kmalloc(sizeof(struct irqaction),
+		action = kmalloc(sizeof(struct irqaction),
 						     GFP_ATOMIC);
 	
 	if (!action) { 
@@ -545,7 +545,7 @@ void __init sun4d_init_sbi_irq(void)
 	nsbi = 0;
 	for_each_sbus(sbus)
 		nsbi++;
-	sbus_actions = (struct sbus_action *)kmalloc (nsbi * 8 * 4 * sizeof(struct sbus_action), GFP_ATOMIC);
+	sbus_actions = kmalloc(nsbi * 8 * 4 * sizeof(struct sbus_action), GFP_ATOMIC);
 	memset (sbus_actions, 0, (nsbi * 8 * 4 * sizeof(struct sbus_action)));
 	for_each_sbus(sbus) {
 #ifdef CONFIG_SMP	
diff -puN arch/sparc64/kernel/sys_sunos32.c~getting-rid-of-all-casts-of-kalloc-calls arch/sparc64/kernel/sys_sunos32.c
--- a/arch/sparc64/kernel/sys_sunos32.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/sparc64/kernel/sys_sunos32.c
@@ -1055,7 +1055,7 @@ asmlinkage int sunos_msgsys(int op, u32 
 		break;
 	case 2:
 		rval = -EFAULT;
-		kmbuf = (struct msgbuf *)kmalloc(sizeof(struct msgbuf) + arg3,
+		kmbuf = kmalloc(sizeof(struct msgbuf) + arg3,
 						 GFP_KERNEL);
 		if (!kmbuf)
 			break;
@@ -1078,7 +1078,7 @@ asmlinkage int sunos_msgsys(int op, u32 
 		break;
 	case 3:
 		rval = -EFAULT;
-		kmbuf = (struct msgbuf *)kmalloc(sizeof(struct msgbuf) + arg3,
+		kmbuf = kmalloc(sizeof(struct msgbuf) + arg3,
 						 GFP_KERNEL);
 		if (!kmbuf || sunos_msgbuf_get((struct msgbuf32 __user *)(unsigned long)arg2,
 					       kmbuf, arg3))
diff -puN arch/um/sys-i386/ldt.c~getting-rid-of-all-casts-of-kalloc-calls arch/um/sys-i386/ldt.c
--- a/arch/um/sys-i386/ldt.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/arch/um/sys-i386/ldt.c
@@ -166,7 +166,7 @@ static long read_ldt_from_host(void __us
 	struct ptrace_ldt ptrace_ldt = (struct ptrace_ldt) {
 			.func = 0,
 			.bytecount = bytecount,
-			.ptr = (void *)kmalloc(bytecount, GFP_KERNEL)};
+			.ptr = kmalloc(bytecount, GFP_KERNEL)};
 	u32 cpu;
 
 	if(ptrace_ldt.ptr == NULL)
@@ -426,7 +426,7 @@ void ldt_get_host_info(void)
 		host_ldt_entries = dummy_list;
 	else {
 		size = (size + 1) * sizeof(dummy_list[0]);
-		host_ldt_entries = (short *)kmalloc(size, GFP_KERNEL);
+		host_ldt_entries = kmalloc(size, GFP_KERNEL);
 		if(host_ldt_entries == NULL) {
 			printk("ldt_get_host_info: couldn't allocate host ldt list\n");
 			goto out_free;
diff -puN drivers/acorn/block/fd1772.c~getting-rid-of-all-casts-of-kalloc-calls drivers/acorn/block/fd1772.c
--- a/drivers/acorn/block/fd1772.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/acorn/block/fd1772.c
@@ -1549,12 +1549,12 @@ int fd1772_init(void)
 #ifdef TRACKBUFFER
 	BufferDrive = BufferSide = BufferTrack = -1;
 	/* Atari uses 512 - I want to eventually cope with 1K sectors */
-	DMABuffer = (char *)kmalloc((FD1772_MAX_SECTORS+1)*512,GFP_KERNEL);
+	DMABuffer = kmalloc((FD1772_MAX_SECTORS+1)*512,GFP_KERNEL);
 	TrackBuffer = DMABuffer + 512;
 #else
 	/* Allocate memory for the DMAbuffer - on the Atari this takes it
 	   out of some special memory... */
-	DMABuffer = (char *) kmalloc(2048);	/* Copes with pretty large sectors */
+	DMABuffer = kmalloc(2048);	/* Copes with pretty large sectors */
 #endif
 	err = -ENOMEM;
 	if (!DMAbuffer)
diff -puN drivers/atm/eni.c~getting-rid-of-all-casts-of-kalloc-calls drivers/atm/eni.c
--- a/drivers/atm/eni.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/atm/eni.c
@@ -1832,7 +1832,7 @@ static int __devinit eni_start(struct at
 	/* initialize memory management */
 	buffer_mem = eni_dev->mem - (buf - eni_dev->ram);
 	eni_dev->free_list_size = buffer_mem/MID_MIN_BUF_SIZE/2;
-	eni_dev->free_list = (struct eni_free *) kmalloc(
+	eni_dev->free_list = kmalloc(
 	    sizeof(struct eni_free)*(eni_dev->free_list_size+1),GFP_KERNEL);
 	if (!eni_dev->free_list) {
 		printk(KERN_ERR DEV_LABEL "(itf %d): couldn't get free page\n",
@@ -2232,7 +2232,7 @@ static int __devinit eni_init_one(struct
 		goto out0;
 	}
 
-	eni_dev = (struct eni_dev *) kmalloc(sizeof(struct eni_dev),GFP_KERNEL);
+	eni_dev = kmalloc(sizeof(struct eni_dev),GFP_KERNEL);
 	if (!eni_dev) goto out0;
 	if (!cpu_zeroes) {
 		cpu_zeroes = pci_alloc_consistent(pci_dev,ENI_ZEROES_SIZE,
diff -puN drivers/atm/he.c~getting-rid-of-all-casts-of-kalloc-calls drivers/atm/he.c
--- a/drivers/atm/he.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/atm/he.c
@@ -2351,7 +2351,7 @@ he_open(struct atm_vcc *vcc)
 
 	cid = he_mkcid(he_dev, vpi, vci);
 
-	he_vcc = (struct he_vcc *) kmalloc(sizeof(struct he_vcc), GFP_ATOMIC);
+	he_vcc = kmalloc(sizeof(struct he_vcc), GFP_ATOMIC);
 	if (he_vcc == NULL) {
 		hprintk("unable to allocate he_vcc during open\n");
 		return -ENOMEM;
diff -puN drivers/atm/lanai.c~getting-rid-of-all-casts-of-kalloc-calls drivers/atm/lanai.c
--- a/drivers/atm/lanai.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/atm/lanai.c
@@ -2602,7 +2602,7 @@ static int __devinit lanai_init_one(stru
 	struct atm_dev *atmdev;
 	int result;
 
-	lanai = (struct lanai_dev *) kmalloc(sizeof(*lanai), GFP_KERNEL);
+	lanai = kmalloc(sizeof(*lanai), GFP_KERNEL);
 	if (lanai == NULL) {
 		printk(KERN_ERR DEV_LABEL
 		       ": couldn't allocate dev_data structure!\n");
diff -puN drivers/atm/nicstar.c~getting-rid-of-all-casts-of-kalloc-calls drivers/atm/nicstar.c
--- a/drivers/atm/nicstar.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/atm/nicstar.c
@@ -997,7 +997,7 @@ static scq_info *get_scq(int size, u32 s
    if (size != VBR_SCQSIZE && size != CBR_SCQSIZE)
       return NULL;
 
-   scq = (scq_info *) kmalloc(sizeof(scq_info), GFP_KERNEL);
+   scq = kmalloc(sizeof(scq_info), GFP_KERNEL);
    if (scq == NULL)
       return NULL;
    scq->org = kmalloc(2 * size, GFP_KERNEL);
@@ -1006,7 +1006,7 @@ static scq_info *get_scq(int size, u32 s
       kfree(scq);
       return NULL;
    }
-   scq->skb = (struct sk_buff **) kmalloc(sizeof(struct sk_buff *) *
+   scq->skb = kmalloc(sizeof(struct sk_buff *) *
                                           (size / NS_SCQE_SIZE), GFP_KERNEL);
    if (scq->skb == NULL)
    {
diff -puN drivers/atm/zatm.c~getting-rid-of-all-casts-of-kalloc-calls drivers/atm/zatm.c
--- a/drivers/atm/zatm.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/atm/zatm.c
@@ -996,7 +996,7 @@ static int start_tx(struct atm_dev *dev)
 
 	DPRINTK("start_tx\n");
 	zatm_dev = ZATM_DEV(dev);
-	zatm_dev->tx_map = (struct atm_vcc **) kmalloc(sizeof(struct atm_vcc *)*
+	zatm_dev->tx_map = kmalloc(sizeof(struct atm_vcc *)*
 	    zatm_dev->chans,GFP_KERNEL);
 	if (!zatm_dev->tx_map) return -ENOMEM;
 	zatm_dev->tx_bw = ATM_OC3_PCR;
@@ -1591,7 +1591,7 @@ static int __devinit zatm_init_one(struc
 	struct zatm_dev *zatm_dev;
 	int ret = -ENOMEM;
 
-	zatm_dev = (struct zatm_dev *) kmalloc(sizeof(*zatm_dev), GFP_KERNEL);
+	zatm_dev = kmalloc(sizeof(*zatm_dev), GFP_KERNEL);
 	if (!zatm_dev) {
 		printk(KERN_EMERG "%s: memory shortage\n", DEV_LABEL);
 		goto out;
diff -puN drivers/base/dmapool.c~getting-rid-of-all-casts-of-kalloc-calls drivers/base/dmapool.c
--- a/drivers/base/dmapool.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/base/dmapool.c
@@ -173,7 +173,7 @@ pool_alloc_page (struct dma_pool *pool, 
 	mapsize = (mapsize + BITS_PER_LONG - 1) / BITS_PER_LONG;
 	mapsize *= sizeof (long);
 
-	page = (struct dma_page *) kmalloc (mapsize + sizeof *page, mem_flags);
+	page = kmalloc(mapsize + sizeof *page, mem_flags);
 	if (!page)
 		return NULL;
 	page->vaddr = dma_alloc_coherent (pool->dev,
diff -puN drivers/block/cciss.c~getting-rid-of-all-casts-of-kalloc-calls drivers/block/cciss.c
--- a/drivers/block/cciss.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/block/cciss.c
@@ -1039,7 +1039,7 @@ static int cciss_ioctl(struct inode *ino
 				status = -ENOMEM;
 				goto cleanup1;
 			}
-			buff_size = (int *)kmalloc(MAXSGENTRIES * sizeof(int),
+			buff_size = kmalloc(MAXSGENTRIES * sizeof(int),
 						   GFP_KERNEL);
 			if (!buff_size) {
 				status = -ENOMEM;
diff -puN drivers/block/cpqarray.c~getting-rid-of-all-casts-of-kalloc-calls drivers/block/cpqarray.c
--- a/drivers/block/cpqarray.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/block/cpqarray.c
@@ -1625,7 +1625,7 @@ static void start_fwbk(int ctlr)
 		" processing\n");
 	/* Command does not return anything, but idasend command needs a 
 		buffer */
-	id_ctlr_buf = (id_ctlr_t *)kmalloc(sizeof(id_ctlr_t), GFP_KERNEL);
+	id_ctlr_buf = kmalloc(sizeof(id_ctlr_t), GFP_KERNEL);
 	if(id_ctlr_buf==NULL)
 	{
 		printk(KERN_WARNING "cpqarray: Out of memory. "
@@ -1660,14 +1660,14 @@ static void getgeometry(int ctlr)
 
 	info_p->log_drv_map = 0;	
 	
-	id_ldrive = (id_log_drv_t *)kmalloc(sizeof(id_log_drv_t), GFP_KERNEL);
+	id_ldrive = kmalloc(sizeof(id_log_drv_t), GFP_KERNEL);
 	if(id_ldrive == NULL)
 	{
 		printk( KERN_ERR "cpqarray:  out of memory.\n");
 		return;
 	}
 
-	id_ctlr_buf = (id_ctlr_t *)kmalloc(sizeof(id_ctlr_t), GFP_KERNEL);
+	id_ctlr_buf = kmalloc(sizeof(id_ctlr_t), GFP_KERNEL);
 	if(id_ctlr_buf == NULL)
 	{
 		kfree(id_ldrive);
@@ -1675,7 +1675,7 @@ static void getgeometry(int ctlr)
 		return;
 	}
 
-	id_lstatus_buf = (sense_log_drv_stat_t *)kmalloc(sizeof(sense_log_drv_stat_t), GFP_KERNEL);
+	id_lstatus_buf = kmalloc(sizeof(sense_log_drv_stat_t), GFP_KERNEL);
 	if(id_lstatus_buf == NULL)
 	{
 		kfree(id_ctlr_buf);
@@ -1684,7 +1684,7 @@ static void getgeometry(int ctlr)
 		return;
 	}
 
-	sense_config_buf = (config_t *)kmalloc(sizeof(config_t), GFP_KERNEL);
+	sense_config_buf = kmalloc(sizeof(config_t), GFP_KERNEL);
 	if(sense_config_buf == NULL)
 	{
 		kfree(id_lstatus_buf);
diff -puN drivers/cdrom/cdrom.c~getting-rid-of-all-casts-of-kalloc-calls drivers/cdrom/cdrom.c
--- a/drivers/cdrom/cdrom.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/cdrom/cdrom.c
@@ -1810,7 +1810,7 @@ static int dvd_read_disckey(struct cdrom
 
 	size = sizeof(s->disckey.value) + 4;
 
-	if ((buf = (u_char *) kmalloc(size, GFP_KERNEL)) == NULL)
+	if ((buf = kmalloc(size, GFP_KERNEL)) == NULL)
 		return -ENOMEM;
 
 	init_cdrom_command(&cgc, buf, size, CGC_DATA_READ);
@@ -1861,7 +1861,7 @@ static int dvd_read_manufact(struct cdro
 
 	size = sizeof(s->manufact.value) + 4;
 
-	if ((buf = (u_char *) kmalloc(size, GFP_KERNEL)) == NULL)
+	if ((buf = kmalloc(size, GFP_KERNEL)) == NULL)
 		return -ENOMEM;
 
 	init_cdrom_command(&cgc, buf, size, CGC_DATA_READ);
@@ -2849,7 +2849,7 @@ static int mmc_ioctl(struct cdrom_device
 		/* FIXME: we need upper bound checking, too!! */
 		if (lba < 0)
 			return -EINVAL;
-		cgc.buffer = (char *) kmalloc(blocksize, GFP_KERNEL);
+		cgc.buffer = kmalloc(blocksize, GFP_KERNEL);
 		if (cgc.buffer == NULL)
 			return -ENOMEM;
 		memset(&sense, 0, sizeof(sense));
@@ -3031,7 +3031,7 @@ static int mmc_ioctl(struct cdrom_device
 		int size = sizeof(dvd_struct);
 		if (!CDROM_CAN(CDC_DVD))
 			return -ENOSYS;
-		if ((s = (dvd_struct *) kmalloc(size, GFP_KERNEL)) == NULL)
+		if ((s = kmalloc(size, GFP_KERNEL)) == NULL)
 			return -ENOMEM;
 		cdinfo(CD_DO_IOCTL, "entering DVD_READ_STRUCT\n"); 
 		if (copy_from_user(s, (dvd_struct __user *)arg, size)) {
diff -puN drivers/cdrom/cm206.c~getting-rid-of-all-casts-of-kalloc-calls drivers/cdrom/cm206.c
--- a/drivers/cdrom/cm206.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/cdrom/cm206.c
@@ -1420,7 +1420,7 @@ int __init cm206_init(void)
 		return -EIO;
 	}
 	printk(" adapter at 0x%x", cm206_base);
-	cd = (struct cm206_struct *) kmalloc(size, GFP_KERNEL);
+	cd = kmalloc(size, GFP_KERNEL);
 	if (!cd)
                goto out_base;
 	/* Now we have found the adaptor card, try to reset it. As we have
diff -puN drivers/char/consolemap.c~getting-rid-of-all-casts-of-kalloc-calls drivers/char/consolemap.c
--- a/drivers/char/consolemap.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/char/consolemap.c
@@ -443,7 +443,7 @@ int con_clear_unimap(struct vc_data *vc,
 	p = (struct uni_pagedir *)*vc->vc_uni_pagedir_loc;
 	if (p && p->readonly) return -EIO;
 	if (!p || --p->refcount) {
-		q = (struct uni_pagedir *)kmalloc(sizeof(*p), GFP_KERNEL);
+		q = kmalloc(sizeof(*p), GFP_KERNEL);
 		if (!q) {
 			if (p) p->refcount++;
 			return -ENOMEM;
diff -puN drivers/char/lcd.c~getting-rid-of-all-casts-of-kalloc-calls drivers/char/lcd.c
--- a/drivers/char/lcd.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/char/lcd.c
@@ -459,7 +459,7 @@ static int lcd_ioctl(struct inode *inode
 			    (&display, (struct lcd_display *) arg,
 			     sizeof(struct lcd_display)))
 				return -EFAULT;
-			rom = (unsigned char *) kmalloc((128), GFP_ATOMIC);
+			rom = kmalloc((128), GFP_ATOMIC);
 			if (rom == NULL) {
 				printk(KERN_ERR LCD "kmalloc() failed in %s\n",
 						__FUNCTION__);
diff -puN drivers/char/lp.c~getting-rid-of-all-casts-of-kalloc-calls drivers/char/lp.c
--- a/drivers/char/lp.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/char/lp.c
@@ -525,7 +525,7 @@ static int lp_open(struct inode * inode,
 			return -EIO;
 		}
 	}
-	lp_table[minor].lp_buffer = (char *) kmalloc(LP_BUFFER_SIZE, GFP_KERNEL);
+	lp_table[minor].lp_buffer = kmalloc(LP_BUFFER_SIZE, GFP_KERNEL);
 	if (!lp_table[minor].lp_buffer) {
 		LP_F(minor) &= ~LP_BUSY;
 		return -ENOMEM;
diff -puN drivers/char/pcmcia/synclink_cs.c~getting-rid-of-all-casts-of-kalloc-calls drivers/char/pcmcia/synclink_cs.c
--- a/drivers/char/pcmcia/synclink_cs.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/char/pcmcia/synclink_cs.c
@@ -541,7 +541,7 @@ static int mgslpc_probe(struct pcmcia_de
     if (debug_level >= DEBUG_LEVEL_INFO)
 	    printk("mgslpc_attach\n");
 
-    info = (MGSLPC_INFO *)kmalloc(sizeof(MGSLPC_INFO), GFP_KERNEL);
+    info = kmalloc(sizeof(MGSLPC_INFO), GFP_KERNEL);
     if (!info) {
 	    printk("Error can't allocate device instance data\n");
 	    return -ENOMEM;
diff -puN drivers/char/rio/riocmd.c~getting-rid-of-all-casts-of-kalloc-calls drivers/char/rio/riocmd.c
--- a/drivers/char/rio/riocmd.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/char/rio/riocmd.c
@@ -556,7 +556,7 @@ struct CmdBlk *RIOGetCmdBlk(void)
 {
 	struct CmdBlk *CmdBlkP;
 
-	CmdBlkP = (struct CmdBlk *)kmalloc(sizeof(struct CmdBlk), GFP_ATOMIC);
+	CmdBlkP = kmalloc(sizeof(struct CmdBlk), GFP_ATOMIC);
 	if (CmdBlkP)
 		memset(CmdBlkP, 0, sizeof(struct CmdBlk));
 	return CmdBlkP;
diff -puN drivers/char/synclink.c~getting-rid-of-all-casts-of-kalloc-calls drivers/char/synclink.c
--- a/drivers/char/synclink.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/char/synclink.c
@@ -4332,7 +4332,7 @@ static struct mgsl_struct* mgsl_allocate
 {
 	struct mgsl_struct *info;
 	
-	info = (struct mgsl_struct *)kmalloc(sizeof(struct mgsl_struct),
+	info = kmalloc(sizeof(struct mgsl_struct),
 		 GFP_KERNEL);
 		 
 	if (!info) {
diff -puN drivers/char/synclinkmp.c~getting-rid-of-all-casts-of-kalloc-calls drivers/char/synclinkmp.c
--- a/drivers/char/synclinkmp.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/char/synclinkmp.c
@@ -2730,7 +2730,7 @@ static int startup(SLMP_INFO * info)
 		return 0;
 
 	if (!info->tx_buf) {
-		info->tx_buf = (unsigned char *)kmalloc(info->max_frame_size, GFP_KERNEL);
+		info->tx_buf = kmalloc(info->max_frame_size, GFP_KERNEL);
 		if (!info->tx_buf) {
 			printk(KERN_ERR"%s(%d):%s can't allocate transmit buffer\n",
 				__FILE__,__LINE__,info->device_name);
@@ -3798,7 +3798,7 @@ static SLMP_INFO *alloc_dev(int adapter_
 {
 	SLMP_INFO *info;
 
-	info = (SLMP_INFO *)kmalloc(sizeof(SLMP_INFO),
+	info = kmalloc(sizeof(SLMP_INFO),
 		 GFP_KERNEL);
 
 	if (!info) {
diff -puN drivers/char/vt.c~getting-rid-of-all-casts-of-kalloc-calls drivers/char/vt.c
--- a/drivers/char/vt.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/char/vt.c
@@ -784,7 +784,7 @@ int vc_resize(struct vc_data *vc, unsign
 	if (new_cols == vc->vc_cols && new_rows == vc->vc_rows)
 		return 0;
 
-	newscreen = (unsigned short *) kmalloc(new_screen_size, GFP_USER);
+	newscreen = kmalloc(new_screen_size, GFP_USER);
 	if (!newscreen)
 		return -ENOMEM;
 
diff -puN drivers/char/vt_ioctl.c~getting-rid-of-all-casts-of-kalloc-calls drivers/char/vt_ioctl.c
--- a/drivers/char/vt_ioctl.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/char/vt_ioctl.c
@@ -129,7 +129,7 @@ do_kdsk_ioctl(int cmd, struct kbentry __
 			    !capable(CAP_SYS_RESOURCE))
 				return -EPERM;
 
-			key_map = (ushort *) kmalloc(sizeof(plain_map),
+			key_map = kmalloc(sizeof(plain_map),
 						     GFP_KERNEL);
 			if (!key_map)
 				return -ENOMEM;
@@ -259,7 +259,7 @@ do_kdgkb_ioctl(int cmd, struct kbsentry 
 		    sz = 256;
 		    while (sz < funcbufsize - funcbufleft + delta)
 		      sz <<= 1;
-		    fnw = (char *) kmalloc(sz, GFP_KERNEL);
+		    fnw = kmalloc(sz, GFP_KERNEL);
 		    if(!fnw) {
 		      ret = -ENOMEM;
 		      goto reterr;
diff -puN drivers/fc4/fc.c~getting-rid-of-all-casts-of-kalloc-calls drivers/fc4/fc.c
--- a/drivers/fc4/fc.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/fc4/fc.c
@@ -266,7 +266,7 @@ static void fcp_report_map_done(fc_chann
 			printk ("FC: Bad magic from REPORT_AL_MAP on %s - %08x\n", fc->name, p->magic);
 			fc->state = FC_STATE_OFFLINE;
 		} else {
-			fc->posmap = (fcp_posmap *)kzalloc(sizeof(fcp_posmap)+p->len, GFP_KERNEL);
+			fc->posmap = kzalloc(sizeof(fcp_posmap)+p->len, GFP_KERNEL);
 			if (!fc->posmap) {
 				printk("FC: Not enough memory, offlining channel\n");
 				fc->state = FC_STATE_OFFLINE;
@@ -355,7 +355,7 @@ void fcp_register(fc_channel *fc, u8 typ
 			for (i = fc->can_queue; i < fc->scsi_bitmap_end; i++)
 				set_bit (i, fc->scsi_bitmap);
 			fc->scsi_free = fc->can_queue;
-			fc->cmd_slots = (fcp_cmnd **)kzalloc(slots * sizeof(fcp_cmnd*), GFP_KERNEL);
+			fc->cmd_slots = kzalloc(slots * sizeof(fcp_cmnd*), GFP_KERNEL);
 			fc->abort_count = 0;
 		} else {
 			fc->scsi_name[0] = 0;
@@ -933,7 +933,7 @@ int fcp_scsi_dev_reset(struct scsi_cmnd 
         DECLARE_MUTEX_LOCKED(sem);
 
 	if (!fc->rst_pkt) {
-		fc->rst_pkt = (struct scsi_cmnd *) kmalloc(sizeof(SCpnt), GFP_KERNEL);
+		fc->rst_pkt = kmalloc(sizeof(SCpnt), GFP_KERNEL);
 		if (!fc->rst_pkt) return FAILED;
 		
 		fcmd = FCP_CMND(fc->rst_pkt);
@@ -1107,7 +1107,7 @@ int fc_do_plogi(fc_channel *fc, unsigned
 	logi *l;
 	int status;
 
-	l = (logi *)kzalloc(2 * sizeof(logi), GFP_KERNEL);
+	l = kzalloc(2 * sizeof(logi), GFP_KERNEL);
 	if (!l) return -ENOMEM;
 	l->code = LS_PLOGI;
 	memcpy (&l->nport_wwn, &fc->wwn_nport, sizeof(fc_wwn));
@@ -1141,7 +1141,7 @@ int fc_do_prli(fc_channel *fc, unsigned 
 	prli *p;
 	int status;
 
-	p = (prli *)kzalloc(2 * sizeof(prli), GFP_KERNEL);
+	p = kzalloc(2 * sizeof(prli), GFP_KERNEL);
 	if (!p) return -ENOMEM;
 	p->code = LS_PRLI;
 	p->params[0] = 0x08002000;
diff -puN drivers/ide/ide-floppy.c~getting-rid-of-all-casts-of-kalloc-calls drivers/ide/ide-floppy.c
--- a/drivers/ide/ide-floppy.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/ide/ide-floppy.c
@@ -2147,7 +2147,7 @@ static int ide_floppy_probe(ide_drive_t 
 		printk("ide-floppy: passing drive %s to ide-scsi emulation.\n", drive->name);
 		goto failed;
 	}
-	if ((floppy = (idefloppy_floppy_t *) kzalloc (sizeof (idefloppy_floppy_t), GFP_KERNEL)) == NULL) {
+	if ((floppy = kzalloc(sizeof (idefloppy_floppy_t), GFP_KERNEL)) == NULL) {
 		printk (KERN_ERR "ide-floppy: %s: Can't allocate a floppy structure\n", drive->name);
 		goto failed;
 	}
diff -puN drivers/ide/ide-tape.c~getting-rid-of-all-casts-of-kalloc-calls drivers/ide/ide-tape.c
--- a/drivers/ide/ide-tape.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/ide/ide-tape.c
@@ -2573,11 +2573,11 @@ static idetape_stage_t *__idetape_kmallo
 	int pages = tape->pages_per_stage;
 	char *b_data = NULL;
 
-	if ((stage = (idetape_stage_t *) kmalloc (sizeof (idetape_stage_t),GFP_KERNEL)) == NULL)
+	if ((stage = kmalloc(sizeof (idetape_stage_t),GFP_KERNEL)) == NULL)
 		return NULL;
 	stage->next = NULL;
 
-	bh = stage->bh = (struct idetape_bh *)kmalloc(sizeof(struct idetape_bh), GFP_KERNEL);
+	bh = stage->bh = kmalloc(sizeof(struct idetape_bh), GFP_KERNEL);
 	if (bh == NULL)
 		goto abort;
 	bh->b_reqnext = NULL;
@@ -2607,7 +2607,7 @@ static idetape_stage_t *__idetape_kmallo
 			continue;
 		}
 		prev_bh = bh;
-		if ((bh = (struct idetape_bh *)kmalloc(sizeof(struct idetape_bh), GFP_KERNEL)) == NULL) {
+		if ((bh = kmalloc(sizeof(struct idetape_bh), GFP_KERNEL)) == NULL) {
 			free_page((unsigned long) b_data);
 			goto abort;
 		}
@@ -4860,7 +4860,7 @@ static int ide_tape_probe(ide_drive_t *d
 		printk(KERN_WARNING "ide-tape: Use drive %s with ide-scsi emulation and osst.\n", drive->name);
 		printk(KERN_WARNING "ide-tape: OnStream support will be removed soon from ide-tape!\n");
 	}
-	tape = (idetape_tape_t *) kzalloc (sizeof (idetape_tape_t), GFP_KERNEL);
+	tape = kzalloc(sizeof (idetape_tape_t), GFP_KERNEL);
 	if (tape == NULL) {
 		printk(KERN_ERR "ide-tape: %s: Can't allocate a tape structure\n", drive->name);
 		goto failed;
diff -puN drivers/isdn/act2000/act2000_isa.c~getting-rid-of-all-casts-of-kalloc-calls drivers/isdn/act2000/act2000_isa.c
--- a/drivers/isdn/act2000/act2000_isa.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/isdn/act2000/act2000_isa.c
@@ -408,7 +408,7 @@ act2000_isa_download(act2000_card * card
         p = cblock.buffer;
         if (!access_ok(VERIFY_READ, p, length))
                 return -EFAULT;
-        buf = (u_char *) kmalloc(1024, GFP_KERNEL);
+        buf = kmalloc(1024, GFP_KERNEL);
         if (!buf)
                 return -ENOMEM;
         timeout = 0;
diff -puN drivers/isdn/capi/capidrv.c~getting-rid-of-all-casts-of-kalloc-calls drivers/isdn/capi/capidrv.c
--- a/drivers/isdn/capi/capidrv.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/isdn/capi/capidrv.c
@@ -2013,7 +2013,7 @@ static int capidrv_addcontr(u16 contr, s
 	strcpy(card->name, id);
 	card->contrnr = contr;
 	card->nbchan = profp->nbchannel;
-	card->bchans = (capidrv_bchan *) kmalloc(sizeof(capidrv_bchan) * card->nbchan, GFP_ATOMIC);
+	card->bchans = kmalloc(sizeof(capidrv_bchan) * card->nbchan, GFP_ATOMIC);
 	if (!card->bchans) {
 		printk(KERN_WARNING
 		"capidrv: (%s) Could not allocate bchan-structs.\n", id);
diff -puN drivers/isdn/divert/divert_procfs.c~getting-rid-of-all-casts-of-kalloc-calls drivers/isdn/divert/divert_procfs.c
--- a/drivers/isdn/divert/divert_procfs.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/isdn/divert/divert_procfs.c
@@ -45,7 +45,7 @@ put_info_buffer(char *cp)
 		return;
 	if (!*cp)
 		return;
-	if (!(ib = (struct divert_info *) kmalloc(sizeof(struct divert_info) + strlen(cp), GFP_ATOMIC)))
+	if (!(ib = kmalloc(sizeof(struct divert_info) + strlen(cp), GFP_ATOMIC)))
 		 return;	/* no memory */
 	strcpy(ib->info_start, cp);	/* set output string */
 	ib->next = NULL;
diff -puN drivers/isdn/divert/isdn_divert.c~getting-rid-of-all-casts-of-kalloc-calls drivers/isdn/divert/isdn_divert.c
--- a/drivers/isdn/divert/isdn_divert.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/isdn/divert/isdn_divert.c
@@ -153,7 +153,7 @@ int cf_command(int drvid, int mode, 
   *ielenp = p - ielenp - 1; /* set total IE length */ 
 
   /* allocate mem for information struct */  
-  if (!(cs = (struct call_struc *) kmalloc(sizeof(struct call_struc), GFP_ATOMIC))) 
+  if (!(cs = kmalloc(sizeof(struct call_struc), GFP_ATOMIC)))
              return(-ENOMEM); /* no memory */
   init_timer(&cs->timer);
   cs->info[0] = '\0';
@@ -276,7 +276,7 @@ int insertrule(int idx, divert_rule *new
 { struct deflect_struc *ds,*ds1=NULL;
   unsigned long flags;
 
-  if (!(ds = (struct deflect_struc *) kmalloc(sizeof(struct deflect_struc), 
+  if (!(ds = kmalloc(sizeof(struct deflect_struc),
                                               GFP_KERNEL))) 
     return(-ENOMEM); /* no memory */
 
@@ -451,7 +451,7 @@ static int isdn_divert_icall(isdn_ctrl *
            if (dv->rule.action == DEFLECT_PROCEED)
 	    if ((!if_used) || ((!extern_wait_max) && (!dv->rule.waittime))) 
               return(0); /* no external deflection needed */  
-           if (!(cs = (struct call_struc *) kmalloc(sizeof(struct call_struc), GFP_ATOMIC))) 
+           if (!(cs = kmalloc(sizeof(struct call_struc), GFP_ATOMIC)))
              return(0); /* no memory */
            init_timer(&cs->timer);
            cs->info[0] = '\0';
diff -puN drivers/isdn/hysdn/hysdn_procconf.c~getting-rid-of-all-casts-of-kalloc-calls drivers/isdn/hysdn/hysdn_procconf.c
--- a/drivers/isdn/hysdn/hysdn_procconf.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/isdn/hysdn/hysdn_procconf.c
@@ -275,7 +275,7 @@ hysdn_conf_open(struct inode *ino, struc
 	} else if ((filep->f_mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ) {
 		/* read access -> output card info data */
 
-		if (!(tmp = (char *) kmalloc(INFO_OUT_LEN * 2 + 2, GFP_KERNEL))) {
+		if (!(tmp = kmalloc(INFO_OUT_LEN * 2 + 2, GFP_KERNEL))) {
 			unlock_kernel();
 			return (-EFAULT);	/* out of memory */
 		}
diff -puN drivers/isdn/hysdn/hysdn_proclog.c~getting-rid-of-all-casts-of-kalloc-calls drivers/isdn/hysdn/hysdn_proclog.c
--- a/drivers/isdn/hysdn/hysdn_proclog.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/isdn/hysdn/hysdn_proclog.c
@@ -111,7 +111,7 @@ put_log_buffer(hysdn_card * card, char *
 	if (pd->if_used <= 0)
 		return;		/* no open file for read */
 
-	if (!(ib = (struct log_data *) kmalloc(sizeof(struct log_data) + strlen(cp), GFP_ATOMIC)))
+	if (!(ib = kmalloc(sizeof(struct log_data) + strlen(cp), GFP_ATOMIC)))
 		 return;	/* no memory */
 	strcpy(ib->log_start, cp);	/* set output string */
 	ib->next = NULL;
diff -puN drivers/isdn/i4l/isdn_audio.c~getting-rid-of-all-casts-of-kalloc-calls drivers/isdn/i4l/isdn_audio.c
--- a/drivers/isdn/i4l/isdn_audio.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/isdn/i4l/isdn_audio.c
@@ -328,7 +328,7 @@ adpcm_state *
 isdn_audio_adpcm_init(adpcm_state * s, int nbits)
 {
 	if (!s)
-		s = (adpcm_state *) kmalloc(sizeof(adpcm_state), GFP_ATOMIC);
+		s = kmalloc(sizeof(adpcm_state), GFP_ATOMIC);
 	if (s) {
 		s->a = 0;
 		s->d = 5;
@@ -343,7 +343,7 @@ dtmf_state *
 isdn_audio_dtmf_init(dtmf_state * s)
 {
 	if (!s)
-		s = (dtmf_state *) kmalloc(sizeof(dtmf_state), GFP_ATOMIC);
+		s = kmalloc(sizeof(dtmf_state), GFP_ATOMIC);
 	if (s) {
 		s->idx = 0;
 		s->last = ' ';
@@ -621,7 +621,7 @@ silence_state *
 isdn_audio_silence_init(silence_state * s)
 {
 	if (!s)
-		s = (silence_state *) kmalloc(sizeof(silence_state), GFP_ATOMIC);
+		s = kmalloc(sizeof(silence_state), GFP_ATOMIC);
 	if (s) {
 		s->idx = 0;
 		s->state = 0;
diff -puN drivers/isdn/i4l/isdn_net.c~getting-rid-of-all-casts-of-kalloc-calls drivers/isdn/i4l/isdn_net.c
--- a/drivers/isdn/i4l/isdn_net.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/isdn/i4l/isdn_net.c
@@ -2948,7 +2948,7 @@ isdn_net_addphone(isdn_net_ioctl_phone *
 	isdn_net_phone *n;
 
 	if (p) {
-		if (!(n = (isdn_net_phone *) kmalloc(sizeof(isdn_net_phone), GFP_KERNEL)))
+		if (!(n = kmalloc(sizeof(isdn_net_phone), GFP_KERNEL)))
 			return -ENOMEM;
 		strcpy(n->num, phone->phone);
 		n->next = p->local->phone[phone->outgoing & 1];
diff -puN drivers/isdn/i4l/isdn_ppp.c~getting-rid-of-all-casts-of-kalloc-calls drivers/isdn/i4l/isdn_ppp.c
--- a/drivers/isdn/i4l/isdn_ppp.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/isdn/i4l/isdn_ppp.c
@@ -717,7 +717,7 @@ isdn_ppp_fill_rq(unsigned char *buf, int
 		printk(KERN_DEBUG "ippp: device not activated.\n");
 		return 0;
 	}
-	nbuf = (unsigned char *) kmalloc(len + 4, GFP_ATOMIC);
+	nbuf = kmalloc(len + 4, GFP_ATOMIC);
 	if (!nbuf) {
 		printk(KERN_WARNING "ippp: Can't alloc buf\n");
 		return 0;
diff -puN drivers/isdn/pcbit/layer2.c~getting-rid-of-all-casts-of-kalloc-calls drivers/isdn/pcbit/layer2.c
--- a/drivers/isdn/pcbit/layer2.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/isdn/pcbit/layer2.c
@@ -100,7 +100,7 @@ pcbit_l2_write(struct pcbit_dev *dev, ul
 		dev_kfree_skb(skb);
 		return -1;
 	}
-	if ((frame = (struct frame_buf *) kmalloc(sizeof(struct frame_buf),
+	if ((frame = kmalloc(sizeof(struct frame_buf),
 						  GFP_ATOMIC)) == NULL) {
 		printk(KERN_WARNING "pcbit_2_write: kmalloc failed\n");
 		dev_kfree_skb(skb);
diff -puN drivers/macintosh/adb.c~getting-rid-of-all-casts-of-kalloc-calls drivers/macintosh/adb.c
--- a/drivers/macintosh/adb.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/macintosh/adb.c
@@ -828,7 +828,7 @@ static ssize_t adb_write(struct file *fi
 	if (!access_ok(VERIFY_READ, buf, count))
 		return -EFAULT;
 
-	req = (struct adb_request *) kmalloc(sizeof(struct adb_request),
+	req = kmalloc(sizeof(struct adb_request),
 					     GFP_KERNEL);
 	if (req == NULL)
 		return -ENOMEM;
diff -puN drivers/macintosh/apm_emu.c~getting-rid-of-all-casts-of-kalloc-calls drivers/macintosh/apm_emu.c
--- a/drivers/macintosh/apm_emu.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/macintosh/apm_emu.c
@@ -321,7 +321,7 @@ static int do_open(struct inode * inode,
 {
 	struct apm_user *	as;
 
-	as = (struct apm_user *)kmalloc(sizeof(*as), GFP_KERNEL);
+	as = kmalloc(sizeof(*as), GFP_KERNEL);
 	if (as == NULL) {
 		printk(KERN_ERR "apm: cannot allocate struct of size %d bytes\n",
 		       sizeof(*as));
diff -puN drivers/macintosh/via-pmu68k.c~getting-rid-of-all-casts-of-kalloc-calls drivers/macintosh/via-pmu68k.c
--- a/drivers/macintosh/via-pmu68k.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/macintosh/via-pmu68k.c
@@ -847,7 +847,7 @@ pbook_pci_save(void)
 	n_pbook_pci_saves = npci;
 	if (npci == 0)
 		return;
-	ps = (struct pci_save *) kmalloc(npci * sizeof(*ps), GFP_KERNEL);
+	ps = kmalloc(npci * sizeof(*ps), GFP_KERNEL);
 	pbook_pci_saves = ps;
 	if (ps == NULL)
 		return;
diff -puN drivers/media/dvb/bt8xx/dst_ca.c~getting-rid-of-all-casts-of-kalloc-calls drivers/media/dvb/bt8xx/dst_ca.c
--- a/drivers/media/dvb/bt8xx/dst_ca.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/media/dvb/bt8xx/dst_ca.c
@@ -480,7 +480,7 @@ static int ca_send_message(struct dst_st
 	struct ca_msg *hw_buffer;
 	int result = 0;
 
-	if ((hw_buffer = (struct ca_msg *) kmalloc(sizeof (struct ca_msg), GFP_KERNEL)) == NULL) {
+	if ((hw_buffer = kmalloc(sizeof (struct ca_msg), GFP_KERNEL)) == NULL) {
 		dprintk(verbose, DST_CA_ERROR, 1, " Memory allocation failure");
 		return -ENOMEM;
 	}
diff -puN drivers/media/dvb/bt8xx/dvb-bt8xx.c~getting-rid-of-all-casts-of-kalloc-calls drivers/media/dvb/bt8xx/dvb-bt8xx.c
--- a/drivers/media/dvb/bt8xx/dvb-bt8xx.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/media/dvb/bt8xx/dvb-bt8xx.c
@@ -657,7 +657,7 @@ static void frontend_init(struct dvb_bt8
 
 	case BTTV_BOARD_TWINHAN_DST:
 		/*	DST is not a frontend driver !!!		*/
-		state = (struct dst_state *) kmalloc(sizeof (struct dst_state), GFP_KERNEL);
+		state = kmalloc(sizeof (struct dst_state), GFP_KERNEL);
 		if (!state) {
 			printk("dvb_bt8xx: No memory\n");
 			break;
diff -puN drivers/media/dvb/ttusb-dec/ttusbdecfe.c~getting-rid-of-all-casts-of-kalloc-calls drivers/media/dvb/ttusb-dec/ttusbdecfe.c
--- a/drivers/media/dvb/ttusb-dec/ttusbdecfe.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
@@ -195,7 +195,7 @@ struct dvb_frontend* ttusbdecfe_dvbt_att
 	struct ttusbdecfe_state* state = NULL;
 
 	/* allocate memory for the internal state */
-	state = (struct ttusbdecfe_state*) kmalloc(sizeof(struct ttusbdecfe_state), GFP_KERNEL);
+	state = kmalloc(sizeof(struct ttusbdecfe_state), GFP_KERNEL);
 	if (state == NULL)
 		return NULL;
 
@@ -215,7 +215,7 @@ struct dvb_frontend* ttusbdecfe_dvbs_att
 	struct ttusbdecfe_state* state = NULL;
 
 	/* allocate memory for the internal state */
-	state = (struct ttusbdecfe_state*) kmalloc(sizeof(struct ttusbdecfe_state), GFP_KERNEL);
+	state = kmalloc(sizeof(struct ttusbdecfe_state), GFP_KERNEL);
 	if (state == NULL)
 		return NULL;
 
diff -puN drivers/media/video/dabusb.c~getting-rid-of-all-casts-of-kalloc-calls drivers/media/video/dabusb.c
--- a/drivers/media/video/dabusb.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/media/video/dabusb.c
@@ -218,7 +218,7 @@ static int dabusb_alloc_buffers (pdabusb
 		 pipesize, packets, transfer_buffer_length);
 
 	while (buffers < (s->total_buffer_size << 10)) {
-		b = (pbuff_t) kzalloc (sizeof (buff_t), GFP_KERNEL);
+		b = kzalloc(sizeof (buff_t), GFP_KERNEL);
 		if (!b) {
 			err("kzalloc(sizeof(buff_t))==NULL");
 			goto err;
@@ -659,7 +659,7 @@ static int dabusb_ioctl (struct inode *i
 	switch (cmd) {
 
 	case IOCTL_DAB_BULK:
-		pbulk = (pbulk_transfer_t) kmalloc (sizeof (bulk_transfer_t), GFP_KERNEL);
+		pbulk = kmalloc(sizeof (bulk_transfer_t), GFP_KERNEL);
 
 		if (!pbulk) {
 			ret = -ENOMEM;
diff -puN drivers/media/video/planb.c~getting-rid-of-all-casts-of-kalloc-calls drivers/media/video/planb.c
--- a/drivers/media/video/planb.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/media/video/planb.c
@@ -138,7 +138,7 @@ static int grabbuf_alloc(struct planb *p
 		+ MAX_LNUM
 #endif /* PLANB_GSCANLINE */
 		);
-	if ((pb->rawbuf = (unsigned char**) kmalloc (npage
+	if ((pb->rawbuf = kmalloc(npage
 				* sizeof(unsigned long), GFP_KERNEL)) == 0)
 		return -ENOMEM;
 	for (i = 0; i < npage; i++) {
diff -puN drivers/media/video/usbvideo/usbvideo.c~getting-rid-of-all-casts-of-kalloc-calls drivers/media/video/usbvideo/usbvideo.c
--- a/drivers/media/video/usbvideo/usbvideo.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/media/video/usbvideo/usbvideo.c
@@ -690,7 +690,7 @@ int usbvideo_register(
 	}
 
 	base_size = num_cams * sizeof(struct uvd) + sizeof(struct usbvideo);
-	cams = (struct usbvideo *) kzalloc(base_size, GFP_KERNEL);
+	cams = kzalloc(base_size, GFP_KERNEL);
 	if (cams == NULL) {
 		err("Failed to allocate %d. bytes for usbvideo struct", base_size);
 		return -ENOMEM;
diff -puN drivers/media/video/videocodec.c~getting-rid-of-all-casts-of-kalloc-calls drivers/media/video/videocodec.c
--- a/drivers/media/video/videocodec.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/media/video/videocodec.c
@@ -346,7 +346,7 @@ videocodec_build_table (void)
 		size);
 
 	kfree(videocodec_buf);
-	videocodec_buf = (char *) kmalloc(size, GFP_KERNEL);
+	videocodec_buf = kmalloc(size, GFP_KERNEL);
 
 	i = 0;
 	i += scnprintf(videocodec_buf + i, size - 1,
diff -puN drivers/message/i2o/i2o_config.c~getting-rid-of-all-casts-of-kalloc-calls drivers/message/i2o/i2o_config.c
--- a/drivers/message/i2o/i2o_config.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/message/i2o/i2o_config.c
@@ -186,7 +186,7 @@ static int i2o_cfg_parms(unsigned long a
 	if (!dev)
 		return -ENXIO;
 
-	ops = (u8 *) kmalloc(kcmd.oplen, GFP_KERNEL);
+	ops = kmalloc(kcmd.oplen, GFP_KERNEL);
 	if (!ops)
 		return -ENOMEM;
 
@@ -199,7 +199,7 @@ static int i2o_cfg_parms(unsigned long a
 	 * It's possible to have a _very_ large table
 	 * and that the user asks for all of it at once...
 	 */
-	res = (u8 *) kmalloc(65536, GFP_KERNEL);
+	res = kmalloc(65536, GFP_KERNEL);
 	if (!res) {
 		kfree(ops);
 		return -ENOMEM;
diff -puN drivers/mtd/devices/mtd_dataflash.c~getting-rid-of-all-casts-of-kalloc-calls drivers/mtd/devices/mtd_dataflash.c
--- a/drivers/mtd/devices/mtd_dataflash.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/mtd/devices/mtd_dataflash.c
@@ -459,7 +459,7 @@ add_dataflash(struct spi_device *spi, ch
 	struct mtd_info			*device;
 	struct flash_platform_data	*pdata = spi->dev.platform_data;
 
-	priv = (struct dataflash *) kzalloc(sizeof *priv, GFP_KERNEL);
+	priv = kzalloc(sizeof *priv, GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
diff -puN drivers/net/appletalk/ipddp.c~getting-rid-of-all-casts-of-kalloc-calls drivers/net/appletalk/ipddp.c
--- a/drivers/net/appletalk/ipddp.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/net/appletalk/ipddp.c
@@ -186,7 +186,7 @@ static int ipddp_xmit(struct sk_buff *sk
  */
 static int ipddp_create(struct ipddp_route *new_rt)
 {
-        struct ipddp_route *rt =(struct ipddp_route*) kmalloc(sizeof(*rt), GFP_KERNEL);
+        struct ipddp_route *rt = kmalloc(sizeof(*rt), GFP_KERNEL);
 
         if (rt == NULL)
                 return -ENOMEM;
diff -puN drivers/net/bsd_comp.c~getting-rid-of-all-casts-of-kalloc-calls drivers/net/bsd_comp.c
--- a/drivers/net/bsd_comp.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/net/bsd_comp.c
@@ -395,7 +395,7 @@ static void *bsd_alloc (unsigned char *o
  * Allocate the main control structure for this instance.
  */
     maxmaxcode = MAXCODE(bits);
-    db         = (struct bsd_db *) kmalloc (sizeof (struct bsd_db),
+    db         = kmalloc(sizeof (struct bsd_db),
 					    GFP_KERNEL);
     if (!db)
       {
diff -puN drivers/net/irda/donauboe.c~getting-rid-of-all-casts-of-kalloc-calls drivers/net/irda/donauboe.c
--- a/drivers/net/irda/donauboe.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/net/irda/donauboe.c
@@ -1603,7 +1603,7 @@ toshoboe_open (struct pci_dev *pci_dev, 
   irda_qos_bits_to_value (&self->qos);
 
   /* Allocate twice the size to guarantee alignment */
-  self->ringbuf = (void *) kmalloc (OBOE_RING_LEN << 1, GFP_KERNEL);
+  self->ringbuf = kmalloc(OBOE_RING_LEN << 1, GFP_KERNEL);
   if (!self->ringbuf)
     {
       printk (KERN_ERR DRIVER_NAME ": can't allocate DMA buffers\n");
diff -puN drivers/net/irda/irda-usb.c~getting-rid-of-all-casts-of-kalloc-calls drivers/net/irda/irda-usb.c
--- a/drivers/net/irda/irda-usb.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/net/irda/irda-usb.c
@@ -1747,7 +1747,7 @@ static int irda_usb_probe(struct usb_int
 	/* Don't change this buffer size and allocation without doing
 	 * some heavy and complete testing. Don't ask why :-(
 	 * Jean II */
-	self->speed_buff = (char *) kmalloc(IRDA_USB_SPEED_MTU, GFP_KERNEL);
+	self->speed_buff = kmalloc(IRDA_USB_SPEED_MTU, GFP_KERNEL);
 	if (self->speed_buff == NULL) 
 		goto err_out_3;
 
diff -puN drivers/net/irda/irport.c~getting-rid-of-all-casts-of-kalloc-calls drivers/net/irda/irport.c
--- a/drivers/net/irda/irport.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/net/irda/irport.c
@@ -164,7 +164,7 @@ irport_open(int i, unsigned int iobase, 
 	
 	/* Allocate memory if needed */
 	if (self->tx_buff.truesize > 0) {
-		self->tx_buff.head = (__u8 *) kmalloc(self->tx_buff.truesize, 
+		self->tx_buff.head = kmalloc(self->tx_buff.truesize,
 						      GFP_KERNEL);
 		if (self->tx_buff.head == NULL) {
 			IRDA_ERROR("%s(), can't allocate memory for "
diff -puN drivers/net/lance.c~getting-rid-of-all-casts-of-kalloc-calls drivers/net/lance.c
--- a/drivers/net/lance.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/net/lance.c
@@ -540,7 +540,7 @@ static int __init lance_probe1(struct ne
 	memset(lp, 0, sizeof(*lp));
 	dev->priv = lp;
 	lp->name = chipname;
-	lp->rx_buffs = (unsigned long)kmalloc(PKT_BUF_SZ*RX_RING_SIZE,
+	lp->rx_buffs = kmalloc(PKT_BUF_SZ*RX_RING_SIZE,
 						  GFP_DMA | GFP_KERNEL);
 	if (!lp->rx_buffs)
 		goto out_lp;
diff -puN drivers/net/lp486e.c~getting-rid-of-all-casts-of-kalloc-calls drivers/net/lp486e.c
--- a/drivers/net/lp486e.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/net/lp486e.c
@@ -884,7 +884,7 @@ static int i596_start_xmit (struct sk_bu
 
 	dev->trans_start = jiffies;
 
-	tx_cmd = (struct tx_cmd *) kmalloc ((sizeof (struct tx_cmd) + sizeof (struct i596_tbd)), GFP_ATOMIC);
+	tx_cmd = kmalloc((sizeof (struct tx_cmd) + sizeof (struct i596_tbd)), GFP_ATOMIC);
 	if (tx_cmd == NULL) {
 		printk(KERN_WARNING "%s: i596_xmit Memory squeeze, dropping packet.\n", dev->name);
 		lp->stats.tx_dropped++;
@@ -1266,7 +1266,7 @@ static void set_multicast_list(struct ne
 	if (dev->mc_count > 0) {
 		struct dev_mc_list *dmi;
 		char *cp;
-		cmd = (struct i596_cmd *)kmalloc(sizeof(struct i596_cmd)+2+dev->mc_count*6, GFP_ATOMIC);
+		cmd = kmalloc(sizeof(struct i596_cmd)+2+dev->mc_count*6, GFP_ATOMIC);
 		if (cmd == NULL) {
 			printk (KERN_ERR "%s: set_multicast Memory squeeze.\n", dev->name);
 			return;
diff -puN drivers/net/ppp_deflate.c~getting-rid-of-all-casts-of-kalloc-calls drivers/net/ppp_deflate.c
--- a/drivers/net/ppp_deflate.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/net/ppp_deflate.c
@@ -121,7 +121,7 @@ static void *z_comp_alloc(unsigned char 
 	if (w_size < DEFLATE_MIN_SIZE || w_size > DEFLATE_MAX_SIZE)
 		return NULL;
 
-	state = (struct ppp_deflate_state *) kmalloc(sizeof(*state),
+	state = kmalloc(sizeof(*state),
 						     GFP_KERNEL);
 	if (state == NULL)
 		return NULL;
@@ -341,7 +341,7 @@ static void *z_decomp_alloc(unsigned cha
 	if (w_size < DEFLATE_MIN_SIZE || w_size > DEFLATE_MAX_SIZE)
 		return NULL;
 
-	state = (struct ppp_deflate_state *) kmalloc(sizeof(*state), GFP_KERNEL);
+	state = kmalloc(sizeof(*state), GFP_KERNEL);
 	if (state == NULL)
 		return NULL;
 
diff -puN drivers/net/ppp_mppe.c~getting-rid-of-all-casts-of-kalloc-calls drivers/net/ppp_mppe.c
--- a/drivers/net/ppp_mppe.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/net/ppp_mppe.c
@@ -200,7 +200,7 @@ static void *mppe_alloc(unsigned char *o
 	    || options[0] != CI_MPPE || options[1] != CILEN_MPPE)
 		goto out;
 
-	state = (struct ppp_mppe_state *) kmalloc(sizeof(*state), GFP_KERNEL);
+	state = kmalloc(sizeof(*state), GFP_KERNEL);
 	if (state == NULL)
 		goto out;
 
diff -puN drivers/net/sgiseeq.c~getting-rid-of-all-casts-of-kalloc-calls drivers/net/sgiseeq.c
--- a/drivers/net/sgiseeq.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/net/sgiseeq.c
@@ -180,7 +180,7 @@ static int seeq_init_ring(struct net_dev
 		if (!sp->tx_desc[i].tdma.pbuf) {
 			unsigned long buffer;
 
-			buffer = (unsigned long) kmalloc(PKT_BUF_SZ, GFP_KERNEL);
+			buffer = kmalloc(PKT_BUF_SZ, GFP_KERNEL);
 			if (!buffer)
 				return -ENOMEM;
 			sp->tx_desc[i].buf_vaddr = CKSEG1ADDR(buffer);
@@ -194,7 +194,7 @@ static int seeq_init_ring(struct net_dev
 		if (!sp->rx_desc[i].rdma.pbuf) {
 			unsigned long buffer;
 
-			buffer = (unsigned long) kmalloc(PKT_BUF_SZ, GFP_KERNEL);
+			buffer = kmalloc(PKT_BUF_SZ, GFP_KERNEL);
 			if (!buffer)
 				return -ENOMEM;
 			sp->rx_desc[i].buf_vaddr = CKSEG1ADDR(buffer);
diff -puN drivers/net/slip.c~getting-rid-of-all-casts-of-kalloc-calls drivers/net/slip.c
--- a/drivers/net/slip.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/net/slip.c
@@ -229,10 +229,10 @@ static int sl_realloc_bufs(struct slip *
 	if (len < 576 * 2)
 		len = 576 * 2;
 
-	xbuff = (unsigned char *) kmalloc (len + 4, GFP_ATOMIC);
-	rbuff = (unsigned char *) kmalloc (len + 4, GFP_ATOMIC);
+	xbuff = kmalloc(len + 4, GFP_ATOMIC);
+	rbuff = kmalloc(len + 4, GFP_ATOMIC);
 #ifdef SL_INCLUDE_CSLIP
-	cbuff = (unsigned char *) kmalloc (len + 4, GFP_ATOMIC);
+	cbuff = kmalloc(len + 4, GFP_ATOMIC);
 #endif
 
 
diff -puN drivers/net/wan/hostess_sv11.c~getting-rid-of-all-casts-of-kalloc-calls drivers/net/wan/hostess_sv11.c
--- a/drivers/net/wan/hostess_sv11.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/net/wan/hostess_sv11.c
@@ -231,7 +231,7 @@ static struct sv11_device *sv11_init(int
 		return NULL;
 	}
 	
-	sv=(struct sv11_device *)kmalloc(sizeof(struct sv11_device), GFP_KERNEL);
+	sv = kmalloc(sizeof(struct sv11_device), GFP_KERNEL);
 	if(!sv)
 		goto fail3;
 			
diff -puN drivers/net/wan/pc300_drv.c~getting-rid-of-all-casts-of-kalloc-calls drivers/net/wan/pc300_drv.c
--- a/drivers/net/wan/pc300_drv.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/net/wan/pc300_drv.c
@@ -3455,7 +3455,7 @@ cpc_init_one(struct pci_dev *pdev, const
 	if ((err = pci_enable_device(pdev)) < 0)
 		return err;
 
-	card = (pc300_t *) kmalloc(sizeof(pc300_t), GFP_KERNEL);
+	card = kmalloc(sizeof(pc300_t), GFP_KERNEL);
 	if (card == NULL) {
 		printk("PC300 found at RAM 0x%016llx, "
 		       "but could not allocate card structure.\n",
diff -puN drivers/net/wan/pc300_tty.c~getting-rid-of-all-casts-of-kalloc-calls drivers/net/wan/pc300_tty.c
--- a/drivers/net/wan/pc300_tty.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/net/wan/pc300_tty.c
@@ -784,7 +784,7 @@ void cpc_tty_receive(pc300dev_t *pc300de
 			continue;
 		} 
 		
-		new = (st_cpc_rx_buf *)kmalloc(rx_len + sizeof(st_cpc_rx_buf), GFP_ATOMIC);
+		new = kmalloc(rx_len + sizeof(st_cpc_rx_buf), GFP_ATOMIC);
 		if (new == 0) {
 			cpc_tty_rx_disc_frame(pc300chan);
 			continue;
diff -puN drivers/net/wan/x25_asy.c~getting-rid-of-all-casts-of-kalloc-calls drivers/net/wan/x25_asy.c
--- a/drivers/net/wan/x25_asy.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/net/wan/x25_asy.c
@@ -123,8 +123,8 @@ static int x25_asy_change_mtu(struct net
 	unsigned char *xbuff, *rbuff;
 	int len = 2* newmtu;
 
-	xbuff = (unsigned char *) kmalloc (len + 4, GFP_ATOMIC);
-	rbuff = (unsigned char *) kmalloc (len + 4, GFP_ATOMIC);
+	xbuff = kmalloc(len + 4, GFP_ATOMIC);
+	rbuff = kmalloc(len + 4, GFP_ATOMIC);
 
 	if (xbuff == NULL || rbuff == NULL)  
 	{
@@ -465,11 +465,11 @@ static int x25_asy_open(struct net_devic
 
 	len = dev->mtu * 2;
 
-	sl->rbuff = (unsigned char *) kmalloc(len + 4, GFP_KERNEL);
+	sl->rbuff = kmalloc(len + 4, GFP_KERNEL);
 	if (sl->rbuff == NULL)   {
 		goto norbuff;
 	}
-	sl->xbuff = (unsigned char *) kmalloc(len + 4, GFP_KERNEL);
+	sl->xbuff = kmalloc(len + 4, GFP_KERNEL);
 	if (sl->xbuff == NULL)   {
 		goto noxbuff;
 	}
diff -puN drivers/net/wireless/hostap/hostap_ap.c~getting-rid-of-all-casts-of-kalloc-calls drivers/net/wireless/hostap/hostap_ap.c
--- a/drivers/net/wireless/hostap/hostap_ap.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/net/wireless/hostap/hostap_ap.c
@@ -1253,7 +1253,7 @@ static char * ap_auth_make_challenge(str
 			return NULL;
 	}
 
-	tmpbuf = (char *) kmalloc(WLAN_AUTH_CHALLENGE_LEN, GFP_ATOMIC);
+	tmpbuf = kmalloc(WLAN_AUTH_CHALLENGE_LEN, GFP_ATOMIC);
 	if (tmpbuf == NULL) {
 		PDEBUG(DEBUG_AP, "AP: kmalloc failed for challenge\n");
 		return NULL;
diff -puN drivers/net/wireless/hostap/hostap_download.c~getting-rid-of-all-casts-of-kalloc-calls drivers/net/wireless/hostap/hostap_download.c
--- a/drivers/net/wireless/hostap/hostap_download.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/net/wireless/hostap/hostap_download.c
@@ -201,7 +201,7 @@ static u8 * prism2_read_pda(struct net_d
 		0x7f0002 /* Intel PRO/Wireless 2011B (PCI) */,
 	};
 
-	buf = (u8 *) kmalloc(PRISM2_PDA_SIZE, GFP_KERNEL);
+	buf = kmalloc(PRISM2_PDA_SIZE, GFP_KERNEL);
 	if (buf == NULL)
 		return NULL;
 
diff -puN drivers/net/wireless/hostap/hostap_hw.c~getting-rid-of-all-casts-of-kalloc-calls drivers/net/wireless/hostap/hostap_hw.c
--- a/drivers/net/wireless/hostap/hostap_hw.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/net/wireless/hostap/hostap_hw.c
@@ -2252,7 +2252,7 @@ static int hostap_tx_compl_read(local_in
 	if (txdesc->sw_support) {
 		len = le16_to_cpu(txdesc->data_len);
 		if (len < PRISM2_DATA_MAXLEN) {
-			*payload = (char *) kmalloc(len, GFP_ATOMIC);
+			*payload = kmalloc(len, GFP_ATOMIC);
 			if (*payload == NULL ||
 			    hfa384x_from_bap(dev, BAP0, *payload, len)) {
 				PDEBUG(DEBUG_EXTRA, "%s: could not read TX "
diff -puN drivers/net/wireless/hostap/hostap_ioctl.c~getting-rid-of-all-casts-of-kalloc-calls drivers/net/wireless/hostap/hostap_ioctl.c
--- a/drivers/net/wireless/hostap/hostap_ioctl.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -3829,7 +3829,7 @@ static int prism2_ioctl_priv_hostapd(loc
 	    p->length > PRISM2_HOSTAPD_MAX_BUF_SIZE || !p->pointer)
 		return -EINVAL;
 
-	param = (struct prism2_hostapd_param *) kmalloc(p->length, GFP_KERNEL);
+	param = kmalloc(p->length, GFP_KERNEL);
 	if (param == NULL)
 		return -ENOMEM;
 
diff -puN drivers/net/wireless/hostap/hostap_main.c~getting-rid-of-all-casts-of-kalloc-calls drivers/net/wireless/hostap/hostap_main.c
--- a/drivers/net/wireless/hostap/hostap_main.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/net/wireless/hostap/hostap_main.c
@@ -250,7 +250,7 @@ u16 hostap_tx_callback_register(local_in
 	unsigned long flags;
 	struct hostap_tx_callback_info *entry;
 
-	entry = (struct hostap_tx_callback_info *) kmalloc(sizeof(*entry),
+	entry = kmalloc(sizeof(*entry),
 							   GFP_ATOMIC);
 	if (entry == NULL)
 		return 0;
diff -puN drivers/net/wireless/ipw2100.c~getting-rid-of-all-casts-of-kalloc-calls drivers/net/wireless/ipw2100.c
--- a/drivers/net/wireless/ipw2100.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/net/wireless/ipw2100.c
@@ -2246,7 +2246,7 @@ static int ipw2100_snapshot_alloc(struct
 	if (priv->snapshot[0])
 		return 1;
 	for (i = 0; i < 0x30; i++) {
-		priv->snapshot[i] = (u8 *) kmalloc(0x1000, GFP_ATOMIC);
+		priv->snapshot[i] = kmalloc(0x1000, GFP_ATOMIC);
 		if (!priv->snapshot[i]) {
 			IPW_DEBUG_INFO("%s: Error allocating snapshot "
 				       "buffer %d\n", priv->net_dev->name, i);
diff -puN drivers/net/wireless/prism54/isl_ioctl.c~getting-rid-of-all-casts-of-kalloc-calls drivers/net/wireless/prism54/isl_ioctl.c
--- a/drivers/net/wireless/prism54/isl_ioctl.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/net/wireless/prism54/isl_ioctl.c
@@ -2775,7 +2775,7 @@ prism54_hostapd(struct net_device *ndev,
            p->length > PRISM2_HOSTAPD_MAX_BUF_SIZE || !p->pointer)
                return -EINVAL;
 
-       param = (struct prism2_hostapd_param *) kmalloc(p->length, GFP_KERNEL);
+       param = kmalloc(p->length, GFP_KERNEL);
        if (param == NULL)
                return -ENOMEM;
 
diff -puN drivers/net/wireless/wavelan_cs.c~getting-rid-of-all-casts-of-kalloc-calls drivers/net/wireless/wavelan_cs.c
--- a/drivers/net/wireless/wavelan_cs.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/net/wireless/wavelan_cs.c
@@ -603,7 +603,7 @@ static wavepoint_history *wl_new_wavepoi
   if(lp->wavepoint_table.num_wavepoints==MAX_WAVEPOINTS)
     return NULL;
   
-  new_wavepoint=(wavepoint_history *) kmalloc(sizeof(wavepoint_history),GFP_ATOMIC);
+  new_wavepoint = kmalloc(sizeof(wavepoint_history),GFP_ATOMIC);
   if(new_wavepoint==NULL)
     return NULL;
   
diff -puN drivers/net/wireless/zd1211rw/zd_chip.c~getting-rid-of-all-casts-of-kalloc-calls drivers/net/wireless/zd1211rw/zd_chip.c
--- a/drivers/net/wireless/zd1211rw/zd_chip.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -101,7 +101,7 @@ int zd_ioread32v_locked(struct zd_chip *
 
 	/* Allocate a single memory block for values and addresses. */
 	count16 = 2*count;
-	a16 = (zd_addr_t *)kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)),
+	a16 = kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)),
 		                   GFP_NOFS);
 	if (!a16) {
 		dev_dbg_f(zd_chip_dev(chip),
diff -puN drivers/parisc/iosapic.c~getting-rid-of-all-casts-of-kalloc-calls drivers/parisc/iosapic.c
--- a/drivers/parisc/iosapic.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/parisc/iosapic.c
@@ -243,7 +243,7 @@ static struct irt_entry *iosapic_alloc_i
 	 * if CONFIG_DEBUG_SLAB is enabled, then we can get only
 	 * 4-byte alignment on 32-bit kernels
 	 */
-	a = (unsigned long)kmalloc(sizeof(struct irt_entry) * num_entries + 8, GFP_KERNEL);
+	a = kmalloc(sizeof(struct irt_entry) * num_entries + 8, GFP_KERNEL);
 	a = (a + 7UL) & ~7UL;
 	return (struct irt_entry *)a;
 }
@@ -874,7 +874,7 @@ void *iosapic_register(unsigned long hpa
 		return NULL;
 	}
 
-	isi = (struct iosapic_info *)kzalloc(sizeof(struct iosapic_info), GFP_KERNEL);
+	isi = kzalloc(sizeof(struct iosapic_info), GFP_KERNEL);
 	if (!isi) {
 		BUG();
 		return NULL;
diff -puN drivers/pci/hotplug/cpqphp_nvram.c~getting-rid-of-all-casts-of-kalloc-calls drivers/pci/hotplug/cpqphp_nvram.c
--- a/drivers/pci/hotplug/cpqphp_nvram.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/pci/hotplug/cpqphp_nvram.c
@@ -520,7 +520,7 @@ int compaq_nvram_load (void __iomem *rom
 			return 2;
 
 		while (nummem--) {
-			mem_node = (struct pci_resource*) kmalloc(sizeof(struct pci_resource), GFP_KERNEL);
+			mem_node = kmalloc(sizeof(struct pci_resource), GFP_KERNEL);
 
 			if (!mem_node)
 				break;
@@ -548,7 +548,7 @@ int compaq_nvram_load (void __iomem *rom
 		}
 
 		while (numpmem--) {
-			p_mem_node = (struct pci_resource*) kmalloc(sizeof(struct pci_resource), GFP_KERNEL);
+			p_mem_node = kmalloc(sizeof(struct pci_resource), GFP_KERNEL);
 
 			if (!p_mem_node)
 				break;
@@ -576,7 +576,7 @@ int compaq_nvram_load (void __iomem *rom
 		}
 
 		while (numio--) {
-			io_node = (struct pci_resource*) kmalloc(sizeof(struct pci_resource), GFP_KERNEL);
+			io_node = kmalloc(sizeof(struct pci_resource), GFP_KERNEL);
 
 			if (!io_node)
 				break;
@@ -604,7 +604,7 @@ int compaq_nvram_load (void __iomem *rom
 		}
 
 		while (numbus--) {
-			bus_node = (struct pci_resource*) kmalloc(sizeof(struct pci_resource), GFP_KERNEL);
+			bus_node = kmalloc(sizeof(struct pci_resource), GFP_KERNEL);
 
 			if (!bus_node)
 				break;
diff -puN drivers/pci/hotplug/pciehp_hpc.c~getting-rid-of-all-casts-of-kalloc-calls drivers/pci/hotplug/pciehp_hpc.c
--- a/drivers/pci/hotplug/pciehp_hpc.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/pci/hotplug/pciehp_hpc.c
@@ -1320,7 +1320,7 @@ int pcie_init(struct controller * ctrl, 
 	DBG_ENTER_ROUTINE
 	
 	spin_lock_init(&list_lock);	
-	php_ctlr = (struct php_ctlr_state_s *) kmalloc(sizeof(struct php_ctlr_state_s), GFP_KERNEL);
+	php_ctlr = kmalloc(sizeof(struct php_ctlr_state_s), GFP_KERNEL);
 
 	if (!php_ctlr) {	/* allocate controller state data */
 		err("%s: HPC controller memory allocation error!\n", __FUNCTION__);
diff -puN drivers/pci/pcie/aer/aerdrv.c~getting-rid-of-all-casts-of-kalloc-calls drivers/pci/pcie/aer/aerdrv.c
--- a/drivers/pci/pcie/aer/aerdrv.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/pci/pcie/aer/aerdrv.c
@@ -148,7 +148,7 @@ static struct aer_rpc* aer_alloc_rpc(str
 {
 	struct aer_rpc *rpc;
 
-	if (!(rpc = (struct aer_rpc *)kmalloc(sizeof(struct aer_rpc),
+	if (!(rpc = kmalloc(sizeof(struct aer_rpc),
 		GFP_KERNEL)))
 		return NULL;
 
diff -puN drivers/pci/rom.c~getting-rid-of-all-casts-of-kalloc-calls drivers/pci/rom.c
--- a/drivers/pci/rom.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/pci/rom.c
@@ -170,7 +170,7 @@ void __iomem *pci_map_rom_copy(struct pc
 			  IORESOURCE_ROM_BIOS_COPY))
 		return rom;
 
-	res->start = (unsigned long)kmalloc(*size, GFP_KERNEL);
+	res->start = kmalloc(*size, GFP_KERNEL);
 	if (!res->start)
 		return rom;
 
diff -puN drivers/pnp/pnpbios/core.c~getting-rid-of-all-casts-of-kalloc-calls drivers/pnp/pnpbios/core.c
--- a/drivers/pnp/pnpbios/core.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/pnp/pnpbios/core.c
@@ -109,7 +109,7 @@ static int pnp_dock_event(int dock, stru
 	if (!current->fs->root) {
 		return -EAGAIN;
 	}
-	if (!(envp = (char **) kcalloc (20, sizeof (char *), GFP_KERNEL))) {
+	if (!(envp = kcalloc(20, sizeof (char *), GFP_KERNEL))) {
 		return -ENOMEM;
 	}
 	if (!(buf = kzalloc(256, GFP_KERNEL))) {
diff -puN drivers/s390/char/con3215.c~getting-rid-of-all-casts-of-kalloc-calls drivers/s390/char/con3215.c
--- a/drivers/s390/char/con3215.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/s390/char/con3215.c
@@ -688,7 +688,7 @@ raw3215_probe (struct ccw_device *cdev)
 	raw->cdev = cdev;
 	raw->inbuf = (char *) raw + sizeof(struct raw3215_info);
 	memset(raw, 0, sizeof(struct raw3215_info));
-	raw->buffer = (char *) kmalloc(RAW3215_BUFFER_SIZE,
+	raw->buffer = kmalloc(RAW3215_BUFFER_SIZE,
 				       GFP_KERNEL|GFP_DMA);
 	if (raw->buffer == NULL) {
 		spin_lock(&raw3215_device_lock);
diff -puN drivers/s390/char/keyboard.c~getting-rid-of-all-casts-of-kalloc-calls drivers/s390/char/keyboard.c
--- a/drivers/s390/char/keyboard.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/s390/char/keyboard.c
@@ -377,7 +377,7 @@ do_kdsk_ioctl(struct kbd_data *kbd, stru
 		if (!(key_map = kbd->key_maps[tmp.kb_table])) {
 			int j;
 
-			key_map = (ushort *) kmalloc(sizeof(plain_map),
+			key_map = kmalloc(sizeof(plain_map),
 						     GFP_KERNEL);
 			if (!key_map)
 				return -ENOMEM;
diff -puN drivers/s390/char/sclp_cpi.c~getting-rid-of-all-casts-of-kalloc-calls drivers/s390/char/sclp_cpi.c
--- a/drivers/s390/char/sclp_cpi.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/s390/char/sclp_cpi.c
@@ -127,7 +127,7 @@ cpi_prepare_req(void)
 	struct cpi_sccb *sccb;
 	struct cpi_evbuf *evb;
 
-	req = (struct sclp_req *) kmalloc(sizeof(struct sclp_req), GFP_KERNEL);
+	req = kmalloc(sizeof(struct sclp_req), GFP_KERNEL);
 	if (req == NULL)
 		return ERR_PTR(-ENOMEM);
 	sccb = (struct cpi_sccb *) __get_free_page(GFP_KERNEL | GFP_DMA);
diff -puN drivers/s390/crypto/zcrypt_cex2a.c~getting-rid-of-all-casts-of-kalloc-calls drivers/s390/crypto/zcrypt_cex2a.c
--- a/drivers/s390/crypto/zcrypt_cex2a.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/s390/crypto/zcrypt_cex2a.c
@@ -295,7 +295,7 @@ static long zcrypt_cex2a_modexpo(struct 
 	struct completion work;
 	int rc;
 
-	ap_msg.message = (void *) kmalloc(CEX2A_MAX_MESSAGE_SIZE, GFP_KERNEL);
+	ap_msg.message = kmalloc(CEX2A_MAX_MESSAGE_SIZE, GFP_KERNEL);
 	if (!ap_msg.message)
 		return -ENOMEM;
 	ap_msg.psmid = (((unsigned long long) current->pid) << 32) +
@@ -337,7 +337,7 @@ static long zcrypt_cex2a_modexpo_crt(str
 	struct completion work;
 	int rc;
 
-	ap_msg.message = (void *) kmalloc(CEX2A_MAX_MESSAGE_SIZE, GFP_KERNEL);
+	ap_msg.message = kmalloc(CEX2A_MAX_MESSAGE_SIZE, GFP_KERNEL);
 	if (!ap_msg.message)
 		return -ENOMEM;
 	ap_msg.psmid = (((unsigned long long) current->pid) << 32) +
diff -puN drivers/s390/crypto/zcrypt_pcica.c~getting-rid-of-all-casts-of-kalloc-calls drivers/s390/crypto/zcrypt_pcica.c
--- a/drivers/s390/crypto/zcrypt_pcica.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/s390/crypto/zcrypt_pcica.c
@@ -279,7 +279,7 @@ static long zcrypt_pcica_modexpo(struct 
 	struct completion work;
 	int rc;
 
-	ap_msg.message = (void *) kmalloc(PCICA_MAX_MESSAGE_SIZE, GFP_KERNEL);
+	ap_msg.message = kmalloc(PCICA_MAX_MESSAGE_SIZE, GFP_KERNEL);
 	if (!ap_msg.message)
 		return -ENOMEM;
 	ap_msg.psmid = (((unsigned long long) current->pid) << 32) +
@@ -321,7 +321,7 @@ static long zcrypt_pcica_modexpo_crt(str
 	struct completion work;
 	int rc;
 
-	ap_msg.message = (void *) kmalloc(PCICA_MAX_MESSAGE_SIZE, GFP_KERNEL);
+	ap_msg.message = kmalloc(PCICA_MAX_MESSAGE_SIZE, GFP_KERNEL);
 	if (!ap_msg.message)
 		return -ENOMEM;
 	ap_msg.psmid = (((unsigned long long) current->pid) << 32) +
diff -puN drivers/s390/crypto/zcrypt_pcixcc.c~getting-rid-of-all-casts-of-kalloc-calls drivers/s390/crypto/zcrypt_pcixcc.c
--- a/drivers/s390/crypto/zcrypt_pcixcc.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/s390/crypto/zcrypt_pcixcc.c
@@ -717,7 +717,7 @@ long zcrypt_pcixcc_send_cprb(struct zcry
 	};
 	int rc;
 
-	ap_msg.message = (void *) kmalloc(PCIXCC_MAX_XCRB_MESSAGE_SIZE, GFP_KERNEL);
+	ap_msg.message = kmalloc(PCIXCC_MAX_XCRB_MESSAGE_SIZE, GFP_KERNEL);
 	if (!ap_msg.message)
 		return -ENOMEM;
 	ap_msg.psmid = (((unsigned long long) current->pid) << 32) +
diff -puN drivers/s390/net/ctcmain.c~getting-rid-of-all-casts-of-kalloc-calls drivers/s390/net/ctcmain.c
--- a/drivers/s390/net/ctcmain.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/s390/net/ctcmain.c
@@ -1646,7 +1646,7 @@ add_channel(struct ccw_device *cdev, enu
 		return -1;
 	}
 	memset(ch, 0, sizeof (struct channel));
-	if ((ch->ccw = (struct ccw1 *) kmalloc(8*sizeof(struct ccw1),
+	if ((ch->ccw = kmalloc(8*sizeof(struct ccw1),
 					       GFP_KERNEL | GFP_DMA)) == NULL) {
 		kfree(ch);
 		ctc_pr_warn("ctc: Out of memory in add_channel\n");
@@ -1693,7 +1693,7 @@ add_channel(struct ccw_device *cdev, enu
 		return -1;
 	}
 	fsm_newstate(ch->fsm, CH_STATE_IDLE);
-	if ((ch->irb = (struct irb *) kmalloc(sizeof (struct irb),
+	if ((ch->irb = kmalloc(sizeof (struct irb),
 					      GFP_KERNEL)) == NULL) {
 		ctc_pr_warn("ctc: Out of memory in add_channel\n");
 		kfree_fsm(ch->fsm);
@@ -2535,7 +2535,7 @@ ctc_print_statistics(struct ctc_priv *pr
 	DBF_TEXT(trace, 4, __FUNCTION__);
 	if (!priv)
 		return;
-	sbuf = (char *)kmalloc(2048, GFP_KERNEL);
+	sbuf = kmalloc(2048, GFP_KERNEL);
 	if (sbuf == NULL)
 		return;
 	p = sbuf;
diff -puN drivers/s390/net/iucv.c~getting-rid-of-all-casts-of-kalloc-calls drivers/s390/net/iucv.c
--- a/drivers/s390/net/iucv.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/s390/net/iucv.c
@@ -772,7 +772,7 @@ iucv_register_program (__u8 pgmname[16],
 	}
 
 	/* Allocate handler entry */
-	new_handler = (handler *)kmalloc(sizeof(handler), GFP_ATOMIC);
+	new_handler = kmalloc(sizeof(handler), GFP_ATOMIC);
 	if (new_handler == NULL) {
 		printk(KERN_WARNING "%s: storage allocation for new handler "
 		       "failed.\n", __FUNCTION__);
diff -puN drivers/s390/scsi/zfcp_aux.c~getting-rid-of-all-casts-of-kalloc-calls drivers/s390/scsi/zfcp_aux.c
--- a/drivers/s390/scsi/zfcp_aux.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/s390/scsi/zfcp_aux.c
@@ -237,7 +237,7 @@ zfcp_device_setup(char *devstr)
 		return 0;
 
 	len = strlen(devstr) + 1;
-	str = (char *) kmalloc(len, GFP_KERNEL);
+	str = kmalloc(len, GFP_KERNEL);
 	if (!str)
 		goto err_out;
 	memcpy(str, devstr, len);
diff -puN drivers/sbus/char/vfc_dev.c~getting-rid-of-all-casts-of-kalloc-calls drivers/sbus/char/vfc_dev.c
--- a/drivers/sbus/char/vfc_dev.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/sbus/char/vfc_dev.c
@@ -659,7 +659,7 @@ static int vfc_probe(void)
 	if (!cards)
 		return -ENODEV;
 
-	vfc_dev_lst = (struct vfc_dev **)kmalloc(sizeof(struct vfc_dev *) *
+	vfc_dev_lst = kmalloc(sizeof(struct vfc_dev *) *
 						 (cards+1),
 						 GFP_KERNEL);
 	if (vfc_dev_lst == NULL)
diff -puN drivers/scsi/aacraid/aachba.c~getting-rid-of-all-casts-of-kalloc-calls drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/scsi/aacraid/aachba.c
@@ -288,7 +288,7 @@ int aac_get_containers(struct aac_dev *d
 
 	if (maximum_num_containers < MAXIMUM_NUM_CONTAINERS)
 		maximum_num_containers = MAXIMUM_NUM_CONTAINERS;
-	fsa_dev_ptr = (struct fsa_dev_info *) kmalloc(
+	fsa_dev_ptr = kmalloc(
 	  sizeof(*fsa_dev_ptr) * maximum_num_containers, GFP_KERNEL);
 	if (!fsa_dev_ptr) {
 		aac_fib_free(fibptr);
diff -puN drivers/scsi/aacraid/comminit.c~getting-rid-of-all-casts-of-kalloc-calls drivers/scsi/aacraid/comminit.c
--- a/drivers/scsi/aacraid/comminit.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/scsi/aacraid/comminit.c
@@ -386,7 +386,7 @@ struct aac_dev *aac_init_adapter(struct 
 	 *	Ok now init the communication subsystem
 	 */
 
-	dev->queues = (struct aac_queue_block *) kmalloc(sizeof(struct aac_queue_block), GFP_KERNEL);
+	dev->queues = kmalloc(sizeof(struct aac_queue_block), GFP_KERNEL);
 	if (dev->queues == NULL) {
 		printk(KERN_ERR "Error could not allocate comm region.\n");
 		return NULL;
diff -puN drivers/scsi/aha1542.c~getting-rid-of-all-casts-of-kalloc-calls drivers/scsi/aha1542.c
--- a/drivers/scsi/aha1542.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/scsi/aha1542.c
@@ -699,7 +699,7 @@ static int aha1542_queuecommand(Scsi_Cmn
 #endif
 		int i;
 		ccb[mbo].op = 2;	/* SCSI Initiator Command  w/scatter-gather */
-		SCpnt->host_scribble = (unsigned char *) kmalloc(512, GFP_KERNEL | GFP_DMA);
+		SCpnt->host_scribble = kmalloc(512, GFP_KERNEL | GFP_DMA);
 		sgpnt = (struct scatterlist *) SCpnt->request_buffer;
 		cptr = (struct chain *) SCpnt->host_scribble;
 		if (cptr == NULL) {
diff -puN drivers/scsi/aic7xxx_old.c~getting-rid-of-all-casts-of-kalloc-calls drivers/scsi/aic7xxx_old.c
--- a/drivers/scsi/aic7xxx_old.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/scsi/aic7xxx_old.c
@@ -2565,7 +2565,7 @@ aic7xxx_allocate_scb(struct aic7xxx_host
       }
     }
     scb_count = min( (i-1), p->scb_data->maxscbs - p->scb_data->numscbs);
-    scb_ap = (struct aic7xxx_scb *)kmalloc(sizeof (struct aic7xxx_scb) * scb_count
+    scb_ap = kmalloc(sizeof (struct aic7xxx_scb) * scb_count
 					   + sizeof(struct aic7xxx_scb_dma), GFP_ATOMIC);
     if (scb_ap == NULL)
       return(0);
diff -puN drivers/scsi/dc395x.c~getting-rid-of-all-casts-of-kalloc-calls drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/scsi/dc395x.c
@@ -4319,7 +4319,7 @@ static int __devinit adapter_sg_tables_a
 
 	dprintkdbg(DBG_1, "Allocate %i pages for SG tables\n", pages);
 	while (pages--) {
-		ptr = (struct SGentry *)kmalloc(PAGE_SIZE, GFP_KERNEL);
+		ptr = kmalloc(PAGE_SIZE, GFP_KERNEL);
 		if (!ptr) {
 			adapter_sg_tables_free(acb);
 			return 1;
diff -puN drivers/scsi/dpt_i2o.c~getting-rid-of-all-casts-of-kalloc-calls drivers/scsi/dpt_i2o.c
--- a/drivers/scsi/dpt_i2o.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/scsi/dpt_i2o.c
@@ -295,7 +295,7 @@ static void adpt_inquiry(adpt_hba* pHba)
 	s32 rcode;
 
 	memset(msg, 0, sizeof(msg));
-	buf = (u8*)kmalloc(80,GFP_KERNEL|ADDR32);
+	buf = kmalloc(80,GFP_KERNEL|ADDR32);
 	if(!buf){
 		printk(KERN_ERR"%s: Could not allocate buffer\n",pHba->name);
 		return;
@@ -1309,7 +1309,7 @@ static s32 adpt_i2o_reset_hba(adpt_hba* 
 		schedule_timeout_uninterruptible(1);
 	} while (m == EMPTY_QUEUE);
 
-	status = (u8*)kmalloc(4, GFP_KERNEL|ADDR32);
+	status = kmalloc(4, GFP_KERNEL|ADDR32);
 	if(status == NULL) {
 		adpt_send_nop(pHba, m);
 		printk(KERN_ERR"IOP reset failed - no free memory.\n");
@@ -1442,7 +1442,7 @@ static int adpt_i2o_parse_lct(adpt_hba* 
 			}
 			continue;
 		}
-		d = (struct i2o_device *)kmalloc(sizeof(struct i2o_device), GFP_KERNEL);
+		d = kmalloc(sizeof(struct i2o_device), GFP_KERNEL);
 		if(d==NULL)
 		{
 			printk(KERN_CRIT"%s: Out of memory for I2O device data.\n",pHba->name);
@@ -2423,7 +2423,7 @@ static s32 adpt_i2o_reparse_lct(adpt_hba
 				pDev = pDev->next_lun;
 			}
 			if(!pDev ) { // Something new add it
-				d = (struct i2o_device *)kmalloc(sizeof(struct i2o_device), GFP_KERNEL);
+				d = kmalloc(sizeof(struct i2o_device), GFP_KERNEL);
 				if(d==NULL)
 				{
 					printk(KERN_CRIT "Out of memory for I2O device data.\n");
@@ -2726,7 +2726,7 @@ static s32 adpt_i2o_init_outbound_q(adpt
 
 	kfree(pHba->reply_pool);
 
-	pHba->reply_pool = (u32*)kmalloc(pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4, GFP_KERNEL|ADDR32);
+	pHba->reply_pool = kmalloc(pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4, GFP_KERNEL|ADDR32);
 	if(!pHba->reply_pool){
 		printk(KERN_ERR"%s: Could not allocate reply pool\n",pHba->name);
 		return -1;
diff -puN drivers/scsi/initio.c~getting-rid-of-all-casts-of-kalloc-calls drivers/scsi/initio.c
--- a/drivers/scsi/initio.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/scsi/initio.c
@@ -2828,7 +2828,7 @@ static int i91u_detect(struct scsi_host_
 
 	for (; tul_num_scb >= MAX_TARGETS + 3; tul_num_scb--) {
 		i = tul_num_ch * tul_num_scb * sizeof(SCB);
-		if ((tul_scb = (SCB *) kmalloc(i, GFP_ATOMIC | GFP_DMA)) != NULL)
+		if ((tul_scb = kmalloc(i, GFP_ATOMIC | GFP_DMA)) != NULL)
 			break;
 	}
 	if (tul_scb == NULL) {
diff -puN drivers/scsi/osst.c~getting-rid-of-all-casts-of-kalloc-calls drivers/scsi/osst.c
--- a/drivers/scsi/osst.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/scsi/osst.c
@@ -5777,7 +5777,7 @@ static int osst_probe(struct device *dev
 	dev_num = i;
 
 	/* allocate a struct osst_tape for this device */
-	tpnt = (struct osst_tape *)kmalloc(sizeof(struct osst_tape), GFP_ATOMIC);
+	tpnt = kmalloc(sizeof(struct osst_tape), GFP_ATOMIC);
 	if (tpnt == NULL) {
 		write_unlock(&os_scsi_tapes_lock);
 		printk(KERN_ERR "osst :E: Can't allocate device descriptor, device not attached.\n");
diff -puN drivers/scsi/pluto.c~getting-rid-of-all-casts-of-kalloc-calls drivers/scsi/pluto.c
--- a/drivers/scsi/pluto.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/scsi/pluto.c
@@ -117,7 +117,7 @@ int __init pluto_detect(struct scsi_host
 #endif
 			return 0;
 	}
-	fcs = (struct ctrl_inquiry *) kmalloc (sizeof (struct ctrl_inquiry) * fcscount, GFP_DMA);
+	fcs = kmalloc(sizeof (struct ctrl_inquiry) * fcscount, GFP_DMA);
 	if (!fcs) {
 		printk ("PLUTO: Not enough memory to probe\n");
 		return 0;
diff -puN drivers/scsi/sr_ioctl.c~getting-rid-of-all-casts-of-kalloc-calls drivers/scsi/sr_ioctl.c
--- a/drivers/scsi/sr_ioctl.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/scsi/sr_ioctl.c
@@ -546,7 +546,7 @@ int sr_is_xa(Scsi_CD *cd)
 	if (!xa_test)
 		return 0;
 
-	raw_sector = (unsigned char *) kmalloc(2048, GFP_KERNEL | SR_GFP_DMA(cd));
+	raw_sector = kmalloc(2048, GFP_KERNEL | SR_GFP_DMA(cd));
 	if (!raw_sector)
 		return -ENOMEM;
 	if (0 == sr_read_sector(cd, cd->ms_offset + 16,
diff -puN drivers/scsi/sr_vendor.c~getting-rid-of-all-casts-of-kalloc-calls drivers/scsi/sr_vendor.c
--- a/drivers/scsi/sr_vendor.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/scsi/sr_vendor.c
@@ -117,7 +117,7 @@ int sr_set_blocklength(Scsi_CD *cd, int 
 		density = (blocklength > 2048) ? 0x81 : 0x83;
 #endif
 
-	buffer = (unsigned char *) kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -164,7 +164,7 @@ int sr_cd_check(struct cdrom_device_info
 	if (cd->cdi.mask & CDC_MULTI_SESSION)
 		return 0;
 
-	buffer = (unsigned char *) kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
 	if (!buffer)
 		return -ENOMEM;
 
diff -puN drivers/usb/gadget/serial.c~getting-rid-of-all-casts-of-kalloc-calls drivers/usb/gadget/serial.c
--- a/drivers/usb/gadget/serial.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/usb/gadget/serial.c
@@ -2195,7 +2195,7 @@ static struct gs_buf *gs_buf_alloc(unsig
 	if (size == 0)
 		return NULL;
 
-	gb = (struct gs_buf *)kmalloc(sizeof(struct gs_buf), kmalloc_flags);
+	gb = kmalloc(sizeof(struct gs_buf), kmalloc_flags);
 	if (gb == NULL)
 		return NULL;
 
diff -puN drivers/usb/host/hc_crisv10.c~getting-rid-of-all-casts-of-kalloc-calls drivers/usb/host/hc_crisv10.c
--- a/drivers/usb/host/hc_crisv10.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/usb/host/hc_crisv10.c
@@ -365,7 +365,7 @@ static inline struct urb *urb_list_first
 /* Adds an urb_entry last in the list for this epid. */
 static inline void urb_list_add(struct urb *urb, int epid)
 {
-	urb_entry_t *urb_entry = (urb_entry_t *)kmalloc(sizeof(urb_entry_t), KMALLOC_FLAG);
+	urb_entry_t *urb_entry = kmalloc(sizeof(urb_entry_t), KMALLOC_FLAG);
 	assert(urb_entry);
 
 	urb_entry->urb = urb;
diff -puN drivers/usb/misc/auerswald.c~getting-rid-of-all-casts-of-kalloc-calls drivers/usb/misc/auerswald.c
--- a/drivers/usb/misc/auerswald.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/usb/misc/auerswald.c
@@ -766,7 +766,7 @@ static int auerbuf_setup (pauerbufctl_t 
                 bep->bufp = kmalloc (bufsize, GFP_KERNEL);
                 if (!bep->bufp)
 			goto bl_fail;
-                bep->dr = (struct usb_ctrlrequest *) kmalloc (sizeof (struct usb_ctrlrequest), GFP_KERNEL);
+                bep->dr = kmalloc(sizeof (struct usb_ctrlrequest), GFP_KERNEL);
                 if (!bep->dr)
 			goto bl_fail;
                 bep->urbp = usb_alloc_urb (0, GFP_KERNEL);
@@ -1967,7 +1967,7 @@ static int auerswald_probe (struct usb_i
 	info("device is a %s", cp->dev_desc);
 
         /* get the maximum allowed control transfer length */
-        pbuf = (__le16 *) kmalloc (2, GFP_KERNEL);    /* use an allocated buffer because of urb target */
+        pbuf = kmalloc(2, GFP_KERNEL);    /* use an allocated buffer because of urb target */
         if (!pbuf) {
 		err( "out of memory");
 		goto pfail;
diff -puN drivers/usb/serial/cypress_m8.c~getting-rid-of-all-casts-of-kalloc-calls drivers/usb/serial/cypress_m8.c
--- a/drivers/usb/serial/cypress_m8.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/usb/serial/cypress_m8.c
@@ -1478,7 +1478,7 @@ static struct cypress_buf *cypress_buf_a
 	if (size == 0)
 		return NULL;
 
-	cb = (struct cypress_buf *)kmalloc(sizeof(struct cypress_buf), GFP_KERNEL);
+	cb = kmalloc(sizeof(struct cypress_buf), GFP_KERNEL);
 	if (cb == NULL)
 		return NULL;
 
diff -puN drivers/usb/serial/digi_acceleport.c~getting-rid-of-all-casts-of-kalloc-calls drivers/usb/serial/digi_acceleport.c
--- a/drivers/usb/serial/digi_acceleport.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/usb/serial/digi_acceleport.c
@@ -1681,7 +1681,7 @@ dbg( "digi_startup: TOP" );
 	for( i=0; i<serial->type->num_ports+1; i++ ) {
 
 		/* allocate port private structure */
-		priv = (struct digi_port *)kmalloc( sizeof(struct digi_port),
+		priv = kmalloc( sizeof(struct digi_port),
 			GFP_KERNEL );
 		if( priv == (struct digi_port *)0 ) {
 			while( --i >= 0 )
@@ -1714,7 +1714,7 @@ dbg( "digi_startup: TOP" );
 	}
 
 	/* allocate serial private structure */
-	serial_priv = (struct digi_serial *)kmalloc( sizeof(struct digi_serial),
+	serial_priv = kmalloc( sizeof(struct digi_serial),
 		GFP_KERNEL );
 	if( serial_priv == (struct digi_serial *)0 ) {
 		for( i=0; i<serial->type->num_ports+1; i++ )
diff -puN drivers/usb/serial/io_ti.c~getting-rid-of-all-casts-of-kalloc-calls drivers/usb/serial/io_ti.c
--- a/drivers/usb/serial/io_ti.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/usb/serial/io_ti.c
@@ -2811,7 +2811,7 @@ static struct edge_buf *edge_buf_alloc(u
 	if (size == 0)
 		return NULL;
 
-	eb = (struct edge_buf *)kmalloc(sizeof(struct edge_buf), GFP_KERNEL);
+	eb = kmalloc(sizeof(struct edge_buf), GFP_KERNEL);
 	if (eb == NULL)
 		return NULL;
 
diff -puN drivers/usb/serial/ipaq.c~getting-rid-of-all-casts-of-kalloc-calls drivers/usb/serial/ipaq.c
--- a/drivers/usb/serial/ipaq.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/usb/serial/ipaq.c
@@ -595,7 +595,7 @@ static int ipaq_open(struct usb_serial_p
 
 	bytes_in = 0;
 	bytes_out = 0;
-	priv = (struct ipaq_private *)kmalloc(sizeof(struct ipaq_private), GFP_KERNEL);
+	priv = kmalloc(sizeof(struct ipaq_private), GFP_KERNEL);
 	if (priv == NULL) {
 		err("%s - Out of memory", __FUNCTION__);
 		return -ENOMEM;
diff -puN drivers/usb/serial/kobil_sct.c~getting-rid-of-all-casts-of-kalloc-calls drivers/usb/serial/kobil_sct.c
--- a/drivers/usb/serial/kobil_sct.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/usb/serial/kobil_sct.c
@@ -269,7 +269,7 @@ static int kobil_open (struct usb_serial
 	}
 
 	// allocate memory for write_urb transfer buffer
-	port->write_urb->transfer_buffer = (unsigned char *) kmalloc(write_urb_transfer_buffer_length, GFP_KERNEL);
+	port->write_urb->transfer_buffer = kmalloc(write_urb_transfer_buffer_length, GFP_KERNEL);
 	if (! port->write_urb->transfer_buffer) {
 		kfree(transfer_buffer);
 		usb_free_urb(port->write_urb);
@@ -696,7 +696,7 @@ static int  kobil_ioctl(struct usb_seria
 		return 0;
 
 	case TCFLSH:   // 0x540B
-		transfer_buffer = (unsigned char *) kmalloc(transfer_buffer_length, GFP_KERNEL);
+		transfer_buffer = kmalloc(transfer_buffer_length, GFP_KERNEL);
 		if (! transfer_buffer) {
 		 	return -ENOBUFS;
 		}
diff -puN drivers/usb/serial/pl2303.c~getting-rid-of-all-casts-of-kalloc-calls drivers/usb/serial/pl2303.c
--- a/drivers/usb/serial/pl2303.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/usb/serial/pl2303.c
@@ -159,7 +159,7 @@ static struct pl2303_buf *pl2303_buf_all
 	if (size == 0)
 		return NULL;
 
-	pb = (struct pl2303_buf *)kmalloc(sizeof(struct pl2303_buf), GFP_KERNEL);
+	pb = kmalloc(sizeof(struct pl2303_buf), GFP_KERNEL);
 	if (pb == NULL)
 		return NULL;
 
diff -puN drivers/usb/serial/ti_usb_3410_5052.c~getting-rid-of-all-casts-of-kalloc-calls drivers/usb/serial/ti_usb_3410_5052.c
--- a/drivers/usb/serial/ti_usb_3410_5052.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/usb/serial/ti_usb_3410_5052.c
@@ -1710,7 +1710,7 @@ static struct circ_buf *ti_buf_alloc(voi
 {
 	struct circ_buf *cb;
 
-	cb = (struct circ_buf *)kmalloc(sizeof(struct circ_buf), GFP_KERNEL);
+	cb = kmalloc(sizeof(struct circ_buf), GFP_KERNEL);
 	if (cb == NULL)
 		return NULL;
 
diff -puN drivers/usb/serial/whiteheat.c~getting-rid-of-all-casts-of-kalloc-calls drivers/usb/serial/whiteheat.c
--- a/drivers/usb/serial/whiteheat.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/usb/serial/whiteheat.c
@@ -416,7 +416,7 @@ static int whiteheat_attach (struct usb_
 	for (i = 0; i < serial->num_ports; i++) {
 		port = serial->port[i];
 
-		info = (struct whiteheat_private *)kmalloc(sizeof(struct whiteheat_private), GFP_KERNEL);
+		info = kmalloc(sizeof(struct whiteheat_private), GFP_KERNEL);
 		if (info == NULL) {
 			err("%s: Out of memory for port structures\n", serial->type->description);
 			goto no_private;
@@ -487,7 +487,7 @@ static int whiteheat_attach (struct usb_
 		usb_set_serial_port_data(port, info);
 	}
 
-	command_info = (struct whiteheat_command_private *)kmalloc(sizeof(struct whiteheat_command_private), GFP_KERNEL);
+	command_info = kmalloc(sizeof(struct whiteheat_command_private), GFP_KERNEL);
 	if (command_info == NULL) {
 		err("%s: Out of memory for port structures\n", serial->type->description);
 		goto no_command_private;
diff -puN drivers/usb/storage/sddr09.c~getting-rid-of-all-casts-of-kalloc-calls drivers/usb/storage/sddr09.c
--- a/drivers/usb/storage/sddr09.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/usb/storage/sddr09.c
@@ -646,7 +646,7 @@ sddr09_read_sg_test_only(struct us_data 
 		return result;
 	}
 
-	buf = (unsigned char *) kmalloc(bulklen, GFP_NOIO);
+	buf = kmalloc(bulklen, GFP_NOIO);
 	if (!buf)
 		return -ENOMEM;
 
diff -puN drivers/video/amba-clcd.c~getting-rid-of-all-casts-of-kalloc-calls drivers/video/amba-clcd.c
--- a/drivers/video/amba-clcd.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/video/amba-clcd.c
@@ -447,7 +447,7 @@ static int clcdfb_probe(struct amba_devi
 		goto out;
 	}
 
-	fb = (struct clcd_fb *) kmalloc(sizeof(struct clcd_fb), GFP_KERNEL);
+	fb = kmalloc(sizeof(struct clcd_fb), GFP_KERNEL);
 	if (!fb) {
 		printk(KERN_INFO "CLCD: could not allocate new clcd_fb struct\n");
 		ret = -ENOMEM;
diff -puN drivers/video/matrox/i2c-matroxfb.c~getting-rid-of-all-casts-of-kalloc-calls drivers/video/matrox/i2c-matroxfb.c
--- a/drivers/video/matrox/i2c-matroxfb.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/video/matrox/i2c-matroxfb.c
@@ -146,7 +146,7 @@ static void* i2c_matroxfb_probe(struct m
 	unsigned long flags;
 	struct matroxfb_dh_maven_info* m2info;
 
-	m2info = (struct matroxfb_dh_maven_info*)kmalloc(sizeof(*m2info), GFP_KERNEL);
+	m2info = kmalloc(sizeof(*m2info), GFP_KERNEL);
 	if (!m2info)
 		return NULL;
 
diff -puN drivers/video/matrox/matroxfb_base.c~getting-rid-of-all-casts-of-kalloc-calls drivers/video/matrox/matroxfb_base.c
--- a/drivers/video/matrox/matroxfb_base.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/video/matrox/matroxfb_base.c
@@ -2028,7 +2028,7 @@ static int matroxfb_probe(struct pci_dev
 	}
 
 #ifdef CONFIG_FB_MATROX_MULTIHEAD
-	minfo = (struct matrox_fb_info*)kmalloc(sizeof(*minfo), GFP_KERNEL);
+	minfo = kmalloc(sizeof(*minfo), GFP_KERNEL);
 	if (!minfo)
 		return -1;
 #else
diff -puN drivers/video/matrox/matroxfb_crtc2.c~getting-rid-of-all-casts-of-kalloc-calls drivers/video/matrox/matroxfb_crtc2.c
--- a/drivers/video/matrox/matroxfb_crtc2.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/drivers/video/matrox/matroxfb_crtc2.c
@@ -694,7 +694,7 @@ static void* matroxfb_crtc2_probe(struct
 	/* hardware is CRTC2 incapable... */
 	if (!ACCESS_FBINFO(devflags.crtc2))
 		return NULL;
-	m2info = (struct matroxfb_dh_fb_info*)kmalloc(sizeof(*m2info), GFP_KERNEL);
+	m2info = kmalloc(sizeof(*m2info), GFP_KERNEL);
 	if (!m2info) {
 		printk(KERN_ERR "matroxfb_crtc2: Not enough memory for CRTC2 control structs\n");
 		return NULL;
diff -puN fs/autofs4/inode.c~getting-rid-of-all-casts-of-kalloc-calls fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/fs/autofs4/inode.c
@@ -313,7 +313,7 @@ int autofs4_fill_super(struct super_bloc
 	struct autofs_sb_info *sbi;
 	struct autofs_info *ino;
 
-	sbi = (struct autofs_sb_info *) kmalloc(sizeof(*sbi), GFP_KERNEL);
+	sbi = kmalloc(sizeof(*sbi), GFP_KERNEL);
 	if ( !sbi )
 		goto fail_unlock;
 	DPRINTK("starting up, sbi = %p",sbi);
diff -puN fs/befs/btree.c~getting-rid-of-all-casts-of-kalloc-calls fs/befs/btree.c
--- a/fs/befs/btree.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/fs/befs/btree.c
@@ -260,7 +260,7 @@ befs_btree_find(struct super_block *sb, 
 		goto error;
 	}
 
-	this_node = (befs_btree_node *) kmalloc(sizeof (befs_btree_node),
+	this_node = kmalloc(sizeof (befs_btree_node),
 						GFP_NOFS);
 	if (!this_node) {
 		befs_error(sb, "befs_btree_find() failed to allocate %u "
diff -puN fs/befs/debug.c~getting-rid-of-all-casts-of-kalloc-calls fs/befs/debug.c
--- a/fs/befs/debug.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/fs/befs/debug.c
@@ -28,7 +28,7 @@ void
 befs_error(const struct super_block *sb, const char *fmt, ...)
 {
 	va_list args;
-	char *err_buf = (char *) kmalloc(ERRBUFSIZE, GFP_KERNEL);
+	char *err_buf = kmalloc(ERRBUFSIZE, GFP_KERNEL);
 	if (err_buf == NULL) {
 		printk(KERN_ERR "could not allocate %d bytes\n", ERRBUFSIZE);
 		return;
@@ -46,7 +46,7 @@ void
 befs_warning(const struct super_block *sb, const char *fmt, ...)
 {
 	va_list args;
-	char *err_buf = (char *) kmalloc(ERRBUFSIZE, GFP_KERNEL);
+	char *err_buf = kmalloc(ERRBUFSIZE, GFP_KERNEL);
 	if (err_buf == NULL) {
 		printk(KERN_ERR "could not allocate %d bytes\n", ERRBUFSIZE);
 		return;
@@ -70,7 +70,7 @@ befs_debug(const struct super_block *sb,
 	char *err_buf = NULL;
 
 	if (BEFS_SB(sb)->mount_opts.debug) {
-		err_buf = (char *) kmalloc(ERRBUFSIZE, GFP_KERNEL);
+		err_buf = kmalloc(ERRBUFSIZE, GFP_KERNEL);
 		if (err_buf == NULL) {
 			printk(KERN_ERR "could not allocate %d bytes\n",
 				ERRBUFSIZE);
diff -puN fs/binfmt_misc.c~getting-rid-of-all-casts-of-kalloc-calls fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/fs/binfmt_misc.c
@@ -311,7 +311,7 @@ static Node *create_entry(const char __u
 
 	err = -ENOMEM;
 	memsize = sizeof(Node) + count + 8;
-	e = (Node *) kmalloc(memsize, GFP_USER);
+	e = kmalloc(memsize, GFP_USER);
 	if (!e)
 		goto out;
 
diff -puN fs/cifs/cifssmb.c~getting-rid-of-all-casts-of-kalloc-calls fs/cifs/cifssmb.c
--- a/fs/cifs/cifssmb.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/fs/cifs/cifssmb.c
@@ -4876,7 +4876,7 @@ int CIFSSMBNotify(const int xid, struct 
 	} else {
 		/* Add file to outstanding requests */
 		/* BB change to kmem cache alloc */	
-		dnotify_req = (struct dir_notify_req *) kmalloc(
+		dnotify_req = kmalloc(
 						sizeof(struct dir_notify_req),
 						 GFP_KERNEL);
 		if(dnotify_req) {
diff -puN fs/jffs/inode-v23.c~getting-rid-of-all-casts-of-kalloc-calls fs/jffs/inode-v23.c
--- a/fs/jffs/inode-v23.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/fs/jffs/inode-v23.c
@@ -818,7 +818,7 @@ jffs_mkdir(struct inode *dir, struct den
 
 	D1({
 	        int len = dentry->d_name.len;
-		char *_name = (char *) kmalloc(len + 1, GFP_KERNEL);
+		char *_name = kmalloc(len + 1, GFP_KERNEL);
 		memcpy(_name, dentry->d_name.name, len);
 		_name[len] = '\0';
 		printk("***jffs_mkdir(): dir = 0x%p, name = \"%s\", "
@@ -964,7 +964,7 @@ jffs_remove(struct inode *dir, struct de
 	D1({
 		int len = dentry->d_name.len;
 		const char *name = dentry->d_name.name;
-		char *_name = (char *) kmalloc(len + 1, GFP_KERNEL);
+		char *_name = kmalloc(len + 1, GFP_KERNEL);
 		memcpy(_name, name, len);
 		_name[len] = '\0';
 		printk("***jffs_remove(): file = \"%s\", ino = %ld\n", _name, dentry->d_inode->i_ino);
diff -puN fs/jffs/intrep.c~getting-rid-of-all-casts-of-kalloc-calls fs/jffs/intrep.c
--- a/fs/jffs/intrep.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/fs/jffs/intrep.c
@@ -436,7 +436,7 @@ jffs_checksum_flash(struct mtd_info *mtd
 	int i, length;
 
 	/* Allocate read buffer */
-	read_buf = (__u8 *) kmalloc (sizeof(__u8) * 4096, GFP_KERNEL);
+	read_buf = kmalloc(sizeof(__u8) * 4096, GFP_KERNEL);
 	if (!read_buf) {
 		printk(KERN_NOTICE "kmalloc failed in jffs_checksum_flash()\n");
 		return -ENOMEM;
@@ -744,11 +744,11 @@ static int check_partly_erased_sectors(s
 
 
 	/* Allocate read buffers */
-	read_buf1 = (__u8 *) kmalloc (sizeof(__u8) * READ_AHEAD_BYTES, GFP_KERNEL);
+	read_buf1 = kmalloc(sizeof(__u8) * READ_AHEAD_BYTES, GFP_KERNEL);
 	if (!read_buf1)
 		return -ENOMEM;
 
-	read_buf2 = (__u8 *) kmalloc (sizeof(__u8) * READ_AHEAD_BYTES, GFP_KERNEL);
+	read_buf2 = kmalloc(sizeof(__u8) * READ_AHEAD_BYTES, GFP_KERNEL);
 	if (!read_buf2) {
 		kfree(read_buf1);
 		return -ENOMEM;
@@ -876,7 +876,7 @@ jffs_scan_flash(struct jffs_control *c)
 	}
 
 	/* Allocate read buffer */
-	read_buf = (__u8 *) kmalloc (sizeof(__u8) * 4096, GFP_KERNEL);
+	read_buf = kmalloc(sizeof(__u8) * 4096, GFP_KERNEL);
 	if (!read_buf) {
 		flash_safe_release(fmc->mtd);
 		return -ENOMEM;
@@ -1463,7 +1463,7 @@ jffs_insert_node(struct jffs_control *c,
 			kfree(f->name);
 			DJM(no_name--);
 		}
-		if (!(f->name = (char *) kmalloc(raw_inode->nsize + 1,
+		if (!(f->name = kmalloc(raw_inode->nsize + 1,
 						 GFP_KERNEL))) {
 			return -ENOMEM;
 		}
@@ -1737,7 +1737,7 @@ jffs_find_child(struct jffs_file *dir, c
 		printk("jffs_find_child(): Found \"%s\".\n", f->name);
 	}
 	else {
-		char *copy = (char *) kmalloc(len + 1, GFP_KERNEL);
+		char *copy = kmalloc(len + 1, GFP_KERNEL);
 		if (copy) {
 			memcpy(copy, name, len);
 			copy[len] = '\0';
@@ -2627,7 +2627,7 @@ jffs_print_tree(struct jffs_file *first_
 		return;
 	}
 
-	if (!(space = (char *) kmalloc(indent + 1, GFP_KERNEL))) {
+	if (!(space = kmalloc(indent + 1, GFP_KERNEL))) {
 		printk("jffs_print_tree(): Out of memory!\n");
 		return;
 	}
diff -puN fs/jfs/jfs_dtree.c~getting-rid-of-all-casts-of-kalloc-calls fs/jfs/jfs_dtree.c
--- a/fs/jfs/jfs_dtree.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/fs/jfs/jfs_dtree.c
@@ -3777,12 +3777,12 @@ static int ciGetLeafPrefixKey(dtpage_t *
 	struct component_name lkey;
 	struct component_name rkey;
 
-	lkey.name = (wchar_t *) kmalloc((JFS_NAME_MAX + 1) * sizeof(wchar_t),
+	lkey.name = kmalloc((JFS_NAME_MAX + 1) * sizeof(wchar_t),
 					GFP_KERNEL);
 	if (lkey.name == NULL)
 		return -ENOMEM;
 
-	rkey.name = (wchar_t *) kmalloc((JFS_NAME_MAX + 1) * sizeof(wchar_t),
+	rkey.name = kmalloc((JFS_NAME_MAX + 1) * sizeof(wchar_t),
 					GFP_KERNEL);
 	if (rkey.name == NULL) {
 		kfree(lkey.name);
diff -puN fs/jfs/jfs_imap.c~getting-rid-of-all-casts-of-kalloc-calls fs/jfs/jfs_imap.c
--- a/fs/jfs/jfs_imap.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/fs/jfs/jfs_imap.c
@@ -120,7 +120,7 @@ int diMount(struct inode *ipimap)
 	 * allocate/initialize the in-memory inode map control structure
 	 */
 	/* allocate the in-memory inode map control structure. */
-	imap = (struct inomap *) kmalloc(sizeof(struct inomap), GFP_KERNEL);
+	imap = kmalloc(sizeof(struct inomap), GFP_KERNEL);
 	if (imap == NULL) {
 		jfs_err("diMount: kmalloc returned NULL!");
 		return -ENOMEM;
diff -puN fs/lockd/svcshare.c~getting-rid-of-all-casts-of-kalloc-calls fs/lockd/svcshare.c
--- a/fs/lockd/svcshare.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/fs/lockd/svcshare.c
@@ -39,7 +39,7 @@ nlmsvc_share_file(struct nlm_host *host,
 			return nlm_lck_denied;
 	}
 
-	share = (struct nlm_share *) kmalloc(sizeof(*share) + oh->len,
+	share = kmalloc(sizeof(*share) + oh->len,
 						GFP_KERNEL);
 	if (share == NULL)
 		return nlm_lck_denied_nolocks;
diff -puN fs/nfs/nfs4proc.c~getting-rid-of-all-casts-of-kalloc-calls fs/nfs/nfs4proc.c
--- a/fs/nfs/nfs4proc.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/fs/nfs/nfs4proc.c
@@ -1877,7 +1877,7 @@ static int nfs4_proc_unlink_setup(struct
 	struct nfs_server *server = NFS_SERVER(dir->d_inode);
 	struct unlink_desc *up;
 
-	up = (struct unlink_desc *) kmalloc(sizeof(*up), GFP_KERNEL);
+	up = kmalloc(sizeof(*up), GFP_KERNEL);
 	if (!up)
 		return -ENOMEM;
 	
diff -puN fs/reiserfs/xattr_acl.c~getting-rid-of-all-casts-of-kalloc-calls fs/reiserfs/xattr_acl.c
--- a/fs/reiserfs/xattr_acl.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/fs/reiserfs/xattr_acl.c
@@ -135,7 +135,7 @@ static void *posix_acl_to_disk(const str
 	int n;
 
 	*size = reiserfs_acl_size(acl->a_count);
-	ext_acl = (reiserfs_acl_header *) kmalloc(sizeof(reiserfs_acl_header) +
+	ext_acl = kmalloc(sizeof(reiserfs_acl_header) +
 						  acl->a_count *
 						  sizeof(reiserfs_acl_entry),
 						  GFP_NOFS);
diff -puN include/asm-avr32/pgalloc.h~getting-rid-of-all-casts-of-kalloc-calls include/asm-avr32/pgalloc.h
--- a/include/asm-avr32/pgalloc.h~getting-rid-of-all-casts-of-kalloc-calls
+++ a/include/asm-avr32/pgalloc.h
@@ -28,7 +28,7 @@ static __inline__ void pmd_populate(stru
 static __inline__ pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	unsigned int pgd_size = (USER_PTRS_PER_PGD * sizeof(pgd_t));
-	pgd_t *pgd = (pgd_t *)kmalloc(pgd_size, GFP_KERNEL);
+	pgd_t *pgd = kmalloc(pgd_size, GFP_KERNEL);
 
 	if (pgd)
 		memset(pgd, 0, pgd_size);
diff -puN include/asm-sh64/pgalloc.h~getting-rid-of-all-casts-of-kalloc-calls include/asm-sh64/pgalloc.h
--- a/include/asm-sh64/pgalloc.h~getting-rid-of-all-casts-of-kalloc-calls
+++ a/include/asm-sh64/pgalloc.h
@@ -41,7 +41,7 @@ static inline void pgd_init(unsigned lon
 static inline pgd_t *get_pgd_slow(void)
 {
 	unsigned int pgd_size = (USER_PTRS_PER_PGD * sizeof(pgd_t));
-	pgd_t *ret = (pgd_t *)kmalloc(pgd_size, GFP_KERNEL);
+	pgd_t *ret = kmalloc(pgd_size, GFP_KERNEL);
 	return ret;
 }
 
diff -puN include/linux/coda_linux.h~getting-rid-of-all-casts-of-kalloc-calls include/linux/coda_linux.h
--- a/include/linux/coda_linux.h~getting-rid-of-all-casts-of-kalloc-calls
+++ a/include/linux/coda_linux.h
@@ -64,7 +64,7 @@ void coda_sysctl_clean(void);
 
 #define CODA_ALLOC(ptr, cast, size) do { \
     if (size < PAGE_SIZE) \
-        ptr = (cast)kmalloc((unsigned long) size, GFP_KERNEL); \
+        ptr = kmalloc((unsigned long) size, GFP_KERNEL); \
     else \
         ptr = (cast)vmalloc((unsigned long) size); \
     if (!ptr) \
diff -puN ipc/msgutil.c~getting-rid-of-all-casts-of-kalloc-calls ipc/msgutil.c
--- a/ipc/msgutil.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/ipc/msgutil.c
@@ -36,7 +36,7 @@ struct msg_msg *load_msg(const void __us
 	if (alen > DATALEN_MSG)
 		alen = DATALEN_MSG;
 
-	msg = (struct msg_msg *)kmalloc(sizeof(*msg) + alen, GFP_KERNEL);
+	msg = kmalloc(sizeof(*msg) + alen, GFP_KERNEL);
 	if (msg == NULL)
 		return ERR_PTR(-ENOMEM);
 
@@ -56,7 +56,7 @@ struct msg_msg *load_msg(const void __us
 		alen = len;
 		if (alen > DATALEN_SEG)
 			alen = DATALEN_SEG;
-		seg = (struct msg_msgseg *)kmalloc(sizeof(*seg) + alen,
+		seg = kmalloc(sizeof(*seg) + alen,
 						 GFP_KERNEL);
 		if (seg == NULL) {
 			err = -ENOMEM;
diff -puN net/tipc/config.c~getting-rid-of-all-casts-of-kalloc-calls net/tipc/config.c
--- a/net/tipc/config.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/net/tipc/config.c
@@ -208,7 +208,7 @@ static void cfg_cmd_event(struct tipc_cm
 
 			if (mng.link_subscriptions > 64)
 				break;
-			sub = (struct subscr_data *)kmalloc(sizeof(*sub),
+			sub = kmalloc(sizeof(*sub),
 							    GFP_ATOMIC);
 			if (sub == NULL) {
 				warn("Memory squeeze; dropped remote link subscription\n");
diff -puN sound/core/oss/mixer_oss.c~getting-rid-of-all-casts-of-kalloc-calls sound/core/oss/mixer_oss.c
--- a/sound/core/oss/mixer_oss.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/sound/core/oss/mixer_oss.c
@@ -1023,7 +1023,7 @@ static int snd_mixer_oss_build_input(str
 	}
 	up_read(&mixer->card->controls_rwsem);
 	if (slot.present != 0) {
-		pslot = (struct slot *)kmalloc(sizeof(slot), GFP_KERNEL);
+		pslot = kmalloc(sizeof(slot), GFP_KERNEL);
 		if (! pslot)
 			return -ENOMEM;
 		*pslot = slot;
diff -puN sound/oss/ad1848.c~getting-rid-of-all-casts-of-kalloc-calls sound/oss/ad1848.c
--- a/sound/oss/ad1848.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/sound/oss/ad1848.c
@@ -1992,7 +1992,7 @@ int ad1848_init (char *name, struct reso
 			devc->audio_flags |= DMA_DUPLEX;
 	}
 
-	portc = (ad1848_port_info *) kmalloc(sizeof(ad1848_port_info), GFP_KERNEL);
+	portc = kmalloc(sizeof(ad1848_port_info), GFP_KERNEL);
 	if(portc==NULL) {
 		release_region(devc->base, 4);
 		return -1;
diff -puN sound/oss/cs4232.c~getting-rid-of-all-casts-of-kalloc-calls sound/oss/cs4232.c
--- a/sound/oss/cs4232.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/sound/oss/cs4232.c
@@ -408,7 +408,7 @@ static int __init cs4232_pnp_probe(struc
 {
 	struct address_info *isapnpcfg;
 
-	isapnpcfg=(struct address_info*)kmalloc(sizeof(*isapnpcfg),GFP_KERNEL);
+	isapnpcfg = kmalloc(sizeof(*isapnpcfg),GFP_KERNEL);
 	if (!isapnpcfg)
 		return -ENOMEM;
 
diff -puN sound/oss/emu10k1/audio.c~getting-rid-of-all-casts-of-kalloc-calls sound/oss/emu10k1/audio.c
--- a/sound/oss/emu10k1/audio.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/sound/oss/emu10k1/audio.c
@@ -1139,7 +1139,7 @@ static int emu10k1_audio_open(struct ino
 
 match:
 
-	wave_dev = (struct emu10k1_wavedevice *) kmalloc(sizeof(struct emu10k1_wavedevice), GFP_KERNEL);
+	wave_dev = kmalloc(sizeof(struct emu10k1_wavedevice), GFP_KERNEL);
 
 	if (wave_dev == NULL) { 
 		ERROR();
@@ -1155,7 +1155,7 @@ match:
 		/* Recording */
 		struct wiinst *wiinst;
 
-		if ((wiinst = (struct wiinst *) kmalloc(sizeof(struct wiinst), GFP_KERNEL)) == NULL) {
+		if ((wiinst = kmalloc(sizeof(struct wiinst), GFP_KERNEL)) == NULL) {
 			ERROR();
 			kfree(wave_dev);
 			return -ENOMEM;
@@ -1211,7 +1211,7 @@ match:
 		struct woinst *woinst;
 		int i;
 
-		if ((woinst = (struct woinst *) kmalloc(sizeof(struct woinst), GFP_KERNEL)) == NULL) {
+		if ((woinst = kmalloc(sizeof(struct woinst), GFP_KERNEL)) == NULL) {
 			ERROR();
 			kfree(wave_dev);
 			return -ENOMEM;
diff -puN sound/oss/emu10k1/cardmi.c~getting-rid-of-all-casts-of-kalloc-calls sound/oss/emu10k1/cardmi.c
--- a/sound/oss/emu10k1/cardmi.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/sound/oss/emu10k1/cardmi.c
@@ -157,7 +157,7 @@ int emu10k1_mpuin_add_buffer(struct emu1
 	midihdr->flags |= MIDIBUF_INQUEUE;	/* set */
 	midihdr->flags &= ~MIDIBUF_DONE;	/* clear */
 
-	if ((midiq = (struct midi_queue *) kmalloc(sizeof(struct midi_queue), GFP_ATOMIC)) == NULL) {
+	if ((midiq = kmalloc(sizeof(struct midi_queue), GFP_ATOMIC)) == NULL) {
 		/* Message lost */
 		return -1;
 	}
diff -puN sound/oss/emu10k1/cardmo.c~getting-rid-of-all-casts-of-kalloc-calls sound/oss/emu10k1/cardmo.c
--- a/sound/oss/emu10k1/cardmo.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/sound/oss/emu10k1/cardmo.c
@@ -117,7 +117,7 @@ int emu10k1_mpuout_add_buffer(struct emu
 	midihdr->flags |= MIDIBUF_INQUEUE;
 	midihdr->flags &= ~MIDIBUF_DONE;
 
-	if ((midiq = (struct midi_queue *) kmalloc(sizeof(struct midi_queue), GFP_KERNEL)) == NULL) {
+	if ((midiq = kmalloc(sizeof(struct midi_queue), GFP_KERNEL)) == NULL) {
 		/* Message lost */
 		return -1;
 	}
diff -puN sound/oss/emu10k1/midi.c~getting-rid-of-all-casts-of-kalloc-calls sound/oss/emu10k1/midi.c
--- a/sound/oss/emu10k1/midi.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/sound/oss/emu10k1/midi.c
@@ -58,7 +58,7 @@ static int midiin_add_buffer(struct emu1
 {
 	struct midi_hdr *midihdr;
 
-	if ((midihdr = (struct midi_hdr *) kmalloc(sizeof(struct midi_hdr), GFP_KERNEL)) == NULL) {
+	if ((midihdr = kmalloc(sizeof(struct midi_hdr), GFP_KERNEL)) == NULL) {
 		ERROR();
 		return -EINVAL;
 	}
@@ -128,7 +128,7 @@ match:
 		mutex_lock(&card->open_sem);
 	}
 
-	if ((midi_dev = (struct emu10k1_mididevice *) kmalloc(sizeof(*midi_dev), GFP_KERNEL)) == NULL)
+	if ((midi_dev = kmalloc(sizeof(*midi_dev), GFP_KERNEL)) == NULL)
 		return -EINVAL;
 
 	midi_dev->card = card;
@@ -328,7 +328,7 @@ static ssize_t emu10k1_midi_write(struct
 	if (!access_ok(VERIFY_READ, buffer, count))
 		return -EFAULT;
 
-	if ((midihdr = (struct midi_hdr *) kmalloc(sizeof(struct midi_hdr), GFP_KERNEL)) == NULL)
+	if ((midihdr = kmalloc(sizeof(struct midi_hdr), GFP_KERNEL)) == NULL)
 		return -EINVAL;
 
 	midihdr->bufferlength = count;
@@ -490,7 +490,7 @@ int emu10k1_seq_midi_open(int dev, int m
 			
 	DPF(2, "emu10k1_seq_midi_open()\n");
 	
-	if ((midi_dev = (struct emu10k1_mididevice *) kmalloc(sizeof(*midi_dev), GFP_KERNEL)) == NULL)
+	if ((midi_dev = kmalloc(sizeof(*midi_dev), GFP_KERNEL)) == NULL)
 		return -EINVAL;
 
 	midi_dev->card = card;
@@ -540,7 +540,7 @@ int emu10k1_seq_midi_out(int dev, unsign
 
 	card = midi_devs[dev]->devc;
 
-	if ((midihdr = (struct midi_hdr *) kmalloc(sizeof(struct midi_hdr), GFP_KERNEL)) == NULL)
+	if ((midihdr = kmalloc(sizeof(struct midi_hdr), GFP_KERNEL)) == NULL)
 		return -EINVAL;
 
 	midihdr->bufferlength = 1;
diff -puN sound/oss/emu10k1/mixer.c~getting-rid-of-all-casts-of-kalloc-calls sound/oss/emu10k1/mixer.c
--- a/sound/oss/emu10k1/mixer.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/sound/oss/emu10k1/mixer.c
@@ -194,7 +194,7 @@ static int emu10k1_private_mixer(struct 
 
 	case SOUND_MIXER_PRIVATE3:
 
-		ctl = (struct mixer_private_ioctl *) kmalloc(sizeof(struct mixer_private_ioctl), GFP_KERNEL);
+		ctl = kmalloc(sizeof(struct mixer_private_ioctl), GFP_KERNEL);
 		if (ctl == NULL)
 			return -ENOMEM;
 
diff -puN sound/oss/hal2.c~getting-rid-of-all-casts-of-kalloc-calls sound/oss/hal2.c
--- a/sound/oss/hal2.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/sound/oss/hal2.c
@@ -1435,7 +1435,7 @@ static int hal2_init_card(struct hal2_ca
 	int ret = 0;
 	struct hal2_card *hal2;
 
-	hal2 = (struct hal2_card *) kmalloc(sizeof(struct hal2_card), GFP_KERNEL);
+	hal2 = kmalloc(sizeof(struct hal2_card), GFP_KERNEL);
 	if (!hal2)
 		return -ENOMEM;
 	memset(hal2, 0, sizeof(struct hal2_card));
diff -puN sound/oss/mpu401.c~getting-rid-of-all-casts-of-kalloc-calls sound/oss/mpu401.c
--- a/sound/oss/mpu401.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/sound/oss/mpu401.c
@@ -1023,7 +1023,7 @@ int attach_mpu401(struct address_info *h
 				devc->capabilities |= MPU_CAP_INTLG;	/* Supports intelligent mode */
 
 
-	mpu401_synth_operations[m] = (struct synth_operations *)kmalloc(sizeof(struct synth_operations), GFP_KERNEL);
+	mpu401_synth_operations[m] = kmalloc(sizeof(struct synth_operations), GFP_KERNEL);
 
 	if (mpu401_synth_operations[m] == NULL)
 	{
diff -puN sound/oss/opl3.c~getting-rid-of-all-casts-of-kalloc-calls sound/oss/opl3.c
--- a/sound/oss/opl3.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/sound/oss/opl3.c
@@ -166,7 +166,7 @@ int opl3_detect(int ioaddr, int *osp)
 		return 0;
 	}
 
-	devc = (struct opl_devinfo *)kmalloc(sizeof(*devc), GFP_KERNEL);
+	devc = kmalloc(sizeof(*devc), GFP_KERNEL);
 
 	if (devc == NULL)
 	{
diff -puN sound/oss/sb_common.c~getting-rid-of-all-casts-of-kalloc-calls sound/oss/sb_common.c
--- a/sound/oss/sb_common.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/sound/oss/sb_common.c
@@ -625,7 +625,7 @@ int sb_dsp_detect(struct address_info *h
 	 */
 
 
-	detected_devc = (sb_devc *)kmalloc(sizeof(sb_devc), GFP_KERNEL);
+	detected_devc = kmalloc(sizeof(sb_devc), GFP_KERNEL);
 	if (detected_devc == NULL)
 	{
 		printk(KERN_ERR "sb: Can't allocate memory for device information\n");
diff -puN sound/oss/sb_midi.c~getting-rid-of-all-casts-of-kalloc-calls sound/oss/sb_midi.c
--- a/sound/oss/sb_midi.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/sound/oss/sb_midi.c
@@ -173,7 +173,7 @@ void sb_dsp_midi_init(sb_devc * devc, st
 		return;
 	}
 	std_midi_synth.midi_dev = devc->my_mididev = dev;
-	midi_devs[dev] = (struct midi_operations *)kmalloc(sizeof(struct midi_operations), GFP_KERNEL);
+	midi_devs[dev] = kmalloc(sizeof(struct midi_operations), GFP_KERNEL);
 	if (midi_devs[dev] == NULL)
 	{
 		printk(KERN_WARNING "Sound Blaster:  failed to allocate MIDI memory.\n");
@@ -189,7 +189,7 @@ void sb_dsp_midi_init(sb_devc * devc, st
 	midi_devs[dev]->devc = devc;
 
 
-	midi_devs[dev]->converter = (struct synth_operations *)kmalloc(sizeof(struct synth_operations), GFP_KERNEL);
+	midi_devs[dev]->converter = kmalloc(sizeof(struct synth_operations), GFP_KERNEL);
 	if (midi_devs[dev]->converter == NULL)
 	{
 		  printk(KERN_WARNING "Sound Blaster:  failed to allocate MIDI memory.\n");
diff -puN sound/oss/sb_mixer.c~getting-rid-of-all-casts-of-kalloc-calls sound/oss/sb_mixer.c
--- a/sound/oss/sb_mixer.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/sound/oss/sb_mixer.c
@@ -734,7 +734,7 @@ int sb_mixer_init(sb_devc * devc, struct
 	if (m == -1)
 		return 0;
 
-	mixer_devs[m] = (struct mixer_operations *)kmalloc(sizeof(struct mixer_operations), GFP_KERNEL);
+	mixer_devs[m] = kmalloc(sizeof(struct mixer_operations), GFP_KERNEL);
 	if (mixer_devs[m] == NULL)
 	{
 		printk(KERN_ERR "sb_mixer: Can't allocate memory\n");
diff -puN sound/oss/v_midi.c~getting-rid-of-all-casts-of-kalloc-calls sound/oss/v_midi.c
--- a/sound/oss/v_midi.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/sound/oss/v_midi.c
@@ -183,7 +183,7 @@ static void __init attach_v_midi (struct
 		return;
 	}
 	
-	m=(struct vmidi_memory *)kmalloc(sizeof(struct vmidi_memory), GFP_KERNEL);
+	m = kmalloc(sizeof(struct vmidi_memory), GFP_KERNEL);
 	if (m == NULL)
 	{
 		printk(KERN_WARNING "Loopback MIDI: Failed to allocate memory\n");
diff -puN sound/oss/waveartist.c~getting-rid-of-all-casts-of-kalloc-calls sound/oss/waveartist.c
--- a/sound/oss/waveartist.c~getting-rid-of-all-casts-of-kalloc-calls
+++ a/sound/oss/waveartist.c
@@ -1267,7 +1267,7 @@ static int __init waveartist_init(wavnc_
 	conf_printf2(dev_name, devc->hw.io_base, devc->hw.irq,
 		     devc->hw.dma, devc->hw.dma2);
 
-	portc = (wavnc_port_info *)kmalloc(sizeof(wavnc_port_info), GFP_KERNEL);
+	portc = kmalloc(sizeof(wavnc_port_info), GFP_KERNEL);
 	if (portc == NULL)
 		goto nomem;
 
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
schedc-correct-comment-for-this_rq_lock-routine.patch
fix-numerous-kcalloc-calls-convert-to-kzalloc.patch
getting-rid-of-all-casts-of-kalloc-calls.patch

