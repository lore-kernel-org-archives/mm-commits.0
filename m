From: akpm@linux-foundation.org
Subject: + mm-hugetlb-introduce-pagehugeactive-flag-fix-fix.patch added to -mm tree
Date: Thu, 02 Apr 2015 14:05:14 -0700
Message-ID: <551daf0a.GK94q+cJMFq/AC4x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56903 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbbDBVFP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2015 17:05:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: set_page_huge_active() can be static
has been added to the -mm tree.  Its filename is
     mm-hugetlb-introduce-pagehugeactive-flag-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-introduce-pagehugeactive-flag-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-introduce-pagehugeactive-flag-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: kbuild test robot <fengguang.wu@intel.com>
Subject: set_page_huge_active() can be static

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-introduce-pagehugeactive-flag-fix-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-introduce-pagehugeactive-flag-fix-fix
+++ a/mm/hugetlb.c
@@ -937,13 +937,13 @@ bool page_huge_active(struct page *page)
 }
 
 /* never called for tail page */
-void set_page_huge_active(struct page *page)
+static void set_page_huge_active(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageHeadHuge(page), page);
 	SetPagePrivate(&page[1]);
 }
 
-void clear_page_huge_active(struct page *page)
+static void clear_page_huge_active(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageHeadHuge(page), page);
 	ClearPagePrivate(&page[1]);
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

x86-mm-support-huge-kva-mappings-on-x86-fix.patch
mm-hugetlb-introduce-pagehugeactive-flag-fix-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix.patch
asoc-pcm512x-use-div_round_closest_ull-from-kernelh.patch
rtc-ds1685-remove-owner-assignment-from-platform_driver.patch
gcov-fix-softlockups.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch

