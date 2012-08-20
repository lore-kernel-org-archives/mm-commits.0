From: akpm@linux-foundation.org
Subject: + thp-use-khugepaged_enabled-to-remove-duplicate-code.patch added to -mm tree
Date: Mon, 20 Aug 2012 14:08:38 -0700
Message-ID: <20120820210839.439851E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-iy0-f202.google.com ([209.85.210.202]:51393 "EHLO
	mail-iy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab2HTVIl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 17:08:41 -0400
Received: by mail-iy0-f202.google.com with SMTP id o24so925435ial.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 14:08:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, hughd@google.com, rientjes@google.com


The patch titled
     Subject: thp: use khugepaged_enabled to remove duplicate code
has been added to the -mm tree.  Its filename is
     thp-use-khugepaged_enabled-to-remove-duplicate-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
thp-fix-the-count-of-thp_collapse_alloc.patch
thp-remove-unnecessary-check-in-start_khugepaged.patch
thp-move-khugepaged_mutex-out-of-khugepaged.patch
thp-remove-unnecessary-khugepaged_thread-check.patch
thp-remove-wake_up_interruptible-in-the-exit-path.patch
thp-remove-some-code-depend-on-config_numa.patch
thp-merge-page-pre-alloc-in-khugepaged_loop-into-khugepaged_do_scan.patch
thp-release-page-in-page-pre-alloc-path.patch
thp-introduce-khugepaged_prealloc_page-and-khugepaged_alloc_page.patch
thp-remove-khugepaged_loop.patch
thp-use-khugepaged_enabled-to-remove-duplicate-code.patch
thp-remove-unnecessary-set_recommended_min_free_kbytes.patch

