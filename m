From: akpm@linux-foundation.org
Subject: + mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve.patch added to -mm tree
Date: Mon, 25 Apr 2011 13:01:47 -0700
Message-ID: <201104252001.p3PK1mKc005374@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751022Ab1DYUC4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Apr 2011 16:02:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arve@android.com, akpm@linux-foundation.org, dave@linux.vnet.ibm.com, john.stultz@linaro.org, mel@csn.ul.ie, mgorman@suse.de


The patch titled
     mm: check if any page in a pageblock is reserved before marking it=
 MIGRATE_RESERVE
has been added to the -mm tree.  Its filename is
     mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-=
migrate_reserve.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: mm: check if any page in a pageblock is reserved before markin=
g it MIGRATE_RESERVE
=46rom: Arve Hj=F8nnev=E5g <arve@android.com>

This fixes a problem where the first pageblock got marked MIGRATE_RESER=
VE
even though it only had a few free pages.  This in turn caused no
contiguous memory to be reserved and frequent kswapd wakeups that empti=
ed
the caches to get more contiguous memory.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Arve Hj=F8nnev=E5g <arve@android.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-check-if-any-page-in-a-pageblock-is-reserv=
ed-before-marking-it-migrate_reserve mm/page_alloc.c
--- a/mm/page_alloc.c~mm-check-if-any-page-in-a-pageblock-is-reserved-b=
efore-marking-it-migrate_reserve
+++ a/mm/page_alloc.c
@@ -3287,6 +3287,20 @@ static inline unsigned long wait_table_b
 #define LONG_ALIGN(x) (((x)+(sizeof(long))-1)&~((sizeof(long))-1))
=20
 /*
+ * Check if a pageblock contains reserved pages
+ */
+static int pageblock_is_reserved(unsigned long start_pfn)
+{
+	unsigned long end_pfn =3D start_pfn + pageblock_nr_pages;
+	unsigned long pfn;
+
+	for (pfn =3D start_pfn; pfn < end_pfn; pfn++)
+		if (PageReserved(pfn_to_page(pfn)))
+			return 1;
+	return 0;
+}
+
+/*
  * Mark a number of pageblocks as MIGRATE_RESERVE. The number
  * of blocks reserved is based on min_wmark_pages(zone). The memory wi=
thin
  * the reserve will tend to store contiguous free pages. Setting min_f=
ree_kbytes
@@ -3325,7 +3339,7 @@ static void setup_zone_migrate_reserve(s
 			continue;
=20
 		/* Blocks with reserved pages will never free, skip them. */
-		if (PageReserved(page))
+		if (pageblock_is_reserved(pfn))
 			continue;
=20
 		block_migratetype =3D get_pageblock_migratetype(page);
_

Patches currently in -mm which might be from arve@android.com are

mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migra=
te_reserve.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
