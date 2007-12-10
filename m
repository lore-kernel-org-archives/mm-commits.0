From: akpm@linux-foundation.org
Subject: - ia64-efi-make-full-use-of-macro-efi_md_size.patch removed from -mm tree
Date: Mon, 10 Dec 2007 15:22:23 -0800
Message-ID: <200712102322.lBANMNOU024330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36579 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752325AbXLJXXH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Dec 2007 18:23:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, horms@verge.net.au, mm-commits@vger.kernel.org


The patch titled
     ia64 efi: make full use of macro efi_md_size
has been removed from the -mm tree.  Its filename was
     ia64-efi-make-full-use-of-macro-efi_md_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ia64 efi: make full use of macro efi_md_size
From: Li Zefan <lizf@cn.fujitsu.com>

Macro efi_md_size is defined in efi.c, and here we apply it throughout
efi.c.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/efi.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/ia64/kernel/efi.c~ia64-efi-make-full-use-of-macro-efi_md_size arch/ia64/kernel/efi.c
--- a/arch/ia64/kernel/efi.c~ia64-efi-make-full-use-of-macro-efi_md_size
+++ a/arch/ia64/kernel/efi.c
@@ -370,7 +370,7 @@ efi_get_pal_addr (void)
 			continue;
 		}
 
-		if (md->num_pages << EFI_PAGE_SHIFT > IA64_GRANULE_SIZE)
+		if (efi_md_size(md) > IA64_GRANULE_SIZE)
 			panic("Woah!  PAL code size bigger than a granule!");
 
 #if EFI_DEBUG
@@ -378,7 +378,7 @@ efi_get_pal_addr (void)
 
 		printk(KERN_INFO "CPU %d: mapping PAL code [0x%lx-0x%lx) into [0x%lx-0x%lx)\n",
 			smp_processor_id(), md->phys_addr,
-			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
+			md->phys_addr + efi_md_size(md),
 			vaddr & mask, (vaddr & mask) + IA64_GRANULE_SIZE);
 #endif
 		return __va(md->phys_addr);
@@ -523,7 +523,7 @@ efi_init (void)
 			md = p;
 			printk("mem%02u: type=%u, attr=0x%lx, range=[0x%016lx-0x%016lx) (%luMB)\n",
 			       i, md->type, md->attribute, md->phys_addr,
-			       md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
+			       md->phys_addr + efi_md_size(md),
 			       md->num_pages >> (20 - EFI_PAGE_SHIFT));
 		}
 	}
@@ -656,7 +656,7 @@ efi_memory_descriptor (unsigned long phy
 	for (p = efi_map_start; p < efi_map_end; p += efi_desc_size) {
 		md = p;
 
-		if (phys_addr - md->phys_addr < (md->num_pages << EFI_PAGE_SHIFT))
+		if (phys_addr - md->phys_addr < efi_md_size(md))
 			 return md;
 	}
 	return NULL;
@@ -1158,7 +1158,7 @@ efi_initialize_iomem_resources(struct re
 
 		res->name = name;
 		res->start = md->phys_addr;
-		res->end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1;
+		res->end = md->phys_addr + efi_md_size(md) - 1;
 		res->flags = flags;
 
 		if (insert_resource(&iomem_resource, res) < 0)
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

git-hid.patch
git-ia64.patch
git-net.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
time-delete-comments-that-refer-to-noexistent-symbols.patch
