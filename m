From: akpm@osdl.org
Subject: - mbxfb-add-more-registers-to-debugfs.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:13:43 -0800
Message-ID: <200612082013.kB8KDhN8003111@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59778 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946857AbWLHUOa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:14:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raph@8d.com, adaplas@pol.net, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mbxfb: add more registers to debugfs
has been removed from the -mm tree.  Its filename was
     mbxfb-add-more-registers-to-debugfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mbxfb: add more registers to debugfs
From: Raphael Assenat <raph@8d.com>

This patch fixes debugfs for mbxfb and adds some missing registers.

The way registers were read was out of sync with the rest of the driver (direct
access instead of using readl())

sdram controller registers are now accessible in the sdram/ subdirectory and
some other registers are grouped in the misc/ subdirectory.

Signed-off-by: Raphael Assenat <raph@8d.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Acked-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/mbx/mbxdebugfs.c |  188 ++++++++++++++++++++-----------
 1 file changed, 122 insertions(+), 66 deletions(-)

diff -puN drivers/video/mbx/mbxdebugfs.c~mbxfb-add-more-registers-to-debugfs drivers/video/mbx/mbxdebugfs.c
--- a/drivers/video/mbx/mbxdebugfs.c~mbxfb-add-more-registers-to-debugfs
+++ a/drivers/video/mbx/mbxdebugfs.c
@@ -10,6 +10,8 @@ struct mbxfb_debugfs_data {
 	struct dentry *clock;
 	struct dentry *display;
 	struct dentry *gsctl;
+	struct dentry *sdram;
+	struct dentry *misc;
 };
 
 static int open_file_generic(struct inode *inode, struct file *file)
@@ -29,11 +31,11 @@ static ssize_t sysconf_read_file(struct 
 {
 	char * s = big_buffer;
 
-	s += sprintf(s, "SYSCFG = %08lx\n", SYSCFG);
-	s += sprintf(s, "PFBASE = %08lx\n", PFBASE);
-	s += sprintf(s, "PFCEIL = %08lx\n", PFCEIL);
-	s += sprintf(s, "POLLFLAG = %08lx\n", POLLFLAG);
-	s += sprintf(s, "SYSRST = %08lx\n", SYSRST);
+	s += sprintf(s, "SYSCFG = %08x\n", readl(SYSCFG));
+	s += sprintf(s, "PFBASE = %08x\n", readl(PFBASE));
+	s += sprintf(s, "PFCEIL = %08x\n", readl(PFCEIL));
+	s += sprintf(s, "POLLFLAG = %08x\n", readl(POLLFLAG));
+	s += sprintf(s, "SYSRST = %08x\n", readl(SYSRST));
 
 	return  simple_read_from_buffer(userbuf, count, ppos,
 					big_buffer, s-big_buffer);
@@ -45,24 +47,24 @@ static ssize_t gsctl_read_file(struct fi
 {
 	char * s = big_buffer;
 
-	s += sprintf(s, "GSCTRL = %08lx\n", GSCTRL);
-	s += sprintf(s, "VSCTRL = %08lx\n", VSCTRL);
-	s += sprintf(s, "GBBASE = %08lx\n", GBBASE);
-	s += sprintf(s, "VBBASE = %08lx\n", VBBASE);
-	s += sprintf(s, "GDRCTRL = %08lx\n", GDRCTRL);
-	s += sprintf(s, "VCMSK = %08lx\n", VCMSK);
-	s += sprintf(s, "GSCADR = %08lx\n", GSCADR);
-	s += sprintf(s, "VSCADR = %08lx\n", VSCADR);
-	s += sprintf(s, "VUBASE = %08lx\n", VUBASE);
-	s += sprintf(s, "VVBASE = %08lx\n", VVBASE);
-	s += sprintf(s, "GSADR = %08lx\n", GSADR);
-	s += sprintf(s, "VSADR = %08lx\n", VSADR);
-	s += sprintf(s, "HCCTRL = %08lx\n", HCCTRL);
-	s += sprintf(s, "HCSIZE = %08lx\n", HCSIZE);
-	s += sprintf(s, "HCPOS = %08lx\n", HCPOS);
-	s += sprintf(s, "HCBADR = %08lx\n", HCBADR);
-	s += sprintf(s, "HCCKMSK = %08lx\n", HCCKMSK);
-	s += sprintf(s, "GPLUT = %08lx\n", GPLUT);
+	s += sprintf(s, "GSCTRL = %08x\n", readl(GSCTRL));
+	s += sprintf(s, "VSCTRL = %08x\n", readl(VSCTRL));
+	s += sprintf(s, "GBBASE = %08x\n", readl(GBBASE));
+	s += sprintf(s, "VBBASE = %08x\n", readl(VBBASE));
+	s += sprintf(s, "GDRCTRL = %08x\n", readl(GDRCTRL));
+	s += sprintf(s, "VCMSK = %08x\n", readl(VCMSK));
+	s += sprintf(s, "GSCADR = %08x\n", readl(GSCADR));
+	s += sprintf(s, "VSCADR = %08x\n", readl(VSCADR));
+	s += sprintf(s, "VUBASE = %08x\n", readl(VUBASE));
+	s += sprintf(s, "VVBASE = %08x\n", readl(VVBASE));
+	s += sprintf(s, "GSADR = %08x\n", readl(GSADR));
+	s += sprintf(s, "VSADR = %08x\n", readl(VSADR));
+	s += sprintf(s, "HCCTRL = %08x\n", readl(HCCTRL));
+	s += sprintf(s, "HCSIZE = %08x\n", readl(HCSIZE));
+	s += sprintf(s, "HCPOS = %08x\n", readl(HCPOS));
+	s += sprintf(s, "HCBADR = %08x\n", readl(HCBADR));
+	s += sprintf(s, "HCCKMSK = %08x\n", readl(HCCKMSK));
+	s += sprintf(s, "GPLUT = %08x\n", readl(GPLUT));
 
 	return  simple_read_from_buffer(userbuf, count, ppos,
 					big_buffer, s-big_buffer);
@@ -73,36 +75,36 @@ static ssize_t display_read_file(struct 
 {
 	char * s = big_buffer;
 
-	s += sprintf(s, "DSCTRL = %08lx\n", DSCTRL);
-	s += sprintf(s, "DHT01 = %08lx\n", DHT01);
-	s += sprintf(s, "DHT02 = %08lx\n", DHT02);
-	s += sprintf(s, "DHT03 = %08lx\n", DHT03);
-	s += sprintf(s, "DVT01 = %08lx\n", DVT01);
-	s += sprintf(s, "DVT02 = %08lx\n", DVT02);
-	s += sprintf(s, "DVT03 = %08lx\n", DVT03);
-	s += sprintf(s, "DBCOL = %08lx\n", DBCOL);
-	s += sprintf(s, "BGCOLOR = %08lx\n", BGCOLOR);
-	s += sprintf(s, "DINTRS = %08lx\n", DINTRS);
-	s += sprintf(s, "DINTRE = %08lx\n", DINTRE);
-	s += sprintf(s, "DINTRCNT = %08lx\n", DINTRCNT);
-	s += sprintf(s, "DSIG = %08lx\n", DSIG);
-	s += sprintf(s, "DMCTRL = %08lx\n", DMCTRL);
-	s += sprintf(s, "CLIPCTRL = %08lx\n", CLIPCTRL);
-	s += sprintf(s, "SPOCTRL = %08lx\n", SPOCTRL);
-	s += sprintf(s, "SVCTRL = %08lx\n", SVCTRL);
-	s += sprintf(s, "DLSTS = %08lx\n", DLSTS);
-	s += sprintf(s, "DLLCTRL = %08lx\n", DLLCTRL);
-	s += sprintf(s, "DVLNUM = %08lx\n", DVLNUM);
-	s += sprintf(s, "DUCTRL = %08lx\n", DUCTRL);
-	s += sprintf(s, "DVECTRL = %08lx\n", DVECTRL);
-	s += sprintf(s, "DHDET = %08lx\n", DHDET);
-	s += sprintf(s, "DVDET = %08lx\n", DVDET);
-	s += sprintf(s, "DODMSK = %08lx\n", DODMSK);
-	s += sprintf(s, "CSC01 = %08lx\n", CSC01);
-	s += sprintf(s, "CSC02 = %08lx\n", CSC02);
-	s += sprintf(s, "CSC03 = %08lx\n", CSC03);
-	s += sprintf(s, "CSC04 = %08lx\n", CSC04);
-	s += sprintf(s, "CSC05 = %08lx\n", CSC05);
+	s += sprintf(s, "DSCTRL = %08x\n", readl(DSCTRL));
+	s += sprintf(s, "DHT01 = %08x\n", readl(DHT01));
+	s += sprintf(s, "DHT02 = %08x\n", readl(DHT02));
+	s += sprintf(s, "DHT03 = %08x\n", readl(DHT03));
+	s += sprintf(s, "DVT01 = %08x\n", readl(DVT01));
+	s += sprintf(s, "DVT02 = %08x\n", readl(DVT02));
+	s += sprintf(s, "DVT03 = %08x\n", readl(DVT03));
+	s += sprintf(s, "DBCOL = %08x\n", readl(DBCOL));
+	s += sprintf(s, "BGCOLOR = %08x\n", readl(BGCOLOR));
+	s += sprintf(s, "DINTRS = %08x\n", readl(DINTRS));
+	s += sprintf(s, "DINTRE = %08x\n", readl(DINTRE));
+	s += sprintf(s, "DINTRCNT = %08x\n", readl(DINTRCNT));
+	s += sprintf(s, "DSIG = %08x\n", readl(DSIG));
+	s += sprintf(s, "DMCTRL = %08x\n", readl(DMCTRL));
+	s += sprintf(s, "CLIPCTRL = %08x\n", readl(CLIPCTRL));
+	s += sprintf(s, "SPOCTRL = %08x\n", readl(SPOCTRL));
+	s += sprintf(s, "SVCTRL = %08x\n", readl(SVCTRL));
+	s += sprintf(s, "DLSTS = %08x\n", readl(DLSTS));
+	s += sprintf(s, "DLLCTRL = %08x\n", readl(DLLCTRL));
+	s += sprintf(s, "DVLNUM = %08x\n", readl(DVLNUM));
+	s += sprintf(s, "DUCTRL = %08x\n", readl(DUCTRL));
+	s += sprintf(s, "DVECTRL = %08x\n", readl(DVECTRL));
+	s += sprintf(s, "DHDET = %08x\n", readl(DHDET));
+	s += sprintf(s, "DVDET = %08x\n", readl(DVDET));
+	s += sprintf(s, "DODMSK = %08x\n", readl(DODMSK));
+	s += sprintf(s, "CSC01 = %08x\n", readl(CSC01));
+	s += sprintf(s, "CSC02 = %08x\n", readl(CSC02));
+	s += sprintf(s, "CSC03 = %08x\n", readl(CSC03));
+	s += sprintf(s, "CSC04 = %08x\n", readl(CSC04));
+	s += sprintf(s, "CSC05 = %08x\n", readl(CSC05));
 
 	return  simple_read_from_buffer(userbuf, count, ppos,
 					big_buffer, s-big_buffer);
@@ -113,24 +115,61 @@ static ssize_t clock_read_file(struct fi
 {
 	char * s = big_buffer;
 
-	s += sprintf(s, "SYSCLKSRC = %08lx\n", SYSCLKSRC);
-	s += sprintf(s, "PIXCLKSRC = %08lx\n", PIXCLKSRC);
-	s += sprintf(s, "CLKSLEEP = %08lx\n", CLKSLEEP);
-	s += sprintf(s, "COREPLL = %08lx\n", COREPLL);
-	s += sprintf(s, "DISPPLL = %08lx\n", DISPPLL);
-	s += sprintf(s, "PLLSTAT = %08lx\n", PLLSTAT);
-	s += sprintf(s, "VOVRCLK = %08lx\n", VOVRCLK);
-	s += sprintf(s, "PIXCLK = %08lx\n", PIXCLK);
-	s += sprintf(s, "MEMCLK = %08lx\n", MEMCLK);
-	s += sprintf(s, "M24CLK = %08lx\n", M24CLK);
-	s += sprintf(s, "MBXCLK = %08lx\n", MBXCLK);
-	s += sprintf(s, "SDCLK = %08lx\n", SDCLK);
-	s += sprintf(s, "PIXCLKDIV = %08lx\n", PIXCLKDIV);
+	s += sprintf(s, "SYSCLKSRC = %08x\n", readl(SYSCLKSRC));
+	s += sprintf(s, "PIXCLKSRC = %08x\n", readl(PIXCLKSRC));
+	s += sprintf(s, "CLKSLEEP = %08x\n", readl(CLKSLEEP));
+	s += sprintf(s, "COREPLL = %08x\n", readl(COREPLL));
+	s += sprintf(s, "DISPPLL = %08x\n", readl(DISPPLL));
+	s += sprintf(s, "PLLSTAT = %08x\n", readl(PLLSTAT));
+	s += sprintf(s, "VOVRCLK = %08x\n", readl(VOVRCLK));
+	s += sprintf(s, "PIXCLK = %08x\n", readl(PIXCLK));
+	s += sprintf(s, "MEMCLK = %08x\n", readl(MEMCLK));
+	s += sprintf(s, "M24CLK = %08x\n", readl(M24CLK));
+	s += sprintf(s, "MBXCLK = %08x\n", readl(MBXCLK));
+	s += sprintf(s, "SDCLK = %08x\n", readl(SDCLK));
+	s += sprintf(s, "PIXCLKDIV = %08x\n", readl(PIXCLKDIV));
 
 	return  simple_read_from_buffer(userbuf, count, ppos,
 					big_buffer, s-big_buffer);
 }
 
+static ssize_t sdram_read_file(struct file *file, char __user *userbuf,
+			       size_t count, loff_t *ppos)
+{
+	char * s = big_buffer;
+
+	s += sprintf(s, "LMRST = %08x\n", readl(LMRST));
+	s += sprintf(s, "LMCFG = %08x\n", readl(LMCFG));
+	s += sprintf(s, "LMPWR = %08x\n", readl(LMPWR));
+	s += sprintf(s, "LMPWRSTAT = %08x\n", readl(LMPWRSTAT));
+	s += sprintf(s, "LMCEMR = %08x\n", readl(LMCEMR));
+	s += sprintf(s, "LMTYPE = %08x\n", readl(LMTYPE));
+	s += sprintf(s, "LMTIM = %08x\n", readl(LMTIM));
+	s += sprintf(s, "LMREFRESH = %08x\n", readl(LMREFRESH));
+	s += sprintf(s, "LMPROTMIN = %08x\n", readl(LMPROTMIN));
+	s += sprintf(s, "LMPROTMAX = %08x\n", readl(LMPROTMAX));
+	s += sprintf(s, "LMPROTCFG = %08x\n", readl(LMPROTCFG));
+	s += sprintf(s, "LMPROTERR = %08x\n", readl(LMPROTERR));
+
+	return  simple_read_from_buffer(userbuf, count, ppos,
+					big_buffer, s-big_buffer);
+}
+
+static ssize_t misc_read_file(struct file *file, char __user *userbuf,
+			       size_t count, loff_t *ppos)
+{
+	char * s = big_buffer;
+
+	s += sprintf(s, "LCD_CONFIG = %08x\n", readl(LCD_CONFIG));
+	s += sprintf(s, "ODFBPWR = %08x\n", readl(ODFBPWR));
+	s += sprintf(s, "ODFBSTAT = %08x\n", readl(ODFBSTAT));
+	s += sprintf(s, "ID = %08x\n", readl(ID));
+
+	return  simple_read_from_buffer(userbuf, count, ppos,
+					big_buffer, s-big_buffer);
+}
+
+
 static struct file_operations sysconf_fops = {
 	.read = sysconf_read_file,
 	.write = write_file_dummy,
@@ -155,6 +194,17 @@ static struct file_operations gsctl_fops
 	.open = open_file_generic,
 };
 
+static struct file_operations sdram_fops = {
+	.read = sdram_read_file,
+	.write = write_file_dummy,
+	.open = open_file_generic,
+};
+
+static struct file_operations misc_fops = {
+	.read = misc_read_file,
+	.write = write_file_dummy,
+	.open = open_file_generic,
+};
 
 static void __devinit mbxfb_debugfs_init(struct fb_info *fbi)
 {
@@ -173,6 +223,10 @@ static void __devinit mbxfb_debugfs_init
 				      fbi, &display_fops);
 	dbg->gsctl = debugfs_create_file("gsctl", 0444, dbg->dir,
 				    fbi, &gsctl_fops);
+	dbg->sdram = debugfs_create_file("sdram", 0444, dbg->dir,
+					fbi, &sdram_fops);
+	dbg->misc = debugfs_create_file("misc", 0444, dbg->dir,
+					fbi, &misc_fops);
 }
 
 static void __devexit mbxfb_debugfs_remove(struct fb_info *fbi)
@@ -180,6 +234,8 @@ static void __devexit mbxfb_debugfs_remo
 	struct mbxfb_info *mfbi = fbi->par;
 	struct mbxfb_debugfs_data *dbg = mfbi->debugfs_data;
 
+	debugfs_remove(dbg->misc);
+	debugfs_remove(dbg->sdram);
 	debugfs_remove(dbg->gsctl);
 	debugfs_remove(dbg->display);
 	debugfs_remove(dbg->clock);
_

Patches currently in -mm which might be from raph@8d.com are

mbxfb-add-more-registers-to-debugfs.patch
mbxfb-add-yuv-video-overlay-support.patch
mbxfb-document-the-new-ioctl.patch

