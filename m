Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2143C25B08
	for <mm-commits@archiver.kernel.org>; Sat, 20 Aug 2022 21:12:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiHTVMt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 20 Aug 2022 17:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiHTVMs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 20 Aug 2022 17:12:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6FE3C8CF
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 14:12:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EF1E5CE0A19
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 21:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A382C433C1;
        Sat, 20 Aug 2022 21:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661029962;
        bh=n6S7Sx5356mHRYBvBHHbiQGDJqchidRhsNyuR66qBhU=;
        h=Date:To:From:Subject:From;
        b=XJ5P65wpReTFDL33RSdbVpb/Eh3N6GCoXog0ALkecAdGcRG9leC5m9tT0+YAv1CAs
         YArdHa2T2KQwv0XcNIVzwNZowADHkc8cKY40JCSDtuInYv+ci4yrwBtjnP7ngHRGn3
         25bsJG1twR6Ir4dQa1PS80HZfv1y0Pmb2eqF2Mig=
Date:   Sat, 20 Aug 2022 14:12:41 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-damon-validate-if-the-pmd-entry-is-present-before-accessing.patch removed from -mm tree
Message-Id: <20220820211242.1A382C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon: validate if the pmd entry is present before accessing
has been removed from the -mm tree.  Its filename was
     mm-damon-validate-if-the-pmd-entry-is-present-before-accessing.patch

This patch was dropped because an updated version will be merged

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
mm-damon-replace-pmd_huge-with-pmd_trans_huge-for-thp.patch

