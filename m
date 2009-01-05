From: akpm@linux-foundation.org
Subject: - vmallocc-fix-flushing-in-vmap_page_range.patch removed from -mm tree
Date: Sun, 04 Jan 2009 22:40:43 -0800
Message-ID: <200901050640.n056eh1o004763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750845AbZAEGkz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 01:40:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adam@os.inf.tu-dresden.de, nickpiggin@yahoo.com.au, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     vmalloc.c: fix flushing in vmap_page_range()
has been removed from the -mm tree.  Its filename was
     vmallocc-fix-flushing-in-vmap_page_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmalloc.c: fix flushing in vmap_page_range()
From: Adam Lackorzynski <adam@os.inf.tu-dresden.de>

The flush_cache_vmap in vmap_page_range() is called with the end of the
range twice.  The following patch fixes this for me.

Signed-off-by: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/vmalloc.c~vmallocc-fix-flushing-in-vmap_page_range mm/vmalloc.c
--- a/mm/vmalloc.c~vmallocc-fix-flushing-in-vmap_page_range
+++ a/mm/vmalloc.c
@@ -151,11 +151,12 @@ static int vmap_pud_range(pgd_t *pgd, un
  *
  * Ie. pte at addr+N*PAGE_SIZE shall point to pfn corresponding to pages[N]
  */
-static int vmap_page_range(unsigned long addr, unsigned long end,
+static int vmap_page_range(unsigned long start_addr, unsigned long end,
 				pgprot_t prot, struct page **pages)
 {
 	pgd_t *pgd;
 	unsigned long next;
+	unsigned long addr = start_addr;
 	int err = 0;
 	int nr = 0;
 
@@ -167,7 +168,7 @@ static int vmap_page_range(unsigned long
 		if (err)
 			break;
 	} while (pgd++, addr = next, addr != end);
-	flush_cache_vmap(addr, end);
+	flush_cache_vmap(start_addr, end);
 
 	if (unlikely(err))
 		return err;
_

Patches currently in -mm which might be from adam@os.inf.tu-dresden.de are

origin.patch

