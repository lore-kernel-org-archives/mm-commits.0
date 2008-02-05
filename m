From: akpm@linux-foundation.org
Subject: - pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:26:58 -0800
Message-ID: <200802052226.m15MQd41011640@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44375 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761293AbYBEW1N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:27:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olof@lixom.net, alan@lxorguk.ukuu.org.uk, benh@kernel.crashing.org, hch@lst.de, linux@dominikbrodowski.net, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     pcmcia: convert some internal-only ioaddr_t to unsigned int
has been removed from the -mm tree.  Its filename was
     pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcmcia: convert some internal-only ioaddr_t to unsigned int
From: Olof Johansson <olof@lixom.net>

Convert the io_req_t members to unsigned int, to allow use on machines with
more than 16 bits worth of IO ports (i.e.  secondary busses on ppc64, etc).

There was only a couple of places in drivers where a change was needed.  I
left printk formats alone (there are lots of %04x-style formats in there),
mostly to not change the format on the platforms that only have 16-bit io
addresses, but also because the padding doesn't really add all that much value
most of the time.

I found only one sprintf of an address, and upsized the string accordingly (I
doubt anyone will have anywhere near INT_MAX as irq value, but at least
there's room for it now).

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pcmcia/cm4000_cs.c    |   17 +++++++++--------
 drivers/pcmcia/pcmcia_resource.c   |   14 +++++++-------
 drivers/scsi/pcmcia/fdomain_stub.c |    2 +-
 include/pcmcia/cs.h                |    8 ++++----
 4 files changed, 21 insertions(+), 20 deletions(-)

diff -puN drivers/char/pcmcia/cm4000_cs.c~pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int drivers/char/pcmcia/cm4000_cs.c
--- a/drivers/char/pcmcia/cm4000_cs.c~pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int
+++ a/drivers/char/pcmcia/cm4000_cs.c
@@ -308,7 +308,8 @@ static unsigned int calc_baudv(unsigned 
 	return (wcrcf / wbrcf);
 }
 
-static unsigned short io_read_num_rec_bytes(ioaddr_t iobase, unsigned short *s)
+static unsigned short io_read_num_rec_bytes(unsigned int iobase,
+					    unsigned short *s)
 {
 	unsigned short tmp;
 
@@ -426,7 +427,7 @@ static struct card_fixup card_fixups[] =
 static void set_cardparameter(struct cm4000_dev *dev)
 {
 	int i;
-	ioaddr_t iobase = dev->p_dev->io.BasePort1;
+	unsigned int iobase = dev->p_dev->io.BasePort1;
 	u_int8_t stopbits = 0x02; /* ISO default */
 
 	DEBUGP(3, dev, "-> set_cardparameter\n");
@@ -459,7 +460,7 @@ static int set_protocol(struct cm4000_de
 	unsigned short num_bytes_read;
 	unsigned char pts_reply[4];
 	ssize_t rc;
-	ioaddr_t iobase = dev->p_dev->io.BasePort1;
+	unsigned int iobase = dev->p_dev->io.BasePort1;
 
 	rc = 0;
 
@@ -610,7 +611,7 @@ exit_setprotocol:
 	return rc;
 }
 
-static int io_detect_cm4000(ioaddr_t iobase, struct cm4000_dev *dev)
+static int io_detect_cm4000(unsigned int iobase, struct cm4000_dev *dev)
 {
 
 	/* note: statemachine is assumed to be reset */
@@ -671,7 +672,7 @@ static void terminate_monitor(struct cm4
 static void monitor_card(unsigned long p)
 {
 	struct cm4000_dev *dev = (struct cm4000_dev *) p;
-	ioaddr_t iobase = dev->p_dev->io.BasePort1;
+	unsigned int iobase = dev->p_dev->io.BasePort1;
 	unsigned short s;
 	struct ptsreq ptsreq;
 	int i, atrc;
@@ -933,7 +934,7 @@ static ssize_t cmm_read(struct file *fil
 			loff_t *ppos)
 {
 	struct cm4000_dev *dev = filp->private_data;
-	ioaddr_t iobase = dev->p_dev->io.BasePort1;
+	unsigned int iobase = dev->p_dev->io.BasePort1;
 	ssize_t rc;
 	int i, j, k;
 
@@ -1054,7 +1055,7 @@ static ssize_t cmm_write(struct file *fi
 			 size_t count, loff_t *ppos)
 {
 	struct cm4000_dev *dev = (struct cm4000_dev *) filp->private_data;
-	ioaddr_t iobase = dev->p_dev->io.BasePort1;
+	unsigned int iobase = dev->p_dev->io.BasePort1;
 	unsigned short s;
 	unsigned char tmp;
 	unsigned char infolen;
@@ -1408,7 +1409,7 @@ static int cmm_ioctl(struct inode *inode
 		     unsigned long arg)
 {
 	struct cm4000_dev *dev = filp->private_data;
-	ioaddr_t iobase = dev->p_dev->io.BasePort1;
+	unsigned int iobase = dev->p_dev->io.BasePort1;
 	struct pcmcia_device *link;
 	int size;
 	int rc;
diff -puN drivers/pcmcia/pcmcia_resource.c~pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int drivers/pcmcia/pcmcia_resource.c
--- a/drivers/pcmcia/pcmcia_resource.c~pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int
+++ a/drivers/pcmcia/pcmcia_resource.c
@@ -65,23 +65,23 @@ extern int ds_pc_debug;
  * Special stuff for managing IO windows, because they are scarce
  */
 
-static int alloc_io_space(struct pcmcia_socket *s, u_int attr, ioaddr_t *base,
-			  ioaddr_t num, u_int lines)
+static int alloc_io_space(struct pcmcia_socket *s, u_int attr,
+			  unsigned int *base, unsigned int num, u_int lines)
 {
 	int i;
-	kio_addr_t try, align;
+	unsigned int try, align;
 
 	align = (*base) ? (lines ? 1<<lines : 0) : 1;
 	if (align && (align < num)) {
 		if (*base) {
-			ds_dbg(s, 0, "odd IO request: num %#x align %#lx\n",
+			ds_dbg(s, 0, "odd IO request: num %#x align %#x\n",
 			       num, align);
 			align = 0;
 		} else
 			while (align && (align < num)) align <<= 1;
 	}
 	if (*base & ~(align-1)) {
-		ds_dbg(s, 0, "odd IO request: base %#x align %#lx\n",
+		ds_dbg(s, 0, "odd IO request: base %#x align %#x\n",
 		       *base, align);
 		align = 0;
 	}
@@ -132,8 +132,8 @@ static int alloc_io_space(struct pcmcia_
 } /* alloc_io_space */
 
 
-static void release_io_space(struct pcmcia_socket *s, ioaddr_t base,
-			     ioaddr_t num)
+static void release_io_space(struct pcmcia_socket *s, unsigned int base,
+			     unsigned int num)
 {
 	int i;
 
diff -puN drivers/scsi/pcmcia/fdomain_stub.c~pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int drivers/scsi/pcmcia/fdomain_stub.c
--- a/drivers/scsi/pcmcia/fdomain_stub.c~pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int
+++ a/drivers/scsi/pcmcia/fdomain_stub.c
@@ -130,7 +130,7 @@ static int fdomain_config(struct pcmcia_
     cisparse_t parse;
     int i, last_ret, last_fn;
     u_char tuple_data[64];
-    char str[16];
+    char str[22];
     struct Scsi_Host *host;
 
     DEBUG(0, "fdomain_config(0x%p)\n", link);
diff -puN include/pcmcia/cs.h~pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int include/pcmcia/cs.h
--- a/include/pcmcia/cs.h~pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int
+++ a/include/pcmcia/cs.h
@@ -147,11 +147,11 @@ typedef struct config_req_t {
 
 /* For RequestIO and ReleaseIO */
 typedef struct io_req_t {
-    ioaddr_t	BasePort1;
-    ioaddr_t	NumPorts1;
+    u_int	BasePort1;
+    u_int	NumPorts1;
     u_int	Attributes1;
-    ioaddr_t	BasePort2;
-    ioaddr_t	NumPorts2;
+    u_int	BasePort2;
+    u_int	NumPorts2;
     u_int	Attributes2;
     u_int	IOAddrLines;
 } io_req_t;
_

Patches currently in -mm which might be from olof@lixom.net are

origin.patch
git-mtd.patch
