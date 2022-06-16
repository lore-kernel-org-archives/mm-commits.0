Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B690EC43334
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jun 2022 18:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbiFPSlv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 14:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiFPSlu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 14:41:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D2C54BCC
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 11:41:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90482B825A0
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 18:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B428C3411B;
        Thu, 16 Jun 2022 18:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655404907;
        bh=iHcoad+DhzPyzQKTMvwOpv5Sy0IRXbC6SrKwyBvoZ4U=;
        h=Date:To:From:Subject:From;
        b=MCCBaAQQah/Z5E6gd+ho7EsZclsbingh6ZIPFFqIcd8Qm5m/P0e7kki4THlQv6ap6
         1wrFfwV5A5DOZaWca1sKqj8ekOfHXx5Pnj5sB+p2GiTAJGm/a+yNOunVnfDm1qALYS
         0VZr7CJ4r/MScQzFtRM0OZUM4MjHttlKelsQagFc=
Date:   Thu, 16 Jun 2022 11:41:46 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-3.patch added to mm-unstable branch
Message-Id: <20220616184147.2B428C3411B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: allow vma_expand() to lock both anon and file locks
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-3.patch

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
Subject: mm/mmap: allow vma_expand() to lock both anon and file locks
Date: Thu, 16 Jun 2022 18:33:06 +0000

vma_expand() was only locking either file or anon based locks but could
unlock both.  This caused a locking error in trinity fuzzer.  Allow both
locks to be taken and released.

Link: https://lkml.kernel.org/r/20220616183258.1153609-1-Liam.Howlett@oracle.com
Fixes: a5985220056d (mm/mmap: use advanced maple tree API for mmap_region())
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/mm/mmap.c~mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-3
+++ a/mm/mmap.c
@@ -694,6 +694,11 @@ inline int vma_expand(struct ma_state *m
 
 	vma_adjust_trans_huge(vma, start, end, 0);
 
+	if (anon_vma) {
+		anon_vma_lock_write(anon_vma);
+		anon_vma_interval_tree_pre_update_vma(vma);
+	}
+
 	if (file) {
 		mapping = file->f_mapping;
 		root = &mapping->i_mmap;
@@ -701,9 +706,6 @@ inline int vma_expand(struct ma_state *m
 		i_mmap_lock_write(mapping);
 		flush_dcache_mmap_lock(mapping);
 		vma_interval_tree_remove(vma, root);
-	} else if (anon_vma) {
-		anon_vma_lock_write(anon_vma);
-		anon_vma_interval_tree_pre_update_vma(vma);
 	}
 
 	vma->vm_start = start;
@@ -732,15 +734,16 @@ inline int vma_expand(struct ma_state *m
 		mm->highest_vm_end = vm_end_gap(vma);
 	}
 
+	if (file) {
+		i_mmap_unlock_write(mapping);
+		uprobe_mmap(vma);
+	}
+
 	if (anon_vma) {
 		anon_vma_interval_tree_post_update_vma(vma);
 		anon_vma_unlock_write(anon_vma);
 	}
 
-	if (file) {
-		i_mmap_unlock_write(mapping);
-		uprobe_mmap(vma);
-	}
 
 	if (remove_next) {
 		if (file) {
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-2.patch
maple-tree-add-new-data-structure-fix-3.patch
maple-tree-add-new-data-structure-fix-4.patch
maple-tree-add-new-data-structure-fix-7.patch
maple-tree-add-new-data-structure-fix-8.patch
maple-tree-add-new-data-structure-fix-9.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix-2.patch
mm-start-tracking-vmas-with-maple-tree-fix-2.patch
mm-start-tracking-vmas-with-maple-tree-fix-3.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-2.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-3.patch
mm-mmap-change-do_brk_munmap-to-use-do_mas_align_munmap-fix.patch
mm-remove-the-vma-linked-list-fix.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

