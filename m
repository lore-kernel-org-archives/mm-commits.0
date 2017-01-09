From: akpm@linux-foundation.org
Subject: + reimplement-idr-and-ida-using-the-radix-tree-fix.patch added to -mm tree
Date: Mon, 09 Jan 2017 13:38:10 -0800
Message-ID: <587402c2.SISD0rxIjKMaouJH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33808 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932800AbdAIVgn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2017 16:36:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, mawilcox@microsoft.com, mm-commits@vger.kernel.org


The patch titled
     Subject: [PATCH] mm: merge fixup for "fix use-after-free in shadow node shrinker"
has been added to the -mm tree.  Its filename is
     reimplement-idr-and-ida-using-the-radix-tree-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/reimplement-idr-and-ida-using-the-radix-tree-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/reimplement-idr-and-ida-using-the-radix-tree-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1949,7 +1949,7 @@ void radix_tree_iter_delete(struct radix
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

reimplement-idr-and-ida-using-the-radix-tree-fix.patch

