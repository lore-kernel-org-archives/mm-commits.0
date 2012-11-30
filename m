From: akpm@linux-foundation.org
Subject: [merged] mm-soft-offline-split-thp-at-the-beginning-of-soft_offline_page.patch removed from -mm tree
Date: Fri, 30 Nov 2012 13:29:15 -0800
Message-ID: <20121130212915.CD968100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:55005 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab2K3V3Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Nov 2012 16:29:16 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so1990593vbi.1
        for <mm-commits@vger.kernel.org>; Fri, 30 Nov 2012 13:29:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi.kleen@intel.com, andi@firstfloor.org, fengguang.wu@intel.com, stable@vger.kernel.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: soft offline: split thp at the beginning of soft_offline_page()
has been removed from the -mm tree.  Its filename was
     mm-soft-offline-split-thp-at-the-beginning-of-soft_offline_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
hwpoison-fix-action_result-to-print-out-dirty-clean.patch
mm-print-out-information-of-file-affected-by-memory-error.patch

