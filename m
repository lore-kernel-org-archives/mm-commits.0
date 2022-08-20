Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 643BCC32772
	for <mm-commits@archiver.kernel.org>; Sat, 20 Aug 2022 21:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiHTVUf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 20 Aug 2022 17:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiHTVUe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 20 Aug 2022 17:20:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8EF40BCA
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 14:20:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4878E609D0
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 21:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A760C433D6;
        Sat, 20 Aug 2022 21:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661030432;
        bh=P7n9R9JAHNhFKo/hG7I2hepb2lIzxngsiay7uy/CSAc=;
        h=Date:To:From:Subject:From;
        b=hhZwDyTJ/vjSEaKF14TZczVpf/iEqZyU3oSHz7GT+A+J5UABBopM+62hVjZnR4vvo
         qvA4RnEGCVq9/H9p3/CrDlsTln6LH5px6rRR7qktlTMGZ6Cu6HlsTVysMXSWsRjisC
         0RJ80bvl3Laxq+81LIjExYNgSVzEevMqQ/6IYCyM=
Date:   Sat, 20 Aug 2022 14:20:31 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        sj@kernel.org, mike.kravetz@oracle.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-replace-pmd_huge-with-pmd_trans_huge-for-thp.patch added to mm-unstable branch
Message-Id: <20220820212032.9A760C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: replace pmd_huge() with pmd_trans_huge() for THP
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-replace-pmd_huge-with-pmd_trans_huge-for-thp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-replace-pmd_huge-with-pmd_trans_huge-for-thp.patch

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

mm-migrate-do-not-retry-10-times-for-the-subpages-of-fail-to-migrate-thp.patch
mm-damon-validate-if-the-pmd-entry-is-present-before-accessing.patch
mm-damon-replace-pmd_huge-with-pmd_trans_huge-for-thp.patch

