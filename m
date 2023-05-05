Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F30C3C7EE2C
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 19:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbjEETar (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 15:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233492AbjEETag (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 15:30:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53772D7C
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 12:30:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3759063F9E
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 19:30:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8964CC433D2;
        Fri,  5 May 2023 19:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683315034;
        bh=eBJKdIVS9IcSBC4vY3j3gzTZXDoCgW6JYGsiIBG99rw=;
        h=Date:To:From:Subject:From;
        b=tb/YuwjHBdZyyQoSAi+9cwbtg2ru9CA64zMG4J+2EyU37gzoKCOFIbooB/uIIWLwy
         qdkkWS/zjvLz66np3o6CguvfY7Dex3e3ImVfQeaot3TV4F8SAnCHGrHaOLoW7ED5MV
         xnl14YpsbqMx9Upovtz16PIisiMT4a68oVkWdMaQ=
Date:   Fri, 05 May 2023 12:30:34 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        senozhatsky@chromium.org, richard.weiyang@gmail.com,
        Liam.Howlett@oracle.com, dcb314@hotmail.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-convert-debug-code-to-use-mt_warn_on-and-mas_warn_on.patch added to mm-unstable branch
Message-Id: <20230505193034.8964CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: convert debug code to use MT_WARN_ON() and MAS_WARN_ON()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-convert-debug-code-to-use-mt_warn_on-and-mas_warn_on.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-convert-debug-code-to-use-mt_warn_on-and-mas_warn_on.patch

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
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: maple_tree: convert debug code to use MT_WARN_ON() and MAS_WARN_ON()
Date: Fri, 5 May 2023 13:41:37 -0400

Using MT_WARN_ON() allows for the removal of if statements before logging.
Using MAS_WARN_ON() will provide more information when issues are
encountered.

Link: https://lkml.kernel.org/r/20230505174204.2665599-10-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- a/lib/maple_tree.c~maple_tree-convert-debug-code-to-use-mt_warn_on-and-mas_warn_on
+++ a/lib/maple_tree.c
@@ -5698,9 +5698,9 @@ void *mas_store(struct ma_state *mas, vo
 
 	trace_ma_write(__func__, mas, 0, entry);
 #ifdef CONFIG_DEBUG_MAPLE_TREE
-	if (mas->index > mas->last)
+	if (MAS_WARN_ON(mas, mas->index > mas->last))
 		pr_err("Error %lX > %lX %p\n", mas->index, mas->last, entry);
-	MT_BUG_ON(mas->tree, mas->index > mas->last);
+
 	if (mas->index > mas->last) {
 		mas_set_err(mas, -EINVAL);
 		return NULL;
@@ -6529,10 +6529,9 @@ unlock:
 	if (likely(entry)) {
 		*index = mas.last + 1;
 #ifdef CONFIG_DEBUG_MAPLE_TREE
-		if ((*index) && (*index) <= copy)
+		if (MT_WARN_ON(mt, (*index) && ((*index) <= copy)))
 			pr_err("index not increased! %lx <= %lx\n",
 			       *index, copy);
-		MT_BUG_ON(mt, (*index) && ((*index) <= copy));
 #endif
 	}
 
@@ -6678,7 +6677,7 @@ static inline void *mas_first_entry(stru
 	max = mas->max;
 	mas->offset = 0;
 	while (likely(!ma_is_leaf(mt))) {
-		MT_BUG_ON(mas->tree, mte_dead_node(mas->node));
+		MAS_WARN_ON(mas, mte_dead_node(mas->node));
 		slots = ma_slots(mn, mt);
 		entry = mas_slot(mas, slots, 0);
 		pivots = ma_pivots(mn, mt);
@@ -6689,7 +6688,7 @@ static inline void *mas_first_entry(stru
 		mn = mas_mn(mas);
 		mt = mte_node_type(mas->node);
 	}
-	MT_BUG_ON(mas->tree, mte_dead_node(mas->node));
+	MAS_WARN_ON(mas, mte_dead_node(mas->node));
 
 	mas->max = max;
 	slots = ma_slots(mn, mt);
@@ -7133,18 +7132,18 @@ static void mas_validate_limits(struct m
 		if (prev_piv > piv) {
 			pr_err("%p[%u] piv %lu < prev_piv %lu\n",
 				mas_mn(mas), i, piv, prev_piv);
-			MT_BUG_ON(mas->tree, piv < prev_piv);
+			MAS_WARN_ON(mas, piv < prev_piv);
 		}
 
 		if (piv < mas->min) {
 			pr_err("%p[%u] %lu < %lu\n", mas_mn(mas), i,
 				piv, mas->min);
-			MT_BUG_ON(mas->tree, piv < mas->min);
+			MAS_WARN_ON(mas, piv < mas->min);
 		}
 		if (piv > mas->max) {
 			pr_err("%p[%u] %lu > %lu\n", mas_mn(mas), i,
 				piv, mas->max);
-			MT_BUG_ON(mas->tree, piv > mas->max);
+			MAS_WARN_ON(mas, piv > mas->max);
 		}
 		prev_piv = piv;
 		if (piv == mas->max)
@@ -7167,7 +7166,7 @@ static void mas_validate_limits(struct m
 
 			pr_err("%p[%u] should not have piv %lu\n",
 			       mas_mn(mas), i, piv);
-			MT_BUG_ON(mas->tree, i < mt_pivots[type] - 1);
+			MAS_WARN_ON(mas, i < mt_pivots[type] - 1);
 		}
 	}
 }
@@ -7226,16 +7225,15 @@ void mt_validate(struct maple_tree *mt)
 
 	mas_first_entry(&mas, mas_mn(&mas), ULONG_MAX, mte_node_type(mas.node));
 	while (!mas_is_none(&mas)) {
-		MT_BUG_ON(mas.tree, mte_dead_node(mas.node));
+		MAS_WARN_ON(&mas, mte_dead_node(mas.node));
 		if (!mte_is_root(mas.node)) {
 			end = mas_data_end(&mas);
-			if ((end < mt_min_slot_count(mas.node)) &&
-			    (mas.max != ULONG_MAX)) {
+			if (MAS_WARN_ON(&mas,
+					(end < mt_min_slot_count(mas.node)) &&
+					(mas.max != ULONG_MAX))) {
 				pr_err("Invalid size %u of %p\n", end,
-				mas_mn(&mas));
-				MT_BUG_ON(mas.tree, 1);
+				       mas_mn(&mas));
 			}
-
 		}
 		mas_validate_parent_slot(&mas);
 		mas_validate_child_slot(&mas);
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

maple_tree-clean-up-mas_parent_enum-and-rename-to-mas_parent_type.patch
maple_tree-add-format-option-to-mt_dump.patch
maple_tree-convert-bug_on-to-mt_bug_on.patch
maple_tree-change-rcu-checks-to-warn_on-instead-of-bug_on.patch
maple_tree-convert-debug-code-to-use-mt_warn_on-and-mas_warn_on.patch

