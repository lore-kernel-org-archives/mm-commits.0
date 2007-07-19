From: akpm@linux-foundation.org
Subject: - readahead-introduce-pg_readahead.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:01:01 -0700
Message-ID: <200707192001.l6JK11I5019498@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54009 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760345AbXGSU2H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:28:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, linuxram@us.ibm.com, rusty@rustcorp.com.au, slpratt@austin.ibm.com, mm-commits@vger.kernel.org


The patch titled
     readahead: introduce PG_readahead
has been removed from the -mm tree.  Its filename was
     readahead-introduce-pg_readahead.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    5 +++++
 mm/page_alloc.c            |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff -puN include/linux/page-flags.h~readahead-introduce-pg_readahead include/linux/page-flags.h
--- a/include/linux/page-flags.h~readahead-introduce-pg_readahead
+++ a/include/linux/page-flags.h
@@ -83,6 +83,7 @@
 #define PG_private		11	/* If pagecache, has fs-private data */
 
 #define PG_writeback		12	/* Page is under writeback */
+#define PG_readahead		13	/* Reminder to do async read-ahead */
 #define PG_compound		14	/* Part of a compound page */
 #define PG_swapcache		15	/* Swap page: swp_entry_t in private */
 
@@ -226,6 +227,10 @@ static inline void SetPageUptodate(struc
 #define SetPageMappedToDisk(page) set_bit(PG_mappedtodisk, &(page)->flags)
 #define ClearPageMappedToDisk(page) clear_bit(PG_mappedtodisk, &(page)->flags)
 
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
@@ -617,7 +617,7 @@ static int prep_new_page(struct page *pa
 	if (PageReserved(page))
 		return 1;
 
-	page->flags &= ~(1 << PG_uptodate | 1 << PG_error |
+	page->flags &= ~(1 << PG_uptodate | 1 << PG_error | 1 << PG_readahead |
 			1 << PG_referenced | 1 << PG_arch_1 |
 			1 << PG_owner_priv_1 | 1 << PG_mappedtodisk);
 	set_page_private(page, 0);
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
