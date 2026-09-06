Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020ED38DD3
	for <mm-commits@vger.kernel.org>; Sun,  6 Sep 2026 02:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788660081; cv=none; b=LKFhdDDT4Cu4Y2bN6DzLDGLhdQ42/3jsuWlELYEp6PHa7OgBr/25kRRCD1UBfZGVWn9GmYBv9n4C4L1IxAFe3noP2kHJzXgYUjd2br5XQZDhb54UtcRNcvt8BOwQgBkClRdgEdEHOR6/kIJAZyoV8FisZTJ6BZR8ZdE7C+nhuns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788660081; c=relaxed/simple;
	bh=d/rvnt2r1AX5D2isNdaIemNFlTZNQ+oky44VLU5SCqA=;
	h=Date:To:From:Subject:Message-Id; b=jeab9QIrirOv0qWMsIREX9TQQICmZyiljnBnqw0Z5YZgNdzgnSt/e5G5FG5OLSI7JYeS7VTjrRtFGzRMnWTTjF98DuHwskD01L0OQwdHHgdXEhVrhnBLxsoB3HtggtkJP44aohXuXjei1WSw8tzPOG/UF2xkTwpAjwhCEAWPUvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RHPGWfJM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RHPGWfJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F21A1F00A3A;
	Sun,  6 Sep 2026 02:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788660079;
	bh=OTjf/jNw/M2K4iLzOMOKFY9ZN7Xc06RdWjsI++f0SZw=;
	h=Date:To:From:Subject;
	b=RHPGWfJMLh9f6EOUIYV4TRkV0IonbT8KOMDxh776E99NIVTnnEvVbq1tN88Xs4DXj
	 v6NGROTWtam/2/vw40a8bOFTqTn2SzHic/7kErZasTjUMe3M0RDI54FurBINRiMvXn
	 UKRXMiSMUtTAeuz4qX5q72qR2/NYyKDZB1fD8b4k=
Date: Sat, 05 Sep 2026 19:01:19 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-make-set_area_direct_map-huge_vmap-friendly.patch added to mm-unstable branch
Message-Id: <20260906020119.7F21A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: make set_area_direct_map HUGE_VMAP friendly
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-make-set_area_direct_map-huge_vmap-friendly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-make-set_area_direct_map-huge_vmap-friendly.patch

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
Cc: Dev Jain <dev.jain@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-make-set_area_direct_map-huge_vmap-friendly
+++ a/mm/vmalloc.c
@@ -3374,12 +3374,15 @@ static inline void set_area_direct_map(c
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

