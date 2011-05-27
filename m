From: akpm@linux-foundation.org
Subject: + mm-nommuc-fix-remap_pfn_range.patch added to -mm tree
Date: Fri, 27 May 2011 15:10:08 -0700
Message-ID: <201105272210.p4RMA8PY024317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753396Ab1E0WKo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 18:10:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, vapier@gentoo.org


The patch titled
     mm/nommu.c: fix remap_pfn_range()
has been added to the -mm tree.  Its filename is
     mm-nommuc-fix-remap_pfn_range.patch

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
Subject: mm/nommu.c: fix remap_pfn_range()
From: Bob Liu <lliubbo@gmail.com>

remap_pfn_range() does not update vma->end on no mmu arch which will cause
munmap() fail because it can't match the vma.

eg.  fb_mmap() in fbmem.c will call io_remap_pfn_range() which is
remap_pfn_range() on nommu arch, if an address is not page aligned
vma->start will be changed in remap_pfn_range(), but neither size nor
vma->end will be updated.  Then munmap(start, len) can't find the vma to
free, because it need to compare (start + len) with vma->end.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Bob Liu <lliubbo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/nommu.c~mm-nommuc-fix-remap_pfn_range mm/nommu.c
--- a/mm/nommu.c~mm-nommuc-fix-remap_pfn_range
+++ a/mm/nommu.c
@@ -1817,6 +1817,7 @@ int remap_pfn_range(struct vm_area_struc
 		unsigned long to, unsigned long size, pgprot_t prot)
 {
 	vma->vm_start = vma->vm_pgoff << PAGE_SHIFT;
+	vma->vm_end = vma->vm_start + size;
 	return 0;
 }
 EXPORT_SYMBOL(remap_pfn_range);
_

Patches currently in -mm which might be from lliubbo@gmail.com are

origin.patch
mm-nommuc-fix-remap_pfn_range.patch

