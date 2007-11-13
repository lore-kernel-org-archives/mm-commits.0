From: akpm@linux-foundation.org
Subject: + config_highpte-vs-sub-page-page-tables-fix.patch added to -mm tree
Date: Tue, 13 Nov 2007 11:13:40 -0800
Message-ID: <200711131913.lADJDef8026141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51751 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762037AbXKMTOS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Nov 2007 14:14:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: schwidefsky@de.ibm.com, kamalesh@linux.vnet.ibm.com


The patch titled
     config_highpte-vs-sub-page-page-tables fix
has been added to the -mm tree.  Its filename is
     config_highpte-vs-sub-page-page-tables-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: config_highpte-vs-sub-page-page-tables fix
From: Martin Schwidefsky <schwidefsky@de.ibm.com>

On Tue, 2007-11-13 at 20:13 +0530, Kamalesh Babulal wrote:
> Hi Andrew,
>
> The kernel build fails, with following build error
>
> mm/memory.c: In function `free_pte_range':
> mm/memory.c:126: error: implicit declaration of function `pmd_pgtable'
> mm/memory.c:126: warning: initialization makes pointer from integer without a cast
> mm/memory.c: In function `apply_to_pte_range':
> mm/memory.c:1389: warning: assignment makes pointer from integer without a cast
> make[1]: *** [mm/memory.o] Error 1
> make: *** [mm] Error 2
>
> The patch causing this issue is config_highpte-vs-sub-page-page-tables.patch.
> Where the marco is defined #ifndef CONFIG_PPC_64K_PAGES.

Forget the request for the .config. Found the problem, fixup patch
below.

Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-powerpc/pgalloc-64.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-powerpc/pgalloc-64.h~config_highpte-vs-sub-page-page-tables-fix include/asm-powerpc/pgalloc-64.h
--- a/include/asm-powerpc/pgalloc-64.h~config_highpte-vs-sub-page-page-tables-fix
+++ a/include/asm-powerpc/pgalloc-64.h
@@ -68,6 +68,7 @@ static inline void pmd_populate_kernel(s
 
 #define pmd_populate(mm, pmd, pte_page) \
 	pmd_populate_kernel(mm, pmd, page_address(pte_page))
+#define pmd_pgtable(pmd) pmd_page(pmd)
 
 #endif /* CONFIG_PPC_64K_PAGES */
 
_

Patches currently in -mm which might be from schwidefsky@de.ibm.com are

git-s390.patch
git-scsi-misc.patch
add-mm-argument-to-pte-pmd-pud-pgd_free.patch
config_highpte-vs-sub-page-page-tables.patch
config_highpte-vs-sub-page-page-tables-fix.patch
arch_rebalance_pgtables-call.patch
taskstats-scaled-time-cleanup.patch
unexport-asm-pageh.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-s390.patch
