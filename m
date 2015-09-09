From: akpm@linux-foundation.org
Subject: [merged]
 pagemap-hide-physical-addresses-from-non-privileged-users.patch removed
 from -mm tree
Date: Wed, 09 Sep 2015 12:43:55 -0700
Message-ID: <55f08bfb.jFnpgM4soPKBHXKX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837AbbIITnz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:43:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, mwilliamson@undo-software.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pagemap: hide physical addresses from non-privileged users
has been removed from the -mm tree.  Its filename was
     pagemap-hide-physical-addresses-from-non-privileged-users.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: pagemap: hide physical addresses from non-privileged users

This patch makes pagemap readable for normal users and hides physical
addresses from them.  For some use-cases PFN isn't required at all.

See http://lkml.kernel.org/r/1425935472-17949-1-git-send-email-kirill@shutemov.name

Fixes: ab676b7d6fbf ("pagemap: do not leak physical addresses to non-privileged userspace")
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Mark Williamson <mwilliamson@undo-software.com>
Tested-by:  Mark Williamson <mwilliamson@undo-software.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff -puN fs/proc/task_mmu.c~pagemap-hide-physical-addresses-from-non-privileged-users fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-hide-physical-addresses-from-non-privileged-users
+++ a/fs/proc/task_mmu.c
@@ -939,6 +939,7 @@ typedef struct {
 struct pagemapread {
 	int pos, len;		/* units: PM_ENTRY_BYTES, not bytes */
 	pagemap_entry_t *buffer;
+	bool show_pfn;
 };
 
 #define PAGEMAP_WALK_SIZE	(PMD_SIZE)
@@ -1015,7 +1016,8 @@ static pagemap_entry_t pte_to_pagemap_en
 	struct page *page = NULL;
 
 	if (pte_present(pte)) {
-		frame = pte_pfn(pte);
+		if (pm->show_pfn)
+			frame = pte_pfn(pte);
 		flags |= PM_PRESENT;
 		page = vm_normal_page(vma, addr, pte);
 		if (pte_soft_dirty(pte))
@@ -1065,8 +1067,9 @@ static int pagemap_pmd_range(pmd_t *pmdp
 		 */
 		if (pmd_present(pmd)) {
 			flags |= PM_PRESENT;
-			frame = pmd_pfn(pmd) +
-				((addr & ~PMD_MASK) >> PAGE_SHIFT);
+			if (pm->show_pfn)
+				frame = pmd_pfn(pmd) +
+					((addr & ~PMD_MASK) >> PAGE_SHIFT);
 		}
 
 		for (; addr != end; addr += PAGE_SIZE) {
@@ -1075,7 +1078,7 @@ static int pagemap_pmd_range(pmd_t *pmdp
 			err = add_to_pagemap(addr, &pme, pm);
 			if (err)
 				break;
-			if (flags & PM_PRESENT)
+			if (pm->show_pfn && (flags & PM_PRESENT))
 				frame++;
 		}
 		spin_unlock(ptl);
@@ -1129,8 +1132,9 @@ static int pagemap_hugetlb_range(pte_t *
 			flags |= PM_FILE;
 
 		flags |= PM_PRESENT;
-		frame = pte_pfn(pte) +
-			((addr & ~hmask) >> PAGE_SHIFT);
+		if (pm->show_pfn)
+			frame = pte_pfn(pte) +
+				((addr & ~hmask) >> PAGE_SHIFT);
 	}
 
 	for (; addr != end; addr += PAGE_SIZE) {
@@ -1139,7 +1143,7 @@ static int pagemap_hugetlb_range(pte_t *
 		err = add_to_pagemap(addr, &pme, pm);
 		if (err)
 			return err;
-		if (flags & PM_PRESENT)
+		if (pm->show_pfn && (flags & PM_PRESENT))
 			frame++;
 	}
 
@@ -1198,6 +1202,9 @@ static ssize_t pagemap_read(struct file
 	if (!count)
 		goto out_mm;
 
+	/* do not disclose physical addresses: attack vector */
+	pm.show_pfn = file_ns_capable(file, &init_user_ns, CAP_SYS_ADMIN);
+
 	pm.len = (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
 	pm.buffer = kmalloc(pm.len * PM_ENTRY_BYTES, GFP_TEMPORARY);
 	ret = -ENOMEM;
@@ -1267,10 +1274,6 @@ static int pagemap_open(struct inode *in
 {
 	struct mm_struct *mm;
 
-	/* do not disclose physical addresses: attack vector */
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
