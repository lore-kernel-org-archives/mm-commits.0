From: akpm@linux-foundation.org
Subject: [merged] hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:26:44 -0800
Message-ID: <20120111212644.AFECE10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:40505 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758145Ab2AKV0p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:26:45 -0500
Received: by mail-yx0-f202.google.com with SMTP id m1so7293yen.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:26:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhillf@gmail.com, aarcange@redhat.com, jweiner@redhat.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: detect race upon page allocation failure during COW
has been removed from the -mm tree.  Its filename was
     hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: hugetlb: detect race upon page allocation failure during COW

Currently we are not rechecking pte_same in hugetlb_cow after we take ptl
lock again in the page allocation failure code path and simply retry
again.  This is not an issue at the moment because hugetlb fault path is
protected by hugetlb_instantiation_mutex so we cannot race.

The original page is locked and so we cannot race even with the page
migration.

Let's add the pte_same check anyway as we want to be consistent with the
other check later in this function and be safe if we ever remove the
mutex.

[mhocko@suse.cz: reworded the changelog]
Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-detect-race-upon-page-allocation-failure-during-cow mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-detect-race-upon-page-allocation-failure-during-cow
+++ a/mm/hugetlb.c
@@ -2408,7 +2408,14 @@ retry_avoidcopy:
 				BUG_ON(page_count(old_page) != 1);
 				BUG_ON(huge_pte_none(pte));
 				spin_lock(&mm->page_table_lock);
-				goto retry_avoidcopy;
+				ptep = huge_pte_offset(mm, address & huge_page_mask(h));
+				if (likely(pte_same(huge_ptep_get(ptep), pte)))
+					goto retry_avoidcopy;
+				/*
+				 * race occurs while re-acquiring page_table_lock, and
+				 * our job is done.
+				 */
+				return 0;
 			}
 			WARN_ON_ONCE(1);
 		}
_

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
linux-next.patch
mm-hugetlb-undo-change-to-page-mapcount-in-fault-handler.patch

