From: akpm@linux-foundation.org
Subject: [merged] mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve.patch removed from -mm tree
Date: Wed, 25 May 2011 13:29:32 -0700
Message-ID: <201105252027.p4PKRuEX014625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755103Ab1EYU2d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:28:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arve@android.com, dave@linux.vnet.ibm.com, john.stultz@linaro.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm: check if any page in a pageblock is reserved before marking it=
 MIGRATE_RESERVE
has been removed from the -mm tree.  Its filename was
     mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-=
migrate_reserve.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: mm: check if any page in a pageblock is reserved before markin=
g it MIGRATE_RESERVE
=46rom: Arve Hj=F8nnev=E5g <arve@android.com>

This fixes a problem where the first pageblock got marked MIGRATE_RESER=
VE
even though it only had a few free pages.  eg, On current ARM port, The
kernel starts at offset 0x8000 to leave room for boot parameters, and t=
he
memory is freed later.

This in turn caused no contiguous memory to be reserved and frequent
kswapd wakeups that emptied the caches to get more contiguous memory.

Unfortunatelly, ARM needs order-2 allocation for pgd (see
arm/mm/pgd.c#pgd_alloc()).  Therefore the issue is not minor nor easy
avoidable.

[kosaki.motohiro@jp.fujitsu.com: added some explanation]
[kosaki.motohiro@jp.fujitsu.com: add !pfn_valid_within() to check]
[minchan.kim@gmail.com: check end_pfn in pageblock_is_reserved]
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Arve Hj=F8nnev=E5g <arve@android.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-check-if-any-page-in-a-pageblock-is-reserv=
ed-before-marking-it-migrate_reserve mm/page_alloc.c
--- a/mm/page_alloc.c~mm-check-if-any-page-in-a-pageblock-is-reserved-b=
efore-marking-it-migrate_reserve
+++ a/mm/page_alloc.c
@@ -3329,6 +3329,20 @@ static inline unsigned long wait_table_b
 #define LONG_ALIGN(x) (((x)+(sizeof(long))-1)&~((sizeof(long))-1))
=20
 /*
+ * Check if a pageblock contains reserved pages
+ */
+static int pageblock_is_reserved(unsigned long start_pfn, unsigned lon=
g end_pfn)
+{
+	unsigned long pfn;
+
+	for (pfn =3D start_pfn; pfn < end_pfn; pfn++) {
+		if (!pfn_valid_within(pfn) || PageReserved(pfn_to_page(pfn)))
+			return 1;
+	}
+	return 0;
+}
+
+/*
  * Mark a number of pageblocks as MIGRATE_RESERVE. The number
  * of blocks reserved is based on min_wmark_pages(zone). The memory wi=
thin
  * the reserve will tend to store contiguous free pages. Setting min_f=
ree_kbytes
@@ -3337,7 +3351,7 @@ static inline unsigned long wait_table_b
  */
 static void setup_zone_migrate_reserve(struct zone *zone)
 {
-	unsigned long start_pfn, pfn, end_pfn;
+	unsigned long start_pfn, pfn, end_pfn, block_end_pfn;
 	struct page *page;
 	unsigned long block_migratetype;
 	int reserve;
@@ -3367,7 +3381,8 @@ static void setup_zone_migrate_reserve(s
 			continue;
=20
 		/* Blocks with reserved pages will never free, skip them. */
-		if (PageReserved(page))
+		block_end_pfn =3D min(pfn + pageblock_nr_pages, end_pfn);
+		if (pageblock_is_reserved(pfn, block_end_pfn))
 			continue;
=20
 		block_migratetype =3D get_pageblock_migratetype(page);
_

Patches currently in -mm which might be from arve@android.com are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
