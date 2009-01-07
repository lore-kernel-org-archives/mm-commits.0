From: akpm@linux-foundation.org
Subject: - sparc64-fix-unsigned-long-long-warnings-in-drivers.patch removed from -mm tree
Date: Wed, 07 Jan 2009 13:37:04 -0800
Message-ID: <200901072137.n07Lb4eo016102@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189AbZAGVhI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 16:37:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     sparc64: fix unsigned long long warnings in drivers
has been removed from the -mm tree.  Its filename was
     sparc64-fix-unsigned-long-long-warnings-in-drivers.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparc64: fix unsigned long long warnings in drivers
From: Sam Ravnborg <sam@ravnborg.org>

Fix warnings caused by the unsigned long long usage in sparc
specific drivers.

The drivers were considered sparc specific more or less from the
filename alone.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/sunvdc.c          |    8 ++++----
 drivers/char/hw_random/n2-drv.c |    2 +-
 drivers/net/sunvnet.c           |    8 ++++----
 drivers/sbus/char/display7seg.c |    2 +-
 sound/sparc/cs4231.c            |    2 +-
 5 files changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/block/sunvdc.c~sparc64-fix-unsigned-long-long-warnings-in-drivers drivers/block/sunvdc.c
--- a/drivers/block/sunvdc.c~sparc64-fix-unsigned-long-long-warnings-in-drivers
+++ a/drivers/block/sunvdc.c
@@ -153,7 +153,7 @@ static int vdc_send_attr(struct vio_driv
 	pkt.vdisk_block_size = port->vdisk_block_size;
 	pkt.max_xfer_size = port->max_xfer_size;
 
-	viodbg(HS, "SEND ATTR xfer_mode[0x%x] blksz[%u] max_xfer[%lu]\n",
+	viodbg(HS, "SEND ATTR xfer_mode[0x%x] blksz[%u] max_xfer[%llu]\n",
 	       pkt.xfer_mode, pkt.vdisk_block_size, pkt.max_xfer_size);
 
 	return vio_ldc_send(&port->vio, &pkt, sizeof(pkt));
@@ -164,8 +164,8 @@ static int vdc_handle_attr(struct vio_dr
 	struct vdc_port *port = to_vdc_port(vio);
 	struct vio_disk_attr_info *pkt = arg;
 
-	viodbg(HS, "GOT ATTR stype[0x%x] ops[%lx] disk_size[%lu] disk_type[%x] "
-	       "xfer_mode[0x%x] blksz[%u] max_xfer[%lu]\n",
+	viodbg(HS, "GOT ATTR stype[0x%x] ops[%llx] disk_size[%llu] disk_type[%x] "
+	       "xfer_mode[0x%x] blksz[%u] max_xfer[%llu]\n",
 	       pkt->tag.stype, pkt->operations,
 	       pkt->vdisk_size, pkt->vdisk_type,
 	       pkt->xfer_mode, pkt->vdisk_block_size,
@@ -753,7 +753,7 @@ static int __devinit vdc_port_probe(stru
 
 	err = -ENODEV;
 	if ((vdev->dev_no << PARTITION_SHIFT) & ~(u64)MINORMASK) {
-		printk(KERN_ERR PFX "Port id [%lu] too large.\n",
+		printk(KERN_ERR PFX "Port id [%llu] too large.\n",
 		       vdev->dev_no);
 		goto err_out_release_mdesc;
 	}
diff -puN drivers/char/hw_random/n2-drv.c~sparc64-fix-unsigned-long-long-warnings-in-drivers drivers/char/hw_random/n2-drv.c
--- a/drivers/char/hw_random/n2-drv.c~sparc64-fix-unsigned-long-long-warnings-in-drivers
+++ a/drivers/char/hw_random/n2-drv.c
@@ -482,7 +482,7 @@ static void n2rng_dump_test_buffer(struc
 	int i;
 
 	for (i = 0; i < SELFTEST_BUFFER_WORDS; i++)
-		dev_err(&np->op->dev, "Test buffer slot %d [0x%016lx]\n",
+		dev_err(&np->op->dev, "Test buffer slot %d [0x%016llx]\n",
 			i, np->test_buffer[i]);
 }
 
diff -puN drivers/net/sunvnet.c~sparc64-fix-unsigned-long-long-warnings-in-drivers drivers/net/sunvnet.c
--- a/drivers/net/sunvnet.c~sparc64-fix-unsigned-long-long-warnings-in-drivers
+++ a/drivers/net/sunvnet.c
@@ -336,7 +336,7 @@ static int vnet_walk_rx_one(struct vnet_
 	if (IS_ERR(desc))
 		return PTR_ERR(desc);
 
-	viodbg(DATA, "vio_walk_rx_one desc[%02x:%02x:%08x:%08x:%lx:%lx]\n",
+	viodbg(DATA, "vio_walk_rx_one desc[%02x:%02x:%08x:%08x:%llx:%llx]\n",
 	       desc->hdr.state, desc->hdr.ack,
 	       desc->size, desc->ncookies,
 	       desc->cookies[0].cookie_addr,
@@ -394,14 +394,14 @@ static int vnet_rx(struct vnet_port *por
 	struct vio_dring_state *dr = &port->vio.drings[VIO_DRIVER_RX_RING];
 	struct vio_driver_state *vio = &port->vio;
 
-	viodbg(DATA, "vnet_rx stype_env[%04x] seq[%016lx] rcv_nxt[%016lx]\n",
+	viodbg(DATA, "vnet_rx stype_env[%04x] seq[%016llx] rcv_nxt[%016llx]\n",
 	       pkt->tag.stype_env, pkt->seq, dr->rcv_nxt);
 
 	if (unlikely(pkt->tag.stype_env != VIO_DRING_DATA))
 		return 0;
 	if (unlikely(pkt->seq != dr->rcv_nxt)) {
-		printk(KERN_ERR PFX "RX out of sequence seq[0x%lx] "
-		       "rcv_nxt[0x%lx]\n", pkt->seq, dr->rcv_nxt);
+		printk(KERN_ERR PFX "RX out of sequence seq[0x%llx] "
+		       "rcv_nxt[0x%llx]\n", pkt->seq, dr->rcv_nxt);
 		return 0;
 	}
 
diff -puN drivers/sbus/char/display7seg.c~sparc64-fix-unsigned-long-long-warnings-in-drivers drivers/sbus/char/display7seg.c
--- a/drivers/sbus/char/display7seg.c~sparc64-fix-unsigned-long-long-warnings-in-drivers
+++ a/drivers/sbus/char/display7seg.c
@@ -214,7 +214,7 @@ static int __devinit d7s_probe(struct of
 
 	writeb(regs,  p->regs);
 
-	printk(KERN_INFO PFX "7-Segment Display%s at [%s:0x%lx] %s\n", 
+	printk(KERN_INFO PFX "7-Segment Display%s at [%s:0x%llx] %s\n",
 	       op->node->full_name,
 	       (regs & D7S_FLIP) ? " (FLIPPED)" : "",
 	       op->resource[0].start,
diff -puN sound/sparc/cs4231.c~sparc64-fix-unsigned-long-long-warnings-in-drivers sound/sparc/cs4231.c
--- a/sound/sparc/cs4231.c~sparc64-fix-unsigned-long-long-warnings-in-drivers
+++ a/sound/sparc/cs4231.c
@@ -2057,7 +2057,7 @@ static int __devinit cs4231_ebus_probe(s
 	if (err)
 		return err;
 
-	sprintf(card->longname, "%s at 0x%lx, irq %d",
+	sprintf(card->longname, "%s at 0x%llx, irq %d",
 		card->shortname,
 		op->resource[0].start,
 		op->irqs[0]);
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
linux-next.patch
sparc64-fix-unsigned-long-long-warnings-in-drivers.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

