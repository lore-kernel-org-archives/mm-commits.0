From: akpm@linux-foundation.org
Subject: [folded-merged]
 vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small-v2.patch
 removed from -mm tree
Date: Thu, 14 Jan 2016 14:23:54 -0800
Message-ID: <56981ffa.JYW6sQ5N/wyDFdri%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44370 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834AbcANWXz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:23:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mgorman@techsingularity.net, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small-v2
has been removed from the -mm tree.  Its filename was
     vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small-v2.patch

This patch was dropped because it was folded into vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small.patch

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small-v2

Changes in v2:
 - remove unnecessary > 0 (Johannes)
 - elaborate on the comment (Andrew)

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN mm/vmscan.c~vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small-v2 mm/vmscan.c
--- a/mm/vmscan.c~vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small-v2
+++ a/mm/vmscan.c
@@ -2043,11 +2043,16 @@ static void get_scan_count(struct lruvec
 	}
 
 	/*
-	 * There is enough inactive page cache, do not reclaim
-	 * anything from the anonymous working set right now.
+	 * If there is enough inactive page cache, i.e. if the size of the
+	 * inactive list is greater than that of the active list *and* the
+	 * inactive list actually has some pages to scan on this priority, we
+	 * do not reclaim anything from the anonymous working set right now.
+	 * Without the second condition we could end up never scanning an
+	 * lruvec even if it has plenty of old anonymous pages unless the
+	 * system is under heavy pressure.
 	 */
 	if (!inactive_file_is_low(lruvec) &&
-	    get_lru_size(lruvec, LRU_INACTIVE_FILE) >> sc->priority > 0) {
+	    get_lru_size(lruvec, LRU_INACTIVE_FILE) >> sc->priority) {
 		scan_balance = SCAN_FILE;
 		goto out;
 	}
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

revert-kernfs-do-not-account-ino_ida-allocations-to-memcg.patch
revert-gfp-add-__gfp_noaccount.patch
memcg-only-account-kmem-allocations-marked-as-__gfp_account.patch
slab-add-slab_account-flag.patch
vmalloc-allow-to-account-vmalloc-to-memcg.patch
account-certain-kmem-allocations-to-memcg.patch
vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small.patch
memcg-do-not-allow-to-disable-tcp-accounting-after-limit-is-set.patch
mm-add-page_check_address_transhuge-helper.patch
mm-add-page_check_address_transhuge-helper-fix.patch

