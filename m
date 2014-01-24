From: akpm@linux-foundation.org
Subject: [merged]
 fs-proc-pagec-add-pageanon-check-to-surely-detect-thp.patch removed from
 -mm tree
Date: Fri, 24 Jan 2014 10:58:31 -0800
Message-ID: <52e2b7d7.eeVL7IC2UDgsCVCl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43161 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS6c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:58:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, n-horiguchi@ah.jp.nec.com

Subject: [merged] fs-proc-pagec-add-pageanon-check-to-surely-detect-thp.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,fengguang.wu@intel.com,kosaki.motohiro@jp.fujitsu.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:58:31 -0800


The patch titled
     Subject: fs/proc/page.c: add PageAnon check to surely detect thp
has been removed from the -mm tree.  Its filename was
     fs-proc-pagec-add-pageanon-check-to-surely-detect-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: fs/proc/page.c: add PageAnon check to surely detect thp

stable_page_flags() checks !PageHuge && PageTransCompound && PageLRU to
know that a specified page is thp or not.  But sometimes it's not enough
and we fail to detect thp when the thp is on pagevec.  This happens only
for a few seconds after LRU list operations, but it makes it difficult to
control our applications depending on this flag.

So this patch adds another check PageAnon to detect thps on pagevec.  It
might not give the future extensibility for thp pagecache, but it's OK at
least for now.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN fs/proc/page.c~fs-proc-pagec-add-pageanon-check-to-surely-detect-thp fs/proc/page.c
--- a/fs/proc/page.c~fs-proc-pagec-add-pageanon-check-to-surely-detect-thp
+++ a/fs/proc/page.c
@@ -118,10 +118,12 @@ u64 stable_page_flags(struct page *page)
 	/*
 	 * PageTransCompound can be true for non-huge compound pages (slab
 	 * pages or pages allocated by drivers with __GFP_COMP) because it
-	 * just checks PG_head/PG_tail, so we need to check PageLRU to make
-	 * sure a given page is a thp, not a non-huge compound page.
+	 * just checks PG_head/PG_tail, so we need to check PageLRU/PageAnon
+	 * to make sure a given page is a thp, not a non-huge compound page.
 	 */
-	else if (PageTransCompound(page) && PageLRU(compound_trans_head(page)))
+	else if (PageTransCompound(page) &&
+		 (PageLRU(compound_trans_head(page)) ||
+		  PageAnon(compound_trans_head(page))))
 		u |= 1 << KPF_THP;
 
 	/*
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch

