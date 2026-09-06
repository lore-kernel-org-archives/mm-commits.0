Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43583305699
	for <mm-commits@vger.kernel.org>; Sun,  6 Sep 2026 01:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788659305; cv=none; b=NGh2MAYJeTnM5ABGd8qz+c1BEruhb88+15mVG5fqhOcN4W3zIgUlsmA9XVkI1X7O8NijC/pEFZZ77DgrgpxwrfAaTqwpu9lEZoGVUZnGy4ereu9YGcOrjixrsWkXgDODZImPfo8PmLE0BsWIrFgDdHgdKV6ckKogQmU1X+1yHuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788659305; c=relaxed/simple;
	bh=P6rJlMkgOO869xsAUjNVp/cZlVLTuyaOeEEZ1K749IQ=;
	h=Date:To:From:Subject:Message-Id; b=NN6NnTPanv/N6TKv7ZE9QIso7xTmj9f320PjbQ76pp0lA4v/pwIfP2f/KoF9taQcfLkei8w5OVarLNpNLecjVSeO0Wy3nRdSxRiIg3EFAuDPOOnxYv2zovaW6V6WbVc6f6tcvQFc0SKaKK0dQf7EeySb925Ci26LjdkGAvt5yCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=onhy6kOf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="onhy6kOf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF3D1F00A3D;
	Sun,  6 Sep 2026 01:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788659303;
	bh=tkTKIYu5vM8Z/fBqqFrKeU6AbbJMbGN3glFdaQ7lFUg=;
	h=Date:To:From:Subject;
	b=onhy6kOf2+V72wHy+n+962cJ92qrVSFzx4pii1nYVLm/g65Iww8Mr1biz1NdC6hj7
	 witARl7HY9spyfUs0GyncURPOHFNwDnk+J6HzHKG1HsUs+8yGShXPRaQVeTrcCd87m
	 TDIuvDGUPoFkQsaToCEJvykRKCptap6h3c0/GfxU=
Date: Sat, 05 Sep 2026 18:48:23 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-make-set_area_direct_map-huge_vmap-friendly.patch removed from -mm tree
Message-Id: <20260906014823.BCF3D1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: make set_area_direct_map HUGE_VMAP friendly
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-make-set_area_direct_map-huge_vmap-friendly.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm/vmalloc: make set_area_direct_map HUGE_VMAP friendly
Date: Sun, 23 Aug 2026 14:46:15 +0300

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

Link: https://lore.kernel.org/20260823-execmem-set-vm-perms-v0-2-v2-4-b013a37d84b3@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-make-set_area_direct_map-huge_vmap-friendly
+++ a/mm/vmalloc.c
@@ -3366,12 +3366,15 @@ static inline void set_area_direct_map(c
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

mm-execmem-use-vm_flush_reset_perms-for-rox-cache-allocations.patch
revert-arch-introduce-set_direct_map_valid_noflush.patch
docs-core-api-memory-allocation-add-kalloc_obj-and-clarify-kmalloc.patch
maintainers-add-memory-related-docs-in-core-mm-to-mm-misc-section.patch
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

