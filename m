Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ADDFEB64DD
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 18:59:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjGXS7n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 14:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbjGXS7m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 14:59:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D663110D1
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 11:59:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62C81613DC
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 18:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A0CC433C8;
        Mon, 24 Jul 2023 18:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690225178;
        bh=2ulMxVpzu8+ePOuecxQzC5pf7zt4AUetMWLHsDVKyLs=;
        h=Date:To:From:Subject:From;
        b=S1TATASFr0czm8pXECLUaPcHTo+1wFxArF+cQrlylipBC5e6D+tlm5Lh8YSvXrqTy
         FDwb6Fc8ZpGNOguVeYCZv4cz/7/EF98RSkT0DyjmokVLzkhv9XvCmenibZfe3RoVRZ
         K9gdIjXs7xIN3cbVhIHNPSG+So4cS5YdJEFKSIEw=
Date:   Mon, 24 Jul 2023 11:59:38 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        surenb@google.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null.patch added to mm-unstable branch
Message-Id: <20230724185938.92A0CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: move mas_wr_end_piv() below mas_wr_extend_null()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null.patch

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
Subject: maple_tree: move mas_wr_end_piv() below mas_wr_extend_null()
Date: Mon, 24 Jul 2023 14:31:53 -0400

Relocate it and call mas_wr_extend_null() from within mas_wr_end_piv().
Extending the NULL may affect the end pivot value so call
mas_wr_endtend_null() from within mas_wr_end_piv() to keep it all
together.

Link: https://lkml.kernel.org/r/20230724183157.3939892-12-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

--- a/lib/maple_tree.c~maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null
+++ a/lib/maple_tree.c
@@ -4180,18 +4180,6 @@ static inline bool mas_wr_slot_store(str
 	return true;
 }
 
-static inline void mas_wr_end_piv(struct ma_wr_state *wr_mas)
-{
-	while ((wr_mas->offset_end < wr_mas->node_end) &&
-	       (wr_mas->mas->last > wr_mas->pivots[wr_mas->offset_end]))
-		wr_mas->offset_end++;
-
-	if (wr_mas->offset_end < wr_mas->node_end)
-		wr_mas->end_piv = wr_mas->pivots[wr_mas->offset_end];
-	else
-		wr_mas->end_piv = wr_mas->mas->max;
-}
-
 static inline void mas_wr_extend_null(struct ma_wr_state *wr_mas)
 {
 	struct ma_state *mas = wr_mas->mas;
@@ -4228,6 +4216,21 @@ static inline void mas_wr_extend_null(st
 	}
 }
 
+static inline void mas_wr_end_piv(struct ma_wr_state *wr_mas)
+{
+	while ((wr_mas->offset_end < wr_mas->node_end) &&
+	       (wr_mas->mas->last > wr_mas->pivots[wr_mas->offset_end]))
+		wr_mas->offset_end++;
+
+	if (wr_mas->offset_end < wr_mas->node_end)
+		wr_mas->end_piv = wr_mas->pivots[wr_mas->offset_end];
+	else
+		wr_mas->end_piv = wr_mas->mas->max;
+
+	if (!wr_mas->entry)
+		mas_wr_extend_null(wr_mas);
+}
+
 static inline unsigned char mas_wr_new_end(struct ma_wr_state *wr_mas)
 {
 	struct ma_state *mas = wr_mas->mas;
@@ -4371,10 +4374,6 @@ static inline void *mas_wr_store_entry(s
 
 	/* At this point, we are at the leaf node that needs to be altered. */
 	mas_wr_end_piv(wr_mas);
-
-	if (!wr_mas->entry)
-		mas_wr_extend_null(wr_mas);
-
 	/* New root for a single pointer */
 	if (unlikely(!mas->index && mas->last == ULONG_MAX)) {
 		mas_new_root(mas, wr_mas->entry);
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

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

