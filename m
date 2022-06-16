Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97574C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jun 2022 19:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbiFPT7A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 15:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiFPT67 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 15:58:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD065A159
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 12:58:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24C6DB82276
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B628FC34114;
        Thu, 16 Jun 2022 19:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655409535;
        bh=TA9NfPYZ1Ujot6ZQTt8Z0lrSWqIWu8Ufk5nErqTJaUI=;
        h=Date:To:From:Subject:From;
        b=A+ZP+BSSL1+nsiEDRVirYRCUj+NClODyHNufAZs/XB3SuAbC1XOk/thbQXEbcvFid
         XYsgIhdQPsAY0w6S8kyyVaMHB52sg+psIPZSn037lPUQuG+yuInao8aDZXmwzSdFRN
         WM4XiLCkG9aUezEGXf9D5IVx/1WwchK0SZqRQRx0=
Date:   Thu, 16 Jun 2022 12:58:54 -0700
To:     mm-commits@vger.kernel.org, quic_qiancai@quicinc.com,
        Liam.Howlett@oracle.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-add-new-data-structure-fix-8-fix.patch added to mm-unstable branch
Message-Id: <20220616195855.B628FC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: Change spanning store to work on larger trees
has been added to the -mm mm-unstable branch.  Its filename is
     maple-tree-add-new-data-structure-fix-8-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple-tree-add-new-data-structure-fix-8-fix.patch

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
Subject: maple_tree: Change spanning store to work on larger trees
Date: Thu, 16 Jun 2022 01:17:55 +0000

remove debug printks

Link: https://lkml.kernel.org/r/20220616011739.802669-3-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Qian Cai <quic_qiancai@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   16 ----------------
 1 file changed, 16 deletions(-)

--- a/lib/maple_tree.c~maple-tree-add-new-data-structure-fix-8-fix
+++ a/lib/maple_tree.c
@@ -3017,15 +3017,6 @@ static int mas_spanning_rebalance(struct
 
 		/* Copy anything necessary out of the right node. */
 		mast_combine_cp_right(mast);
-		if (mte_dead_node(mast->orig_l->node) ||
-		    mte_dead_node(mast->orig_r->node)) {
-			printk("FUCKED.  l %p is %s and r %p is %s\n",
-			       mas_mn(mast->orig_l),
-			       mte_dead_node(mast->orig_l->node) ? "dead" : "alive",
-			       mas_mn(mast->orig_r),
-			       mte_dead_node(mast->orig_r->node) ? "dead" : "alive");
-			printk("Writing %lu-%lu\n", mas->index, mas->last);
-		}
 		mast_topiary(mast);
 		mast->orig_l->last = mast->orig_l->max;
 
@@ -4019,13 +4010,6 @@ static inline int mas_wr_spanning_store(
 	mast.bn = &b_node;
 	mast.orig_l = &l_mas;
 	mast.orig_r = &r_mas;
-		if (mte_dead_node(mast.orig_l->node) ||
-		    mte_dead_node(mast.orig_r->node)) {
-			printk("FUCKED.  l is %s and r is %s\n",
-		       mte_dead_node(mast.orig_l->node) ? "dead" : "alive",
-		       mte_dead_node(mast.orig_r->node) ? "dead" : "alive");
-			printk("Writing %lu-%lu\n", mas->index, mas->last);
-		}
 	/* Combine l_mas and r_mas and split them up evenly again. */
 	return mas_spanning_rebalance(mas, &mast, height + 1);
 }
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-2.patch
maple-tree-add-new-data-structure-fix-3.patch
maple-tree-add-new-data-structure-fix-4.patch
maple-tree-add-new-data-structure-fix-7.patch
maple-tree-add-new-data-structure-fix-8.patch
maple-tree-add-new-data-structure-fix-8-fix.patch
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

