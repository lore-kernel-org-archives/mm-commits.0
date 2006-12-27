From: akpm@osdl.org
Subject: + x86-64-system-crashes-when-no-memory-populating-node-0.patch added to -mm tree
Date: Tue, 26 Dec 2006 23:32:27 -0800
Message-ID: <200612270732.kBR7WRkV004462@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36629 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932950AbWL0Hcf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 02:32:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: James.Puthukattukaran@sun.com, ak@suse.de


The patch titled
     x86-64 system crashes when no memory populating Node 0
has been added to the -mm tree.  Its filename is
     x86-64-system-crashes-when-no-memory-populating-node-0.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86-64 system crashes when no memory populating Node 0
From: James Puthukattukaran <James.Puthukattukaran@sun.com>

I have a 4 socket AMD Operton system. The 2.6.18 kernel I have crashes
when there is no memory in node0.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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

x86-64-system-crashes-when-no-memory-populating-node-0.patch

