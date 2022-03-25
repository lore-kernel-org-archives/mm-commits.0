Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6841C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 23:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234107AbiCYXMd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 19:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234029AbiCYXMc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 19:12:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD0549910
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 16:10:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10720B82A30
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 23:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D490C2BBE4;
        Fri, 25 Mar 2022 23:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648249854;
        bh=OZBAtxrzb0jtBOmirALMNXHpkleIOnsAon5GzYYqrFg=;
        h=Date:To:From:Subject:From;
        b=HBLJrQWCbdDsk45pM6TczBHI/WLc3eYtlrAnrQMbFlaR1LuuYD8alk8DOl9DOTtRx
         3dqKwrvpxxCq4g+VoH14Mtb2FMrt8AhobnyDjl1XmfB+SxHmUupz4WY4BOgNh9aboM
         U9A0s6ahz8pnSlEjY1S8B8ueWeDraWb10GK0T6bw=
Date:   Fri, 25 Mar 2022 16:10:54 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        naoya.horiguchi@nec.com, liqiong@nfschina.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-unnecessary-void-conversions.patch added to -mm tree
Message-Id: <20220325231054.9D490C2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: remove unnecessary (void*) conversions
has been added to the -mm tree.  Its filename is
     mm-remove-unnecessary-void-conversions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-unnecessary-void-conversions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-unnecessary-void-conversions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: liqiong <liqiong@nfschina.com>
Subject: mm/memory-failure.c: remove unnecessary (void*) conversions

No need cast (void*) to (struct hwp_walk*).

Link: https://lkml.kernel.org/r/20220322142826.25939-1-liqiong@nfschina.com
Signed-off-by: liqiong <liqiong@nfschina.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-remove-unnecessary-void-conversions
+++ a/mm/memory-failure.c
@@ -622,7 +622,7 @@ static int check_hwpoisoned_pmd_entry(pm
 static int hwpoison_pte_range(pmd_t *pmdp, unsigned long addr,
 			      unsigned long end, struct mm_walk *walk)
 {
-	struct hwp_walk *hwp = (struct hwp_walk *)walk->private;
+	struct hwp_walk *hwp = walk->private;
 	int ret = 0;
 	pte_t *ptep, *mapped_pte;
 	spinlock_t *ptl;
@@ -656,7 +656,7 @@ static int hwpoison_hugetlb_range(pte_t
 			    unsigned long addr, unsigned long end,
 			    struct mm_walk *walk)
 {
-	struct hwp_walk *hwp = (struct hwp_walk *)walk->private;
+	struct hwp_walk *hwp = walk->private;
 	pte_t pte = huge_ptep_get(ptep);
 	struct hstate *h = hstate_vma(walk->vma);
 
_

Patches currently in -mm which might be from liqiong@nfschina.com are

mm-remove-unnecessary-void-conversions.patch

