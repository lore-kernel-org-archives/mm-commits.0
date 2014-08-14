From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-hugetlb-add-migration-entry-check-in-hugetlb_change_protection.patch
 removed from -mm tree
Date: Thu, 14 Aug 2014 14:32:35 -0700
Message-ID: <53ed2af3.hInN/HEEFEYQf7zP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:61488 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbaHNVch (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Aug 2014 17:32:37 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so25266igd.2
        for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2014 14:32:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, cl@linux.com, hughd@google.com, mel@csn.ul.ie, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: add migration entry check in hugetlb_change_protection
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-migration-entry-check-in-hugetlb_change_protection.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/hugetlb: add migration entry check in hugetlb_change_protection

There is a race condition between hugepage migration and
change_protection(), where hugetlb_change_protection() doesn't care about
migration entries and wrongly overwrites them.  That causes unexpected
results like kernel crash.

This patch adds is_hugetlb_entry_(migration|hwpoisoned) check in this
function and skip all such entries.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: <stable@vger.kernel.org>	[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-add-migration-entry-check-in-hugetlb_change_protection mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-add-migration-entry-check-in-hugetlb_change_protection
+++ a/mm/hugetlb.c
@@ -3358,7 +3358,13 @@ unsigned long hugetlb_change_protection(
 			spin_unlock(ptl);
 			continue;
 		}
-		if (!huge_pte_none(huge_ptep_get(ptep))) {
+		pte = huge_ptep_get(ptep);
+		if (unlikely(is_hugetlb_entry_migration(pte) ||
+			     is_hugetlb_entry_hwpoisoned(pte))) {
+			spin_unlock(ptl);
+			continue;
+		}
+		if (!huge_pte_none(pte)) {
 			pte = huge_ptep_get_and_clear(mm, address, ptep);
 			pte = pte_mkhuge(huge_pte_modify(pte, newprot));
 			pte = arch_make_huge_pte(pte, vma, NULL, 0);
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
memory-hotplug-add-sysfs-zones_online_to-attribute.patch
mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

