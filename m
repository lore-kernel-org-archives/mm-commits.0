From: akpm@linux-foundation.org
Subject: +
 mm-hwpoison-disable-memory-error-handling-on-1gb-hugepage-v2.patch added to -mm tree
Date: Tue, 30 Jan 2018 12:53:38 -0800
Message-ID: <5a70db52.zORb7or9xd0Q4ES2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39346 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753325AbeA3Uxj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jan 2018 15:53:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, khandual@linux.vnet.ibm.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hwpoison-disable-memory-error-handling-on-1gb-hugepage-v2
has been added to the -mm tree.  Its filename is
     mm-hwpoison-disable-memory-error-handling-on-1gb-hugepage-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-disable-memory-error-handling-on-1gb-hugepage-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-disable-memory-error-handling-on-1gb-hugepage-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm-hwpoison-disable-memory-error-handling-on-1gb-hugepage-v2

- add comment about what we need to support hwpoision for pud-sized hugetlb
- use "page size > PMD_SIZE" condition instead of hstate_is_gigantic()

Link: http://lkml.kernel.org/r/1517284444-18149-1-git-send-email-n-horiguchi@ah.jp.nec.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    2 +-
 mm/memory-failure.c |   15 ++++++++++++---
 2 files changed, 13 insertions(+), 4 deletions(-)

diff -puN include/linux/mm.h~mm-hwpoison-disable-memory-error-handling-on-1gb-hugepage-v2 include/linux/mm.h
--- a/include/linux/mm.h~mm-hwpoison-disable-memory-error-handling-on-1gb-hugepage-v2
+++ a/include/linux/mm.h
@@ -2607,7 +2607,7 @@ enum mf_action_page_type {
 	MF_MSG_POISONED_HUGE,
 	MF_MSG_HUGE,
 	MF_MSG_FREE_HUGE,
-	MF_MSG_GIGANTIC,
+	MF_MSG_NON_PMD_HUGE,
 	MF_MSG_UNMAP_FAILED,
 	MF_MSG_DIRTY_SWAPCACHE,
 	MF_MSG_CLEAN_SWAPCACHE,
diff -puN mm/memory-failure.c~mm-hwpoison-disable-memory-error-handling-on-1gb-hugepage-v2 mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-disable-memory-error-handling-on-1gb-hugepage-v2
+++ a/mm/memory-failure.c
@@ -508,7 +508,7 @@ static const char * const action_page_ty
 	[MF_MSG_POISONED_HUGE]		= "huge page already hardware poisoned",
 	[MF_MSG_HUGE]			= "huge page",
 	[MF_MSG_FREE_HUGE]		= "free huge page",
-	[MF_MSG_GIGANTIC]		= "gigantic page",
+	[MF_MSG_NON_PMD_HUGE]		= "non-pmd-sized huge page",
 	[MF_MSG_UNMAP_FAILED]		= "unmapping failed page",
 	[MF_MSG_DIRTY_SWAPCACHE]	= "dirty swapcache page",
 	[MF_MSG_CLEAN_SWAPCACHE]	= "clean swapcache page",
@@ -1091,8 +1091,17 @@ static int memory_failure_hugetlb(unsign
 		return 0;
 	}
 
-	if (hstate_is_gigantic(page_hstate(head))) {
-		action_result(pfn, MF_MSG_GIGANTIC, MF_IGNORED);
+	/*
+	 * TODO: hwpoison for pud-sized hugetlb doesn't work right now, so
+	 * simply disable it. In order to make it work properly, we need
+	 * make sure that:
+	 *  - conversion of a pud that maps an error hugetlb into hwpoison
+	 *    entry properly works, and
+	 *  - other mm code walking over page table is aware of pud-aligned
+	 *    hwpoison entries.
+	 */
+	if (huge_page_size(page_hstate(head)) > PMD_SIZE) {
+		action_result(pfn, MF_MSG_NON_PMD_HUGE, MF_IGNORED);
 		res = -EBUSY;
 		goto out;
 	}
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-hwpoison-disable-memory-error-handling-on-1gb-hugepage.patch
mm-hwpoison-disable-memory-error-handling-on-1gb-hugepage-v2.patch

