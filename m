From: akpm@linux-foundation.org
Subject: + drivers-base-nodec-fix-compilation-error.patch added to -mm tree
Date: Thu, 17 Nov 2011 13:42:41 -0800
Message-ID: <201111172142.pAHLgfqk018319@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:35241 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab1KQVmn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2011 16:42:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: claudio@evidence.eu.com, gregkh@suse.de, rientjes@google.com, stable@vger.kernel.org


The patch titled
     Subject: drivers/base/node.c: fix compilation error
has been added to the -mm tree.  Its filename is
     drivers-base-nodec-fix-compilation-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Subject: Subject: drivers/base/node.c: fix compilation error

Patches currently in -mm which might be from claudio@evidence.eu.com are

linux-next.patch
fs-proc-meminfoc-fix-compilation-error.patch
drivers-base-nodec-fix-compilation-error.patch

