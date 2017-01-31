From: akpm@linux-foundation.org
Subject: [merged] reimplement-idr-and-ida-using-the-radix-tree-fix.patch
 removed from -mm tree
Date: Tue, 31 Jan 2017 12:28:46 -0800
Message-ID: <5890f37e.CHMbRuRRtzP+v/KV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57608 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751268AbdAaU2r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 15:28:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, mawilcox@microsoft.com, mm-commits@vger.kernel.org


The patch titled
     Subject: [PATCH] mm: merge fixup for "fix use-after-free in shadow node shrinker"
has been removed from the -mm tree.  Its filename was
     reimplement-idr-and-ida-using-the-radix-tree-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] mm: merge fixup for "fix use-after-free in shadow node shrinker"

Link: http://lkml.kernel.org/r/20170109150920.444b4560@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/radix-tree.c~reimplement-idr-and-ida-using-the-radix-tree-fix lib/radix-tree.c
--- a/lib/radix-tree.c~reimplement-idr-and-ida-using-the-radix-tree-fix
+++ a/lib/radix-tree.c
@@ -1950,7 +1950,7 @@ void radix_tree_iter_delete(struct radix
 	if (node) {
 		node->slots[iter_offset(iter)] = NULL;
 		node->count--;
-		__radix_tree_delete_node(root, node);
+		__radix_tree_delete_node(root, node, NULL, NULL);
 	} else {
 		root->rnode = NULL;
 	}
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are


