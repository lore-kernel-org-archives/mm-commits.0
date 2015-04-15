From: akpm@linux-foundation.org
Subject: [merged] cma-debug-document-new-debugfs-interface.patch removed
 from -mm tree
Date: Wed, 15 Apr 2015 12:09:29 -0700
Message-ID: <552eb769.E2jcnRuSnFSmvLJf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47995 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720AbbDOTJa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:09:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, iamjoonsoo.kim@lge.com, konrad.wilk@oracle.com, lauraa@codeaurora.org, m.szyprowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cma: debug: document new debugfs interface
has been removed from the -mm tree.  Its filename was
     cma-debug-document-new-debugfs-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: cma: debug: document new debugfs interface

Document the structure and files under the new debugfs interface.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cma/debugfs.txt |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN /dev/null Documentation/cma/debugfs.txt
--- /dev/null
+++ a/Documentation/cma/debugfs.txt
@@ -0,0 +1,21 @@
+The CMA debugfs interface is useful to retrieve basic information out of the
+different CMA areas and to test allocation/release in each of the areas.
+
+Each CMA zone represents a directory under <debugfs>/cma/, indexed by the
+kernel's CMA index. So the first CMA zone would be:
+
+	<debugfs>/cma/cma-0
+
+The structure of the files created under that directory is as follows:
+
+ - [RO] base_pfn: The base PFN (Page Frame Number) of the zone.
+ - [RO] count: Amount of memory in the CMA area.
+ - [RO] order_per_bit: Order of pages represented by one bit.
+ - [RO] bitmap: The bitmap of page states in the zone.
+ - [WO] alloc: Allocate N pages from that CMA area. For example:
+
+	echo 5 > <debugfs>/cma/cma-2/alloc
+
+would try to allocate 5 pages from the cma-2 area.
+
+ - [WO] free: Free N pages from that CMA area, similar to the above.
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

origin.patch
mm-mmapc-use-while-instead-of-ifgoto.patch
mm-mmapc-use-while-instead-of-ifgoto-fix.patch
mm-memory-print-also-a_ops-readpage-in-print_bad_pte.patch
mm-memory-print-also-a_ops-readpage-in-print_bad_pte-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

