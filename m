Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F28C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 17:34:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjKFReK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:34:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjKFReJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 12:34:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0741B7
        for <mm-commits@vger.kernel.org>; Mon,  6 Nov 2023 09:34:06 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BED7C433C8;
        Mon,  6 Nov 2023 17:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699292046;
        bh=eKI80cUgWVHEjyPaoH9Mny2pqSxxFfh4un01LIorv+4=;
        h=Date:To:From:Subject:From;
        b=mwINdhoR/WY4uoQhwkVAvpBMy+mNjk2N26DHharNyKBJGmOZQTcwzG6R8fraFNVPg
         DP38PlbXicUP9YRYL3NMXpr7zhe7FH8w1HdFWE6nVKW1I1j2UWcxFAvecDDodh65EX
         Pf47XJmcjlkMmoVAKIHuHPXyO0RqS19RD8d3xuSw=
Date:   Mon, 06 Nov 2023 09:34:05 -0800
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-unnecessary-default-labels-from-switch-statements.patch added to mm-unstable branch
Message-Id: <20231106173406.8BED7C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: remove unnecessary default labels from switch statements
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-remove-unnecessary-default-labels-from-switch-statements.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-remove-unnecessary-default-labels-from-switch-statements.patch

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
Subject: maple_tree: remove unnecessary default labels from switch statements
Date: Wed, 1 Nov 2023 13:16:18 -0400

Patch series "maple_tree: iterator state changes".

These patches have some general cleanup and a change to separate the maple
state status tracking from the maple state node.

The maple state status change allows for walks to continue from previous
places when the status needs to be recorded to make logical sense for the
next call to the maple state.  For instance, it allows for prev/next to
function in a way that better resembles the linked list.  It also allows
switch statements to be used to detect missed states during compile, and
the addition of fast-path "active" state is cleaner as an enum.

While making the status change, perf showed some very small (one line)
functions that were not inlined even with the inline key word.  Making
these small functions __always_inline is less expensive according to perf.
As part of that change, some inlines have been dropped from larger
functions.

Perf also showed that the commonly used mas_for_each() iterator was
spending a lot of time finding the end of the node.  This series
introduces caching of the end of the node in the maple state (and updating
it during writes).  This caching along with the inline changes yielded at
23.25% improvement on the BENCH_MAS_FOR_EACH maple tree test framework
benchmark.

I've also included a change to mtree_range_walk and mtree_lookup_walk to
take advantage of Peng's change [1] to the initial pivot setup.

mmtests did not produce any significant gains.

[1] https://lore.kernel.org/all/20230711035444.526-1-zhangpeng.00@bytedance.com/T/#u


This patch (of 12):

Removing the default types from the switch statements will cause compile
warnings on missing cases.

Link: https://lkml.kernel.org/r/20231101171629.3612299-2-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-unnecessary-default-labels-from-switch-statements
+++ a/lib/maple_tree.c
@@ -771,7 +771,6 @@ static inline void mte_set_pivot(struct
 
 	BUG_ON(piv >= mt_pivots[type]);
 	switch (type) {
-	default:
 	case maple_range_64:
 	case maple_leaf_64:
 		node->mr64.pivot[piv] = val;
@@ -795,7 +794,6 @@ static inline void mte_set_pivot(struct
 static inline void __rcu **ma_slots(struct maple_node *mn, enum maple_type mt)
 {
 	switch (mt) {
-	default:
 	case maple_arange_64:
 		return mn->ma64.slot;
 	case maple_range_64:
@@ -804,6 +802,8 @@ static inline void __rcu **ma_slots(stru
 	case maple_dense:
 		return mn->slot;
 	}
+
+	return NULL;
 }
 
 static inline bool mt_write_locked(const struct maple_tree *mt)
@@ -7002,7 +7002,6 @@ static void mt_dump_range(unsigned long
 		else
 			pr_info("%.*s%lx-%lx: ", depth * 2, spaces, min, max);
 		break;
-	default:
 	case mt_dump_dec:
 		if (min == max)
 			pr_info("%.*s%lu: ", depth * 2, spaces, min);
@@ -7042,7 +7041,6 @@ static void mt_dump_range64(const struct
 		case mt_dump_hex:
 			pr_cont("%p %lX ", node->slot[i], node->pivot[i]);
 			break;
-		default:
 		case mt_dump_dec:
 			pr_cont("%p %lu ", node->slot[i], node->pivot[i]);
 		}
@@ -7072,7 +7070,6 @@ static void mt_dump_range64(const struct
 				pr_err("node %p last (%lx) > max (%lx) at pivot %d!\n",
 					node, last, max, i);
 				break;
-			default:
 			case mt_dump_dec:
 				pr_err("node %p last (%lu) > max (%lu) at pivot %d!\n",
 					node, last, max, i);
@@ -7097,7 +7094,6 @@ static void mt_dump_arange64(const struc
 		case mt_dump_hex:
 			pr_cont("%lx ", node->gap[i]);
 			break;
-		default:
 		case mt_dump_dec:
 			pr_cont("%lu ", node->gap[i]);
 		}
@@ -7108,7 +7104,6 @@ static void mt_dump_arange64(const struc
 		case mt_dump_hex:
 			pr_cont("%p %lX ", node->slot[i], node->pivot[i]);
 			break;
-		default:
 		case mt_dump_dec:
 			pr_cont("%p %lu ", node->slot[i], node->pivot[i]);
 		}
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-remove-unnecessary-default-labels-from-switch-statements.patch
maple_tree-make-mas_erase-more-robust.patch
maple_tree-move-debug-check-to-__mas_set_range.patch
maple_tree-add-end-of-node-tracking-to-the-maple-state.patch
maple_tree-use-cached-node-end-in-mas_next.patch
maple_tree-use-cached-node-end-in-mas_destroy.patch
maple_tree-clean-up-inlines-for-some-functions.patch
maple_tree-separate-ma_state-node-from-status.patch
maple_tree-separate-ma_state-node-from-status-fix-1.patch
maple_tree-separate-ma_state-node-from-status-fix-2.patch
maple_tree-remove-mas_searchable.patch
maple_tree-use-maple-state-end-for-write-operations.patch
maple_tree-dont-find-node-end-in-mtree_lookup_walk.patch
maple_tree-mtree_range_walk-clean-up.patch

