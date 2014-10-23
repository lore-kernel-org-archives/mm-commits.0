From: akpm@linux-foundation.org
Subject: [merged]
 mm-migratec-fix-set-cpupid-on-page-migration-twice-against-thp.patch
 removed from -mm tree
Date: Thu, 23 Oct 2014 13:10:22 -0700
Message-ID: <544960ae.scFo22O1hwHyCgUS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaJWUKV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Oct 2014 16:10:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liwanp@linux.vnet.ibm.com, mgorman@suse.de, n-horiguchi@ah.jp.nec.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate.c: fix set cpupid on page migration twice against thp
has been removed from the -mm tree.  Its filename was
     mm-migratec-fix-set-cpupid-on-page-migration-twice-against-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/migrate.c: fix set cpupid on page migration twice against thp

7851a45cd3 (mm: numa: Copy cpupid on page migration) copies over the
cpupid at page migration time.  It is unnecessary to set it again in
migrate_misplaced_transhuge_page().

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/migrate.c~mm-migratec-fix-set-cpupid-on-page-migration-twice-against-thp mm/migrate.c
--- a/mm/migrate.c~mm-migratec-fix-set-cpupid-on-page-migration-twice-against-thp
+++ a/mm/migrate.c
@@ -1753,8 +1753,6 @@ int migrate_misplaced_transhuge_page(str
 	if (!new_page)
 		goto out_fail;
 
-	page_cpupid_xchg_last(new_page, page_cpupid_last(page));
