From: akpm@linux-foundation.org
Subject: [merged] mm-nommuc-fix-remap_pfn_range.patch removed from -mm tree
Date: Mon, 11 Jul 2011 11:43:06 -0700
Message-ID: <201107111842.p6BIgbKA025509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753050Ab1GKTmW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jul 2011 15:42:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lliubbo@gmail.com, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, stable@kernel.org, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     mm/nommu.c: fix remap_pfn_range()
has been removed from the -mm tree.  Its filename was
     mm-nommuc-fix-remap_pfn_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/nommu.c: fix remap_pfn_range()
From: Bob Liu <lliubbo@gmail.com>

remap_pfn_range() means map physical address pfn<<PAGE_SHIFT to user addr.

For nommu arch it's implemented by vma->vm_start = pfn << PAGE_SHIFT which
is wrong acroding the original meaning of this function.  And some driver
developer using remap_pfn_range() with correct parameter will get
unexpected result because vm_start is changed.  It should be implementd
like addr = pfn << PAGE_SHIFT but which is meanless on nommu arch, this
patch just make it simply return.

Parameter name and setting of vma->vm_flags also be fixed.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Bob Liu <lliubbo@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/nommu.c~mm-nommuc-fix-remap_pfn_range mm/nommu.c
--- a/mm/nommu.c~mm-nommuc-fix-remap_pfn_range
+++ a/mm/nommu.c
@@ -1813,10 +1813,13 @@ struct page *follow_page(struct vm_area_
 	return NULL;
 }
 
-int remap_pfn_range(struct vm_area_struct *vma, unsigned long from,
-		unsigned long to, unsigned long size, pgprot_t prot)
+int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pfn, unsigned long size, pgprot_t prot)
 {
-	vma->vm_start = vma->vm_pgoff << PAGE_SHIFT;
+	if (addr != (pfn << PAGE_SHIFT))
+		return -EINVAL;
+
+	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
 	return 0;
 }
 EXPORT_SYMBOL(remap_pfn_range);
_

Patches currently in -mm which might be from lliubbo@gmail.com are

origin.patch
linux-next.patch

