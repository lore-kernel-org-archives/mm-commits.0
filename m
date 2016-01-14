From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-zonelist-enumerate-zonelists-array-index-fix-fix.patch removed from -mm
 tree
Date: Thu, 14 Jan 2016 14:21:28 -0800
Message-ID: <56981f68.KTuZ9q6IDdMdPmU4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760AbcANWV3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:21:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, baiyaowei@cmss.chinamobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: fix warning in comparing enumerator
has been removed from the -mm tree.  Its filename was
     mm-zonelist-enumerate-zonelists-array-index-fix-fix.patch

This patch was dropped because it was folded into mm-zonelist-enumerate-zonelists-array-index.patch

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

mm-zonelist-enumerate-zonelists-array-index.patch
mm-zonelist-enumerate-zonelists-array-index-fix-fix-fix.patch
mm-page_isolation-use-micro-to-judge-the-alignment.patch
rmap-add-argument-to-charge-compound-page-fix.patch
mm-soft-offline-check-return-value-in-second-__get_any_page-call.patch
mm-hwpoison-adjust-for-new-thp-refcounting.patch

