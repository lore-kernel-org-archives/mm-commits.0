From: akpm@linux-foundation.org
Subject: +
 vmscan-reclaim_clean_pages_from_list-must-use-mod_zone_page_state.patch
 added to -mm tree
Date: Tue, 15 Apr 2014 11:18:44 -0700
Message-ID: <534d7804.jrhUbGWFtqwGkpGP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbaDOSSp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Apr 2014 14:18:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, santosh.shilimkar@ti.com, mingo@kernel.org, mel@csn.ul.ie, grygorii.strashko@ti.com, cl@linux.com

Subject: + vmscan-reclaim_clean_pages_from_list-must-use-mod_zone_page_state.patch added to -mm tree
To: cl@linux.com,grygorii.strashko@ti.com,mel@csn.ul.ie,mingo@kernel.org,santosh.shilimkar@ti.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 15 Apr 2014 11:18:44 -0700


The patch titled
     Subject: vmscan: reclaim_clean_pages_from_list() must use mod_zone_page_state()
has been added to the -mm tree.  Its filename is
     vmscan-reclaim_clean_pages_from_list-must-use-mod_zone_page_state.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmscan-reclaim_clean_pages_from_list-must-use-mod_zone_page_state.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmscan-reclaim_clean_pages_from_list-must-use-mod_zone_page_state.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: vmscan: reclaim_clean_pages_from_list() must use mod_zone_page_state()

Seems to be called with preemption enabled.  Therefore it must use
mod_zone_page_state instead.

Signed-off-by: Christoph Lameter <cl@linux.com>
Reported-by: Grygorii Strashko <grygorii.strashko@ti.com>
Tested-by: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-reclaim_clean_pages_from_list-must-use-mod_zone_page_state mm/vmscan.c
--- a/mm/vmscan.c~vmscan-reclaim_clean_pages_from_list-must-use-mod_zone_page_state
+++ a/mm/vmscan.c
@@ -1158,7 +1158,7 @@ unsigned long reclaim_clean_pages_from_l
 			TTU_UNMAP|TTU_IGNORE_ACCESS,
 			&dummy1, &dummy2, &dummy3, &dummy4, &dummy5, true);
 	list_splice(&clean_pages, page_list);
-	__mod_zone_page_state(zone, NR_ISOLATED_FILE, -ret);
+	mod_zone_page_state(zone, NR_ISOLATED_FILE, -ret);
 	return ret;
 }
 
_

Patches currently in -mm which might be from cl@linux.com are

vmscan-reclaim_clean_pages_from_list-must-use-mod_zone_page_state.patch
linux-next.patch

