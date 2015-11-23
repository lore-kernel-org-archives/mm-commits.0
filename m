From: akpm@linux-foundation.org
Subject: +
 vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small-v2.patch
 added to -mm tree
Date: Mon, 23 Nov 2015 15:03:02 -0800
Message-ID: <56539b26.ECCmAZdChc7V7qK4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbbKWXDD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 18:03:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mgorman@techsingularity.net, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small-v2
has been added to the -mm tree.  Its filename is
     vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small-v2.patch

