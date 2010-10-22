From: akpm@linux-foundation.org
Subject: + mm-hugetlbc-add-missing-spin_lock-to-hugetlb_cow.patch added to -mm tree
Date: Fri, 22 Oct 2010 12:32:36 -0700
Message-ID: <201010221932.o9MJWaBV002940@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753087Ab0JVTdm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Oct 2010 15:33:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dnelson@redhat.com, mel@csn.ul.ie, stable@kernel.org


The patch titled
     mm/hugetlb.c: add missing spin_lock() to hugetlb_cow()
has been added to the -mm tree.  Its filename is
     mm-hugetlbc-add-missing-spin_lock-to-hugetlb_cow.patch

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
Subject: mm/hugetlb.c: add missing spin_lock() to hugetlb_cow()
From: Dean Nelson <dnelson@redhat.com>

Add missing spin_lock() of the page_table_lock before an error return in
hugetlb_cow(). Callers of hugtelb_cow() expect it to be held upon return.

Signed-off-by: Dean Nelson <dnelson@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlbc-add-missing-spin_lock-to-hugetlb_cow mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbc-add-missing-spin_lock-to-hugetlb_cow
+++ a/mm/hugetlb.c
@@ -2448,8 +2448,11 @@ retry_avoidcopy:
 	 * When the original hugepage is shared one, it does not have
 	 * anon_vma prepared.
 	 */
-	if (unlikely(anon_vma_prepare(vma)))
+	if (unlikely(anon_vma_prepare(vma))) {
+		/* Caller expects lock to be held */
+		spin_lock(&mm->page_table_lock);
 		return VM_FAULT_OOM;
+	}
 
 	copy_user_huge_page(new_page, old_page, address, vma);
 	__SetPageUptodate(new_page);
_

Patches currently in -mm which might be from dnelson@redhat.com are

linux-next.patch
mm-hugetlbc-add-missing-spin_lock-to-hugetlb_cow.patch

