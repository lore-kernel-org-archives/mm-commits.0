Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9A2CC54EE9
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiILDcm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiILDaq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:30:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE69FD31
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CCF461171
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729F9C433D7;
        Mon, 12 Sep 2022 03:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953378;
        bh=9gNMcrRPo/RxEVhXfMK2urduXI+WWK22dUHnGrsxIwQ=;
        h=Date:To:From:Subject:From;
        b=AAWHwKIjgMu8jCvVTQ4vapw14YdWBHJZuV3vC1vBRizXB1uLJuE5qZq0WtEJnfeli
         eZLRmMjXi2ZzInbNkN+bfH/N/S7epfdx8HGT22EYJzN8ehgRoPMFegTeYf17mmuUVr
         MkWxcHdEalHQjpD3GJ2nUCYsJW9NHkOARPfXGwSk=
Date:   Sun, 11 Sep 2022 20:29:37 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        sj@kernel.org, mike.kravetz@oracle.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-replace-pmd_huge-with-pmd_trans_huge-for-thp.patch removed from -mm tree
Message-Id: <20220912032938.729F9C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon: replace pmd_huge() with pmd_trans_huge() for THP
has been removed from the -mm tree.  Its filename was
     mm-damon-replace-pmd_huge-with-pmd_trans_huge-for-thp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm/damon: replace pmd_huge() with pmd_trans_huge() for THP
Date: Thu, 18 Aug 2022 15:37:44 +0800

pmd_huge() is usually used to indicate a pmd level hugetlb.  However a pmd
mapped huge page can only be THP in damon_mkold_pmd_entry() or
damon_young_pmd_entry(), so replace pmd_huge() with pmd_trans_huge() in
this case to make the code more readable according to the discussion [1].

[1] https://lore.kernel.org/all/098c1480-416d-bca9-cedb-ca495df69b64@linux.alibaba.com/

Link: https://lkml.kernel.org/r/a9e010ca5d299e18d740c7c52290ecb6a014dde6.1660805030.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-replace-pmd_huge-with-pmd_trans_huge-for-thp
+++ a/mm/damon/vaddr.c
@@ -302,14 +302,14 @@ static int damon_mkold_pmd_entry(pmd_t *
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	if (pmd_huge(*pmd)) {
+	if (pmd_trans_huge(*pmd)) {
 		ptl = pmd_lock(walk->mm, pmd);
 		if (!pmd_present(*pmd)) {
 			spin_unlock(ptl);
 			return 0;
 		}
 
-		if (pmd_huge(*pmd)) {
+		if (pmd_trans_huge(*pmd)) {
 			damon_pmdp_mkold(pmd, walk->mm, addr);
 			spin_unlock(ptl);
 			return 0;
@@ -434,14 +434,14 @@ static int damon_young_pmd_entry(pmd_t *
 	struct damon_young_walk_private *priv = walk->private;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (pmd_huge(*pmd)) {
+	if (pmd_trans_huge(*pmd)) {
 		ptl = pmd_lock(walk->mm, pmd);
 		if (!pmd_present(*pmd)) {
 			spin_unlock(ptl);
 			return 0;
 		}
 
-		if (!pmd_huge(*pmd)) {
+		if (!pmd_trans_huge(*pmd)) {
 			spin_unlock(ptl);
 			goto regular_page;
 		}
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-hugetlb-fix-races-when-looking-up-a-cont-pte-pmd-size-hugetlb-page.patch
mm-migrate-do-not-retry-10-times-for-the-subpages-of-fail-to-migrate-thp.patch

