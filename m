From: akpm@linux-foundation.org
Subject: [merged]
 mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch removed from -mm tree
Date: Tue, 28 Jan 2014 11:09:55 -0800
Message-ID: <52e80083.H70zdCdwZ3SOTfN2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602AbaA1TJz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:09:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com

Subject: [merged] mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:09:55 -0800


The patch titled
     Subject: mm/migrate.c: fix setting of cpupid on page migration twice against normal page
has been removed from the -mm tree.  Its filename was
     mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/migrate.c: fix setting of cpupid on page migration twice against normal page

7851a45cd3 ("mm: numa: Copy cpupid on page migration") copies over the
cpupid at page migration time.  It is unnecessary to set it again in
alloc_misplaced_dst_page().

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/migrate.c~mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page mm/migrate.c
--- a/mm/migrate.c~mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page
+++ a/mm/migrate.c
@@ -1548,8 +1548,6 @@ static struct page *alloc_misplaced_dst_
 					  __GFP_NOMEMALLOC | __GFP_NORETRY |
 					  __GFP_NOWARN) &
 					 ~GFP_IOFS, 0);
-	if (newpage)
-		page_cpupid_xchg_last(newpage, page_cpupid_last(page));
 
 	return newpage;
 }
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
linux-next.patch

