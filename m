From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes-fix.patch
 removed from -mm tree
Date: Fri, 24 Feb 2017 14:40:02 -0800
Message-ID: <58b0b642.zXSoxb81A4rrGXbl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34120 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbdBXWkX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:40:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, mgorman@techsingularity.net, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes-fix
has been removed from the -mm tree.  Its filename was
     mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes-fix.patch

This patch was dropped because it was folded into mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes-fix

remove unwanted ppc change, per Aneesh

Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/pgtable.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN arch/powerpc/mm/pgtable.c~mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes-fix arch/powerpc/mm/pgtable.c
--- a/arch/powerpc/mm/pgtable.c~mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes-fix
+++ a/arch/powerpc/mm/pgtable.c
@@ -186,7 +186,12 @@ static pte_t set_access_flags_filter(pte
 void set_pte_at(struct mm_struct *mm, unsigned long addr, pte_t *ptep,
 		pte_t pte)
 {
-	VM_WARN_ON(pte_present(*ptep));
+	/*
+	 * When handling numa faults, we already have the pte marked
+	 * _PAGE_PRESENT, but we can be sure that it is not in hpte.
+	 * Hence we can use set_pte_at for them.
+	 */
+	VM_WARN_ON(pte_present(*ptep) && !pte_protnone(*ptep));
 
 	/*
 	 * Add the pte bit when tryint set a pte
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_hotplugc-unexport-__remove_pages.patch
z3fold-add-kref-refcounting-checkpatch-fixes.patch
mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
lib-update-lz4-compressor-module.patch
lib-update-lz4-compressor-module-fix-fix.patch
lib-update-lz4-compressor-module-fix-fix-fix.patch

