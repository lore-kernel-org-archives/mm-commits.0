From: akpm@linux-foundation.org
Subject: + hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch added to -mm tree
Date: Fri, 18 Nov 2011 11:40:06 -0800
Message-ID: <201111181940.pAIJe63h019235@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:42900 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756691Ab1KRTkK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2011 14:40:10 -0500
Received: by faap16 with SMTP id p16so107083faa.1
        for <mm-commits@vger.kernel.org>; Fri, 18 Nov 2011 11:40:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhillf@gmail.com, aarcange@redhat.com, jweiner@redhat.com, mhocko@suse.cz


The patch titled
     Subject: hugetlb: detect race upon page allocation failure during COW
has been added to the -mm tree.  Its filename is
     hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Subject: Subject: hugetlb: detect race upon page allocation failure during COW

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
linux-next.patch
hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch

