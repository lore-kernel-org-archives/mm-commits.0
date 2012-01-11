From: akpm@linux-foundation.org
Subject: [merged] vmscan-promote-shared-file-mapped-pages.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:26:09 -0800
Message-ID: <20120111212610.2E9105C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:61824 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab2AKV0N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:26:13 -0500
Received: by wgbdt14 with SMTP id dt14so42852wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:26:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, fengguang.wu@intel.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, npiggin@kernel.dk, penberg@kernel.org, riel@redhat.com, shaohua.li@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: promote shared file mapped pages
has been removed from the -mm tree.  Its filename was
     vmscan-promote-shared-file-mapped-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: vmscan: promote shared file mapped pages

Commit 645747462435 ("vmscan: detect mapped file pages used only once")
greatly decreases lifetime of single-used mapped file pages. 
Unfortunately it also decreases life time of all shared mapped file pages.
Because after commit bf3f3bc5e7347 ("mm: don't mark_page_accessed
in fault path") page-fault handler does not mark page active or even
referenced.

Thus page_check_references() activates file page only if it was used twice
while it stays in inactive list, meanwhile it activates anon pages after
first access.  Inactive list can be small enough, this way reclaimer can
accidentally throw away any widely used page if it wasn't used twice in
short period.

After this patch page_check_references() also activate file mapped page at
first inactive list scan if this page is already used multiple times via
several ptes.

I found this while trying to fix degragation in rhel6 (~2.6.32) from rhel5
(~2.6.18).  There a complete mess with >100 web/mail/spam/ftp containers,
they share all their files but there a lot of anonymous pages: ~500mb
shared file mapped memory and 15-20Gb non-shared anonymous memory.  In
this situation major-pagefaults are very costly, because all containers
share the same page.  In my load kernel created a disproportionate
pressure on the file memory, compared with the anonymous, they equaled
only if I raise swappiness up to 150 =)

These patches actually wasn't helped a lot in my problem, but I saw
noticable (10-20 times) reduce in count and average time of
major-pagefault in file-mapped areas.

Actually both patches are fixes for commit v2.6.33-5448-g6457474, because
it was aimed at one scenario (singly used pages), but it breaks the logic
in other scenarios (shared and/or executable pages)

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: Pekka Enberg <penberg@kernel.org>
Acked-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-promote-shared-file-mapped-pages mm/vmscan.c
--- a/mm/vmscan.c~vmscan-promote-shared-file-mapped-pages
+++ a/mm/vmscan.c
@@ -715,7 +715,7 @@ static enum page_references page_check_r
 		 */
 		SetPageReferenced(page);
 
-		if (referenced_page)
+		if (referenced_page || referenced_ptes > 1)
 			return PAGEREF_ACTIVATE;
 
 		return PAGEREF_KEEP;
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch
mm-take-pagevecs-off-reclaim-stack.patch

