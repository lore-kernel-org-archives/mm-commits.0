From: akpm@linux-foundation.org
Subject: - x86-64-system-crashes-when-no-memory-populating-node-0.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:30:35 -0700
Message-ID: <200704132330.l3DNUZ2G012750@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60695 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161224AbXDMXak (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:30:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: James.Puthukattukaran@sun.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86-64 system crashes when no memory populating Node 0
has been removed from the -mm tree.  Its filename was
     x86-64-system-crashes-when-no-memory-populating-node-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86-64 system crashes when no memory populating Node 0
From: James Puthukattukaran <James.Puthukattukaran@sun.com>

I have a 4 socket AMD Operton system. The 2.6.18 kernel I have crashes
when there is no memory in node0.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/aperture.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/x86_64/kernel/aperture.c~x86-64-system-crashes-when-no-memory-populating-node-0 arch/x86_64/kernel/aperture.c
--- a/arch/x86_64/kernel/aperture.c~x86-64-system-crashes-when-no-memory-populating-node-0
+++ a/arch/x86_64/kernel/aperture.c
@@ -51,7 +51,6 @@ static void __init insert_aperture_resou
 
 static u32 __init allocate_aperture(void) 
 {
-	pg_data_t *nd0 = NODE_DATA(0);
 	u32 aper_size;
 	void *p; 
 
@@ -65,12 +64,12 @@ static u32 __init allocate_aperture(void
 	 * Unfortunately we cannot move it up because that would make the
 	 * IOMMU useless.
 	 */
-	p = __alloc_bootmem_node(nd0, aper_size, aper_size, 0); 
+	p = __alloc_bootmem(aper_size, aper_size, 0);
 	if (!p || __pa(p)+aper_size > 0xffffffff) {
 		printk("Cannot allocate aperture memory hole (%p,%uK)\n",
 		       p, aper_size>>10);
 		if (p)
-			free_bootmem_node(nd0, __pa(p), aper_size); 
+			free_bootmem(__pa(p), aper_size);
 		return 0;
 	}
 	printk("Mapping aperture over %d KB of RAM @ %lx\n",
_

Patches currently in -mm which might be from James.Puthukattukaran@sun.com are
