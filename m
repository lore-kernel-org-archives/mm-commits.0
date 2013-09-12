From: akpm@linux-foundation.org
Subject: [merged]
 mm-hwpoison-dont-set-migration-type-twice-to-avoid-holding-heavily-contend-zone-lock.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:45:29 -0700
Message-ID: <523219d9.JCdCs2MJ1Fr7TYL3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58591 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184Ab3ILTpa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:45:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony.luck@intel.com, n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, liwanp@linux.vnet.ibm.com

Subject: [merged] mm-hwpoison-dont-set-migration-type-twice-to-avoid-holding-heavily-contend-zone-lock.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,andi@firstfloor.org,n-horiguchi@ah.jp.nec.com,tony.luck@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:45:29 -0700


The patch titled
     Subject: mm/hwpoison: don't set migration type twice to avoid holding heavily contend zone->lock
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-dont-set-migration-type-twice-to-avoid-holding-heavily-contend-zone-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/hwpoison: don't set migration type twice to avoid holding heavily contend zone->lock

Set pageblock migration type will hold zone->lock which is heavy contended
in system to avoid race.  However, soft offline page will set pageblock
migration type twice during get page if the page is in used, not hugetlbfs
page and not on lru list.  There is unnecessary to set the pageblock
migration type and hold heavy contended zone->lock again if the first
round get page have already set the pageblock to right migration type.

The trick here is migration type is MIGRATE_ISOLATE.  There are other two
parts can change MIGRATE_ISOLATE except hwpoison.  One is memory hoplug,
however, we hold lock_memory_hotplug() which avoid race.  The second is
CMA which umovable page allocation requst can't fallback to.  So it's safe
here.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memory-failure.c~mm-hwpoison-dont-set-migration-type-twice-to-avoid-holding-heavily-contend-zone-lock mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-dont-set-migration-type-twice-to-avoid-holding-heavily-contend-zone-lock
+++ a/mm/memory-failure.c
@@ -1429,7 +1429,8 @@ static int __get_any_page(struct page *p
 	 * was free. This flag should be kept set until the source page
 	 * is freed and PG_hwpoison on it is set.
 	 */
-	set_migratetype_isolate(p, true);
+	if (get_pageblock_migratetype(p) != MIGRATE_ISOLATE)
+		set_migratetype_isolate(p, true);
 	/*
 	 * When the target page is a free hugepage, just remove it
 	 * from free hugepage list.
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

origin.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

