From: akpm@linux-foundation.org
Subject: [folded-merged]
 radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch
 removed from -mm tree
Date: Thu, 25 Jun 2015 14:53:51 -0700
Message-ID: <558c786f.9rcxG3hhcS2kCjDi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40818 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbbFYVxw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Jun 2015 17:53:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree-replace-preallocated-node-array-with-linked-list-fix
has been removed from the -mm tree.  Its filename was
     radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch

This patch was dropped because it was folded into radix-tree-replace-preallocated-node-array-with-linked-list.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: radix-tree-replace-preallocated-node-array-with-linked-list-fix

fix comment, coding style

Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-replace-preallocated-node-array-with-linked-list-fix lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-replace-preallocated-node-array-with-linked-list-fix
+++ a/lib/radix-tree.c
@@ -65,7 +65,7 @@ static struct kmem_cache *radix_tree_nod
  */
 struct radix_tree_preload {
 	int nr;
-	/* nodes->private_data points to next prealocated node */
+	/* nodes->private_data points to next preallocated node */
 	struct radix_tree_node *nodes;
 };
 static DEFINE_PER_CPU(struct radix_tree_preload, radix_tree_preloads) = { 0, };
@@ -270,8 +270,9 @@ static int __radix_tree_preload(gfp_t gf
 			node->private_data = rtp->nodes;
 			rtp->nodes = node;
 			rtp->nr++;
-		} else
+		} else {
 			kmem_cache_free(radix_tree_node_cachep, node);
+		}
 	}
 	ret = 0;
 out:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
s390-mm-change-hpage_shift-type-to-int.patch
zswap-runtime-enable-disable.patch
prctl-more-prctlpr_set_mm_-checks.patch
proc-fix-page_size-limit-of-proc-pid-cmdline.patch
maintainers-davidlohr-has-moved.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string.patch
radix-tree-replace-preallocated-node-array-with-linked-list.patch
checkpatch-emit-an-error-when-theres-a-diff-in-a-changelog.patch
init-do_mounts-add-create_dev-failure-log-fix.patch

