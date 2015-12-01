From: akpm@linux-foundation.org
Subject: + mm-zonelist-enumerate-zonelists-array-index-fix-fix.patch added to -mm tree
Date: Tue, 01 Dec 2015 13:39:34 -0800
Message-ID: <565e1396.lEjGQM+GMg2UXrzX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757052AbbLAVjf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2015 16:39:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, baiyaowei@cmss.chinamobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: fix warning in comparing enumerator
has been added to the -mm tree.  Its filename is
     mm-zonelist-enumerate-zonelists-array-index-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zonelist-enumerate-zonelists-array-index-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zonelist-enumerate-zonelists-array-index-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/page_alloc.c: fix warning in comparing enumerator

I saw the following warning when building mmotm-2015-11-25-17-08.

mm/page_alloc.c:4185:16: warning: comparison between 'enum zone_type' and 'enum <anonymous>' [-Wenum-compare]
  for (i = 0; i < MAX_ZONELISTS; i++) {
                ^

enum zone_type is named like ZONE_* which is different from ZONELIST_*, so
we are somehow doing incorrect comparison.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-zonelist-enumerate-zonelists-array-index-fix-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-zonelist-enumerate-zonelists-array-index-fix-fix
+++ a/mm/page_alloc.c
@@ -4148,8 +4148,7 @@ static void set_zonelist_order(void)
 
 static void build_zonelists(pg_data_t *pgdat)
 {
-	int j, node, load;
-	enum zone_type i;
+	int i, j, node, load;
 	nodemask_t used_mask;
 	int local_node, prev_node;
 	struct zonelist *zonelist;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-hugetlb-fix-hugepage-memory-leak-caused-by-wrong-reserve-count.patch
mm-hugetlb-call-huge_pte_alloc-only-if-ptep-is-null.patch
mm-zonelist-enumerate-zonelists-array-index-fix-fix.patch
rmap-add-argument-to-charge-compound-page-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting.patch

