From: akpm@linux-foundation.org
Subject: - mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch removed from -mm tree
Date: Wed, 23 Jul 2008 15:51:12 -0700
Message-ID: <200807232303.m6NN3oNu016547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753979AbYGWXE1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:04:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, cl@linux-foundation.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Fix for memory initialisation debugging framework
has been removed from the -mm tree.  Its filename was
     mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch

This patch was dropped because it was folded into mm-add-a-basic-debugging-framework-for-memory-initialisation.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix for memory initialisation debugging framework
From: Mel Gorman <mel@csn.ul.ie>

This patch is a fix to
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch pointed out
by an off-list reviewer. The intention of the code was to change the printk
loglevel depending on the message level passed to mminit_dprintk(). What
actually happens is that for MMINIT_WARNING and levels, only the loglevel
is sent to printk() and not the message. This patch fixes the code to behave
as intended.

It can be folded safely into
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch without
causing collisions later in the set.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/internal.h~mm-add-a-basic-debugging-framework-for-memory-initialisation-fix mm/internal.h
--- a/mm/internal.h~mm-add-a-basic-debugging-framework-for-memory-initialisation-fix
+++ a/mm/internal.h
@@ -73,8 +73,8 @@ extern int mminit_loglevel;
 #define mminit_dprintk(level, prefix, fmt, arg...) \
 do { \
 	if (level < mminit_loglevel) { \
-		printk(level <= MMINIT_WARNING ? KERN_WARNING : KERN_DEBUG \
-			"mminit:: " prefix " " fmt, ##arg); \
+		printk(level <= MMINIT_WARNING ? KERN_WARNING : KERN_DEBUG); \
+		printk(KERN_CONT "mminit::" prefix " " fmt, ##arg); \
 	} \
 } while (0)
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
page-allocator-inlnie-some-__alloc_pages-wrappers.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
hugetlb-move-hugetlb_acct_memory.patch
hugetlb-reserve-huge-pages-for-reliable-map_private-hugetlbfs-mappings-until-fork.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-align-faulting-address-to-a-hugepage-boundary-before-unmapping.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
hugetlb-reservations-fix-hugetlb-map_private-reservations-across-vma-splits-v2.patch
mm-remove-mm_init-compilation-dependency-on-config_debug_memory_init.patch
mm-create-sys-kernel-mm.patch
mm-create-sys-kernel-mm-fix.patch
hugetlb-new-sysfs-interface-hugetlb-hang-off-of-sys-kernel-mm-rather-than-sys-kernel.patch
hugetlb-new-sysfs-interface-hugetlb-remove-config_sysfs-dependency.patch
hugetlb-fix-race-when-reading-proc-meminfo.patch
hugetlb-fix-a-hugepage-reservation-check-for-map_shared.patch
hugetlb-quota-is-not-freed-for-unused-reserved-private-huge-pages.patch
mm-add-alloc_pages_exact-and-free_pages_exact.patch
memory-hotplugallocate-usemap-on-the-section-with-pgdat-take-4.patch
memory-hotplug-add-sysfs-removable-attribute-for-hotplug-memory-remove.patch

