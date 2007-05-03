From: akpm@linux-foundation.org
Subject: + ne-add-needs_portlist-to-control-isa-auto-probe.patch added to -mm tree
Date: Wed, 02 May 2007 20:39:53 -0700
Message-ID: <200705030339.l433drUX004100@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767359AbXECDkJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 May 2007 23:40:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, ralf@linux-mips.org


The patch titled
     ne: add NEEDS_PORTLIST to control ISA auto-probe
has been added to the -mm tree.  Its filename is
     ne-add-needs_portlist-to-control-isa-auto-probe.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ne: add NEEDS_PORTLIST to control ISA auto-probe
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Add NEEDS_PORTLIST cpp macro to control ISA auto-probe.
(I'm not sure M32R needs auto-probe but it is current behavior)

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ne.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/net/ne.c~ne-add-needs_portlist-to-control-isa-auto-probe drivers/net/ne.c
--- a/drivers/net/ne.c~ne-add-needs_portlist-to-control-isa-auto-probe
+++ a/drivers/net/ne.c
@@ -78,8 +78,13 @@ static const char version2[] =
 /* Do we have a non std. amount of memory? (in units of 256 byte pages) */
 /* #define PACKETBUF_MEMSIZE	0x40 */
 
+#if !defined(MODULE) && (defined(CONFIG_ISA) || defined(CONFIG_M32R))
+/* Do we need a portlist for the ISA auto-probe ? */
+#define NEEDS_PORTLIST
+#endif
+
 /* A zero-terminated list of I/O addresses to be probed at boot. */
-#ifndef MODULE
+#ifdef NEEDS_PORTLIST
 static unsigned int netcard_portlist[] __initdata = {
 	0x300, 0x280, 0x320, 0x340, 0x360, 0x380, 0
 };
@@ -186,7 +191,7 @@ static void ne_block_output(struct net_d
 static int __init do_ne_probe(struct net_device *dev)
 {
 	unsigned long base_addr = dev->base_addr;
-#ifndef MODULE
+#ifdef NEEDS_PORTLIST
 	int orig_irq = dev->irq;
 #endif
 
@@ -202,7 +207,7 @@ static int __init do_ne_probe(struct net
 	if (isapnp_present() && (ne_probe_isapnp(dev) == 0))
 		return 0;
 
-#ifndef MODULE
+#ifdef NEEDS_PORTLIST
 	/* Last resort. The semi-risky ISA auto-probe. */
 	for (base_addr = 0; netcard_portlist[base_addr] != 0; base_addr++) {
 		int ioaddr = netcard_portlist[base_addr];
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
git-kbuild.patch
git-mips.patch
mips-drop-unnecessary-config_isa-from-rbtx49xx.patch
ne-add-platform_driver.patch
ne-misc-fixes-for-platform-driver.patch
ne-add-needs_portlist-to-control-isa-auto-probe.patch
ne-mips-use-platform_driver-for-ne-on-rbtx49xx.patch
serial_txx9-use-assigned-device-numbers.patch
serial_txx9-zap-changelog-from-source-code.patch
