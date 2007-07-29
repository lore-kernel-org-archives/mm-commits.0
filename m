From: akpm@linux-foundation.org
Subject: - lguest-documentation-iii-drivers.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:11:30 -0700
Message-ID: <200707290611.l6T6BUP9010989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33052 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757031AbXG2GLv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:11:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: documentation III: Drivers
has been removed from the -mm tree.  Its filename was
     lguest-documentation-iii-drivers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lguest: documentation III: Drivers
From: Rusty Russell <rusty@rustcorp.com.au>

Documentation: The Drivers

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/lguest_blk.c      |  169 +++++++++++++++++++++--
 drivers/char/hvc_lguest.c       |   79 ++++++++++
 drivers/lguest/lguest_bus.c     |   72 +++++++++
 drivers/net/lguest_net.c        |  218 +++++++++++++++++++++++++++---
 include/linux/lguest_bus.h      |    5 
 include/linux/lguest_launcher.h |   60 +++++++-
 6 files changed, 563 insertions(+), 40 deletions(-)

diff -puN drivers/block/lguest_blk.c~lguest-documentation-iii-drivers drivers/block/lguest_blk.c
--- a/drivers/block/lguest_blk.c~lguest-documentation-iii-drivers
+++ a/drivers/block/lguest_blk.c
@@ -1,6 +1,12 @@
-/* A simple block driver for lguest.
+/*D:400
+ * The Guest block driver
  *
- * Copyright 2006 Rusty Russell <rusty@rustcorp.com.au> IBM Corporation
+ * This is a simple block driver, which appears as /dev/lgba, lgbb, lgbc etc.
+ * The mechanism is simple: we place the information about the request in the
+ * device page, then use SEND_DMA (containing the data for a write, or an empty
+ * "ping" DMA for a read).
+ :*/
+/* Copyright 2006 Rusty Russell <rusty@rustcorp.com.au> IBM Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -25,27 +31,50 @@
 
 static char next_block_index = 'a';
 
+/*D:420 Here is the structure which holds all the information we need about
+ * each Guest block device.
+ *
+ * I'm sure at this stage, you're wondering "hey, where was the adventure I was
+ * promised?" and thinking "Rusty sucks, I shall say nasty things about him on
+ * my blog".  I think Real adventures have boring bits, too, and you're in the
+ * middle of one.  But it gets better.  Just not quite yet. */
 struct blockdev
 {
+	/* The block queue infrastructure wants a spinlock: it is held while it
+	 * calls our block request function.  We grab it in our interrupt
+	 * handler so the responses don't mess with new requests. */
 	spinlock_t lock;
 
-	/* The disk structure for the kernel. */
+	/* The disk structure registered with kernel. */
 	struct gendisk *disk;
 
-	/* The major number for this disk. */
+	/* The major device number for this disk, and the interrupt.  We only
+	 * really keep them here for completeness; we'd need them if we
+	 * supported device unplugging. */
 	int major;
 	int irq;
 
+	/* The physical address of this device's memory page */
 	unsigned long phys_addr;
-	/* The mapped block page. */
+	/* The mapped memory page for convenient acces. */
 	struct lguest_block_page *lb_page;
 
-	/* We only have a single request outstanding at a time. */
+	/* We only have a single request outstanding at a time: this is it. */
 	struct lguest_dma dma;
 	struct request *req;
 };
 
-/* Jens gave me this nice helper to end all chunks of a request. */
+/*D:495 We originally used end_request() throughout the driver, but it turns
+ * out that end_request() is deprecated, and doesn't actually end the request
+ * (which seems like a good reason to deprecate it!).  It simply ends the first
+ * bio.  So if we had 3 bios in a "struct request" we would do all 3,
+ * end_request(), do 2, end_request(), do 1 and end_request(): twice as much
+ * work as we needed to do.
+ *
+ * This reinforced to me that I do not understand the block layer.
+ *
+ * Nonetheless, Jens Axboe gave me this nice helper to end all chunks of a
+ * request.  This improved disk speed by 130%. */
 static void end_entire_request(struct request *req, int uptodate)
 {
 	if (end_that_request_first(req, uptodate, req->hard_nr_sectors))
@@ -55,30 +84,62 @@ static void end_entire_request(struct re
 	end_that_request_last(req, uptodate);
 }
 
+/* I'm told there are only two stories in the world worth telling: love and
+ * hate.  So there used to be a love scene here like this:
+ *
+ *  Launcher:	We could make beautiful I/O together, you and I.
+ *  Guest:	My, that's a big disk!
+ *
+ * Unfortunately, it was just too raunchy for our otherwise-gentle tale. */
+
+/*D:490 This is the interrupt handler, called when a block read or write has
+ * been completed for us. */
 static irqreturn_t lgb_irq(int irq, void *_bd)
 {
+	/* We handed our "struct blockdev" as the argument to request_irq(), so
+	 * it is passed through to us here.  This tells us which device we're
+	 * dealing with in case we have more than one. */
 	struct blockdev *bd = _bd;
 	unsigned long flags;
 
+	/* We weren't doing anything?  Strange, but could happen if we shared
+	 * interrupts (we don't!). */
 	if (!bd->req) {
 		pr_debug("No work!\n");
 		return IRQ_NONE;
 	}
 
+	/* Not done yet?  That's equally strange. */
 	if (!bd->lb_page->result) {
 		pr_debug("No result!\n");
 		return IRQ_NONE;
 	}
 
+	/* We have to grab the lock before ending the request. */
 	spin_lock_irqsave(&bd->lock, flags);
+	/* "result" is 1 for success, 2 for failure: end_entire_request() wants
+	 * to know whether this succeeded or not. */
 	end_entire_request(bd->req, bd->lb_page->result == 1);
+	/* Clear out request, it's done. */
 	bd->req = NULL;
+	/* Reset incoming DMA for next time. */
 	bd->dma.used_len = 0;
+	/* Ready for more reads or writes */
 	blk_start_queue(bd->disk->queue);
 	spin_unlock_irqrestore(&bd->lock, flags);
+
+	/* The interrupt was for us, we dealt with it. */
 	return IRQ_HANDLED;
 }
 
+/*D:480 The block layer's "struct request" contains a number of "struct bio"s,
+ * each of which contains "struct bio_vec"s, each of which contains a page, an
+ * offset and a length.
+ *
+ * Fortunately there are iterators to help us walk through the "struct
+ * request".  Even more fortunately, there were plenty of places to steal the
+ * code from.  We pack the "struct request" into our "struct lguest_dma" and
+ * return the total length. */
 static unsigned int req_to_dma(struct request *req, struct lguest_dma *dma)
 {
 	unsigned int i = 0, idx, len = 0;
@@ -87,8 +148,13 @@ static unsigned int req_to_dma(struct re
 	rq_for_each_bio(bio, req) {
 		struct bio_vec *bvec;
 		bio_for_each_segment(bvec, bio, idx) {
+			/* We told the block layer not to give us too many. */
 			BUG_ON(i == LGUEST_MAX_DMA_SECTIONS);
+			/* If we had a zero-length segment, it would look like
+			 * the end of the data referred to by the "struct
+			 * lguest_dma", so make sure that doesn't happen. */
 			BUG_ON(!bvec->bv_len);
+			/* Convert page & offset to a physical address */
 			dma->addr[i] = page_to_phys(bvec->bv_page)
 				+ bvec->bv_offset;
 			dma->len[i] = bvec->bv_len;
@@ -96,26 +162,39 @@ static unsigned int req_to_dma(struct re
 			i++;
 		}
 	}
+	/* If the array isn't full, we mark the end with a 0 length */
 	if (i < LGUEST_MAX_DMA_SECTIONS)
 		dma->len[i] = 0;
 	return len;
 }
 
+/* This creates an empty DMA, useful for prodding the Host without sending data
+ * (ie. when we want to do a read) */
 static void empty_dma(struct lguest_dma *dma)
 {
 	dma->len[0] = 0;
 }
 
+/*D:470 Setting up a request is fairly easy: */
 static void setup_req(struct blockdev *bd,
 		      int type, struct request *req, struct lguest_dma *dma)
 {
+	/* The type is 1 (write) or 0 (read). */
 	bd->lb_page->type = type;
+	/* The sector on disk where the read or write starts. */
 	bd->lb_page->sector = req->sector;
+	/* The result is initialized to 0 (unfinished). */
 	bd->lb_page->result = 0;
+	/* The current request (so we can end it in the interrupt handler). */
 	bd->req = req;
+	/* The number of bytes: returned as a side-effect of req_to_dma(),
+	 * which packs the block layer's "struct request" into our "struct
+	 * lguest_dma" */
 	bd->lb_page->bytes = req_to_dma(req, dma);
 }
 
+/*D:450 Write is pretty straightforward: we pack the request into a "struct
+ * lguest_dma", then use SEND_DMA to send the request. */
 static void do_write(struct blockdev *bd, struct request *req)
 {
 	struct lguest_dma send;
@@ -126,6 +205,9 @@ static void do_write(struct blockdev *bd
 	lguest_send_dma(bd->phys_addr, &send);
 }
 
+/* Read is similar to write, except we pack the request into our receive
+ * "struct lguest_dma" and send through an empty DMA just to tell the Host that
+ * there's a request pending. */
 static void do_read(struct blockdev *bd, struct request *req)
 {
 	struct lguest_dma ping;
@@ -137,21 +219,30 @@ static void do_read(struct blockdev *bd,
 	lguest_send_dma(bd->phys_addr, &ping);
 }
 
+/*D:440 This where requests come in: we get handed the request queue and are
+ * expected to pull a "struct request" off it until we've finished them or
+ * we're waiting for a reply: */
 static void do_lgb_request(struct request_queue *q)
 {
 	struct blockdev *bd;
 	struct request *req;
 
 again:
+	/* This sometimes returns NULL even on the very first time around.  I
+	 * wonder if it's something to do with letting elves handle the request
+	 * queue... */
 	req = elv_next_request(q);
 	if (!req)
 		return;
 
+	/* We attached the struct blockdev to the disk: get it back */
 	bd = req->rq_disk->private_data;
-	/* Sometimes we get repeated requests after blk_stop_queue. */
+	/* Sometimes we get repeated requests after blk_stop_queue(), but we
+	 * can only handle one at a time. */
 	if (bd->req)
 		return;
 
+	/* We only do reads and writes: no tricky business! */
 	if (!blk_fs_request(req)) {
 		pr_debug("Got non-command 0x%08x\n", req->cmd_type);
 		req->errors++;
@@ -164,20 +255,31 @@ again:
 	else
 		do_read(bd, req);
 
-	/* Wait for interrupt to tell us it's done. */
+	/* We've put out the request, so stop any more coming in until we get
+	 * an interrupt, which takes us to lgb_irq() to re-enable the queue. */
 	blk_stop_queue(q);
 }
 
+/*D:430 This is the "struct block_device_operations" we attach to the disk at
+ * the end of lguestblk_probe().  It doesn't seem to want much. */
 static struct block_device_operations lguestblk_fops = {
 	.owner = THIS_MODULE,
 };
 
+/*D:425 Setting up a disk device seems to involve a lot of code.  I'm not sure
+ * quite why.  I do know that the IDE code sent two or three of the maintainers
+ * insane, perhaps this is the fringe of the same disease?
+ *
+ * As in the console code, the probe function gets handed the generic
+ * lguest_device from lguest_bus.c: */
 static int lguestblk_probe(struct lguest_device *lgdev)
 {
 	struct blockdev *bd;
 	int err;
 	int irqflags = IRQF_SHARED;
 
+	/* First we allocate our own "struct blockdev" and initialize the easy
+	 * fields. */
 	bd = kmalloc(sizeof(*bd), GFP_KERNEL);
 	if (!bd)
 		return -ENOMEM;
@@ -187,59 +289,100 @@ static int lguestblk_probe(struct lguest
 	bd->req = NULL;
 	bd->dma.used_len = 0;
 	bd->dma.len[0] = 0;
+	/* The descriptor in the lguest_devices array provided by the Host
+	 * gives the Guest the physical page number of the device's page. */
 	bd->phys_addr = (lguest_devices[lgdev->index].pfn << PAGE_SHIFT);
 
+	/* We use lguest_map() to get a pointer to the device page */
 	bd->lb_page = lguest_map(bd->phys_addr, 1);
 	if (!bd->lb_page) {
 		err = -ENOMEM;
 		goto out_free_bd;
 	}
 
+	/* We need a major device number: 0 means "assign one dynamically". */
 	bd->major = register_blkdev(0, "lguestblk");
 	if (bd->major < 0) {
 		err = bd->major;
 		goto out_unmap;
 	}
 
+	/* This allocates a "struct gendisk" where we pack all the information
+	 * about the disk which the rest of Linux sees.  We ask for one minor
+	 * number; I do wonder if we should be asking for more. */
 	bd->disk = alloc_disk(1);
 	if (!bd->disk) {
 		err = -ENOMEM;
 		goto out_unregister_blkdev;
 	}
 
+	/* Every disk needs a queue for requests to come in: we set up the
+	 * queue with a callback function (the core of our driver) and the lock
+	 * to use. */
 	bd->disk->queue = blk_init_queue(do_lgb_request, &bd->lock);
 	if (!bd->disk->queue) {
 		err = -ENOMEM;
 		goto out_put_disk;
 	}
 
-	/* We can only handle a certain number of sg entries */
+	/* We can only handle a certain number of pointers in our SEND_DMA
+	 * call, so we set that with blk_queue_max_hw_segments().  This is not
+	 * to be confused with blk_queue_max_phys_segments() of course!  I
+	 * know, who could possibly confuse the two?
+	 *
+	 * Well, it's simple to tell them apart: this one seems to work and the
+	 * other one didn't. */
 	blk_queue_max_hw_segments(bd->disk->queue, LGUEST_MAX_DMA_SECTIONS);
-	/* Buffers must not cross page boundaries */
+
+	/* Due to technical limitations of our Host (and simple coding) we
+	 * can't have a single buffer which crosses a page boundary.  Tell it
+	 * here.  This means that our maximum request size is 16
+	 * (LGUEST_MAX_DMA_SECTIONS) pages. */
 	blk_queue_segment_boundary(bd->disk->queue, PAGE_SIZE-1);
 
+	/* We name our disk: this becomes the device name when udev does its
+	 * magic thing and creates the device node, such as /dev/lgba.
+	 * next_block_index is a global which starts at 'a'.  Unfortunately
+	 * this simple increment logic means that the 27th disk will be called
+	 * "/dev/lgb{".  In that case, I recommend having at least 29 disks, so
+	 * your /dev directory will be balanced. */
 	sprintf(bd->disk->disk_name, "lgb%c", next_block_index++);
+
+	/* We look to the device descriptor again to see if this device's
+	 * interrupts are expected to be random.  If they are, we tell the irq
+	 * subsystem.  At the moment this bit is always set. */
 	if (lguest_devices[lgdev->index].features & LGUEST_DEVICE_F_RANDOMNESS)
 		irqflags |= IRQF_SAMPLE_RANDOM;
+
+	/* Now we have the name and irqflags, we can request the interrupt; we
+	 * give it the "struct blockdev" we have set up to pass to lgb_irq()
+	 * when there is an interrupt. */
 	err = request_irq(bd->irq, lgb_irq, irqflags, bd->disk->disk_name, bd);
 	if (err)
 		goto out_cleanup_queue;
 
+	/* We bind our one-entry DMA pool to the key for this block device so
+	 * the Host can reply to our requests.  The key is equal to the
+	 * physical address of the device's page, which is conveniently
+	 * unique. */
 	err = lguest_bind_dma(bd->phys_addr, &bd->dma, 1, bd->irq);
 	if (err)
 		goto out_free_irq;
 
+	/* We finish our disk initialization and add the disk to the system. */
 	bd->disk->major = bd->major;
 	bd->disk->first_minor = 0;
 	bd->disk->private_data = bd;
 	bd->disk->fops = &lguestblk_fops;
-	/* This is initialized to the disk size by the other end. */
+	/* This is initialized to the disk size by the Launcher. */
 	set_capacity(bd->disk, bd->lb_page->num_sectors);
 	add_disk(bd->disk);
 
 	printk(KERN_INFO "%s: device %i at major %d\n",
 	       bd->disk->disk_name, lgdev->index, bd->major);
 
+	/* We don't need to keep the "struct blockdev" around, but if we ever
+	 * implemented device removal, we'd need this. */
 	lgdev->private = bd;
 	return 0;
 
@@ -258,6 +401,8 @@ out_free_bd:
 	return err;
 }
 
+/*D:410 The boilerplate code for registering the lguest block driver is just
+ * like the console: */
 static struct lguest_driver lguestblk_drv = {
 	.name = "lguestblk",
 	.owner = THIS_MODULE,
diff -puN drivers/char/hvc_lguest.c~lguest-documentation-iii-drivers drivers/char/hvc_lguest.c
--- a/drivers/char/hvc_lguest.c~lguest-documentation-iii-drivers
+++ a/drivers/char/hvc_lguest.c
@@ -1,6 +1,19 @@
-/* Simple console for lguest.
+/*D:300
+ * The Guest console driver
  *
- * Copyright (C) 2006 Rusty Russell, IBM Corporation
+ * This is a trivial console driver: we use lguest's DMA mechanism to send
+ * bytes out, and register a DMA buffer to receive bytes in.  It is assumed to
+ * be present and available from the very beginning of boot.
+ *
+ * Writing console drivers is one of the few remaining Dark Arts in Linux.
+ * Fortunately for us, the path of virtual consoles has been well-trodden by
+ * the PowerPC folks, who wrote "hvc_console.c" to generically support any
+ * virtual console.  We use that infrastructure which only requires us to write
+ * the basic put_chars and get_chars functions and call the right register
+ * functions.
+ :*/
+
+/* Copyright (C) 2006 Rusty Russell, IBM Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -21,49 +34,81 @@
 #include <linux/lguest_bus.h>
 #include "hvc_console.h"
 
+/*D:340 This is our single console input buffer, with associated "struct
+ * lguest_dma" referring to it.  Note the 0-terminated length array, and the
+ * use of physical address for the buffer itself. */
 static char inbuf[256];
 static struct lguest_dma cons_input = { .used_len = 0,
 					.addr[0] = __pa(inbuf),
 					.len[0] = sizeof(inbuf),
 					.len[1] = 0 };
 
+/*D:310 The put_chars() callback is pretty straightforward.
+ *
+ * First we put the pointer and length in a "struct lguest_dma": we only have
+ * one pointer, so we set the second length to 0.  Then we use SEND_DMA to send
+ * the data to (Host) buffers attached to the console key.  Usually a device's
+ * key is a physical address within the device's memory, but because the
+ * console device doesn't have any associated physical memory, we use the
+ * LGUEST_CONSOLE_DMA_KEY constant (aka 0). */
 static int put_chars(u32 vtermno, const char *buf, int count)
 {
 	struct lguest_dma dma;
 
-	/* FIXME: what if it's over a page boundary? */
+	/* FIXME: DMA buffers in a "struct lguest_dma" are not allowed
+	 * to go over page boundaries.  This never seems to happen,
+	 * but if it did we'd need to fix this code. */
 	dma.len[0] = count;
 	dma.len[1] = 0;
 	dma.addr[0] = __pa(buf);
 
 	lguest_send_dma(LGUEST_CONSOLE_DMA_KEY, &dma);
+	/* We're expected to return the amount of data we wrote: all of it. */
 	return count;
 }
 
+/*D:350 get_chars() is the callback from the hvc_console infrastructure when
+ * an interrupt is received.
+ *
+ * Firstly we see if our buffer has been filled: if not, we return.  The rest
+ * of the code deals with the fact that the hvc_console() infrastructure only
+ * asks us for 16 bytes at a time.  We keep a "cons_offset" variable for
+ * partially-read buffers. */
 static int get_chars(u32 vtermno, char *buf, int count)
 {
 	static int cons_offset;
 
+	/* Nothing left to see here... */
 	if (!cons_input.used_len)
 		return 0;
 
+	/* You want more than we have to give?  Well, try wanting less! */
 	if (cons_input.used_len - cons_offset < count)
 		count = cons_input.used_len - cons_offset;
 
+	/* Copy across to their buffer and increment offset. */
 	memcpy(buf, inbuf + cons_offset, count);
 	cons_offset += count;
+
+	/* Finished?  Zero offset, and reset cons_input so Host will use it
+	 * again. */
 	if (cons_offset == cons_input.used_len) {
 		cons_offset = 0;
 		cons_input.used_len = 0;
 	}
 	return count;
 }
+/*:*/
 
 static struct hv_ops lguest_cons = {
 	.get_chars = get_chars,
 	.put_chars = put_chars,
 };
 
+/*D:320 Console drivers are initialized very early so boot messages can go
+ * out.  At this stage, the console is output-only.  Our driver checks we're a
+ * Guest, and if so hands hvc_instantiate() the console number (0), priority
+ * (0), and the struct hv_ops containing the put_chars() function. */
 static int __init cons_init(void)
 {
 	if (strcmp(paravirt_ops.name, "lguest") != 0)
@@ -73,21 +118,46 @@ static int __init cons_init(void)
 }
 console_initcall(cons_init);
 
+/*D:370 To set up and manage our virtual console, we call hvc_alloc() and
+ * stash the result in the private pointer of the "struct lguest_device".
+ * Since we never remove the console device we never need this pointer again,
+ * but using ->private is considered good form, and you never know who's going
+ * to copy your driver.
+ *
+ * Once the console is set up, we bind our input buffer ready for input. */
 static int lguestcons_probe(struct lguest_device *lgdev)
 {
 	int err;
 
+	/* The first argument of hvc_alloc() is the virtual console number, so
+	 * we use zero.  The second argument is the interrupt number.
+	 *
+	 * The third argument is a "struct hv_ops" containing the put_chars()
+	 * and get_chars() pointers.  The final argument is the output buffer
+	 * size: we use 256 and expect the Host to have room for us to send
+	 * that much. */
 	lgdev->private = hvc_alloc(0, lgdev_irq(lgdev), &lguest_cons, 256);
 	if (IS_ERR(lgdev->private))
 		return PTR_ERR(lgdev->private);
 
+	/* We bind a single DMA buffer at key LGUEST_CONSOLE_DMA_KEY.
+	 * "cons_input" is that statically-initialized global DMA buffer we saw
+	 * above, and we also give the interrupt we want. */
 	err = lguest_bind_dma(LGUEST_CONSOLE_DMA_KEY, &cons_input, 1,
 			      lgdev_irq(lgdev));
 	if (err)
 		printk("lguest console: failed to bind buffer.\n");
 	return err;
 }
-
+/* Note the use of lgdev_irq() for the interrupt number.  We tell hvc_alloc()
+ * to expect input when this interrupt is triggered, and then tell
+ * lguest_bind_dma() that is the interrupt to send us when input comes in. */
+
+/*D:360 From now on the console driver follows standard Guest driver form:
+ * register_lguest_driver() registers the device type and probe function, and
+ * the probe function sets up the device.
+ *
+ * The standard "struct lguest_driver": */
 static struct lguest_driver lguestcons_drv = {
 	.name = "lguestcons",
 	.owner = THIS_MODULE,
@@ -95,6 +165,7 @@ static struct lguest_driver lguestcons_d
 	.probe = lguestcons_probe,
 };
 
+/* The standard init function */
 static int __init hvc_lguest_init(void)
 {
 	return register_lguest_driver(&lguestcons_drv);
diff -puN drivers/lguest/lguest_bus.c~lguest-documentation-iii-drivers drivers/lguest/lguest_bus.c
--- a/drivers/lguest/lguest_bus.c~lguest-documentation-iii-drivers
+++ a/drivers/lguest/lguest_bus.c
@@ -46,6 +46,10 @@ static struct device_attribute lguest_de
 	__ATTR_NULL
 };
 
+/*D:130 The generic bus infrastructure requires a function which says whether a
+ * device matches a driver.  For us, it is simple: "struct lguest_driver"
+ * contains a "device_type" field which indicates what type of device it can
+ * handle, so we just cast the args and compare: */
 static int lguest_dev_match(struct device *_dev, struct device_driver *_drv)
 {
 	struct lguest_device *dev = container_of(_dev,struct lguest_device,dev);
@@ -53,6 +57,7 @@ static int lguest_dev_match(struct devic
 
 	return (drv->device_type == lguest_devices[dev->index].type);
 }
+/*:*/
 
 struct lguest_bus {
 	struct bus_type bus;
@@ -71,11 +76,24 @@ static struct lguest_bus lguest_bus = {
 	}
 };
 
+/*D:140 This is the callback which occurs once the bus infrastructure matches
+ * up a device and driver, ie. in response to add_lguest_device() calling
+ * device_register(), or register_lguest_driver() calling driver_register().
+ *
+ * At the moment it's always the latter: the devices are added first, since
+ * scan_devices() is called from a "core_initcall", and the drivers themselves
+ * called later as a normal "initcall".  But it would work the other way too.
+ *
+ * So now we have the happy couple, we add the status bit to indicate that we
+ * found a driver.  If the driver truly loves the device, it will return
+ * happiness from its probe function (ok, perhaps this wasn't my greatest
+ * analogy), and we set the final "driver ok" bit so the Host sees it's all
+ * green. */
 static int lguest_dev_probe(struct device *_dev)
 {
 	int ret;
-	struct lguest_device *dev = container_of(_dev,struct lguest_device,dev);
-	struct lguest_driver *drv = container_of(dev->dev.driver,
+	struct lguest_device*dev = container_of(_dev,struct lguest_device,dev);
+	struct lguest_driver*drv = container_of(dev->dev.driver,
 						struct lguest_driver, drv);
 
 	lguest_devices[dev->index].status |= LGUEST_DEVICE_S_DRIVER;
@@ -85,6 +103,10 @@ static int lguest_dev_probe(struct devic
 	return ret;
 }
 
+/* The last part of the bus infrastructure is the function lguest drivers use
+ * to register themselves.  Firstly, we do nothing if there's no lguest bus
+ * (ie. this is not a Guest), otherwise we fill in the embedded generic "struct
+ * driver" fields and call the generic driver_register(). */
 int register_lguest_driver(struct lguest_driver *drv)
 {
 	if (!lguest_devices)
@@ -97,12 +119,36 @@ int register_lguest_driver(struct lguest
 
 	return driver_register(&drv->drv);
 }
+
+/* At the moment we build all the drivers into the kernel because they're so
+ * simple: 8144 bytes for all three of them as I type this.  And as the console
+ * really needs to be built in, it's actually only 3527 bytes for the network
+ * and block drivers.
+ *
+ * If they get complex it will make sense for them to be modularized, so we
+ * need to explicitly export the symbol.
+ *
+ * I don't think non-GPL modules make sense, so it's a GPL-only export.
+ */
 EXPORT_SYMBOL_GPL(register_lguest_driver);
 
+/*D:120 This is the core of the lguest bus: actually adding a new device.
+ * It's a separate function because it's neater that way, and because an
+ * earlier version of the code supported hotplug and unplug.  They were removed
+ * early on because they were never used.
+ *
+ * As Andrew Tridgell says, "Untested code is buggy code".
+ *
+ * It's worth reading this carefully: we start with an index into the array of
+ * "struct lguest_device_desc"s indicating the device which is new: */
 static void add_lguest_device(unsigned int index)
 {
 	struct lguest_device *new;
 
+	/* Each "struct lguest_device_desc" has a "status" field, which the
+	 * Guest updates as the device is probed.  In the worst case, the Host
+	 * can look at these bits to tell what part of device setup failed,
+	 * even if the console isn't available. */
 	lguest_devices[index].status |= LGUEST_DEVICE_S_ACKNOWLEDGE;
 	new = kmalloc(sizeof(struct lguest_device), GFP_KERNEL);
 	if (!new) {
@@ -111,12 +157,17 @@ static void add_lguest_device(unsigned i
 		return;
 	}
 
+	/* The "struct lguest_device" setup is pretty straight-forward example
+	 * code. */
 	new->index = index;
 	new->private = NULL;
 	memset(&new->dev, 0, sizeof(new->dev));
 	new->dev.parent = &lguest_bus.dev;
 	new->dev.bus = &lguest_bus.bus;
 	sprintf(new->dev.bus_id, "%u", index);
+
+	/* device_register() causes the bus infrastructure to look for a
+	 * matching driver. */
 	if (device_register(&new->dev) != 0) {
 		printk(KERN_EMERG "Cannot register lguest device %u\n", index);
 		lguest_devices[index].status |= LGUEST_DEVICE_S_FAILED;
@@ -124,6 +175,9 @@ static void add_lguest_device(unsigned i
 	}
 }
 
+/*D:110 scan_devices() simply iterates through the device array.  The type 0
+ * is reserved to mean "no device", and anything else means we have found a
+ * device: add it. */
 static void scan_devices(void)
 {
 	unsigned int i;
@@ -133,12 +187,23 @@ static void scan_devices(void)
 			add_lguest_device(i);
 }
 
+/*D:100 Fairly early in boot, lguest_bus_init() is called to set up the lguest
+ * bus.  We check that we are a Guest by checking paravirt_ops.name: there are
+ * other ways of checking, but this seems most obvious to me.
+ *
+ * So we can access the array of "struct lguest_device_desc"s easily, we map
+ * that memory and store the pointer in the global "lguest_devices".  Then we
+ * register the bus with the core.  Doing two registrations seems clunky to me,
+ * but it seems to be the correct sysfs incantation.
+ *
+ * Finally we call scan_devices() which adds all the devices found in the
+ * "struct lguest_device_desc" array. */
 static int __init lguest_bus_init(void)
 {
 	if (strcmp(paravirt_ops.name, "lguest") != 0)
 		return 0;
 
-	/* Devices are in page above top of "normal" mem. */
+	/* Devices are in a single page above top of "normal" mem */
 	lguest_devices = lguest_map(max_pfn<<PAGE_SHIFT, 1);
 
 	if (bus_register(&lguest_bus.bus) != 0
@@ -148,4 +213,5 @@ static int __init lguest_bus_init(void)
 	scan_devices();
 	return 0;
 }
+/* Do this after core stuff, before devices. */
 postcore_initcall(lguest_bus_init);
diff -puN drivers/net/lguest_net.c~lguest-documentation-iii-drivers drivers/net/lguest_net.c
--- a/drivers/net/lguest_net.c~lguest-documentation-iii-drivers
+++ a/drivers/net/lguest_net.c
@@ -1,6 +1,13 @@
-/* A simple network driver for lguest.
+/*D:500
+ * The Guest network driver.
  *
- * Copyright 2006 Rusty Russell <rusty@rustcorp.com.au> IBM Corporation
+ * This is very simple a virtual network driver, and our last Guest driver.
+ * The only trick is that it can talk directly to multiple other recipients
+ * (ie. other Guests on the same network).  It can also be used with only the
+ * Host on the network.
+ :*/
+
+/* Copyright 2006 Rusty Russell <rusty@rustcorp.com.au> IBM Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -28,23 +35,28 @@
 #define MAX_LANS		4
 #define NUM_SKBS		8
 
+/*D:530 The "struct lguestnet_info" contains all the information we need to
+ * know about the network device. */
 struct lguestnet_info
 {
-	/* The shared page(s). */
+	/* The mapped device page(s) (an array of "struct lguest_net"). */
 	struct lguest_net *peer;
+	/* The physical address of the device page(s) */
 	unsigned long peer_phys;
+	/* The size of the device page(s). */
 	unsigned long mapsize;
 
 	/* The lguest_device I come from */
 	struct lguest_device *lgdev;
 
-	/* My peerid. */
+	/* My peerid (ie. my slot in the array). */
 	unsigned int me;
 
-	/* Receive queue. */
+	/* Receive queue: the network packets waiting to be filled. */
 	struct sk_buff *skb[NUM_SKBS];
 	struct lguest_dma dma[NUM_SKBS];
 };
+/*:*/
 
 /* How many bytes left in this page. */
 static unsigned int rest_of_page(void *data)
@@ -52,39 +64,82 @@ static unsigned int rest_of_page(void *d
 	return PAGE_SIZE - ((unsigned long)data % PAGE_SIZE);
 }
 
-/* Simple convention: offset 4 * peernum. */
+/*D:570 Each peer (ie. Guest or Host) on the network binds their receive
+ * buffers to a different key: we simply use the physical address of the
+ * device's memory page plus the peer number.  The Host insists that all keys
+ * be a multiple of 4, so we multiply the peer number by 4. */
 static unsigned long peer_key(struct lguestnet_info *info, unsigned peernum)
 {
 	return info->peer_phys + 4 * peernum;
 }
 
+/* This is the routine which sets up a "struct lguest_dma" to point to a
+ * network packet, similar to req_to_dma() in lguest_blk.c.  The structure of a
+ * "struct sk_buff" has grown complex over the years: it consists of a "head"
+ * linear section pointed to by "skb->data", and possibly an array of
+ * "fragments" in the case of a non-linear packet.
+ *
+ * Our receive buffers don't use fragments at all but outgoing skbs might, so
+ * we handle it. */
 static void skb_to_dma(const struct sk_buff *skb, unsigned int headlen,
 		       struct lguest_dma *dma)
 {
 	unsigned int i, seg;
 
+	/* First, we put the linear region into the "struct lguest_dma".  Each
+	 * entry can't go over a page boundary, so even though all our packets
+	 * are 1514 bytes or less, we might need to use two entries here: */
 	for (i = seg = 0; i < headlen; seg++, i += rest_of_page(skb->data+i)) {
 		dma->addr[seg] = virt_to_phys(skb->data + i);
 		dma->len[seg] = min((unsigned)(headlen - i),
 				    rest_of_page(skb->data + i));
 	}
+
+	/* Now we handle the fragments: at least they're guaranteed not to go
+	 * over a page.  skb_shinfo(skb) returns a pointer to the structure
+	 * which tells us about the number of fragments and the fragment
+	 * array. */
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++, seg++) {
 		const skb_frag_t *f = &skb_shinfo(skb)->frags[i];
 		/* Should not happen with MTU less than 64k - 2 * PAGE_SIZE. */
 		if (seg == LGUEST_MAX_DMA_SECTIONS) {
+			/* We will end up sending a truncated packet should
+			 * this ever happen.  Plus, a cool log message! */
 			printk("Woah dude!  Megapacket!\n");
 			break;
 		}
 		dma->addr[seg] = page_to_phys(f->page) + f->page_offset;
 		dma->len[seg] = f->size;
 	}
+
+	/* If after all that we didn't use the entire "struct lguest_dma"
+	 * array, we terminate it with a 0 length. */
 	if (seg < LGUEST_MAX_DMA_SECTIONS)
 		dma->len[seg] = 0;
 }
 
-/* We overload multicast bit to show promiscuous mode. */
+/*
+ * Packet transmission.
+ *
+ * Our packet transmission is a little unusual.  A real network card would just
+ * send out the packet and leave the receivers to decide if they're interested.
+ * Instead, we look through the network device memory page and see if any of
+ * the ethernet addresses match the packet destination, and if so we send it to
+ * that Guest.
+ *
+ * This is made a little more complicated in two cases.  The first case is
+ * broadcast packets: for that we send the packet to all Guests on the network,
+ * one at a time.  The second case is "promiscuous" mode, where a Guest wants
+ * to see all the packets on the network.  We need a way for the Guest to tell
+ * us it wants to see all packets, so it sets the "multicast" bit on its
+ * published MAC address, which is never valid in a real ethernet address.
+ */
 #define PROMISC_BIT		0x01
 
+/* This is the callback which is summoned whenever the network device's
+ * multicast or promiscuous state changes.  If the card is in promiscuous mode,
+ * we advertise that in our ethernet address in the device's memory.  We do the
+ * same if Linux wants any or all multicast traffic.  */
 static void lguestnet_set_multicast(struct net_device *dev)
 {
 	struct lguestnet_info *info = netdev_priv(dev);
@@ -95,11 +150,14 @@ static void lguestnet_set_multicast(stru
 		info->peer[info->me].mac[0] &= ~PROMISC_BIT;
 }
 
+/* A simple test function to see if a peer wants to see all packets.*/
 static int promisc(struct lguestnet_info *info, unsigned int peer)
 {
 	return info->peer[peer].mac[0] & PROMISC_BIT;
 }
 
+/* Another simple function to see if a peer's advertised ethernet address
+ * matches a packet's destination ethernet address. */
 static int mac_eq(const unsigned char mac[ETH_ALEN],
 		  struct lguestnet_info *info, unsigned int peer)
 {
@@ -109,6 +167,8 @@ static int mac_eq(const unsigned char ma
 	return memcmp(mac+1, info->peer[peer].mac+1, ETH_ALEN-1) == 0;
 }
 
+/* This is the function which actually sends a packet once we've decided a
+ * peer wants it: */
 static void transfer_packet(struct net_device *dev,
 			    struct sk_buff *skb,
 			    unsigned int peernum)
@@ -116,76 +176,134 @@ static void transfer_packet(struct net_d
 	struct lguestnet_info *info = netdev_priv(dev);
 	struct lguest_dma dma;
 
+	/* We use our handy "struct lguest_dma" packing function to prepare
+	 * the skb for sending. */
 	skb_to_dma(skb, skb_headlen(skb), &dma);
 	pr_debug("xfer length %04x (%u)\n", htons(skb->len), skb->len);
 
+	/* This is the actual send call which copies the packet. */
 	lguest_send_dma(peer_key(info, peernum), &dma);
+
+	/* Check that the entire packet was transmitted.  If not, it could mean
+	 * that the other Guest registered a short receive buffer, but this
+	 * driver should never do that.  More likely, the peer is dead. */
 	if (dma.used_len != skb->len) {
 		dev->stats.tx_carrier_errors++;
 		pr_debug("Bad xfer to peer %i: %i of %i (dma %p/%i)\n",
 			 peernum, dma.used_len, skb->len,
 			 (void *)dma.addr[0], dma.len[0]);
 	} else {
+		/* On success we update the stats. */
 		dev->stats.tx_bytes += skb->len;
 		dev->stats.tx_packets++;
 	}
 }
 
+/* Another helper function to tell is if a slot in the device memory is unused.
+ * Since we always set the Local Assignment bit in the ethernet address, the
+ * first byte can never be 0. */
 static int unused_peer(const struct lguest_net peer[], unsigned int num)
 {
 	return peer[num].mac[0] == 0;
 }
 
+/* Finally, here is the routine which handles an outgoing packet.  It's called
+ * "start_xmit" for traditional reasons. */
 static int lguestnet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	unsigned int i;
 	int broadcast;
 	struct lguestnet_info *info = netdev_priv(dev);
+	/* Extract the destination ethernet address from the packet. */
 	const unsigned char *dest = ((struct ethhdr *)skb->data)->h_dest;
 
 	pr_debug("%s: xmit %02x:%02x:%02x:%02x:%02x:%02x\n",
 		 dev->name, dest[0],dest[1],dest[2],dest[3],dest[4],dest[5]);
 
+	/* If it's a multicast packet, we broadcast to everyone.  That's not
+	 * very efficient, but there are very few applications which actually
+	 * use multicast, which is a shame really.
+	 *
+	 * As etherdevice.h points out: "By definition the broadcast address is
+	 * also a multicast address."  So we don't have to test for broadcast
+	 * packets separately. */
 	broadcast = is_multicast_ether_addr(dest);
+
+	/* Look through all the published ethernet addresses to see if we
+	 * should send this packet. */
 	for (i = 0; i < info->mapsize/sizeof(struct lguest_net); i++) {
+		/* We don't send to ourselves (we actually can't SEND_DMA to
+		 * ourselves anyway), and don't send to unused slots.*/
 		if (i == info->me || unused_peer(info->peer, i))
 			continue;
 
+		/* If it's broadcast we send it.  If they want every packet we
+		 * send it.  If the destination matches their address we send
+		 * it.  Otherwise we go to the next peer. */
 		if (!broadcast && !promisc(info, i) && !mac_eq(dest, info, i))
 			continue;
 
 		pr_debug("lguestnet %s: sending from %i to %i\n",
 			 dev->name, info->me, i);
+		/* Our routine which actually does the transfer. */
 		transfer_packet(dev, skb, i);
 	}
+
+	/* An xmit routine is expected to dispose of the packet, so we do. */
 	dev_kfree_skb(skb);
+
+	/* As per kernel convention, 0 means success.  This is why I love
+	 * networking: even if we never sent to anyone, that's still
+	 * success! */
 	return 0;
 }
 
-/* Find a new skb to put in this slot in shared mem. */
+/*D:560
+ * Packet receiving.
+ *
+ * First, here's a helper routine which fills one of our array of receive
+ * buffers: */
 static int fill_slot(struct net_device *dev, unsigned int slot)
 {
 	struct lguestnet_info *info = netdev_priv(dev);
-	/* Try to create and register a new one. */
+
+	/* We can receive ETH_DATA_LEN (1500) byte packets, plus a standard
+	 * ethernet header of ETH_HLEN (14) bytes. */
 	info->skb[slot] = netdev_alloc_skb(dev, ETH_HLEN + ETH_DATA_LEN);
 	if (!info->skb[slot]) {
 		printk("%s: could not fill slot %i\n", dev->name, slot);
 		return -ENOMEM;
 	}
 
+	/* skb_to_dma() is a helper which sets up the "struct lguest_dma" to
+	 * point to the data in the skb: we also use it for sending out a
+	 * packet. */
 	skb_to_dma(info->skb[slot], ETH_HLEN + ETH_DATA_LEN, &info->dma[slot]);
+
+	/* This is a Write Memory Barrier: it ensures that the entry in the
+	 * receive buffer array is written *before* we set the "used_len" entry
+	 * to 0.  If the Host were looking at the receive buffer array from a
+	 * different CPU, it could potentially see "used_len = 0" and not see
+	 * the updated receive buffer information.  This would be a horribly
+	 * nasty bug, so make sure the compiler and CPU know this has to happen
+	 * first. */
 	wmb();
-	/* Now we tell hypervisor it can use the slot. */
+	/* Writing 0 to "used_len" tells the Host it can use this receive
+	 * buffer now. */
 	info->dma[slot].used_len = 0;
 	return 0;
 }
 
+/* This is the actual receive routine.  When we receive an interrupt from the
+ * Host to tell us a packet has been delivered, we arrive here: */
 static irqreturn_t lguestnet_rcv(int irq, void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct lguestnet_info *info = netdev_priv(dev);
 	unsigned int i, done = 0;
 
+	/* Look through our entire receive array for an entry which has data
+	 * in it. */
 	for (i = 0; i < ARRAY_SIZE(info->dma); i++) {
 		unsigned int length;
 		struct sk_buff *skb;
@@ -194,10 +312,16 @@ static irqreturn_t lguestnet_rcv(int irq
 		if (length == 0)
 			continue;
 
+		/* We've found one!  Remember the skb (we grabbed the length
+		 * above), and immediately refill the slot we've taken it
+		 * from. */
 		done++;
 		skb = info->skb[i];
 		fill_slot(dev, i);
 
+		/* This shouldn't happen: micropackets could be sent by a
+		 * badly-behaved Guest on the network, but the Host will never
+		 * stuff more data in the buffer than the buffer length. */
 		if (length < ETH_HLEN || length > ETH_HLEN + ETH_DATA_LEN) {
 			pr_debug(KERN_WARNING "%s: unbelievable skb len: %i\n",
 				 dev->name, length);
@@ -205,36 +329,72 @@ static irqreturn_t lguestnet_rcv(int irq
 			continue;
 		}
 
+		/* skb_put(), what a great function!  I've ranted about this
+		 * function before (http://lkml.org/lkml/1999/9/26/24).  You
+		 * call it after you've added data to the end of an skb (in
+		 * this case, it was the Host which wrote the data). */
 		skb_put(skb, length);
+
+		/* The ethernet header contains a protocol field: we use the
+		 * standard helper to extract it, and place the result in
+		 * skb->protocol.  The helper also sets up skb->pkt_type and
+		 * eats up the ethernet header from the front of the packet. */
 		skb->protocol = eth_type_trans(skb, dev);
-		/* This is a reliable transport. */
+
+		/* If this device doesn't need checksums for sending, we also
+		 * don't need to check the packets when they come in. */
 		if (dev->features & NETIF_F_NO_CSUM)
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
+
+		/* As a last resort for debugging the driver or the lguest I/O
+		 * subsystem, you can uncomment the "#define DEBUG" at the top
+		 * of this file, which turns all the pr_debug() into printk()
+		 * and floods the logs. */
 		pr_debug("Receiving skb proto 0x%04x len %i type %i\n",
 			 ntohs(skb->protocol), skb->len, skb->pkt_type);
 
+		/* Update the packet and byte counts (visible from ifconfig,
+		 * and good for debugging). */
 		dev->stats.rx_bytes += skb->len;
 		dev->stats.rx_packets++;
+
+		/* Hand our fresh network packet into the stack's "network
+		 * interface receive" routine.  That will free the packet
+		 * itself when it's finished. */
 		netif_rx(skb);
 	}
+
+	/* If we found any packets, we assume the interrupt was for us. */
 	return done ? IRQ_HANDLED : IRQ_NONE;
 }
 
+/*D:550 This is where we start: when the device is brought up by dhcpd or
+ * ifconfig.  At this point we advertise our MAC address to the rest of the
+ * network, and register receive buffers ready for incoming packets. */
 static int lguestnet_open(struct net_device *dev)
 {
 	int i;
 	struct lguestnet_info *info = netdev_priv(dev);
 
-	/* Set up our MAC address */
+	/* Copy our MAC address into the device page, so others on the network
+	 * can find us. */
 	memcpy(info->peer[info->me].mac, dev->dev_addr, ETH_ALEN);
 
-	/* Turn on promisc mode if needed */
+	/* We might already be in promisc mode (dev->flags & IFF_PROMISC).  Our
+	 * set_multicast callback handles this already, so we call it now. */
 	lguestnet_set_multicast(dev);
 
+	/* Allocate packets and put them into our "struct lguest_dma" array.
+	 * If we fail to allocate all the packets we could still limp along,
+	 * but it's a sign of real stress so we should probably give up now. */
 	for (i = 0; i < ARRAY_SIZE(info->dma); i++) {
 		if (fill_slot(dev, i) != 0)
 			goto cleanup;
 	}
+
+	/* Finally we tell the Host where our array of "struct lguest_dma"
+	 * receive buffers is, binding it to the key corresponding to the
+	 * device's physical memory plus our peerid. */
 	if (lguest_bind_dma(peer_key(info,info->me), info->dma,
 			    NUM_SKBS, lgdev_irq(info->lgdev)) != 0)
 		goto cleanup;
@@ -245,22 +405,29 @@ cleanup:
 		dev_kfree_skb(info->skb[i]);
 	return -ENOMEM;
 }
+/*:*/
 
+/* The close routine is called when the device is no longer in use: we clean up
+ * elegantly. */
 static int lguestnet_close(struct net_device *dev)
 {
 	unsigned int i;
 	struct lguestnet_info *info = netdev_priv(dev);
 
-	/* Clear all trace: others might deliver packets, we'll ignore it. */
+	/* Clear all trace of our existence out of the device memory by setting
+	 * the slot which held our MAC address to 0 (unused). */
 	memset(&info->peer[info->me], 0, sizeof(info->peer[info->me]));
 
-	/* Deregister sg lists. */
+	/* Unregister our array of receive buffers */
 	lguest_unbind_dma(peer_key(info, info->me), info->dma);
 	for (i = 0; i < ARRAY_SIZE(info->dma); i++)
 		dev_kfree_skb(info->skb[i]);
 	return 0;
 }
 
+/*D:510 The network device probe function is basically a standard ethernet
+ * device setup.  It reads the "struct lguest_device_desc" and sets the "struct
+ * net_device".  Oh, the line-by-line excitement!  Let's skip over it. :*/
 static int lguestnet_probe(struct lguest_device *lgdev)
 {
 	int err, irqf = IRQF_SHARED;
@@ -290,10 +457,16 @@ static int lguestnet_probe(struct lguest
 	dev->stop = lguestnet_close;
 	dev->hard_start_xmit = lguestnet_start_xmit;
 
-	/* Turning on/off promisc will call dev->set_multicast_list.
-	 * We don't actually support multicast yet */
+	/* We don't actually support multicast yet, but turning on/off
+	 * promisc also calls dev->set_multicast_list. */
 	dev->set_multicast_list = lguestnet_set_multicast;
 	SET_NETDEV_DEV(dev, &lgdev->dev);
+
+	/* The network code complains if you have "scatter-gather" capability
+	 * if you don't also handle checksums (it seem that would be
+	 * "illogical").  So we use a lie of omission and don't tell it that we
+	 * can handle scattered packets unless we also don't want checksums,
+	 * even though to us they're completely independent. */
 	if (desc->features & LGUEST_NET_F_NOCSUM)
 		dev->features = NETIF_F_SG|NETIF_F_NO_CSUM;
 
@@ -325,6 +498,9 @@ static int lguestnet_probe(struct lguest
 	}
 
 	pr_debug("lguestnet: registered device %s\n", dev->name);
+	/* Finally, we put the "struct net_device" in the generic "struct
+	 * lguest_device"s private pointer.  Again, it's not necessary, but
+	 * makes sure the cool kernel kids don't tease us. */
 	lgdev->private = dev;
 	return 0;
 
@@ -352,3 +528,11 @@ module_init(lguestnet_init);
 
 MODULE_DESCRIPTION("Lguest network driver");
 MODULE_LICENSE("GPL");
+
+/*D:580
+ * This is the last of the Drivers, and with this we have covered the many and
+ * wonderous and fine (and boring) details of the Guest.
+ *
+ * "make Launcher" beckons, where we answer questions like "Where do Guests
+ * come from?", and "What do you do when someone asks for optimization?"
+ */
diff -puN include/linux/lguest_bus.h~lguest-documentation-iii-drivers include/linux/lguest_bus.h
--- a/include/linux/lguest_bus.h~lguest-documentation-iii-drivers
+++ a/include/linux/lguest_bus.h
@@ -15,11 +15,14 @@ struct lguest_device {
 	void *private;
 };
 
-/* By convention, each device can use irq index+1 if it wants to. */
+/*D:380 Since interrupt numbers are arbitrary, we use a convention: each device
+ * can use the interrupt number corresponding to its index.  The +1 is because
+ * interrupt 0 is not usable (it's actually the timer interrupt). */
 static inline int lgdev_irq(const struct lguest_device *dev)
 {
 	return dev->index + 1;
 }
+/*:*/
 
 /* dma args must not be vmalloced! */
 void lguest_send_dma(unsigned long key, struct lguest_dma *dma);
diff -puN include/linux/lguest_launcher.h~lguest-documentation-iii-drivers include/linux/lguest_launcher.h
--- a/include/linux/lguest_launcher.h~lguest-documentation-iii-drivers
+++ a/include/linux/lguest_launcher.h
@@ -9,14 +9,45 @@
 /* How many devices?  Assume each one wants up to two dma arrays per device. */
 #define LGUEST_MAX_DEVICES (LGUEST_MAX_DMA/2)
 
+/*D:200
+ * Lguest I/O
+ *
+ * The lguest I/O mechanism is the only way Guests can talk to devices.  There
+ * are two hypercalls involved: SEND_DMA for output and BIND_DMA for input.  In
+ * each case, "struct lguest_dma" describes the buffer: this contains 16
+ * addr/len pairs, and if there are fewer buffer elements the len array is
+ * terminated with a 0.
+ *
+ * I/O is organized by keys: BIND_DMA attaches buffers to a particular key, and
+ * SEND_DMA transfers to buffers bound to particular key.  By convention, keys
+ * correspond to a physical address within the device's page.  This means that
+ * devices will never accidentally end up with the same keys, and allows the
+ * Host use The Futex Trick (as we'll see later in our journey).
+ *
+ * SEND_DMA simply indicates a key to send to, and the physical address of the
+ * "struct lguest_dma" to send.  The Host will write the number of bytes
+ * transferred into the "struct lguest_dma"'s used_len member.
+ *
+ * BIND_DMA indicates a key to bind to, a pointer to an array of "struct
+ * lguest_dma"s ready for receiving, the size of that array, and an interrupt
+ * to trigger when data is received.  The Host will only allow transfers into
+ * buffers with a used_len of zero: it then sets used_len to the number of
+ * bytes transferred and triggers the interrupt for the Guest to process the
+ * new input. */
 struct lguest_dma
 {
-	/* 0 if free to be used, filled by hypervisor. */
+	/* 0 if free to be used, filled by the Host. */
  	u32 used_len;
 	unsigned long addr[LGUEST_MAX_DMA_SECTIONS];
 	u16 len[LGUEST_MAX_DMA_SECTIONS];
 };
+/*:*/
 
+/*D:460 This is the layout of a block device memory page.  The Launcher sets up
+ * the num_sectors initially to tell the Guest the size of the disk.  The Guest
+ * puts the type, sector and length of the request in the first three fields,
+ * then DMAs to the Host.  The Host processes the request, sets up the result,
+ * then DMAs back to the Guest. */
 struct lguest_block_page
 {
 	/* 0 is a read, 1 is a write. */
@@ -28,27 +59,47 @@ struct lguest_block_page
 	u32 num_sectors; /* Disk length = num_sectors * 512 */
 };
 
-/* There is a shared page of these. */
+/*D:520 The network device is basically a memory page where all the Guests on
+ * the network publish their MAC (ethernet) addresses: it's an array of "struct
+ * lguest_net": */
 struct lguest_net
 {
 	/* Simply the mac address (with multicast bit meaning promisc). */
 	unsigned char mac[6];
 };
+/*:*/
 
 /* Where the Host expects the Guest to SEND_DMA console output to. */
 #define LGUEST_CONSOLE_DMA_KEY 0
 
-/* We have a page of these descriptors in the lguest_device page. */
+/*D:010
+ * Drivers
+ *
+ * The Guest needs devices to do anything useful.  Since we don't let it touch
+ * real devices (think of the damage it could do!) we provide virtual devices.
+ * We could emulate a PCI bus with various devices on it, but that is a fairly
+ * complex burden for the Host and suboptimal for the Guest, so we have our own
+ * "lguest" bus and simple drivers.
+ *
+ * Devices are described by an array of LGUEST_MAX_DEVICES of these structs,
+ * placed by the Launcher just above the top of physical memory:
+ */
 struct lguest_device_desc {
+	/* The device type: console, network, disk etc. */
 	u16 type;
 #define LGUEST_DEVICE_T_CONSOLE	1
 #define LGUEST_DEVICE_T_NET	2
 #define LGUEST_DEVICE_T_BLOCK	3
 
+	/* The specific features of this device: these depends on device type
+	 * except for LGUEST_DEVICE_F_RANDOMNESS. */
 	u16 features;
 #define LGUEST_NET_F_NOCSUM		0x4000 /* Don't bother checksumming */
 #define LGUEST_DEVICE_F_RANDOMNESS	0x8000 /* IRQ is fairly random */
 
+	/* This is how the Guest reports status of the device: the Host can set
+	 * LGUEST_DEVICE_S_REMOVED to indicate removal, but the rest are only
+	 * ever manipulated by the Guest, and only ever set. */
 	u16 status;
 /* 256 and above are device specific. */
 #define LGUEST_DEVICE_S_ACKNOWLEDGE	1 /* We have seen device. */
@@ -58,9 +109,12 @@ struct lguest_device_desc {
 #define LGUEST_DEVICE_S_REMOVED_ACK	16 /* Driver has been told. */
 #define LGUEST_DEVICE_S_FAILED		128 /* Something actually failed */
 
+	/* Each device exists somewhere in Guest physical memory, over some
+	 * number of pages. */
 	u16 num_pages;
 	u32 pfn;
 };
+/*:*/
 
 /* Write command first word is a request. */
 enum lguest_req
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-kvm.patch
git-newsetup-fixup.patch
readahead-compacting-file_ra_state.patch
readahead-mmap-read-around-simplification.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
radixtree-introduce-radix_tree_next_hole.patch
readahead-basic-support-of-interleaved-reads.patch
readahead-remove-the-local-copy-of-ra-in-do_generic_mapping_read.patch
readahead-remove-several-readahead-macros.patch
readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb.patch
filemap-trivial-code-cleanups.patch
filemap-convert-some-unsigned-long-to-pgoff_t.patch
mmaps2-vma-out-of-mem_size_stats.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
remove-unsafe-from-module-struct.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
