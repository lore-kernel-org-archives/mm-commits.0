Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1814D2E737F
	for <mm-commits@vger.kernel.org>; Sun,  6 Sep 2026 02:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788660076; cv=none; b=QsN/GoaFLdRSug0IvERp96s3W6jZWXZREfx8U7d7LclVXFWyIcb9nk/J4DflHAFF3whODiwTR6C3kSTS62jfRpDB28lG7kLHGxbtLOd/W/6RQ1fwmwzEbtxDEfpJKTqnthkGYTlUJNNQpgSGj894Hx+SpFY5hIYSmQqnpTnBslU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788660076; c=relaxed/simple;
	bh=8+4/ufIzVHDza83OGOGlWqMv29O5dDmqGEbLPArVGrI=;
	h=Date:To:From:Subject:Message-Id; b=tWgB+9yszOTB0LTBZWNwODqmag1iKH8IY6ErhU4jgMKlH6D0T4P+54+5qq+AypuKEY+DqULMr/r/L893eEhyBRFvIvi+f1JZ/VBGAK/VRdEWxlN2+azNPdW9ySV67e9qs8d7O/n8XEy1U1uEBIxQI6cBgRqQKgfPGTYTk2WOk2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LaDUQKTb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LaDUQKTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DBB81F00A3A;
	Sun,  6 Sep 2026 02:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788660074;
	bh=6d3x+zEZObAAzt2mr6s0I7oRq2XdnP2Sx8BFvhvabZg=;
	h=Date:To:From:Subject;
	b=LaDUQKTbSxoLMBxLzfR/ucwSrUyHrH1+dXcGGBAAfyhOu6OlA50+R65kKJHDYNXi7
	 fQ4fBB69MVDKVn+B9VTOxL9lE7MFTzruzkJRE8d/y2Uab71bv6tKvSLs7luqiGjEnD
	 nwxCb68Bsxwi8EvJw7b3xr8Q63gmLbo0X7E8QyDc=
Date: Sat, 05 Sep 2026 19:01:14 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-set-areas-page_order-after-allocation-succeeds.patch added to mm-unstable branch
Message-Id: <20260906020114.8DBB81F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: set area's page_order after allocation succeeds
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-set-areas-page_order-after-allocation-succeeds.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-set-areas-page_order-after-allocation-succeeds.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-set-areas-page_order-after-allocation-succeeds
+++ a/mm/vmalloc.c
@@ -3886,7 +3886,7 @@ static void *__vmalloc_area_node(struct
 	unsigned long size = get_vm_area_size(area);
 	unsigned long array_size;
 	unsigned long nr_small_pages = size >> PAGE_SHIFT;
-	unsigned int page_order;
+	unsigned int page_order = page_shift - PAGE_SHIFT;
 	unsigned int flags;
 	int ret;
 
@@ -3914,9 +3914,6 @@ static void *__vmalloc_area_node(struct
 		goto fail;
 	}
 
-	set_vm_area_page_order(area, page_shift - PAGE_SHIFT);
-	page_order = vm_area_page_order(area);
-
 	/*
 	 * High-order nofail allocations are really expensive and
 	 * potentially dangerous (pre-mature OOM, disruptive reclaim
@@ -3971,6 +3968,7 @@ static void *__vmalloc_area_node(struct
 		goto fail;
 	}
 
+	set_vm_area_page_order(area, page_order);
 	return area->addr;
 
 fail:
_

Patches currently in -mm which might be from rppt@kernel.org are

set_memory-add-number-of-pages-parameter-to-set_direct_map-apis.patch
mm-vmalloc-set-areas-page_order-after-allocation-succeeds.patch
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

