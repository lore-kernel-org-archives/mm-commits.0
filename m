From: akpm@linux-foundation.org
Subject: + cma-debug-document-new-debugfs-interface.patch added to -mm
 tree
Date: Fri, 27 Feb 2015 14:01:20 -0800
Message-ID: <54f0e930.aXRTxY7g+rPpAvi8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787AbbB0WBV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Feb 2015 17:01:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, iamjoonsoo.kim@lge.com, konrad.wilk@oracle.com, lauraa@codeaurora.org, m.szyprowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cma: debug: document new debugfs interface
has been added to the -mm tree.  Its filename is
     cma-debug-document-new-debugfs-interface.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cma-debug-document-new-debugfs-interface.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cma-debug-document-new-debugfs-interface.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-cma-debugfs-interface.patch
mm-cma-allocation-trigger.patch
mm-cma-release-trigger.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-release-trigger-fixpatch.patch
mm-cma-allocation-trigger-fix.patch
cma-debug-document-new-debugfs-interface.patch
mm-incorporate-zero-pages-into-transparent-huge-pages.patch
mm-incorporate-zero-pages-into-transparent-huge-pages-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

