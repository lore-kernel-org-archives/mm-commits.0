From: akpm@linux-foundation.org
Subject: + mm-soft-offline-split-thp-at-the-beginning-of-soft_offline_page.patch added to -mm tree
Date: Tue, 27 Nov 2012 13:55:23 -0800
Message-ID: <20121127215523.A7A4582004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:34699 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab2K0VzZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Nov 2012 16:55:25 -0500
Received: by mail-qa0-f74.google.com with SMTP id g40so693241qab.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Nov 2012 13:55:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, andi.kleen@intel.com, andi@firstfloor.org, fengguang.wu@intel.com, stable@vger.kernel.org, tony.luck@intel.com


The patch titled
     Subject: mm: soft offline: split thp at the beginning of soft_offline_page()
has been added to the -mm tree.  Its filename is
     mm-soft-offline-split-thp-at-the-beginning-of-soft_offline_page.patch

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
Subject: mm: soft offline: split thp at the beginning of soft_offline_page()

When we try to soft-offline a thp tail page, put_page() is called on the
tail page unthinkingly and VM_BUG_ON is triggered in put_compound_page(). 
This patch splits thp before going into the main body of soft-offlining.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/memory-failure.c~mm-soft-offline-split-thp-at-the-beginning-of-soft_offline_page mm/memory-failure.c
--- a/mm/memory-failure.c~mm-soft-offline-split-thp-at-the-beginning-of-soft_offline_page
+++ a/mm/memory-failure.c
@@ -1476,9 +1476,17 @@ int soft_offline_page(struct page *page,
 {
 	int ret;
 	unsigned long pfn = page_to_pfn(page);
+	struct page *hpage = compound_trans_head(page);
 
 	if (PageHuge(page))
 		return soft_offline_huge_page(page, flags);
+	if (PageTransHuge(hpage)) {
+		if (PageAnon(hpage) && unlikely(split_huge_page(hpage))) {
+			pr_info("soft offline: %#lx: failed to split THP\n",
+				pfn);
+			return -EBUSY;
+		}
+	}
 
 	ret = get_any_page(page, pfn, flags);
 	if (ret < 0)
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-soft-offline-split-thp-at-the-beginning-of-soft_offline_page.patch
hwpoison-fix-action_result-to-print-out-dirty-clean.patch
mm-print-out-information-of-file-affected-by-memory-error.patch

