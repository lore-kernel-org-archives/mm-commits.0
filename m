Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF9C2D9780
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334187; cv=none; b=ob+L4wX5THzOX3Xqc+XuB8Zyvxebz+DMlnwIY4k7l3YxoKRdVukf37z+XNJlpPMqm5kRkyB+VSeUliu5jNRlxX62/KotCD6/Vkgg3exQC8FwXf4puilycpgDlrVIq8BZdm1NTnmu2jCr8x1O0W9tLRRdyGfac4NN/Ylb3+x0e0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334187; c=relaxed/simple;
	bh=5mHVJzusoYmbedycLpQHaxfmyDz36sDNPJ7Tyey8gWw=;
	h=Date:To:From:Subject:Message-Id; b=KSHwEiZlStNRMCx19EnvsBI9/SHmSH1oua5Ceh1Y1xH25+CErTjkWF/NacpN0asjXZ2VIc9hU3MnrwRFRnP4sKZ8ubHxD7Lg9JKbhutQnoUQB4A5NqV0xloS49jCvcV5PwQva0+Y0FjgsFCq1pu/wSIqYeLVMG+g0C0yK+YjA6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S0ViWj66; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S0ViWj66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDC01F0089B;
	Wed,  7 Oct 2026 00:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334185;
	bh=GXWufiEdb/diUGd8rH5ylrL1LsbUr4hLLMQGDl5rX7I=;
	h=Date:To:From:Subject;
	b=S0ViWj66cctPo1YFRkWIvSHaBqK9Fu3EKcmCk1gRbPfm1l99hnBfykgGh9t9w6Xah
	 j5b4u2l3VqHTdw5zp5qG56nEcLJTYq5kxddjC2xJV4FXpVVbBLrouvdGF12R3g9iJN
	 sx8zWN5jl50Wn5u7j0qrC/ebAU5E5LN4VnGSVOCY=
Date: Tue, 06 Oct 2026 17:49:44 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,urezki@gmail.com,svens@linux.ibm.com,ryan.roberts@arm.com,rafael@kernel.org,peterz@infradead.org,palmer@dabbelt.com,mingo@redhat.com,luto@kernel.org,lenb@kernel.org,kevin.brodsky@arm.com,kernel@xen0n.name,hpa@zytor.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dev.jain@arm.com,david@kernel.org,dave.hansen@linux.intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,brendan.jackman@linux.dev,bp@alien8.de,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,alex@ghiti.fr,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-set-areas-page_order-after-allocation-succeeds.patch removed from -mm tree
Message-Id: <20261007004945.0FDC01F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: set area's page_order after allocation succeeds
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-set-areas-page_order-after-allocation-succeeds.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm/vmalloc: set area's page_order after allocation succeeds
Date: Thu, 03 Sep 2026 12:28:28 +0300

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

Link: https://lore.kernel.org/20260903-execmem-set-vm-perms-v0-2-v3-2-949b64a9f755@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
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
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
---

 mm/vmalloc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-set-areas-page_order-after-allocation-succeeds
+++ a/mm/vmalloc.c
@@ -3873,7 +3873,7 @@ static void *__vmalloc_area_node(struct
 	unsigned long size = get_vm_area_size(area);
 	unsigned long array_size;
 	unsigned long nr_small_pages = size >> PAGE_SHIFT;
-	unsigned int page_order;
+	unsigned int page_order = page_shift - PAGE_SHIFT;
 	unsigned int flags;
 	int ret;
 
@@ -3901,9 +3901,6 @@ static void *__vmalloc_area_node(struct
 		goto fail;
 	}
 
-	set_vm_area_page_order(area, page_shift - PAGE_SHIFT);
-	page_order = vm_area_page_order(area);
-
 	/*
 	 * High-order nofail allocations are really expensive and
 	 * potentially dangerous (pre-mature OOM, disruptive reclaim
@@ -3958,6 +3955,7 @@ static void *__vmalloc_area_node(struct
 		goto fail;
 	}
 
+	set_vm_area_page_order(area, page_order);
 	return area->addr;
 
 fail:
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

