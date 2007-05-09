From: akpm@linux-foundation.org
Subject: - ne-add-needs_portlist-to-control-isa-auto-probe.patch removed from -mm tree
Date: Tue, 08 May 2007 19:43:10 -0700
Message-ID: <200705090243.l492hAXw008433@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754012AbXEICnW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:43:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     ne: add NEEDS_PORTLIST to control ISA auto-probe
has been removed from the -mm tree.  Its filename was
     ne-add-needs_portlist-to-control-isa-auto-probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-mips.patch
mips-make-resources-for-ds1742-static-__initdata.patch
