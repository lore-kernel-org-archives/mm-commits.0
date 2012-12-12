From: akpm@linux-foundation.org
Subject: [folded-merged] hwpoison-hugetlbfs-fix-rss-counter-warning-fix.patch removed from -mm tree
Date: Wed, 12 Dec 2012 13:41:11 -0800
Message-ID: <20121212214111.98D2782004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:43280 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab2LLVlN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 16:41:13 -0500
Received: by mail-yh0-f73.google.com with SMTP id 47so129769yhr.2
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 13:41:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andi.kleen@intel.com, aneesh.kumar@linux.vnet.ibm.com, fengguang.wu@intel.com, n-horiguchi@ah.jp.nec.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hwpoison-hugetlbfs-fix-rss-counter-warning-fix
has been removed from the -mm tree.  Its filename was
     hwpoison-hugetlbfs-fix-rss-counter-warning-fix.patch

This patch was dropped because it was folded into hwpoison-hugetlbfs-fix-rss-counter-warning.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hwpoison-hugetlbfs-fix-rss-counter-warning-fix

clean up code layout

Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/rmap.c~hwpoison-hugetlbfs-fix-rss-counter-warning-fix mm/rmap.c
--- a/mm/rmap.c~hwpoison-hugetlbfs-fix-rss-counter-warning-fix
+++ a/mm/rmap.c
@@ -1249,14 +1249,14 @@ int try_to_unmap_one(struct page *page, 
 	update_hiwater_rss(mm);
 
 	if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
-		if (PageHuge(page))
-			;
-		else if (PageAnon(page))
-			dec_mm_counter(mm, MM_ANONPAGES);
-		else
-			dec_mm_counter(mm, MM_FILEPAGES);
-		set_pte_at(mm, address, pte,
-				swp_entry_to_pte(make_hwpoison_entry(page)));
+		if (!PageHuge(page)) {
+			if (PageAnon(page))
+				dec_mm_counter(mm, MM_ANONPAGES);
+			else
+				dec_mm_counter(mm, MM_FILEPAGES);
+			set_pte_at(mm, address, pte,
+				   swp_entry_to_pte(make_hwpoison_entry(page)));
+		}
 	} else if (PageAnon(page)) {
 		swp_entry_t entry = { .val = page_private(page) };
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
mm-add-a-reminder-comment-for-__gfp_bits_shift.patch
numa-add-config_movable_node-for-movable-dedicated-node.patch
mm-introduce-new-field-managed_pages-to-struct-zone.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch
tmpfs-support-seek_data-and-seek_hole-reprise.patch
hwpoison-hugetlbfs-fix-rss-counter-warning.patch
hwpoison-hugetlbfs-fix-rss-counter-warning-fix-fix.patch
mm-memoryc-remove-unused-code-from-do_wp_page-fix.patch

