Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9147C001DB
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 17:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjHDRny (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 13:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjHDRnx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 13:43:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544EE4C01
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 10:43:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2861620D1
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 17:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22035C433C7;
        Fri,  4 Aug 2023 17:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691171031;
        bh=0FwsMxMJPPPeg/pQmyCxMGkJwEjw5l5KWB1gQv4BkP0=;
        h=Date:To:From:Subject:From;
        b=UEBNFXlHpzg02/T24t+yMQ8+Ie331PVLjB3MXOBD/5FoFL9L8N+qLleR5TDxyKLn9
         0zD+HAPa6a/RZRtfsiwRs0NjNFB+RNKyj3MJ4xz3Lqs+FNWYYRR3UPEj8drrrUsLe1
         37qUVYsBmtDjvLlBDwMj5anpwsM35ZufQnW27DtE=
Date:   Fri, 04 Aug 2023 10:43:50 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        paulmck@kernel.org, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-hex-output-to-maple_arange64-dump.patch added to mm-unstable branch
Message-Id: <20230804174351.22035C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: add hex output to maple_arange64 dump
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-add-hex-output-to-maple_arange64-dump.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-hex-output-to-maple_arange64-dump.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: add hex output to maple_arange64 dump
Date: Fri, 4 Aug 2023 12:59:46 -0400

Patch series "maple_tree: Change replacement strategy".

The maple tree marks nodes dead as soon as they are going to be replaced. 
This could be problematic when used in the RCU context since the writer
may be starved of CPU time by the readers.  This patch set addresses the
issue by switching the data replacement strategy to one that will only
mark data as dead once the new data is available.

This series changes the ordering of the node replacement so that the new
data is live before the old data is marked 'dead'.  When readers hit
'dead' nodes, they will restart from the top of the tree and end up in the
new data.

In more complex scenarios, the replacement strategy means a subtree is
built and graphed into the tree leaving some nodes to point to the old
parent.  The view of tasks into the old data will either remain with the
old data, or see the new data once the old data is marked 'dead'.

Iterators will see the 'dead' node and restart on their own and switch to
the new data.  There is no risk of the reader seeing old data in these
cases.

The 'dead' subtree of data is then fully marked dead, but reused nodes
will still point to the dead nodes until the parent pointer is updated. 
Walking up to a 'dead' node will cause a re-walk from the top of the tree
and enter the new data area where old data is not reachable.

Once the parent pointers are fully up to date in the active data, the
'dead' subtree is iterated to collect entirely 'dead' subtrees, and dead
nodes (nodes that partially contained reused data).


This patch (of 6):

When dumping the tree, honour formatting request to output hex for the
maple node type arange64.

Link: https://lkml.kernel.org/r/20230804165951.2661157-1-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20230804165951.2661157-2-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/lib/maple_tree.c~maple_tree-add-hex-output-to-maple_arange64-dump
+++ a/lib/maple_tree.c
@@ -6833,11 +6833,27 @@ static void mt_dump_arange64(const struc
 	int i;
 
 	pr_cont(" contents: ");
-	for (i = 0; i < MAPLE_ARANGE64_SLOTS; i++)
-		pr_cont("%lu ", node->gap[i]);
+	for (i = 0; i < MAPLE_ARANGE64_SLOTS; i++) {
+		switch (format) {
+		case mt_dump_hex:
+			pr_cont("%lx ", node->gap[i]);
+			break;
+		default:
+		case mt_dump_dec:
+			pr_cont("%lu ", node->gap[i]);
+		}
+	}
 	pr_cont("| %02X %02X| ", node->meta.end, node->meta.gap);
-	for (i = 0; i < MAPLE_ARANGE64_SLOTS - 1; i++)
-		pr_cont("%p %lu ", node->slot[i], node->pivot[i]);
+	for (i = 0; i < MAPLE_ARANGE64_SLOTS - 1; i++) {
+		switch (format) {
+		case mt_dump_hex:
+			pr_cont("%p %lX ", node->slot[i], node->pivot[i]);
+			break;
+		default:
+		case mt_dump_dec:
+			pr_cont("%p %lu ", node->slot[i], node->pivot[i]);
+		}
+	}
 	pr_cont("%p\n", node->slot[i]);
 	for (i = 0; i < MAPLE_ARANGE64_SLOTS; i++) {
 		unsigned long last = max;
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maintainers-add-maple-tree-mailing-list.patch
mm-mmap-clean-up-validate_mm-calls.patch
maple_tree-relax-lockdep-checks-for-on-stack-trees.patch
mm-mmap-change-detached-vma-locking-scheme.patch
maple_tree-be-more-strict-about-locking.patch
maple_tree-add-benchmarking-for-mas_for_each.patch
maple_tree-add-benchmarking-for-mas_prev.patch
mm-change-do_vmi_align_munmap-tracking-of-vmas-to-remove.patch
mm-remove-prev-check-from-do_vmi_align_munmap.patch
maple_tree-introduce-__mas_set_range.patch
mm-remove-re-walk-from-mmap_region.patch
maple_tree-re-introduce-entry-to-mas_preallocate-arguments.patch
maple_tree-adjust-node-allocation-on-mas_rebalance.patch
mm-use-vma_iter_clear_gfp-in-nommu.patch
mm-set-up-vma-iterator-for-vma_iter_prealloc-calls.patch
maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null.patch
maple_tree-update-mas_preallocate-testing.patch
maple_tree-refine-mas_preallocate-node-calculations.patch
maple_tree-reduce-resets-during-store-setup.patch
mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch
maple_tree-add-hex-output-to-maple_arange64-dump.patch
maple_tree-reorder-replacement-of-nodes-to-avoid-live-lock.patch
maple_tree-introduce-mas_put_in_tree.patch
maple_tree-introduce-mas_tree_parent-definition.patch
maple_tree-change-mas_adopt_children-parent-usage.patch
maple_tree-replace-data-before-marking-dead-in-split-and-spanning-store.patch

