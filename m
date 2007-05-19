From: akpm@linux-foundation.org
Subject: + readahead-introduce-pg_readahead.patch added to -mm tree
Date: Fri, 18 May 2007 23:28:33 -0700
Message-ID: <200705190628.l4J6SZuK031252@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34061 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754114AbXESGbC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 19 May 2007 02:31:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn, linuxram@us.ibm.com, slpratt@austin.ibm.com


The patch titled
     readahead: introduce PG_readahead
has been added to the -mm tree.  Its filename is
     readahead-introduce-pg_readahead.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead: introduce PG_readahead
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Introduce a new page flag: PG_readahead.

It acts as a look-ahead mark, which tells the page reader: Hey, it's time to
invoke the read-ahead logic.  For the sake of I/O pipelining, don't wait until
it runs out of cached pages!

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Steven Pratt <slpratt@austin.ibm.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    6 ++++++
 mm/page_alloc.c            |    2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN include/linux/page-flags.h~readahead-introduce-pg_readahead include/linux/page-flags.h
--- a/include/linux/page-flags.h~readahead-introduce-pg_readahead
+++ a/include/linux/page-flags.h
@@ -92,6 +92,8 @@
 #define PG_lazyfree		19	/* MADV_FREE potential throwaway */
 #define PG_booked		20	/* Has blocks reserved on-disk */
 
+#define PG_readahead		21	/* Reminder to do async read-ahead */
+
 /* PG_owner_priv_1 users should have descriptive aliases */
 #define PG_checked		PG_owner_priv_1 /* Used by some filesystems */
 
@@ -205,6 +207,10 @@ static inline void SetPageUptodate(struc
 #define SetPageBooked(page)	set_bit(PG_booked, &(page)->flags)
 #define ClearPageBooked(page)	clear_bit(PG_booked, &(page)->flags)
 
+#define PageReadahead(page)	test_bit(PG_readahead, &(page)->flags)
+#define SetPageReadahead(page)	set_bit(PG_readahead, &(page)->flags)
+#define ClearPageReadahead(page) clear_bit(PG_readahead, &(page)->flags)
+
 #define PageReclaim(page)	test_bit(PG_reclaim, &(page)->flags)
 #define SetPageReclaim(page)	set_bit(PG_reclaim, &(page)->flags)
 #define ClearPageReclaim(page)	clear_bit(PG_reclaim, &(page)->flags)
diff -puN mm/page_alloc.c~readahead-introduce-pg_readahead mm/page_alloc.c
--- a/mm/page_alloc.c~readahead-introduce-pg_readahead
+++ a/mm/page_alloc.c
@@ -649,7 +649,7 @@ static int prep_new_page(struct page *pa
 	if (PageReserved(page))
 		return 1;
 
-	page->flags &= ~(1 << PG_uptodate | 1 << PG_error |
+	page->flags &= ~(1 << PG_uptodate | 1 << PG_error | 1 << PG_readahead |
 			1 << PG_referenced | 1 << PG_arch_1 |
 			1 << PG_owner_priv_1 | 1 << PG_mappedtodisk);
 	set_page_private(page, 0);
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

readahead-introduce-pg_readahead.patch
readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
readahead-min_ra_pages-max_ra_pages-macros.patch
readahead-data-structure-and-routines.patch
readahead-on-demand-readahead-logic.patch
readahead-convert-filemap-invocations.patch
readahead-convert-splice-invocations.patch
readahead-convert-ext3-ext4-invocations.patch
readahead-remove-the-old-algorithm.patch
