From: akpm@linux-foundation.org
Subject: [merged] thp-use-khugepaged_enabled-to-remove-duplicate-code.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:08:07 -0700
Message-ID: <20121009180807.B0EF51E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:53045 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab2JISII (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:08:08 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so661858vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:08:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, hughd@google.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: use khugepaged_enabled to remove duplicate code
has been removed from the -mm tree.  Its filename was
     thp-use-khugepaged_enabled-to-remove-duplicate-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: thp: use khugepaged_enabled to remove duplicate code

Use khugepaged_enabled to see whether thp is enabled

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff -puN mm/huge_memory.c~thp-use-khugepaged_enabled-to-remove-duplicate-code mm/huge_memory.c
--- a/mm/huge_memory.c~thp-use-khugepaged_enabled-to-remove-duplicate-code
+++ a/mm/huge_memory.c
@@ -102,10 +102,7 @@ static int set_recommended_min_free_kbyt
 	unsigned long recommended_min;
 	extern int min_free_kbytes;
 
-	if (!test_bit(TRANSPARENT_HUGEPAGE_FLAG,
-		      &transparent_hugepage_flags) &&
-	    !test_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
-		      &transparent_hugepage_flags))
+	if (!khugepaged_enabled())
 		return 0;
 
 	for_each_populated_zone(zone)
@@ -228,11 +225,7 @@ static ssize_t enabled_store(struct kobj
 			ret = err;
 	}
 
-	if (ret > 0 &&
-	    (test_bit(TRANSPARENT_HUGEPAGE_FLAG,
-		      &transparent_hugepage_flags) ||
-	     test_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
-		      &transparent_hugepage_flags)))
+	if (ret > 0 && khugepaged_enabled())
 		set_recommended_min_free_kbytes();
 
 	return ret;
_

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

origin.patch
linux-next.patch

