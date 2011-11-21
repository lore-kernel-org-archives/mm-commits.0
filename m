From: akpm@linux-foundation.org
Subject: [to-be-updated] hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch removed from -mm tree
Date: Mon, 21 Nov 2011 14:05:13 -0800
Message-ID: <201111212205.pALM5Ddg018319@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:49475 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757342Ab1KUWFY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2011 17:05:24 -0500
Received: by wwe5 with SMTP id 5so178586wwe.1
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2011 14:05:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhillf@gmail.com, aarcange@redhat.com, jweiner@redhat.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: detect race upon page allocation failure during COW
has been removed from the -mm tree.  Its filename was
     hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: hugetlb: detect race upon page allocation failure during COW

In the error path where we failed to allocate a new huge page, we should
check whether a racing thread has added this page for us while this thread
waited for the page_table_lock.

We are serialized by hugetlb_instantiation_mutex on the pagefault patch
but this race can occur when another thread is performing page migration.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-detect-race-upon-page-allocation-failure-during-cow mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-detect-race-upon-page-allocation-failure-during-cow
+++ a/mm/hugetlb.c
@@ -2407,7 +2407,14 @@ retry_avoidcopy:
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

