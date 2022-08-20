Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B938C25B08
	for <mm-commits@archiver.kernel.org>; Sat, 20 Aug 2022 21:20:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbiHTVUe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 20 Aug 2022 17:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiHTVUd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 20 Aug 2022 17:20:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D6640BC5
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 14:20:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 423BE6091A
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 21:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B19FC433D7;
        Sat, 20 Aug 2022 21:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661030430;
        bh=TXG/3JL/hRj1Luwkq3cn3LKoJc0ipr1vy3euCHgsqBw=;
        h=Date:To:From:Subject:From;
        b=jqQra5z47/WJultVwQQVEcEmyNc+akFh+4YOkd84sdnl318oyvEAQ6cS1gCfG+hXI
         JHbO+pOqFpjrQJ/tBDe/M/3G1kbQzb1nFe9W9zPbLdUnVTEJtgXnOeXYGgQxxfaHmM
         4NmJS6GJALEfqDq1/5SqRufl3rnkILfOdFSgW2Lc=
Date:   Sat, 20 Aug 2022 14:20:29 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        sj@kernel.org, mike.kravetz@oracle.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-validate-if-the-pmd-entry-is-present-before-accessing.patch added to mm-unstable branch
Message-Id: <20220820212030.8B19FC433D7@smtp.kernel.org>
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
Date: Thu, 18 Aug 2022 15:37:43 +0800

pmd_huge() is used to validate if the pmd entry is mapped by a huge page,
also including the case of non-present (migration or hwpoisoned) pmd entry
on arm64 or x86 architectures.  This means that pmd_pfn() can not get the
correct pfn number for a non-present pmd entry, which will cause
damon_get_page() to get an incorrect page struct (also may be NULL by
pfn_to_online_page()), making the access statistics incorrect.

Moreover it does not make sense that we still waste time to get the page
of the non-present entry.  Just treat it as not-accessed and skip it,
which maintains consistency with non-present pte level entries.

So add pmd entry present validation to fix the above issues.

Link: https://lkml.kernel.org/r/58b1d1f5fbda7db49ca886d9ef6783e3dcbbbc98.1660805030.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
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
mm-damon-replace-pmd_huge-with-pmd_trans_huge-for-thp.patch

