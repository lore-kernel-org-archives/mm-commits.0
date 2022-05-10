Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D45DC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235922AbiEJEPf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235987AbiEJEOw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:14:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD76B237C5
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:10:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 652D961736
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF428C385C5;
        Tue, 10 May 2022 04:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155855;
        bh=Izk7g325GP+ks9YSp5PIktRaVBR3DNuYJwC4VmvcbEU=;
        h=Date:To:From:Subject:From;
        b=Qc/1BKaPQEvi2CFwhjASRGsbwQiyOntu+w3BZxXEmb6LJvbEtNduJGUTbx0FLAtEo
         kUrlk7PAbqd6Zy2qnh/gnf3R3lfm/+8JL+puWP1r83K442pEo5GfiC7a0xp5Mgf+zL
         9x8ZhbVaGemnltUCqyDW38RjjIyPfZIZbf2kAXo0=
Date:   Mon, 09 May 2022 21:10:55 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        naoya.horiguchi@nec.com, liqiong@nfschina.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-unnecessary-void-conversions.patch removed from -mm tree
Message-Id: <20220510041055.BF428C385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory-failure.c: remove unnecessary (void*) conversions
has been removed from the -mm tree.  Its filename was
     mm-remove-unnecessary-void-conversions.patch

This patch was dropped because it was merged into mm-stable

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


