From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5-fix.patch
 removed from -mm tree
Date: Thu, 14 Jan 2016 14:39:17 -0800
Message-ID: <56982395.aL4SQLDCmPWGpFuc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46098 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361AbcANWjS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:39:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5-fix
has been removed from the -mm tree.  Its filename was
     mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5-fix.patch

This patch was dropped because it was folded into mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps.patch

------------------------------------------------------
From: Michal Hocko <mhocko@kernel.org>
Subject: mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5-fix

Dohh, forgot to git add after s@PageCoumpound@PageTransCompound@

Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5-fix
+++ a/mm/memcontrol.c
@@ -4905,7 +4905,7 @@ retry:
 			 * ignore such a partial THP and keep it in original
 			 * memcg. There should be somebody mapping the head.
 			 */
-			if (PageCompound(page))
+			if (PageTransCompound(page))
 				goto put;
 			if (isolate_lru_page(page))
 				goto put;
_

Patches currently in -mm which might be from mhocko@kernel.org are

mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps.patch

