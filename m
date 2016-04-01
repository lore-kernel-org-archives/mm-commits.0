From: akpm@linux-foundation.org
Subject: [folded-merged]
 ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-3.patch removed from -mm tree
Date: Fri, 01 Apr 2016 14:11:28 -0700
Message-ID: <56fee400.2TmA0LAWQyExeJiL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49510 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbcDAVL3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Apr 2016 17:11:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: validate STABLE_NODE_DUP_HEAD conditional to gcc version
has been removed from the -mm tree.  Its filename was
     ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-3.patch

This patch was dropped because it was folded into ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit.patch

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: ksm: validate STABLE_NODE_DUP_HEAD conditional to gcc version

BUILD_BUG_ON can only validate this successfully on recent gcc.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/ksm.c~ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-3 mm/ksm.c
--- a/mm/ksm.c~ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-3
+++ a/mm/ksm.c
@@ -621,8 +621,10 @@ static void remove_node_from_stable_tree
 	 * from &migrate_nodes. This will verify that future list.h changes
 	 * don't break STABLE_NODE_DUP_HEAD.
 	 */
+#if GCC_VERSION >= 40903 /* only recent gcc can handle it */
 	BUILD_BUG_ON(STABLE_NODE_DUP_HEAD <= &migrate_nodes);
 	BUILD_BUG_ON(STABLE_NODE_DUP_HEAD >= &migrate_nodes + 1);
+#endif
 
 	if (stable_node->head == &migrate_nodes)
 		list_del(&stable_node->list);
_

Patches currently in -mm which might be from aarcange@redhat.com are

ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit.patch

