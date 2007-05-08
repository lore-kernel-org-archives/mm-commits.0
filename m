From: akpm@linux-foundation.org
Subject: - get_unmapped_area-doesnt-need-hugetlbfs-hacks-anymore.patch removed from -mm tree
Date: Mon, 07 May 2007 17:04:18 -0700
Message-ID: <200705080004.l4804IVD009003@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967379AbXEHAGd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:06:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, agl@us.ibm.com, ak@suse.de, bill.irwin@oracle.com, davem@davemloft.net, david@gibson.dropbear.id.au, dhowells@redhat.com, grundler@parisc-linux.org, ink@jurassic.park.msu.ru, kyle@mcmartin.ca, paulus@samba.org, rmk+kernel@arm.linux.org.uk, rth@twiddle.net, tony.luck@intel.com, willy@debian.org, mm-commits@vger.kernel.org


The patch titled
     get_unmapped_area doesn't need hugetlbfs hacks anymore
has been removed from the -mm tree.  Its filename was
     get_unmapped_area-doesnt-need-hugetlbfs-hacks-anymore.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: get_unmapped_area doesn't need hugetlbfs hacks anymore
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Remove the hugetlbfs specific hacks in toplevel get_unmapped_area() now that
all archs and hugetlbfs itself do the right thing for both cases.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: William Irwin <bill.irwin@oracle.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <willy@debian.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Adam Litke <agl@us.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   16 ----------------
 1 file changed, 16 deletions(-)

diff -puN mm/mmap.c~get_unmapped_area-doesnt-need-hugetlbfs-hacks-anymore mm/mmap.c
--- a/mm/mmap.c~get_unmapped_area-doesnt-need-hugetlbfs-hacks-anymore
+++ a/mm/mmap.c
@@ -1382,22 +1382,6 @@ get_unmapped_area(struct file *file, uns
 	if (addr & ~PAGE_MASK)
 		return -EINVAL;
 
-	if (file && is_file_hugepages(file))  {
-		/*
-		 * Check if the given range is hugepage aligned, and
-		 * can be made suitable for hugepages.
-		 */
-		ret = prepare_hugepage_range(addr, len, pgoff);
-	} else {
-		/*
-		 * Ensure that a normal request is not falling in a
-		 * reserved hugepage range.  For some archs like IA-64,
-		 * there is a separate region for hugepages.
-		 */
-		ret = is_hugepage_only_range(current->mm, addr, len);
-	}
-	if (ret)
-		return -EINVAL;
 	return addr;
 }
 
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
git-powerpc.patch
gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed-powerpc-fixes.patch
use-slab_panic-flag-cleanup.patch
the-scheduled-removal-of-obsolete_oss-options.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
parport-dev-driver-model-support.patch
introduce-freezer-flags-rev-2.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-powerpc-optimization.patch
aty128fb-fix-blanking.patch
radeonfb-add-support-for-radeon-xpress-200m.patch
