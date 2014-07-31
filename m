From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-fix-an-outdated-comment-still-mentioning-get_scan_ratio.patch
 added to -mm tree
Date: Thu, 31 Jul 2014 15:25:08 -0700
Message-ID: <53dac244.e6YcZNB0kjSYydRK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:61541 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaGaWZJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Jul 2014 18:25:09 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so625598pab.0
        for <mm-commits@vger.kernel.org>; Thu, 31 Jul 2014 15:25:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmarchan@redhat.com, hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: fix an outdated comment still mentioning get_scan_ratio
has been added to the -mm tree.  Its filename is
     mm-vmscan-fix-an-outdated-comment-still-mentioning-get_scan_ratio.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-fix-an-outdated-comment-still-mentioning-get_scan_ratio.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-fix-an-outdated-comment-still-mentioning-get_scan_ratio.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Jerome Marchand" <jmarchan@redhat.com>
Subject: mm, vmscan: fix an outdated comment still mentioning get_scan_ratio

Quite a while ago, get_scan_ratio() has been renamed get_scan_count(),
however a comment in shrink_active_list() still mention it.  This patch
fixes the outdated comment.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-fix-an-outdated-comment-still-mentioning-get_scan_ratio mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-fix-an-outdated-comment-still-mentioning-get_scan_ratio
+++ a/mm/vmscan.c
@@ -1759,7 +1759,7 @@ static void shrink_active_list(unsigned
 	 * Count referenced pages from currently used mappings as rotated,
 	 * even though only some of them are actually re-activated.  This
 	 * helps balance scan pressure between file and anonymous pages in
-	 * get_scan_ratio.
+	 * get_scan_count.
 	 */
 	reclaim_stat->recent_rotated[file] += nr_rotated;
 
_

Patches currently in -mm which might be from jmarchan@redhat.com are

mm-make-copy_pte_range-static-again.patch
mm-vmscan-fix-an-outdated-comment-still-mentioning-get_scan_ratio.patch
memcg-vmscan-fix-forced-scan-of-anonymous-pages.patch
zram-use-size_t-instead-of-u16.patch
zram-remove-global-tb_lock-with-fine-grain-lock.patch

