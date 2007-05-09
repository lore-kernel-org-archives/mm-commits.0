From: akpm@linux-foundation.org
Subject: - ne-misc-fixes-for-platform-driver.patch removed from -mm tree
Date: Tue, 08 May 2007 19:43:07 -0700
Message-ID: <200705090243.l492h7IX008424@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969218AbXEICnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:43:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     ne: misc fixes for platform driver
has been removed from the -mm tree.  Its filename was
     ne-misc-fixes-for-platform-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ne: misc fixes for platform driver
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Miscellaneous fixes to make ne platform driver work properly.

* Make ioaddr 'unsigned long'.
* Move a printk down to show dev->name assigned in register_netdev.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ne.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/net/ne.c~ne-misc-fixes-for-platform-driver drivers/net/ne.c
--- a/drivers/net/ne.c~ne-misc-fixes-for-platform-driver
+++ a/drivers/net/ne.c
@@ -147,7 +147,7 @@ bad_clone_list[] __initdata = {
 #  define DCR_VAL 0x49
 #endif
 
-static int ne_probe1(struct net_device *dev, int ioaddr);
+static int ne_probe1(struct net_device *dev, unsigned long ioaddr);
 static int ne_probe_isapnp(struct net_device *dev);
 
 static int ne_open(struct net_device *dev);
@@ -185,7 +185,7 @@ static void ne_block_output(struct net_d
 
 static int __init do_ne_probe(struct net_device *dev)
 {
-	unsigned int base_addr = dev->base_addr;
+	unsigned long base_addr = dev->base_addr;
 #ifndef MODULE
 	int orig_irq = dev->irq;
 #endif
@@ -286,7 +286,7 @@ static int __init ne_probe_isapnp(struct
 	return -ENODEV;
 }
 
-static int __init ne_probe1(struct net_device *dev, int ioaddr)
+static int __init ne_probe1(struct net_device *dev, unsigned long ioaddr)
 {
 	int i;
 	unsigned char SA_prom[32];
@@ -325,7 +325,7 @@ static int __init ne_probe1(struct net_d
 	if (ei_debug  &&  version_printed++ == 0)
 		printk(KERN_INFO "%s" KERN_INFO "%s", version1, version2);
 
-	printk(KERN_INFO "NE*000 ethercard probe at %#3x:", ioaddr);
+	printk(KERN_INFO "NE*000 ethercard probe at %#3lx:", ioaddr);
 
 	/* A user with a poor card that fails to ack the reset, or that
 	   does not have a valid 0x57,0x57 signature can still use this
@@ -517,8 +517,7 @@ static int __init ne_probe1(struct net_d
 	}
 #endif
 
-	printk("\n%s: %s found at %#x, using IRQ %d.\n",
-		dev->name, name, ioaddr, dev->irq);
+	printk("\n");
 
 	ei_status.name = name;
 	ei_status.tx_start_page = start_page;
@@ -548,6 +547,8 @@ static int __init ne_probe1(struct net_d
 	ret = register_netdev(dev);
 	if (ret)
 		goto out_irq;
+	printk(KERN_INFO "%s: %s found at %#lx, using IRQ %d.\n",
+	       dev->name, name, ioaddr, dev->irq);
 	return 0;
 
 out_irq:
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
git-mips.patch
mips-make-resources-for-ds1742-static-__initdata.patch
