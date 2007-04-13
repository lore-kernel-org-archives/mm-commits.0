From: akpm@linux-foundation.org
Subject: + round_up-macro-cleanup-in-arch-sh64-kernel-pci_sh5c.patch added to -mm tree
Date: Fri, 13 Apr 2007 11:59:38 -0700
Message-ID: <200704131859.l3DIxci7006993@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46306 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141AbXDMS7m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 14:59:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: milindchoudhary@gmail.com, lethal@linux-sh.org


The patch titled
     ROUND_UP macro cleanup in arch/sh64/kernel/pci_sh5.c
has been added to the -mm tree.  Its filename is
     round_up-macro-cleanup-in-arch-sh64-kernel-pci_sh5c.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ROUND_UP macro cleanup in arch/sh64/kernel/pci_sh5.c
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

ROUND_UP macro cleanup, use ALIGN where ever appropriate.

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh64/kernel/pci_sh5.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff -puN arch/sh64/kernel/pci_sh5.c~round_up-macro-cleanup-in-arch-sh64-kernel-pci_sh5c arch/sh64/kernel/pci_sh5.c
--- a/arch/sh64/kernel/pci_sh5.c~round_up-macro-cleanup-in-arch-sh64-kernel-pci_sh5c
+++ a/arch/sh64/kernel/pci_sh5.c
@@ -375,8 +375,6 @@ irqreturn_t pcish5_serr_irq(int irq, voi
 	return IRQ_NONE;
 }
 
-#define ROUND_UP(x, a)		(((x) + (a) - 1) & ~((a) - 1))
-
 static void __init
 pcibios_size_bridge(struct pci_bus *bus, struct resource *ior,
 		    struct resource *memr)
@@ -433,8 +431,8 @@ pcibios_size_bridge(struct pci_bus *bus,
 	mem_res.end -= mem_res.start;
 
 	/* Align the sizes up by bridge rules */
-	io_res.end = ROUND_UP(io_res.end, 4*1024) - 1;
-	mem_res.end = ROUND_UP(mem_res.end, 1*1024*1024) - 1;
+	io_res.end = ALIGN(io_res.end, 4*1024) - 1;
+	mem_res.end = ALIGN(mem_res.end, 1*1024*1024) - 1;
 
 	/* Adjust the bridge's allocation requirements */
 	bridge->resource[0].end = bridge->resource[0].start + io_res.end;
@@ -447,18 +445,16 @@ pcibios_size_bridge(struct pci_bus *bus,
 
 	/* adjust parent's resource requirements */
 	if (ior) {
-		ior->end = ROUND_UP(ior->end, 4*1024);
+		ior->end = ALIGN(ior->end, 4*1024);
 		ior->end += io_res.end;
 	}
 
 	if (memr) {
-		memr->end = ROUND_UP(memr->end, 1*1024*1024);
+		memr->end = ALIGN(memr->end, 1*1024*1024);
 		memr->end += mem_res.end;
 	}
 }
 
-#undef ROUND_UP
-
 static void __init pcibios_size_bridges(void)
 {
 	struct resource io_res, mem_res;
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are

unused-round_up-name_offset-macro-in-arch-powerpc.patch
spin_lock_unlocked-cleanup-in-arch-powerpc.patch
git-ieee1394.patch
spin_lock_unlocked-cleanup-in-drivers-ata-pata_winbondc.patch
round_up-macro-cleanup-in-drivers-net-ppp_genericc.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
pcie-remove-spin_lock_unlocked.patch
round_up-macro-cleanup-in-arch-sh64-kernel-pci_sh5c.patch
round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch
round_up-macro-cleanup-in-drivers-char-lpc.patch
round_up-macro-cleanup-in-fs-selectcompatreaddirc.patch
round_up-macro-cleanup-in-fs-smbfs-requestc.patch
