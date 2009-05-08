From: akpm@linux-foundation.org
Subject: [merged] nommu-dont-check-vm_region-vm_start-is-page-aligned-in-add_nommu_region.patch removed from -mm tree
Date: Fri, 08 May 2009 11:33:39 -0700
Message-ID: <200905081833.n48IXd02027198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932080AbZEHSfp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 May 2009 14:35:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     nommu: don't check vm_region::vm_start is page aligned in add_nommu_region()
has been removed from the -mm tree.  Its filename was
     nommu-dont-check-vm_region-vm_start-is-page-aligned-in-add_nommu_region.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: don't check vm_region::vm_start is page aligned in add_nommu_region()
From: David Howells <dhowells@redhat.com>

Don't check vm_region::vm_start is page aligned in add_nommu_region()
because the region may reflect some non-page-aligned mapped file, such as
could be obtained from RomFS XIP.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/nommu.c~nommu-dont-check-vm_region-vm_start-is-page-aligned-in-add_nommu_region mm/nommu.c
--- a/mm/nommu.c~nommu-dont-check-vm_region-vm_start-is-page-aligned-in-add_nommu_region
+++ a/mm/nommu.c
@@ -515,8 +515,6 @@ static void add_nommu_region(struct vm_r
 
 	validate_nommu_regions();
 
-	BUG_ON(region->vm_start & ~PAGE_MASK);
