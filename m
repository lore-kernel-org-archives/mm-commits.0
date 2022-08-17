Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D7BDC25B08
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 16:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240791AbiHQQIW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 12:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240893AbiHQQII (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 12:08:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEAFA0252
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 09:08:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35B88B81CB2
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 16:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F25C433C1;
        Wed, 17 Aug 2022 16:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660752479;
        bh=TS1DfO+Jn4E7RFnn+RaK2URPrcoAOiNEMBSTF73ojP0=;
        h=Date:To:From:Subject:From;
        b=qptC1xmIuwSHk6/Gz8WXIJSB+lR3YvQQFPXeeP1BuCLOTdW3xxLr+FTe57ZYCZCAd
         5+3h6U/uYt9vLbgTnaVvyXk74RLZ0YFYdskXsM8ZPZGy+bck6mbXof2GHRe7pva9XF
         gNtRpRG5cihwhwLOPwnj8MyUIJGKQcYHj/ulmma4=
Date:   Wed, 17 Aug 2022 09:07:59 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-validate-if-the-pmd-entry-is-present-before-accessing.patch added to mm-unstable branch
Message-Id: <20220817160759.D1F25C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: validate if the pmd entry is present before accessing
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-validate-if-the-pmd-entry-is-present-before-accessing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-validate-if-the-pmd-entry-is-present-before-accessing.patch

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
Subject: mm/damon: validate if the pmd entry is present before accessing
Date: Wed, 17 Aug 2022 14:21:12 +0800

The pmd_huge() is used to validate if the pmd entry is mapped by a huge
page, also including the case of non-present (migration or hwpoisoned) pmd
entry on arm64 or x86 architectures.  Thus we should validate if it is
present before making the pmd entry old or getting young state, otherwise
we can not get the correct corresponding page.

Link: https://lkml.kernel.org/r/2838b6737bc259cf575ff11fd1c4b7fdb340fa73.1660717122.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/damon/vaddr.c~mm-damon-validate-if-the-pmd-entry-is-present-before-accessing
+++ a/mm/damon/vaddr.c
@@ -304,6 +304,11 @@ static int damon_mkold_pmd_entry(pmd_t *
 
 	if (pmd_huge(*pmd)) {
 		ptl = pmd_lock(walk->mm, pmd);
+		if (!pmd_present(*pmd)) {
+			spin_unlock(ptl);
+			return 0;
+		}
+
 		if (pmd_huge(*pmd)) {
 			damon_pmdp_mkold(pmd, walk->mm, addr);
 			spin_unlock(ptl);
@@ -431,6 +436,11 @@ static int damon_young_pmd_entry(pmd_t *
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	if (pmd_huge(*pmd)) {
 		ptl = pmd_lock(walk->mm, pmd);
+		if (!pmd_present(*pmd)) {
+			spin_unlock(ptl);
+			return 0;
+		}
+
 		if (!pmd_huge(*pmd)) {
 			spin_unlock(ptl);
 			goto regular_page;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-migrate-do-not-retry-10-times-for-the-subpages-of-fail-to-migrate-thp.patch
mm-damon-validate-if-the-pmd-entry-is-present-before-accessing.patch

