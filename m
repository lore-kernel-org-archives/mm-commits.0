From: akpm@linux-foundation.org
Subject: [merged] thp-khugepaged_prealloc_page-forgot-to-reset-the-page-alloc-indicator.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:13:02 -0700
Message-ID: <20121009181302.B79111E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:59664 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748Ab2JISND (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:13:03 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so661396ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:13:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, hughd@google.com, rientjes@google.com, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: khugepaged_prealloc_page() forgot to reset the page alloc indicator
has been removed from the -mm tree.  Its filename was
     thp-khugepaged_prealloc_page-forgot-to-reset-the-page-alloc-indicator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: thp: khugepaged_prealloc_page() forgot to reset the page alloc indicator

If NUMA is enabled, the indicator is not reset if the previous page
request failed, ausing us to trigger the BUG_ON() in
khugepaged_alloc_page().

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/huge_memory.c~thp-khugepaged_prealloc_page-forgot-to-reset-the-page-alloc-indicator mm/huge_memory.c
--- a/mm/huge_memory.c~thp-khugepaged_prealloc_page-forgot-to-reset-the-page-alloc-indicator
+++ a/mm/huge_memory.c
@@ -1797,6 +1797,7 @@ static bool khugepaged_prealloc_page(str
 			return false;
 
 		*wait = false;
+		*hpage = NULL;
 		khugepaged_alloc_sleep();
 	} else if (*hpage) {
 		put_page(*hpage);
_

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

origin.patch
linux-next.patch

