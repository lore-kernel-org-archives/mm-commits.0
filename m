From: akpm@linux-foundation.org
Subject: [to-be-updated] ksm-add-get_pte-helper-function-fetching-pte-for-va.patch removed from -mm tree
Date: Tue, 16 Jun 2009 15:40:54 -0700
Message-ID: <200906162240.n5GMesUi002871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762250AbZFPWlk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 18:41:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ieidus@redhat.com, aarcange@redhat.com, avi@redhat.com, chrisw@redhat.com, hugh.dickins@tiscali.co.uk, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     ksm: add get_pte(): helper function: fetching pte for va
has been removed from the -mm tree.  Its filename was
     ksm-add-get_pte-helper-function-fetching-pte-for-va.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: add get_pte(): helper function: fetching pte for va
From: Izik Eidus <ieidus@redhat.com>

get_pte() receives the mm_struct of a task and a virtual address and
returns the pte corresponding to it.

This function return NULL in case it couldnt fetch the pte.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN include/linux/mm.h~ksm-add-get_pte-helper-function-fetching-pte-for-va include/linux/mm.h
--- a/include/linux/mm.h~ksm-add-get_pte-helper-function-fetching-pte-for-va
+++ a/include/linux/mm.h
@@ -883,6 +883,30 @@ int vma_wants_writenotify(struct vm_area
 
 extern pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr, spinlock_t **ptl);
 
+static inline pte_t *get_pte(struct mm_struct *mm, unsigned long addr)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *ptep = NULL;
+
+	pgd = pgd_offset(mm, addr);
+	if (!pgd_present(*pgd))
+		goto out;
+
+	pud = pud_offset(pgd, addr);
+	if (!pud_present(*pud))
+		goto out;
+
+	pmd = pmd_offset(pud, addr);
+	if (!pmd_present(*pmd))
+		goto out;
+
+	ptep = pte_offset_map(pmd, addr);
+out:
+	return ptep;
+}
+
 #ifdef __PAGETABLE_PUD_FOLDED
 static inline int __pud_alloc(struct mm_struct *mm, pgd_t *pgd,
 						unsigned long address)
_

Patches currently in -mm which might be from ieidus@redhat.com are

linux-next.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-page_wrprotect-write-protecting-page.patch
ksm-add-replace_page-change-the-page-pte-is-pointing-to.patch
ksm-add-ksm-kernel-shared-memory-driver.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
ksm-add-ksm-kernel-shared-memory-driver-fix-unsafe-pte-fetching.patch
ksm-add-ksm-kernel-shared-memory-driver-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-limiting-the-num-of-mem-regions-user-can-register-per-fd.patch
ksm-add-ksm-kernel-shared-memory-driver-dont-allow-overlap-memory-addresses-registrations.patch
ksm-add-ksm-kernel-shared-memory-driver-change-the-ksm_remove_memory_region-ioctl.patch
ksm-add-ksm-kernel-shared-memory-driver-change-the-prot-handling-to-use-the-generic-helper-functions.patch
ksm-add-ksm-kernel-shared-memory-driver-use-another-miscdevice-minor-number.patch
ksm-add-ksm-kernel-shared-memory-driver-ksm-fix-rmap_item-use-after-free.patch
ksm-add-replace_page-change-the-page-pte-is-pointing-to-fix-losing-visibility-of-part-of-rmap_item-next-list.patch

