From: akpm@linux-foundation.org
Subject: + hugetlb-release-pages-in-the-error-path-of-hugetlb_cow.patch added to -mm tree
Date: Mon, 14 Nov 2011 15:32:34 -0800
Message-ID: <201111142332.pAENWYvR019694@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:58549 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553Ab1KNXch (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2011 18:32:37 -0500
Received: by vcbfy13 with SMTP id fy13so547573vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2011 15:32:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhillf@gmail.com, aarcange@redhat.com, hughd@google.com, jweiner@redhat.com


The patch titled
     Subject: hugetlb: release pages in the error path of hugetlb_cow()
has been added to the -mm tree.  Its filename is
     hugetlb-release-pages-in-the-error-path-of-hugetlb_cow.patch

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
Subject: hugetlb: release pages in the error path of hugetlb_cow()

If we fail to prepare an anon_vma, the {new, old}_page should be released,
or they will leak.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/hugetlb.c~hugetlb-release-pages-in-the-error-path-of-hugetlb_cow mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-release-pages-in-the-error-path-of-hugetlb_cow
+++ a/mm/hugetlb.c
@@ -2422,6 +2422,8 @@ retry_avoidcopy:
 	 * anon_vma prepared.
 	 */
 	if (unlikely(anon_vma_prepare(vma))) {
+		page_cache_release(new_page);
+		page_cache_release(old_page);
 		/* Caller expects lock to be held */
 		spin_lock(&mm->page_table_lock);
 		return VM_FAULT_OOM;
_
Subject: Subject: hugetlb: release pages in the error path of hugetlb_cow()

Patches currently in -mm which might be from dhillf@gmail.com are

linux-next.patch
hugetlb-release-pages-in-the-error-path-of-hugetlb_cow.patch

