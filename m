From: akpm@linux-foundation.org
Subject: [merged] prio_tree-remove-unnecessary-code-in-prio_tree_replace.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:30:05 -0700
Message-ID: <20120326193005.5492CA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:56973 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2CZTaG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:30:06 -0400
Received: by ghbz15 with SMTP id z15so831473ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:30:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaoguangrong@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: prio_tree: remove unnecessary code in prio_tree_replace
has been removed from the -mm tree.  Its filename was
     prio_tree-remove-unnecessary-code-in-prio_tree_replace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: prio_tree: remove unnecessary code in prio_tree_replace

Remove the code since 'node' has already been initialized in the begin of
the function

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/prio_tree.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN lib/prio_tree.c~prio_tree-remove-unnecessary-code-in-prio_tree_replace lib/prio_tree.c
--- a/lib/prio_tree.c~prio_tree-remove-unnecessary-code-in-prio_tree_replace
+++ a/lib/prio_tree.c
@@ -151,7 +151,6 @@ struct prio_tree_node *prio_tree_replace
 		 * We can reduce root->index_bits here. However, it is complex
 		 * and does not help much to improve performance (IMO).
 		 */
-		node->parent = node;
 		root->prio_tree_node = node;
 	} else {
 		node->parent = old->parent;
_

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

origin.patch
linux-next.patch

