From: akpm@linux-foundation.org
Subject: - get_unmapped_area-handles-map_fixed-in-hugetlbfs.patch removed from -mm tree
Date: Mon, 07 May 2007 17:04:12 -0700
Message-ID: <200705080004.l4804CUS008997@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967464AbXEHANz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:13:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, agl@us.ibm.com, ak@suse.de, bill.irwin@oracle.com, davem@davemloft.net, david@gibson.dropbear.id.au, dhowells@redhat.com, grundler@parisc-linux.org, ink@jurassic.park.msu.ru, kyle@mcmartin.ca, paulus@samba.org, rmk+kernel@arm.linux.org.uk, rth@twiddle.net, tony.luck@intel.com, willy@debian.org, mm-commits@vger.kernel.org


The patch titled
     get_unmapped_area handles MAP_FIXED in hugetlbfs
has been removed from the -mm tree.  Its filename was
     get_unmapped_area-handles-map_fixed-in-hugetlbfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: get_unmapped_area handles MAP_FIXED in hugetlbfs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Generic hugetlb_get_unmapped_area() now handles MAP_FIXED by just calling
prepare_hugepage_range()

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

 fs/hugetlbfs/inode.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN fs/hugetlbfs/inode.c~get_unmapped_area-handles-map_fixed-in-hugetlbfs fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~get_unmapped_area-handles-map_fixed-in-hugetlbfs
+++ a/fs/hugetlbfs/inode.c
@@ -22,6 +22,7 @@
 #include <linux/backing-dev.h>
 #include <linux/hugetlb.h>
 #include <linux/pagevec.h>
+#include <linux/mman.h>
 #include <linux/quotaops.h>
 #include <linux/slab.h>
 #include <linux/dnotify.h>
@@ -112,6 +113,12 @@ hugetlb_get_unmapped_area(struct file *f
 	if (len > TASK_SIZE)
 		return -ENOMEM;
 
+	if (flags & MAP_FIXED) {
+		if (prepare_hugepage_range(addr, len, pgoff))
+			return -EINVAL;
+		return addr;
+	}
+
 	if (addr) {
 		addr = ALIGN(addr, HPAGE_SIZE);
 		vma = find_vma(mm, addr);
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
