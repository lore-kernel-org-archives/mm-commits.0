From: akpm@linux-foundation.org
Subject: [merged] thp-no-paravirt-version-of-pmd-ops.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:46:38 -0800
Message-ID: <201101142249.p0EMnSZl005297@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46501 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753795Ab1ANWtl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:49:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: no paravirt version of pmd ops
has been removed from the -mm tree.  Its filename was
     thp-no-paravirt-version-of-pmd-ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: no paravirt version of pmd ops
From: Andrea Arcangeli <aarcange@redhat.com>

No paravirt version of set_pmd_at/pmd_update/pmd_update_defer.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/x86/include/asm/pgtable.h~thp-no-paravirt-version-of-pmd-ops arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~thp-no-paravirt-version-of-pmd-ops
+++ a/arch/x86/include/asm/pgtable.h
@@ -35,6 +35,7 @@ extern struct mm_struct *pgd_page_get_mm
 #else  /* !CONFIG_PARAVIRT */
 #define set_pte(ptep, pte)		native_set_pte(ptep, pte)
 #define set_pte_at(mm, addr, ptep, pte)	native_set_pte_at(mm, addr, ptep, pte)
+#define set_pmd_at(mm, addr, pmdp, pmd)	native_set_pmd_at(mm, addr, pmdp, pmd)
 
 #define set_pte_atomic(ptep, pte)					\
 	native_set_pte_atomic(ptep, pte)
@@ -59,6 +60,8 @@ extern struct mm_struct *pgd_page_get_mm
 
 #define pte_update(mm, addr, ptep)              do { } while (0)
 #define pte_update_defer(mm, addr, ptep)        do { } while (0)
+#define pmd_update(mm, addr, ptep)              do { } while (0)
+#define pmd_update_defer(mm, addr, ptep)        do { } while (0)
 
 #define pgd_val(x)	native_pgd_val(x)
 #define __pgd(x)	native_make_pgd(x)
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

