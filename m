From: akpm@linux-foundation.org
Subject: +
 vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small.patch added to -mm tree
Date: Fri, 20 Nov 2015 13:43:58 -0800
Message-ID: <564f941e./CwiDb2nBFFgvPqB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932397AbbKTVn7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Nov 2015 16:43:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mgorman@techsingularity.net, mhocko@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: do not force-scan file lru if its absolute size is small
has been added to the -mm tree.  Its filename is
     vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small.patch

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
Subject: vmscan: do not force-scan file lru if its absolute size is small

We assume there is enough inactive page cache if the size of inactive
file lru is greater than the size of active file lru, in which case we
force-scan file lru ignoring anonymous pages. While this logic works
fine when there are plenty of page cache pages, it fails if the size of
file lru is small (several MB): in this case (lru_size >> prio) will be
0 for normal scan priorities, as a result, if inactive file lru happens
to be larger than active file lru, anonymous pages of a cgroup will
never get evicted unless the system experiences severe memory pressure,
even if there are gigabytes of unused anonymous memory there, which is
unfair in respect to other cgroups, whose workloads might be page cache
oriented.

This patch attempts to fix this by elaborating the "enough inactive page
cache" check: it makes it not only check that inactive lru size > active
lru size, but also that we will scan something from the cgroup at the
current scan priority. If these conditions do not hold, we proceed to
SCAN_FRACT as usual.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small mm/vmscan.c
--- a/mm/vmscan.c~vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small
+++ a/mm/vmscan.c
@@ -2046,7 +2046,8 @@ static void get_scan_count(struct lruvec
 	 * There is enough inactive page cache, do not reclaim
 	 * anything from the anonymous working set right now.
 	 */
-	if (!inactive_file_is_low(lruvec)) {
+	if (!inactive_file_is_low(lruvec) &&
+	    get_lru_size(lruvec, LRU_INACTIVE_FILE) >> sc->priority > 0) {
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

