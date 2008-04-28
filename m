From: akpm@linux-foundation.org
Subject: - cris-add-constfy-to-pgd_offset.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:54:44 -0700
Message-ID: <200804282154.m3SLsiZN018037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936326AbYD1VzE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:55:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, jesper.nilsson@axis.com, mpm@selenic.com, starvik@axis.com, vegard.nossum@gmail.com, mm-commits@vger.kernel.org


The patch titled
     cris: add constfy to pgd_offset()
has been removed from the -mm tree.  Its filename was
     cris-add-constfy-to-pgd_offset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
memcgroup-make-the-memory-controller-more-desktop-responsive.patch

