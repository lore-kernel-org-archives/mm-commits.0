Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ACB1C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 17:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbjKFR2B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjKFR2A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 12:28:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B873F3
        for <mm-commits@vger.kernel.org>; Mon,  6 Nov 2023 09:27:58 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911B6C433C7;
        Mon,  6 Nov 2023 17:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699291677;
        bh=IcjVnzwFCBVsnie0Nl3AU9lWlkTTdGdqKYOYhtGydFY=;
        h=Date:To:From:Subject:From;
        b=r7QkzAEAChzRHqgNkZu4PNDsaitf31b4LvRac2uIuNKIZr06bnI+Qll4a4ihOlQIF
         KlfbGnlI/k5tEVtjsM2dhsoo/h1IdRG0k+cmb3spXG6hZk9zOo1dtGJw3JXExg9w8J
         bL191+i1tqn/EAzgZMmaJ/u8GL88YLoKYKnYK9EU=
Date:   Mon, 06 Nov 2023 09:27:57 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        peterz@infradead.org, npiggin@gmail.com, mst@redhat.com,
        mjguzik@gmail.com, michael.christie@oracle.com,
        mathieu.desnoyers@efficios.com, Liam.Howlett@oracle.com,
        corbet@lwn.net, brauner@kernel.org, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-mt_free_one-and-mt_attr-helpers.patch added to mm-unstable branch
Message-Id: <20231106172757.911B6C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: add mt_free_one() and mt_attr() helpers
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-add-mt_free_one-and-mt_attr-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-mt_free_one-and-mt_attr-helpers.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: add mt_free_one() and mt_attr() helpers
Date: Fri, 27 Oct 2023 11:38:36 +0800

Patch series "Introduce __mt_dup() to improve the performance of fork()", v7.

This series introduces __mt_dup() to improve the performance of fork(). 
During the duplication process of mmap, all VMAs are traversed and
inserted one by one into the new maple tree, causing the maple tree to be
rebalanced multiple times.  Balancing the maple tree is a costly
operation.  To duplicate VMAs more efficiently, mtree_dup() and __mt_dup()
are introduced for the maple tree.  They can efficiently duplicate a maple
tree.

Here are some algorithmic details about {mtree,__mt}_dup().  We perform a
DFS pre-order traversal of all nodes in the source maple tree.  During
this process, we fully copy the nodes from the source tree to the new
tree.  This involves memory allocation, and when encountering a new node,
if it is a non-leaf node, all its child nodes are allocated at once.

This idea was originally from Liam R.  Howlett's Maple Tree Work email,
and I added some of my own ideas to implement it.  Some previous
discussions can be found in [1].  For a more detailed analysis of the
algorithm, please refer to the logs for patch [3/10] and patch [10/10].

There is a "spawn" in byte-unixbench[2], which can be used to test the
performance of fork().  I modified it slightly to make it work with
different number of VMAs.

Below are the test results.  The first row shows the number of VMAs.  The
second and third rows show the number of fork() calls per ten seconds,
corresponding to next-20231006 and the this patchset, respectively.  The
test results were obtained with CPU binding to avoid scheduler load
balancing that could cause unstable results.  There are still some
fluctuations in the test results, but at least they are better than the
original performance.

21     121   221    421    821    1621   3221   6421   12821  25621  51221
112100 76261 54227  34035  20195  11112  6017   3161   1606   802    393
114558 83067 65008  45824  28751  16072  8922   4747   2436   1233   599
2.19%  8.92% 19.88% 34.64% 42.37% 44.64% 48.28% 50.17% 51.68% 53.74% 52.42%

Thanks to Liam and Matthew for the review.


This patch (of 10):

Add two helpers:
1. mt_free_one(), used to free a maple node.
2. mt_attr(), used to obtain the attributes of maple tree.

Link: https://lkml.kernel.org/r/20231027033845.90608-1-zhangpeng.00@bytedance.com
Link: https://lkml.kernel.org/r/20231027033845.90608-2-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-add-mt_free_one-and-mt_attr-helpers
+++ a/lib/maple_tree.c
@@ -165,6 +165,11 @@ static inline int mt_alloc_bulk(gfp_t gf
 	return kmem_cache_alloc_bulk(maple_node_cache, gfp, size, nodes);
 }
 
+static inline void mt_free_one(struct maple_node *node)
+{
+	kmem_cache_free(maple_node_cache, node);
+}
+
 static inline void mt_free_bulk(size_t size, void __rcu **nodes)
 {
 	kmem_cache_free_bulk(maple_node_cache, size, (void **)nodes);
@@ -205,6 +210,11 @@ static unsigned int mas_mt_height(struct
 	return mt_height(mas->tree);
 }
 
+static inline unsigned int mt_attr(struct maple_tree *mt)
+{
+	return mt->ma_flags & ~MT_FLAGS_HEIGHT_MASK;
+}
+
 static inline enum maple_type mte_node_type(const struct maple_enode *entry)
 {
 	return ((unsigned long)entry >> MAPLE_NODE_TYPE_SHIFT) &
@@ -5573,7 +5583,7 @@ void mas_destroy(struct ma_state *mas)
 			mt_free_bulk(count, (void __rcu **)&node->slot[1]);
 			total -= count;
 		}
-		kmem_cache_free(maple_node_cache, node);
+		mt_free_one(ma_mnode_ptr(node));
 		total--;
 	}
 
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

maple_tree-add-mt_free_one-and-mt_attr-helpers.patch
maple_tree-introduce-mtreemas_lock_nested.patch
maple_tree-introduce-interfaces-__mt_dup-and-mtree_dup.patch
radix-tree-test-suite-align-kmem_cache_alloc_bulk-with-kernel-behavior.patch
maple_tree-add-test-for-mtree_dup.patch
maple_tree-update-the-documentation-of-maple-tree.patch
maple_tree-skip-other-tests-when-bench-is-enabled.patch
maple_tree-update-check_forking-and-bench_forking.patch
maple_tree-preserve-the-tree-attributes-when-destroying-maple-tree.patch
fork-use-__mt_dup-to-duplicate-maple-tree-in-dup_mmap.patch

