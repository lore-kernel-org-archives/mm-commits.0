From: akpm@linux-foundation.org
Subject: +
 mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve.patch added to -mm tree
Date: Tue, 19 Nov 2013 16:25:26 -0800
Message-ID: <528c0176.sBuopd6maOIBpNjj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42884 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab3KTAZ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Nov 2013 19:25:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de, kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com

Subject: + mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve.patch added to -mm tree
To: isimatu.yasuaki@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,mgorman@suse.de
From: akpm@linux-foundation.org
Date: Tue, 19 Nov 2013 16:25:26 -0800


The patch titled
     Subject: mm: get rid of unnecessary pageblock scanning in setup_zone_migrate_reserve
has been added to the -mm tree.  Its filename is
     mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: mm: get rid of unnecessary pageblock scanning in setup_zone_migrate_reserve

Yasuaki Ishimatsu reported memory hot-add spent more than 5 _hours_ on 9TB
memory machine since onlining memory sections is too slow.  And we found
out setup_zone_migrate_reserve spent >90% of the time.

The problem is, setup_zone_migrate_reserve scans all pageblocks
unconditionally, but it is only necessary if the number of reserved block
was reduced (i.e.  memory hot remove).

Moreover, maximum MIGRATE_RESERVE per zone is currently 2.  It means that
the number of reserved pageblocks is almost always unchanged.

This patch adds zone->nr_migrate_reserve_block to maintain the number of
MIGRATE_RESERVE pageblocks and it reduces the overhead of
setup_zone_migrate_reserve dramatically.  The following table shows time
of onlining a memory section.

  Amount of memory     | 128GB | 192GB | 256GB|
  ---------------------------------------------
  linux-3.12           |  23.9 |  31.4 | 44.5 |
  This patch           |   8.3 |   8.3 |  8.6 |
  Mel's proposal patch |  10.9 |  19.2 | 31.3 |
  ---------------------------------------------
                                   (millisecond)

  128GB : 4 nodes and each node has 32GB of memory
  192GB : 6 nodes and each node has 32GB of memory
  256GB : 8 nodes and each node has 32GB of memory

  (*1) Mel proposed his idea by the following threads.
       https://lkml.org/lkml/2013/10/30/272

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Reported-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Tested-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 ++++++
 mm/page_alloc.c        |   13 +++++++++++++
 2 files changed, 19 insertions(+)

diff -puN include/linux/mmzone.h~mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve
+++ a/include/linux/mmzone.h
@@ -490,6 +490,12 @@ struct zone {
 	unsigned long		managed_pages;
 
 	/*
+	 * Number of MIGRATE_RESEVE page block. To maintain for just
+	 * optimization. Protected by zone->lock.
+	 */
+	int			nr_migrate_reserve_block;
+
+	/*
 	 * rarely used fields:
 	 */
 	const char		*name;
diff -puN mm/page_alloc.c~mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve mm/page_alloc.c
--- a/mm/page_alloc.c~mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve
+++ a/mm/page_alloc.c
@@ -3902,6 +3902,7 @@ static void setup_zone_migrate_reserve(s
 	struct page *page;
 	unsigned long block_migratetype;
 	int reserve;
+	int old_reserve;
 
 	/*
 	 * Get the start pfn, end pfn and the number of blocks to reserve
@@ -3923,6 +3924,12 @@ static void setup_zone_migrate_reserve(s
 	 * future allocation of hugepages at runtime.
 	 */
 	reserve = min(2, reserve);
+	old_reserve = zone->nr_migrate_reserve_block;
+
+	/* When memory hot-add, we almost always need to do nothing */
+	if (reserve == old_reserve)
+		return;
+	zone->nr_migrate_reserve_block = reserve;
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
 		if (!pfn_valid(pfn))
@@ -3960,6 +3967,12 @@ static void setup_zone_migrate_reserve(s
 				reserve--;
 				continue;
 			}
+		} else if (!old_reserve) {
+			/*
+			 * When boot time, we don't need scan whole zone
+			 * for turning off MIGRATE_RESERVE.
+			 */
+			break;
 		}
 
 		/*
_

Patches currently in -mm which might be from isimatu.yasuaki@jp.fujitsu.com are

origin.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch

