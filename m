From: akpm@linux-foundation.org
Subject: [folded] mm-nommuc-fix-remap_pfn_range-update.patch removed from -mm tree
Date: Fri, 08 Jul 2011 15:38:19 -0700
Message-ID: <201107082238.p68McJrS019493@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751872Ab1GHWjB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2011 18:39:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lliubbo@gmail.com, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     mm-nommuc-fix-remap_pfn_range-update
has been removed from the -mm tree.  Its filename was
     mm-nommuc-fix-remap_pfn_range-update.patch

This patch was dropped because it was folded into mm-nommuc-fix-remap_pfn_range.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-nommuc-fix-remap_pfn_range-update
From: Bob Liu <lliubbo@gmail.com>

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Bob Liu <lliubbo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/nommu.c~mm-nommuc-fix-remap_pfn_range-update mm/nommu.c
--- a/mm/nommu.c~mm-nommuc-fix-remap_pfn_range-update
+++ a/mm/nommu.c
@@ -1813,11 +1813,13 @@ struct page *follow_page(struct vm_area_
 	return NULL;
 }
 
-int remap_pfn_range(struct vm_area_struct *vma, unsigned long from,
-		unsigned long to, unsigned long size, pgprot_t prot)
+int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pfn, unsigned long size, pgprot_t prot)
 {
-	vma->vm_start = vma->vm_pgoff << PAGE_SHIFT;
-	vma->vm_end = vma->vm_start + size;
+	if (addr != (pfn << PAGE_SHIFT))
+		return -EINVAL;
+
+	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
 	return 0;
 }
 EXPORT_SYMBOL(remap_pfn_range);
_

Patches currently in -mm which might be from lliubbo@gmail.com are

mm-nommuc-fix-remap_pfn_range.patch
linux-next.patch

