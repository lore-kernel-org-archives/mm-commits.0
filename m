From: akpm@linux-foundation.org
Subject: + cris-add-constfy-to-pgd_offset.patch added to -mm tree
Date: Sun, 27 Apr 2008 11:58:50 -0700
Message-ID: <200804271858.m3RIwoB8020121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023AbYD0S7L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 14:59:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, jesper.nilsson@axis.com, mpm@selenic.com, starvik@axis.com, vegard.nossum@gmail.com


The patch titled
     cris: add constfy to pgd_offset()
has been added to the -mm tree.  Its filename is
     cris-add-constfy-to-pgd_offset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cris: add constfy to pgd_offset()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

add constfy to pgd_offset() for avoid following warnings.

  CC      mm/pagewalk.o
mm/pagewalk.c: In function 'walk_page_range':
mm/pagewalk.c:111: warning: passing argument 1 of 'pgd_offset' discards qualifiers from p\
ointer target type

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-cris/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-cris/pgtable.h~cris-add-constfy-to-pgd_offset include/asm-cris/pgtable.h
--- a/include/asm-cris/pgtable.h~cris-add-constfy-to-pgd_offset
+++ a/include/asm-cris/pgtable.h
@@ -231,7 +231,7 @@ static inline void pmd_set(pmd_t * pmdp,
 #define pgd_index(address) (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
 
 /* to find an entry in a page-table-directory */
-static inline pgd_t * pgd_offset(struct mm_struct * mm, unsigned long address)
+static inline pgd_t * pgd_offset(const struct mm_struct *mm, unsigned long address)
 {
 	return mm->pgd + pgd_index(address);
 }
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo.patch
vmallocinfo-add-caller-information.patch
sparsemem-vmemmap-does-not-need-section-bits.patch
kbuild-create-a-way-to-create-preprocessor-constants-from-c-expressions.patch
pageflags-use-an-enum-for-the-flags.patch
pageflags-get-rid-of-flags_reserved.patch
pageflags-introduce-macros-to-generate-page-flag-functions.patch
pageflags-convert-to-the-use-of-new-macros.patch
pageflags-use-proper-page-flag-functions-in-xen.patch
pageflags-eliminate-pg_xxx-aliases.patch
smaps-account-swap-entries.patch
smaps-account-swap-entries-sneak-in-a-coding-style-fix.patch
hugetlb-vmstat-events-for-huge-page-allocations.patch
memcgroup-make-the-memory-controller-more-desktop-responsive.patch
cris-add-constfy-to-pgd_offset.patch

