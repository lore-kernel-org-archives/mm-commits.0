Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41872246778
	for <mm-commits@vger.kernel.org>; Sun,  6 Sep 2026 01:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788659302; cv=none; b=p3jgqscBEZj2WVF5wZb4Me4S1tvfIJ0qz7W9IzLUlIrZVY59ZiDiIDpGBnAzryhsUaJk01R+QFA0sbLEj/eLNPgU1WBXjeXIjsroP3dVjmVwY3XZlJ6abQ/gWsYEJUjCQU+45IY5zGBejgWJ253VsJRQwZeqdTi9dOrU5oPO7JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788659302; c=relaxed/simple;
	bh=BXSgO29C6qwneVJIkfpp4UiUWW71vKn+Gh49+GXZ80U=;
	h=Date:To:From:Subject:Message-Id; b=ncdLkMKzDOuwxm0HMO2d22hOcXqjZ0Ao+nQSGX7I+H32fubsWmnrtuir7q2yGsaNuDarWjGxgmfBavCmzRg56i24ca+IsuTTXj/wsTqS6Ey7INdHvdLZuD0esgpPxbqAi1sQjP9uNNa6lb6wSdx4Dp/2CocZPmZpvVDjvuFQctU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=agFTFvza; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="agFTFvza"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36471F00A3D;
	Sun,  6 Sep 2026 01:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788659301;
	bh=sxBCnH7MWgdfNGM+kFZn8HCknRtl8KmABdNEJwI9iPU=;
	h=Date:To:From:Subject;
	b=agFTFvzabtfunOkJB7Xm7zOhMSMJF+IATJFrjFii0ntQOd/NS3LbyoQimtUumB5GD
	 bMCu4xXzSw+gC6UQZ3M9Eu8ui6igsWoi8wvD5YrcfLrLcsnhEFcctWvaFHjA2LLQ38
	 /AdbdK3qFeAlAKnJ/Ii65aOlBPkpqdsevAbi6T4A=
Date: Sat, 05 Sep 2026 18:48:20 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-set-areas-page_order-after-allocation-succeeds.patch removed from -mm tree
Message-Id: <20260906014820.E36471F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: set area's page_order after allocation succeeds
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-set-areas-page_order-after-allocation-succeeds.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm/vmalloc: set area's page_order after allocation succeeds
Date: Sun, 23 Aug 2026 14:46:13 +0300

__vmalloc_area_node() calls set_vm_area_page_order() to set area's
page_order before actually allocating pages to populate the area.

If allocation of large pages in HUGE_VMAP case fails midway, this leaves
the area with elevated page_order throughout the cleanup path.

There is no actual issue with this because the only place that currently
relies on area->page_order on the cleanup path is the loop calculating the
direct map alias range in vm_reset_perms() and it anyway skips unpopulated
pages.

But having set_vm_area_page_order() in the middle of __vmalloc_area_node()
makes things very obscure, hard to reason about and error prone against
future changes of the cleanup path.

Move the call to set_vm_area_page_order() just before the successful
return from __vmalloc_area_node() where page order is guaranteed.

While on it, initialize local page_order variable with its declaration.

Link: https://lore.kernel.org/20260823-execmem-set-vm-perms-v0-2-v2-2-b013a37d84b3@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
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
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-set-areas-page_order-after-allocation-succeeds
+++ a/mm/vmalloc.c
@@ -3878,7 +3878,7 @@ static void *__vmalloc_area_node(struct
 	unsigned long size = get_vm_area_size(area);
 	unsigned long array_size;
 	unsigned long nr_small_pages = size >> PAGE_SHIFT;
-	unsigned int page_order;
+	unsigned int page_order = page_shift - PAGE_SHIFT;
 	unsigned int flags;
 	int ret;
 
@@ -3906,9 +3906,6 @@ static void *__vmalloc_area_node(struct
 		goto fail;
 	}
 
-	set_vm_area_page_order(area, page_shift - PAGE_SHIFT);
-	page_order = vm_area_page_order(area);
-
 	/*
 	 * High-order nofail allocations are really expensive and
 	 * potentially dangerous (pre-mature OOM, disruptive reclaim
@@ -3963,6 +3960,7 @@ static void *__vmalloc_area_node(struct
 		goto fail;
 	}
 
+	set_vm_area_page_order(area, page_order);
 	return area->addr;
 
 fail:
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-vmalloc-constify-vm-parameter-of-get_vm_area_page_order.patch
mm-vmalloc-make-set_area_direct_map-huge_vmap-friendly.patch
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

