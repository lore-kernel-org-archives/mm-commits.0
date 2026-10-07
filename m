Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A97547041
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334192; cv=none; b=Tz3rcBcKurAPggtf/CqrXyS/YAAuRyORFS6laDqN+Ja+rfU0UoWuaqDJNq8KgaeONjEfKoqihj7sAxvIabF6fqtamh4mGRbKf3PgiHKEmrlDUbWIwTJNCyz8nKfrfz1NmOTQz9HfE3xlUoqMMcwLFRTscBV92plQwQbmOZSI970=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334192; c=relaxed/simple;
	bh=z3Pt5eWbunWs6mrbKW8NEkTgPnfVEWUvmzWoYyWV67o=;
	h=Date:To:From:Subject:Message-Id; b=ALmvTxrZCAzfjJ03Cg/7G8rqvNN/xCrdlTfLI26+5ZGtCTj/vYO2GHLHniel+ENzSQ7NBjvb7WYDL4JEw2Strd/TUWig2VbAVNjrjmBPk1GSaxmGTtQv5LBMwJHM3V110GCa0vHLXyHWqzPSxrofvYiL9DwX2RzchHVhcpdESqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u1DMXW2k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u1DMXW2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7DB1F0089B;
	Wed,  7 Oct 2026 00:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334190;
	bh=Q5NQJEU16X7dXE3YgtslTwqiBTDcQ+gGKG2HqtzKnrY=;
	h=Date:To:From:Subject;
	b=u1DMXW2kuYwMTRbxKWx/w/7VJo/4hwLMHBgjlgh6CUya6oOBMwkszC90yP3Detfsu
	 8yWn9UAIDceB0Q5U4sovNCuEYgVI+k006dMj3Pkh2pwQkMZ/vSxLCP88dS3hQ1Gzn9
	 gMhMWBHpK4gMdRyalRBL/SzTLTt2hWgPJJyx00vs=
Date: Tue, 06 Oct 2026 17:49:50 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,urezki@gmail.com,svens@linux.ibm.com,ryan.roberts@arm.com,rafael@kernel.org,peterz@infradead.org,palmer@dabbelt.com,mingo@redhat.com,luto@kernel.org,lenb@kernel.org,kevin.brodsky@arm.com,kernel@xen0n.name,hpa@zytor.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dev.jain@arm.com,david@kernel.org,dave.hansen@linux.intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,brendan.jackman@linux.dev,bp@alien8.de,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,alex@ghiti.fr,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-make-set_area_direct_map-huge_vmap-friendly.patch removed from -mm tree
Message-Id: <20261007004950.9B7DB1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: make set_area_direct_map HUGE_VMAP friendly
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-make-set_area_direct_map-huge_vmap-friendly.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm/vmalloc: make set_area_direct_map HUGE_VMAP friendly
Date: Thu, 03 Sep 2026 12:28:30 +0300

set_area_direct_map() always updates direct map alias permissions in
single page increments.

For HUGE_VMAP areas it's suboptimal.  Not only the loop in
set_area_direct_map() needlessly has more iterations (e.g times 512 on
x86), but it also causes fragmentation of the direct map that could be
avoided for the HUGE_VMAP areas populated with large pages.

All pages in an area are always of the same order: either same-order large
pages when VM_ALLOW_HUGE_VMAP is set and all huge pages were successfully
allocated, or order-0 page when VM_ALLOW_HUGE_VMAP is cleared or when huge
pages allocation fails and fallback path is taken.

Instead of updating the direct map permissions for every order-0 page in
an area, use the area's page_order as the loop increment and update the
large pages in one call to set_direct_map_{invalid,default}_noflush().

Link: https://lore.kernel.org/20260903-execmem-set-vm-perms-v0-2-v3-4-949b64a9f755@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
---

 mm/vmalloc.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-make-set_area_direct_map-huge_vmap-friendly
+++ a/mm/vmalloc.c
@@ -3361,12 +3361,15 @@ static inline void set_area_direct_map(c
 				       int (*set_direct_map)(struct page *page,
 							     unsigned int nr))
 {
-	unsigned long i;
+	unsigned int nr = (1U << vm_area_page_order(area));
 
-	/* HUGE_VMALLOC passes small pages to set_direct_map */
-	for (i = 0; i < area->nr_pages; i++)
-		if (page_address(area->pages[i]))
-			set_direct_map(area->pages[i], 1);
+	for (unsigned long i = 0; i < area->nr_pages; i += nr) {
+		if (page_address(area->pages[i])) {
+			int err = set_direct_map(area->pages[i], nr);
+
+			WARN_ON_ONCE(err);
+		}
+	}
 }
 
 /*
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-execmem-free-rox-cache-chunks-only-when-they-span-an-entire-vm-area.patch
mm-execmem-handle-potential-allocation-errors-in-the-maple-tree.patch
mm-execmem-make-sure-rox-cache-always-contains-multiples-of-pmd_size.patch
mm-vmalloc-add-define_free-for-vfree.patch
mm-execmem-use-cleanup-infrastructure-in-rox-cache-functions.patch
docs-core-api-memory-allocation-add-kalloc_obj-and-clarify-kmalloc.patch
maintainers-add-memory-related-docs-in-core-mm-to-mm-misc-section.patch
docs-core-api-memory-allocation-clarify-when-to-use-kzalloc_obj-and-kzalloc.patch
docs-mm-describe-set_memory-and-set_direct_map-apis.patch
docs-mm-describe-set_memory-and-set_direct_map-apis-fix.patch
arch-mm-promote-debug_wx-to-check_wx.patch
sh-remove-config_numa-and-realted-configuration-options.patch
sh-mm-remove-numac.patch
sh-mm-drop-allocate_pgdat.patch
sh-remove-setup_bootmem_node-and-plat_mem_setup.patch
sh-drop-dead-code-guarded-by-ifdef-config_numa.patch
sh-drop-include-asm-mmzoneh.patch
init-kconfig-drop-arch_want_numa_variable_locality.patch
sh-init-remove-call-the-memblock_set_node.patch
sh-remove-sparsemem-related-entries-from-kconfig.patch
sh-drop-include-asm-sparsememh.patch

