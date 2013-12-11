From: akpm@linux-foundation.org
Subject: +
 mm-migratec-fix-set-cpupid-on-page-migration-twice-against-thp.patch added
 to -mm tree
Date: Wed, 11 Dec 2013 15:47:50 -0800
Message-ID: <52a8f9a6.FYNgGpfIg0nk1JIn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab3LKXrv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Dec 2013 18:47:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com

Subject: + mm-migratec-fix-set-cpupid-on-page-migration-twice-against-thp.patch added to -mm tree
To: liwanp@linux.vnet.ibm.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 11 Dec 2013 15:47:50 -0800


The patch titled
     Subject: mm/migrate.c: fix set cpupid on page migration twice against thp
has been added to the -mm tree.  Its filename is
     mm-migratec-fix-set-cpupid-on-page-migration-twice-against-thp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migratec-fix-set-cpupid-on-page-migration-twice-against-thp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migratec-fix-set-cpupid-on-page-migration-twice-against-thp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1763,8 +1763,6 @@ int migrate_misplaced_transhuge_page(str
 	if (!new_page)
 		goto out_fail;
 
-	page_cpupid_xchg_last(new_page, page_cpupid_last(page));
