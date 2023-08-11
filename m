Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06A27C04FDF
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:01:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236848AbjHKXBx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237000AbjHKXAf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B27359F
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B919D634A6
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C971C433C7;
        Fri, 11 Aug 2023 23:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794819;
        bh=qSUHbtpUIZgA+GhB38MgUoFenwVJFEd/uAeiSvdOmII=;
        h=Date:To:From:Subject:From;
        b=2JYnojVl/j09m8SvjXt5ffUUkvozp5OvwT2yYsIGmQawau7vB6FdRrWAzrZC8p5Ca
         D2B1SZOkFqfyshhEYox18lKYxPQSMekiNCmAciRpD9KtPMiwhSjRPQOkwy/OEfDfCU
         E0nA+OHlh3lg+lSrl0mR/FA7mQLIvoSi3nfyy+CM=
Date:   Fri, 11 Aug 2023 16:00:18 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        geert@linux-m68k.org, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-make-mas_validate_limits-check-root-node-and-node-limit.patch removed from -mm tree
Message-Id: <20230811230019.1C971C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: make mas_validate_limits() check root node and node limit
has been removed from the -mm tree.  Its filename was
     maple_tree-make-mas_validate_limits-check-root-node-and-node-limit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: make mas_validate_limits() check root node and node limit
Date: Tue, 11 Jul 2023 11:54:41 +0800

Update mas_validate_limits() to check root node, check node limit pivot if
there is enough room for it to exist and check data_end.  Remove the check
for child existence as it is done in mas_validate_child_slot().

Link: https://lkml.kernel.org/r/20230711035444.526-6-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- a/lib/maple_tree.c~maple_tree-make-mas_validate_limits-check-root-node-and-node-limit
+++ a/lib/maple_tree.c
@@ -7120,7 +7120,9 @@ static void mas_validate_child_slot(stru
 }
 
 /*
- * Validate all pivots are within mas->min and mas->max.
+ * Validate all pivots are within mas->min and mas->max, check metadata ends
+ * where the maximum ends and ensure there is no slots or pivots set outside of
+ * the end of the data.
  */
 static void mas_validate_limits(struct ma_state *mas)
 {
@@ -7130,26 +7132,15 @@ static void mas_validate_limits(struct m
 	void __rcu **slots = ma_slots(mte_to_node(mas->node), type);
 	unsigned long *pivots = ma_pivots(mas_mn(mas), type);
 
-	/* all limits are fine here. */
-	if (mte_is_root(mas->node))
-		return;
-
 	for (i = 0; i < mt_slots[type]; i++) {
 		unsigned long piv;
 
 		piv = mas_safe_pivot(mas, pivots, i, type);
 
-		if (!piv && (i != 0))
-			break;
-
-		if (!mte_is_leaf(mas->node)) {
-			void *entry = mas_slot(mas, slots, i);
-
-			if (!entry)
-				pr_err("%p[%u] cannot be null\n",
-				       mas_mn(mas), i);
-
-			MT_BUG_ON(mas->tree, !entry);
+		if (!piv && (i != 0)) {
+			pr_err("Missing node limit pivot at %p[%u]",
+			       mas_mn(mas), i);
+			MAS_WARN_ON(mas, 1);
 		}
 
 		if (prev_piv > piv) {
@@ -7172,6 +7163,13 @@ static void mas_validate_limits(struct m
 		if (piv == mas->max)
 			break;
 	}
+
+	if (mas_data_end(mas) != i) {
+		pr_err("node%p: data_end %u != the last slot offset %u\n",
+		       mas_mn(mas), mas_data_end(mas), i);
+		MT_BUG_ON(mas->tree, 1);
+	}
+
 	for (i += 1; i < mt_slots[type]; i++) {
 		void *entry = mas_slot(mas, slots, i);
 
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are


