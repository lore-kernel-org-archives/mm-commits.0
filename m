From: akpm@linux-foundation.org
Subject: + mm-nommuc-fix-remap_pfn_range-update.patch added to -mm tree
Date: Wed, 29 Jun 2011 16:16:24 -0700
Message-ID: <201106292316.p5TNGOHF018549@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752348Ab1F2XQl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jun 2011 19:16:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, vapier@gentoo.org


The patch titled
     mm-nommuc-fix-remap_pfn_range-update
has been added to the -mm tree.  Its filename is
     mm-nommuc-fix-remap_pfn_range-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
mm-nommuc-fix-remap_pfn_range-update.patch

