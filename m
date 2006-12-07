From: akpm@osdl.org
Subject: - m68k-replace-kmallocmemset-with-kzalloc.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:00:05 -0800
Message-ID: <200612072300.kB7N054g029607@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51198 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163645AbWLGXAS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:00:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: burman.yan@gmail.com, geert@linux-m68k.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: replace kmalloc+memset with kzalloc
has been removed from the -mm tree.  Its filename was
     m68k-replace-kmallocmemset-with-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m68k: replace kmalloc+memset with kzalloc
From: Yan Burman <burman.yan@gmail.com>

Replace kmalloc+memset with kzalloc

Signed-off-by: Yan Burman <burman.yan@gmail.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/m68k/amiga/chipram.c   |    3 +--
 arch/m68k/atari/hades-pci.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN arch/m68k/amiga/chipram.c~m68k-replace-kmallocmemset-with-kzalloc arch/m68k/amiga/chipram.c
--- a/arch/m68k/amiga/chipram.c~m68k-replace-kmallocmemset-with-kzalloc
+++ a/arch/m68k/amiga/chipram.c
@@ -52,10 +52,9 @@ void *amiga_chip_alloc(unsigned long siz
 #ifdef DEBUG
     printk("amiga_chip_alloc: allocate %ld bytes\n", size);
 #endif
-    res = kmalloc(sizeof(struct resource), GFP_KERNEL);
+    res = kzalloc(sizeof(struct resource), GFP_KERNEL);
     if (!res)
 	return NULL;
-    memset(res, 0, sizeof(struct resource));
     res->name = name;
 
     if (allocate_resource(&chipram_res, res, size, 0, UINT_MAX, PAGE_SIZE, NULL, NULL) < 0) {
diff -puN arch/m68k/atari/hades-pci.c~m68k-replace-kmallocmemset-with-kzalloc arch/m68k/atari/hades-pci.c
--- a/arch/m68k/atari/hades-pci.c~m68k-replace-kmallocmemset-with-kzalloc
+++ a/arch/m68k/atari/hades-pci.c
@@ -375,10 +375,9 @@ struct pci_bus_info * __init init_hades_
 	 * Allocate memory for bus info structure.
 	 */
 
-	bus = kmalloc(sizeof(struct pci_bus_info), GFP_KERNEL);
+	bus = kzalloc(sizeof(struct pci_bus_info), GFP_KERNEL);
 	if (!bus)
 		return NULL;
-	memset(bus, 0, sizeof(struct pci_bus_info));
 
 	/*
 	 * Claim resources. The m68k has no separate I/O space, both
_

Patches currently in -mm which might be from burman.yan@gmail.com are

origin.patch
ia64-replace-kmallocmemset-with-kzalloc.patch
jffs2-replace-kmallocmemset-with-kzalloc.patch
nfsd-replace-kmallocmemset-with-kcalloc.patch

