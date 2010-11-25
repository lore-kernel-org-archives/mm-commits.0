From: akpm@linux-foundation.org
Subject: + mm-hugetlbc-avoid-double-unlock_page-in-hugetlb_fault.patch added to -mm tree
Date: Wed, 24 Nov 2010 16:33:59 -0800
Message-ID: <201011250038.oAP0cJ20017553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751510Ab0KYAif (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Nov 2010 19:38:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dnelson@redhat.com, stable@kernel.org


The patch titled
     mm/hugetlb.c: avoid double unlock_page() in hugetlb_fault()
has been added to the -mm tree.  Its filename is
     mm-hugetlbc-avoid-double-unlock_page-in-hugetlb_fault.patch

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
Subject: mm/hugetlb.c: avoid double unlock_page() in hugetlb_fault()
From: Dean Nelson <dnelson@redhat.com>

Have hugetlb_fault() call unlock_page(page) only if it had previously
called lock_page(page).

Setting CONFIG_DEBUG_VM=y and then running the libhugetlbfs test suite,
resulted in the tripping of VM_BUG_ON(!PageLocked(page)) in unlock_page()
having been called by hugetlb_fault() when page == pagecache_page.  This
patch remedied the problem.

Signed-off-by: Dean Nelson <dnelson@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlbc-avoid-double-unlock_page-in-hugetlb_fault mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbc-avoid-double-unlock_page-in-hugetlb_fault
+++ a/mm/hugetlb.c
@@ -2738,7 +2738,8 @@ out_page_table_lock:
 		unlock_page(pagecache_page);
 		put_page(pagecache_page);
 	}
-	unlock_page(page);
+	if (page != pagecache_page)
+		unlock_page(page);
 
 out_mutex:
 	mutex_unlock(&hugetlb_instantiation_mutex);
_

Patches currently in -mm which might be from dnelson@redhat.com are

mm-hugetlbc-avoid-double-unlock_page-in-hugetlb_fault.patch

