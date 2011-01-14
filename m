From: akpm@linux-foundation.org
Subject: [merged] thp-add-native_set_pmd_at.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:46:36 -0800
Message-ID: <201101142249.p0EMnQr6005293@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753795Ab1ANWtj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:49:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: add native_set_pmd_at
has been removed from the -mm tree.  Its filename was
     thp-add-native_set_pmd_at.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: add native_set_pmd_at
From: Andrea Arcangeli <aarcange@redhat.com>

Used by paravirt and not paravirt set_pmd_at.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN arch/x86/include/asm/pgtable.h~thp-add-native_set_pmd_at arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~thp-add-native_set_pmd_at
+++ a/arch/x86/include/asm/pgtable.h
@@ -530,6 +530,12 @@ static inline void native_set_pte_at(str
 	native_set_pte(ptep, pte);
 }
 
+static inline void native_set_pmd_at(struct mm_struct *mm, unsigned long addr,
+				     pmd_t *pmdp , pmd_t pmd)
+{
+	native_set_pmd(pmdp, pmd);
+}
+
 #ifndef CONFIG_PARAVIRT
 /*
  * Rules for using pte_update - it must be called after any PTE update which
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

