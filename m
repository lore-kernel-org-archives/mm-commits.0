From: akpm@linux-foundation.org
Subject: - parisc-fix-discontigmem-compile-breakage.patch removed from -mm tree
Date: Tue, 13 May 2008 14:33:41 -0700
Message-ID: <200805132133.m4DLXfYH000845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760360AbYEMVej (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:34:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, James.Bottomley@HansenPartnership.com, bunk@kernel.org, clameter@sgi.com, grundler@parisc-linux.org, kyle@mcmartin.ca, lee.schermerhorn@hp.com, mm-commits@vger.kernel.org


The patch titled
     parisc: fix DISCONTIGMEM compile breakage
has been removed from the -mm tree.  Its filename was
     parisc-fix-discontigmem-compile-breakage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parisc: fix DISCONTIGMEM compile breakage
From: Mel Gorman <mel@csn.ul.ie>

PA-RISC to aid debugging prints out the zonelists setup by the system.  A
bad call to node_zonelist() breaks at compile-time.  This patch fixes it.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/mm/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/parisc/mm/init.c~parisc-fix-discontigmem-compile-breakage arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c~parisc-fix-discontigmem-compile-breakage
+++ a/arch/parisc/mm/init.c
@@ -606,7 +606,7 @@ void show_mem(void)
 		int i, j;
 
 		for (i = 0; i < npmem_ranges; i++) {
-			zl = node_zonelist(i);
+			zl = node_zonelist(i, 0);
 			for (j = 0; j < MAX_NR_ZONES; j++) {
 				struct zoneref *z;
 				struct zone *zone;
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
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch

