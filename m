Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00D87C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jul 2022 16:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiGMQUM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jul 2022 12:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236502AbiGMQUL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2022 12:20:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7941425F
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 09:20:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BE78B8203D
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 16:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E49C34114;
        Wed, 13 Jul 2022 16:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657729208;
        bh=MTJwHQQYSuwJTVXK7KznohfSH2rreOQOSINBRCddhw8=;
        h=Date:To:From:Subject:From;
        b=mHBm5LVEKEgSQhvPamWk9z0USowdFQ/9RE8Sjpiksx7Xj/vTPefaC1besdz5U19Mt
         qGzJz6KTBdEnT2ymdK+v0nl1/ruYB2l2HBuxmdmgths5ml8nygR5vVqNxiYJWyKySr
         4hMmGJDb8kY1tyE2Lia4Lws+oxq55Gfz7roDa990=
Date:   Wed, 13 Jul 2022 09:20:07 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        hughd@google.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix.patch added to mm-unstable branch
Message-Id: <20220713162007.D5E49C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: fix locking issues in vma_expand()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm/mmap: fix locking issues in vma_expand()
Date: Tue, 12 Jul 2022 14:49:43 +0000

Hugh noted that the locking was mixed up in vma_expand(), revert to the
correct order.

Link: https://lkml.kernel.org/r/20220712144926.4190769-1-Liam.Howlett@oracle.com
Fixes: b2c87578e0ea (mm/mmap: use advanced maple tree API for mmap_region())
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/mm/mmap.c~mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix
+++ a/mm/mmap.c
@@ -677,7 +677,8 @@ inline int vma_expand(struct ma_state *m
 		if (next->anon_vma && !vma->anon_vma) {
 			int error;
 
-			vma->anon_vma = next->anon_vma;
+			anon_vma = next->anon_vma;
+			vma->anon_vma = anon_vma;
 			error = anon_vma_clone(vma, next);
 			if (error)
 				return error;
@@ -695,16 +696,19 @@ inline int vma_expand(struct ma_state *m
 
 	vma_adjust_trans_huge(vma, start, end, 0);
 
+	if (file) {
+		mapping = file->f_mapping;
+		root = &mapping->i_mmap;
+		uprobe_munmap(vma, vma->vm_start, vma->vm_end);
+		i_mmap_lock_write(mapping);
+	}
+
 	if (anon_vma) {
 		anon_vma_lock_write(anon_vma);
 		anon_vma_interval_tree_pre_update_vma(vma);
 	}
 
 	if (file) {
-		mapping = file->f_mapping;
-		root = &mapping->i_mmap;
-		uprobe_munmap(vma, vma->vm_start, vma->vm_end);
-		i_mmap_lock_write(mapping);
 		flush_dcache_mmap_lock(mapping);
 		vma_interval_tree_remove(vma, root);
 	}
@@ -735,16 +739,15 @@ inline int vma_expand(struct ma_state *m
 		mm->highest_vm_end = vm_end_gap(vma);
 	}
 
-	if (file) {
-		i_mmap_unlock_write(mapping);
-		uprobe_mmap(vma);
-	}
-
 	if (anon_vma) {
 		anon_vma_interval_tree_post_update_vma(vma);
 		anon_vma_unlock_write(anon_vma);
 	}
 
+	if (file) {
+		i_mmap_unlock_write(mapping);
+		uprobe_mmap(vma);
+	}
 
 	if (remove_next) {
 		if (file) {
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

android-binder-fix-lockdep-check-on-clearing-vma.patch
maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-2.patch
maple-tree-add-new-data-structure-fix-3.patch
maple-tree-add-new-data-structure-fix-4.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix-2.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix-3.patch
mm-mmap-change-do_brk_flags-to-expand-existing-vma-and-add-do_brk_munmap-fix.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix.patch
mm-remove-the-vma-linked-list-fix-3.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

