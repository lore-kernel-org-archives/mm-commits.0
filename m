From: akpm@linux-foundation.org
Subject: [patch 090/126] radix-tree: must check
 __radix_tree_preload() return value
Date: Fri, 08 Sep 2017 16:15:54 -0700
Message-ID: <20170908231554.FJ8gMFfA6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53216 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753026AbdIHXP4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:15:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, edumazet@google.com, kirill.shutemov@linux.intel.com, mawilcox@microsoft.com, mm-commits@vger.kernel.org, stable@vger.kernel.org, torvalds@linux-foundation.org

From: Eric Dumazet <edumazet@google.com>
Subject: radix-tree: must check __radix_tree_preload() return value

__radix_tree_preload() only disables preemption if no error is returned.

So we really need to make sure callers always check the return value.

idr_preload() contract is to always disable preemption, so we need
to add a missing preempt_disable() if an error happened.

Similarly, ida_pre_get() only needs to call preempt_enable() in the
case no error happened.

Link: http://lkml.kernel.org/r/1504637190.15310.62.camel@edumazet-glaptop3.roam.corp.google.com
Fixes: 0a835c4f090a ("Reimplement IDR and IDA using the radix tree")
Fixes: 7ad3d4d85c7a ("ida: Move ida_bitmap to a percpu variable")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>    [4.11+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-must-check-__radix_tree_preload-return-value lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-must-check-__radix_tree_preload-return-value
+++ a/lib/radix-tree.c
@@ -463,7 +463,7 @@ radix_tree_node_free(struct radix_tree_n
  * To make use of this facility, the radix tree must be initialised without
  * __GFP_DIRECT_RECLAIM being passed to INIT_RADIX_TREE().
  */
-static int __radix_tree_preload(gfp_t gfp_mask, unsigned nr)
+static __must_check int __radix_tree_preload(gfp_t gfp_mask, unsigned nr)
 {
 	struct radix_tree_preload *rtp;
 	struct radix_tree_node *node;
@@ -2104,7 +2104,8 @@ EXPORT_SYMBOL(radix_tree_tagged);
  */
 void idr_preload(gfp_t gfp_mask)
 {
-	__radix_tree_preload(gfp_mask, IDR_PRELOAD_SIZE);
+	if (__radix_tree_preload(gfp_mask, IDR_PRELOAD_SIZE))
+		preempt_disable();
 }
 EXPORT_SYMBOL(idr_preload);
 
@@ -2118,13 +2119,13 @@ EXPORT_SYMBOL(idr_preload);
  */
 int ida_pre_get(struct ida *ida, gfp_t gfp)
 {
-	__radix_tree_preload(gfp, IDA_PRELOAD_SIZE);
 	/*
 	 * The IDA API has no preload_end() equivalent.  Instead,
 	 * ida_get_new() can return -EAGAIN, prompting the caller
 	 * to return to the ida_pre_get() step.
 	 */
-	preempt_enable();
+	if (!__radix_tree_preload(gfp, IDA_PRELOAD_SIZE))
+		preempt_enable();
 
 	if (!this_cpu_read(ida_bitmap)) {
 		struct ida_bitmap *bitmap = kmalloc(sizeof(*bitmap), gfp);
_
