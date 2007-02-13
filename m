From: akpm@linux-foundation.org
Subject: + lguest-trivial-guest-block-driver.patch added to -mm tree
Date: Mon, 12 Feb 2007 23:03:37 -0800
Message-ID: <200702130703.l1D73bid024565@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57027 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbXBMHDp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 02:03:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de


The patch titled
     lguest: trivial guest block driver
has been added to the -mm tree.  Its filename is
     lguest-trivial-guest-block-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest: trivial guest block driver
From: Rusty Russell <rusty@rustcorp.com.au>

A simple block driver for lguest (/dev/lgbX).  Only does one request at once.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/Makefile     |    1 
 drivers/block/lguest_blk.c |  260 +++++++++++++++++++++++++++++++++++
 2 files changed, 261 insertions(+)

diff -puN drivers/block/Makefile~lguest-trivial-guest-block-driver drivers/block/Makefile
--- a/drivers/block/Makefile~lguest-trivial-guest-block-driver
+++ a/drivers/block/Makefile
@@ -28,4 +28,5 @@ obj-$(CONFIG_BLK_DEV_CRYPTOLOOP) += cryp
 obj-$(CONFIG_VIODASD)		+= viodasd.o
 obj-$(CONFIG_BLK_DEV_SX8)	+= sx8.o
 obj-$(CONFIG_BLK_DEV_UB)	+= ub.o
+obj-$(CONFIG_LGUEST_GUEST)	+= lguest_blk.o
 
diff -puN /dev/null drivers/block/lguest_blk.c
--- /dev/null
+++ a/drivers/block/lguest_blk.c
@@ -0,0 +1,260 @@
+/* A simple block driver for lguest.
+ *
+ * Copyright 2006 Rusty Russell <rusty@rustcorp.com.au> IBM Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+//#define DEBUG
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/blkdev.h>
+#include <linux/interrupt.h>
+#include <asm/lguest_device.h>
+
+static char next_block_index = 'a';
+
+struct blockdev
+{
+	spinlock_t lock;
+
+	/* The disk structure for the kernel. */
+	struct gendisk *disk;
+
+	/* The major number for this disk. */
+	int major;
+	int irq;
+
+	unsigned long phys_addr;
+	/* The ioremap'ed block page. */
+	struct lguest_block_page *lb_page;
+
+	/* We only have a single request outstanding at a time. */
+	struct lguest_dma dma;
+	struct request *req;
+};
+
+static irqreturn_t lgb_irq(int irq, void *_bd)
+{
+	struct blockdev *bd = _bd;
+	unsigned long flags;
+
+	if (!bd->req) {
+		pr_debug("No work!\n");
+		return IRQ_NONE;
+	}
+
+	if (!bd->lb_page->result) {
+		pr_debug("No result!\n");
+		return IRQ_NONE;
+	}
+
+	spin_lock_irqsave(&bd->lock, flags);
+	end_request(bd->req, bd->lb_page->result == 1);
+	bd->req = NULL;
+	bd->dma.used_len = 0;
+	blk_start_queue(bd->disk->queue);
+	spin_unlock_irqrestore(&bd->lock, flags);
+	return IRQ_HANDLED;
+}
+
+static unsigned int req_to_dma(struct request *req, struct lguest_dma *dma)
+{
+	unsigned int i = 0, idx, len = 0;
+	struct bio *bio;
+
+	rq_for_each_bio(bio, req) {
+		struct bio_vec *bvec;
+		bio_for_each_segment(bvec, bio, idx) {
+			BUG_ON(i == LGUEST_MAX_DMA_SECTIONS);
+			BUG_ON(!bvec->bv_len);
+			dma->addr[i] = page_to_phys(bvec->bv_page)
+				+ bvec->bv_offset;
+			dma->len[i] = bvec->bv_len;
+			len += bvec->bv_len;
+			i++;
+		}
+	}
+	if (i < LGUEST_MAX_DMA_SECTIONS)
+		dma->len[i] = 0;
+	return len;
+}
+
+static void empty_dma(struct lguest_dma *dma)
+{
+	dma->len[0] = 0;
+}
+
+static void setup_req(struct blockdev *bd,
+		      int type, struct request *req, struct lguest_dma *dma)
+{
+	bd->lb_page->type = type;
+	bd->lb_page->sector = req->sector;
+	bd->lb_page->result = 0;
+	bd->req = req;
+	bd->lb_page->bytes = req_to_dma(req, dma);
+}
+
+static int do_write(struct blockdev *bd, struct request *req)
+{
+	struct lguest_dma send;
+
+	pr_debug("lgb: WRITE sector %li\n", (long)req->sector);
+	setup_req(bd, 1, req, &send);
+
+	hcall(LHCALL_SEND_DMA, bd->phys_addr, __pa(&send), 0);
+	return 1;
+}
+
+static int do_read(struct blockdev *bd, struct request *req)
+{
+	struct lguest_dma ping;
+
+	pr_debug("lgb: READ sector %li\n", (long)req->sector);
+	setup_req(bd, 0, req, &bd->dma);
+
+	empty_dma(&ping);
+	hcall(LHCALL_SEND_DMA,bd->phys_addr,__pa(&ping),0);
+	return 1;
+}
+
+static void do_lgb_request(request_queue_t *q)
+{
+	struct blockdev *bd;
+	struct request *req;
+	int ok;
+
+again:
+	req = elv_next_request(q);
+	if (!req)
+		return;
+
+	bd = req->rq_disk->private_data;
+	/* Sometimes we get repeated requests after blk_stop_queue. */
+	if (bd->req)
+		return;
+
+	if (!blk_fs_request(req)) {
+		pr_debug("Got non-command 0x%08x\n", req->cmd_type);
+	error:
+		req->errors++;
+		end_request(req, 0);
+		goto again;
+	} else {
+		if (rq_data_dir(req) == WRITE)
+			ok = do_write(req->rq_disk->private_data, req);
+		else
+			ok = do_read(req->rq_disk->private_data, req);
+
+		if (!ok)
+			goto error;
+		/* Wait for interrupt to tell us it's done. */
+		blk_stop_queue(q);
+	}
+}
+
+static struct block_device_operations lguestblk_fops = {
+	.owner = THIS_MODULE,
+};
+
+static int lguestblk_probe(struct lguest_device *lhdev)
+{
+	struct blockdev *bd;
+	int err;
+	int irqflags = IRQF_SHARED;
+
+	bd = kmalloc(sizeof(*bd), GFP_KERNEL);
+	if (!bd)
+		return -ENOMEM;
+
+	spin_lock_init(&bd->lock);
+	bd->phys_addr = (lguest_devices[lhdev->index].pfn << PAGE_SHIFT);
+
+	bd->disk = alloc_disk(1);
+	if (!bd->disk) {
+		err = -ENOMEM;
+		goto out_free_bd;
+	}
+
+	bd->disk->queue = blk_init_queue(do_lgb_request, &bd->lock);
+	if (!bd->disk->queue) {
+		err = -ENOMEM;
+		goto out_put;
+	}
+
+	/* We can only handle a certain number of sg entries */
+	blk_queue_max_hw_segments(bd->disk->queue, LGUEST_MAX_DMA_SECTIONS);
+	/* Buffers must not cross page boundaries */
+	blk_queue_segment_boundary(bd->disk->queue, PAGE_SIZE-1);
+
+	bd->irq = lhdev->index+1;
+	bd->major = register_blkdev(0, "lguestblk");
+	if (bd->major < 0) {
+		err = bd->major;
+		goto out_cleanup_queue;
+	}
+	bd->lb_page = (void *)ioremap(bd->phys_addr, PAGE_SIZE);
+	bd->req = NULL;
+
+	sprintf(bd->disk->disk_name, "lgb%c", next_block_index++);
+	if (lguest_devices[lhdev->index].features & LGUEST_DEVICE_F_RANDOMNESS)
+		irqflags |= IRQF_SAMPLE_RANDOM;
+	err = request_irq(bd->irq, lgb_irq, irqflags, bd->disk->disk_name, bd);
+	if (err)
+		goto out_unmap;
+
+	bd->dma.used_len = 0;
+	bd->dma.len[0] = 0;
+	hcall(LHCALL_BIND_DMA, bd->phys_addr, __pa(&bd->dma), (1<<8)+bd->irq);
+
+	printk(KERN_INFO "%s: device %i at major %d\n",
+	       bd->disk->disk_name, lhdev->index, bd->major);
+
+	bd->disk->major = bd->major;
+	bd->disk->first_minor = 0;
+	bd->disk->private_data = bd;
+	bd->disk->fops = &lguestblk_fops;
+	/* This is initialized to the disk size by the other end. */
+	set_capacity(bd->disk, bd->lb_page->num_sectors);
+	add_disk(bd->disk);
+
+	lhdev->private = bd;
+	return 0;
+
+out_unmap:
+	iounmap(bd->lb_page);
+out_cleanup_queue:
+	blk_cleanup_queue(bd->disk->queue);
+out_put:
+	put_disk(bd->disk);
+out_free_bd:
+	kfree(bd);
+	return err;
+}
+
+static struct lguest_driver lguestblk_drv = {
+	.name = "lguestblk",
+	.owner = THIS_MODULE,
+	.device_type = LGUEST_DEVICE_T_BLOCK,
+	.probe = lguestblk_probe,
+};
+
+static __init int lguestblk_init(void)
+{
+	return register_lguest_driver(&lguestblk_drv);
+}
+module_init(lguestblk_init);
+
+MODULE_DESCRIPTION("Lguest block driver");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
cleanup-paravirt-unhandled-fallthrough.patch
cleanup-initialize-esp0-properly-all-the-time.patch
cleanup-make-hvc_consolec-compile-on-non-powerpc.patch
cleanup-move-mce_disabled-to-asm-mceh.patch
cleanup-rename-cpu_gdt_descr-and-remove-extern.patch
cleanup-remove-extern-declaration-from.patch
cleanup-make-disable_acpi-valid-w-o-config_acpi.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
lguest-guest-code.patch
lguest-makefile.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-network-driver-fix.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-documentatation-and-example-launcher.patch
vmi-versus-hrtimers.patch
