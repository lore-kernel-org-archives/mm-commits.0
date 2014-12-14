From: akpm@linux-foundation.org
Subject: [merged]
 mm-move-swp_entry_t-definition-to-include-linux-mm_typesh.patch removed
 from -mm tree
Date: Sat, 13 Dec 2014 20:07:30 -0800
Message-ID: <548d0d02.Xyn4+qb3+W3o5xM1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47598 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaLNEHX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:07:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, hannes@cmpxchg.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move swp_entry_t definition to include/linux/mm_types.h
has been removed from the -mm tree.  Its filename was
     mm-move-swp_entry_t-definition-to-include-linux-mm_typesh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: mm: move swp_entry_t definition to include/linux/mm_types.h

swp_entry_t being defined in include/linux/swap.h instead of
include/linux/mm_types.h causes cyclic include dependency later when
include/linux/page_cgroup.h is included from writeback path.  Move the
definition to include/linux/mm_types.h.

While at it, reformat the comment above it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    8 ++++++++
 include/linux/swap.h     |    8 --------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN include/linux/mm_types.h~mm-move-swp_entry_t-definition-to-include-linux-mm_typesh include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-move-swp_entry_t-definition-to-include-linux-mm_typesh
+++ a/include/linux/mm_types.h
@@ -534,4 +534,12 @@ enum tlb_flush_reason {
 	NR_TLB_FLUSH_REASONS,
 };
 
+ /*
+  * A swap entry has to fit into a "unsigned long", as the entry is hidden
+  * in the "index" field of the swapper address space.
+  */
+typedef struct {
+	unsigned long val;
+} swp_entry_t;
+
 #endif /* _LINUX_MM_TYPES_H */
diff -puN include/linux/swap.h~mm-move-swp_entry_t-definition-to-include-linux-mm_typesh include/linux/swap.h
--- a/include/linux/swap.h~mm-move-swp_entry_t-definition-to-include-linux-mm_typesh
+++ a/include/linux/swap.h
@@ -102,14 +102,6 @@ union swap_header {
 	} info;
 };
 
- /* A swap entry has to fit into a "unsigned long", as
-  * the entry is hidden in the "index" field of the
-  * swapper address space.
-  */
-typedef struct {
-	unsigned long val;
-} swp_entry_t;
