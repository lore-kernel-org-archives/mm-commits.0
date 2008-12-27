From: akpm@linux-foundation.org
Subject: + vmallocc-fix-flushing-in-vmap_page_range.patch added to -mm tree
Date: Fri, 26 Dec 2008 16:39:52 -0800
Message-ID: <200812270039.mBR0dqae011038@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753296AbYL0AkD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Dec 2008 19:40:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adam@os.inf.tu-dresden.de, nickpiggin@yahoo.com.au, stable@kernel.org


The patch titled
     vmalloc.c: fix flushing in vmap_page_range()
has been added to the -mm tree.  Its filename is
     vmallocc-fix-flushing-in-vmap_page_range.patch

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

vmallocc-fix-flushing-in-vmap_page_range.patch

