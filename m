From: akpm@linux-foundation.org
Subject: [folded-merged] mmotm-memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pagespatch-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:30:48 -0800
Message-ID: <20130222233048.C1B765A42CE@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:33906 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708Ab3BVXat (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:30:49 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so120070ggn.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:30:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghan@google.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mmotm: memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch fix
has been removed from the -mm tree.  Its filename was
     mmotm-memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pagespatch-fix.patch

This patch was dropped because it was folded into memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch

------------------------------------------------------
From: Ying Han <yinghan@google.com>
Subject: mmotm: memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch fix

We should break out of the hierarchy loop only if nr_reclaimed exceeded
nr_to_reclaim and not vice-versa. This patch fixes the condition.

Signed-off-by: Ying Han <yinghan@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mmotm-memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pagespatch-fix mm/vmscan.c
--- a/mm/vmscan.c~mmotm-memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pagespatch-fix
+++ a/mm/vmscan.c
@@ -1983,7 +1983,7 @@ static void shrink_zone(struct zone *zon
 			 * whole hierarchy is not sufficient.
 			 */
 			if (!global_reclaim(sc) &&
-					sc->nr_to_reclaim >= sc->nr_reclaimed) {
+					sc->nr_to_reclaim <= sc->nr_reclaimed) {
 				mem_cgroup_iter_break(root, memcg);
 				break;
 			}
_

Patches currently in -mm which might be from yinghan@google.com are

memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch
mmotm-memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pagespatch-fix-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch

