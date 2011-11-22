From: akpm@linux-foundation.org
Subject: [merged] drivers-base-nodec-fix-compilation-error.patch removed from -mm tree
Date: Tue, 22 Nov 2011 11:24:20 -0800
Message-ID: <201111221924.pAMJOLRD011270@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bw0-f74.google.com ([209.85.214.74]:45802 "EHLO
	mail-bw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab1KVTY0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2011 14:24:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: claudio@evidence.eu.com, gregkh@suse.de, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/base/node.c: fix compilation error
has been removed from the -mm tree.  Its filename was
     drivers-base-nodec-fix-compilation-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Claudio Scordino <claudio@evidence.eu.com>
Subject: drivers/base/node.c: fix compilation error

Fix the error message "directives may not be used inside a macro argument"
which appears when the kernel is compiled for the cris architecture.

Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
Cc: Greg KH <gregkh@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN drivers/base/node.c~drivers-base-nodec-fix-compilation-error drivers/base/node.c
--- a/drivers/base/node.c~drivers-base-nodec-fix-compilation-error
+++ a/drivers/base/node.c
@@ -127,12 +127,13 @@ static ssize_t node_read_meminfo(struct 
 		       nid, K(node_page_state(nid, NR_WRITEBACK)),
 		       nid, K(node_page_state(nid, NR_FILE_PAGES)),
 		       nid, K(node_page_state(nid, NR_FILE_MAPPED)),
-		       nid, K(node_page_state(nid, NR_ANON_PAGES)
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		       nid, K(node_page_state(nid, NR_ANON_PAGES)
 			+ node_page_state(nid, NR_ANON_TRANSPARENT_HUGEPAGES) *
-			HPAGE_PMD_NR
+			HPAGE_PMD_NR),
+#else
+		       nid, K(node_page_state(nid, NR_ANON_PAGES)),
 #endif
-		       ),
 		       nid, K(node_page_state(nid, NR_SHMEM)),
 		       nid, node_page_state(nid, NR_KERNEL_STACK) *
 				THREAD_SIZE / 1024,
@@ -143,13 +144,14 @@ static ssize_t node_read_meminfo(struct 
 		       nid, K(node_page_state(nid, NR_SLAB_RECLAIMABLE) +
 				node_page_state(nid, NR_SLAB_UNRECLAIMABLE)),
 		       nid, K(node_page_state(nid, NR_SLAB_RECLAIMABLE)),
-		       nid, K(node_page_state(nid, NR_SLAB_UNRECLAIMABLE))
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		       nid, K(node_page_state(nid, NR_SLAB_UNRECLAIMABLE))
 			, nid,
 			K(node_page_state(nid, NR_ANON_TRANSPARENT_HUGEPAGES) *
-			HPAGE_PMD_NR)
+			HPAGE_PMD_NR));
+#else
+		       nid, K(node_page_state(nid, NR_SLAB_UNRECLAIMABLE)));
 #endif
-		       );
 	n += hugetlb_report_node_meminfo(nid, buf + n);
 	return n;
 }
_

Patches currently in -mm which might be from claudio@evidence.eu.com are

origin.patch
linux-next.patch
fs-proc-meminfoc-fix-compilation-error.patch

