From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-remove-remaining-references-to-numa-hinting-bits-and-helpers-fix.patch
 removed from -mm tree
Date: Thu, 12 Feb 2015 14:13:09 -0800
Message-ID: <54dd2575.OHXkXN2K6MhaQhkE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbbBLWNL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 17:13:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, broonie@kernel.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove remaining references to NUMA hinting bits and helpers -fix
has been removed from the -mm tree.  Its filename was
     mm-remove-remaining-references-to-numa-hinting-bits-and-helpers-fix.patch

This patch was dropped because it was folded into mm-remove-remaining-references-to-numa-hinting-bits-and-helpers.patch

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: remove remaining references to NUMA hinting bits and helpers -fix

The patch "mm: remove remaining references to NUMA hinting bits and
helpers" was meant to remove NUMA hinting bits and helpers but broke
is_swap_pte.  >From the original bug report

	For at least the past couple of days tests of libhugetlbfs have
	been hanging on mustang in the mlock test running ARMv8 defconfig
	with both 32 bit and 64 bit userspace - after the mprotect test
	(the one before it) we get no console output for several hours so
	it appears that the test has deadlocked.  The tail of the log is:

	| find_path (2M: 64):   PASS
	| unlinked_fd (2M: 64): PASS
	| readback (2M: 64):    PASS
	| truncate (2M: 64):    PASS
	| shared (2M: 64):      PASS
	| mprotect (2M: 64):    PASS

This patch should address the problem and is a fix to the mmotm patch
mm-remove-remaining-references-to-numa-hinting-bits-and-helpers.patch

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Mark Brown <broonie@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/swapops.h~mm-remove-remaining-references-to-numa-hinting-bits-and-helpers-fix include/linux/swapops.h
--- a/include/linux/swapops.h~mm-remove-remaining-references-to-numa-hinting-bits-and-helpers-fix
+++ a/include/linux/swapops.h
@@ -54,7 +54,7 @@ static inline pgoff_t swp_offset(swp_ent
 /* check whether a pte points to a swap entry */
 static inline int is_swap_pte(pte_t pte)
 {
-	return !pte_none(pte);
+	return !pte_none(pte) && !pte_present(pte);
 }
 #endif
 
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-numa-do-not-dereference-pmd-outside-of-the-lock-during-numa-hinting-fault.patch
mm-add-p-protnone-helpers-for-use-by-numa-balancing.patch
mm-convert-p_numa-users-to-p_protnone_numa.patch
ppc64-add-paranoid-warnings-for-unexpected-dsisr_protfault.patch
mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch
mm-remove-remaining-references-to-numa-hinting-bits-and-helpers.patch
mm-numa-do-not-trap-faults-on-the-huge-zero-page.patch
x86-mm-restore-original-pte_special-check.patch
mm-numa-add-paranoid-check-around-pte_protnone_numa.patch
mm-numa-avoid-unnecessary-tlb-flushes-when-setting-numa-hinting-entries.patch
mm-compaction-fix-wrong-order-check-in-compact_finished.patch
mm-compaction-stop-the-isolation-when-we-isolate-enough-freepage.patch
mm-internalh-dont-split-printk-call-in-two.patch
mm-page_allocc-pull-out-init-code-from-build_all_zonelists.patch
mm-mm_initc-mark-mminit_verify_zonelist-as-__init.patch
mm-mm_initc-mark-mminit_loglevel-__meminitdata.patch
kernel-cpusetc-mark-cpuset_init_current_mems_allowed-as-__init.patch

