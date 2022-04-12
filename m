Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1211AC43217
	for <mm-commits@archiver.kernel.org>; Tue, 12 Apr 2022 23:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiDLXcK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiDLXb6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Apr 2022 19:31:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F1F90FE9
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 15:18:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBD6AB82053
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 22:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82147C385A5;
        Tue, 12 Apr 2022 22:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649801877;
        bh=f5TH381SD1TdD/bIGcrkGN9UCl8B6rpTDjztD1B5RY4=;
        h=Date:To:From:Subject:From;
        b=iFWJB5UBjSLYi8CtncrRApeI/qvJuEsynDODiRG50HY2h2HCZKAMTlTmdfwizhwB/
         NM7f+YCeXo0/+IOkY85d+hAcpN5w0XXA81jdHMlzQwCyVyMkCCJiY5k4Jt6rw5p1HN
         e2M1lyxU20zMLj2WsuPCMzEIPC+ASDUQiQy/3IUk=
Date:   Tue, 12 Apr 2022 15:17:56 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, songmuchun@bytedance.com, apopple@nvidia.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-simplify-the-refcount-validation-when-migrating-hugetlb-mapping.patch added to -mm tree
Message-Id: <20220412221757.82147C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: simplify the refcount validation when migrating hugetlb mapping
has been added to the -mm tree.  Its filename is
     mm-migrate-simplify-the-refcount-validation-when-migrating-hugetlb-mapping.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-simplify-the-refcount-validation-when-migrating-hugetlb-mapping.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-simplify-the-refcount-validation-when-migrating-hugetlb-mapping.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: migrate: simplify the refcount validation when migrating hugetlb mapping

There is no need to validate the hugetlb page's refcount before trying to
freeze the hugetlb page's expected refcount, instead we can just rely on
the page_ref_freeze() to simplify the validation.

Moreover we are always under the page lock when migrating the hugetlb page
mapping, which means nowhere else can remove it from the page cache, so we
can remove the xas_load() validation under the i_pages lock.

Link: https://lkml.kernel.org/r/eb2fbbeaef2b1714097b9dec457426d682ee0635.1649676424.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/migrate.c~mm-migrate-simplify-the-refcount-validation-when-migrating-hugetlb-mapping
+++ a/mm/migrate.c
@@ -477,11 +477,6 @@ int migrate_huge_page_move_mapping(struc
 
 	xas_lock_irq(&xas);
 	expected_count = 2 + page_has_private(page);
-	if (page_count(page) != expected_count || xas_load(&xas) != page) {
-		xas_unlock_irq(&xas);
-		return -EAGAIN;
-	}
-
 	if (!page_ref_freeze(page, expected_count)) {
 		xas_unlock_irq(&xas);
 		return -EAGAIN;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-migrate-simplify-the-refcount-validation-when-migrating-hugetlb-mapping.patch

