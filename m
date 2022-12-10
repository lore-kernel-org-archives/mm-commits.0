Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E2C1C4332F
	for <mm-commits@archiver.kernel.org>; Sat, 10 Dec 2022 01:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiLJB5Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Dec 2022 20:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiLJB5Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2022 20:57:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54653941B2
        for <mm-commits@vger.kernel.org>; Fri,  9 Dec 2022 17:57:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E532F622AA
        for <mm-commits@vger.kernel.org>; Sat, 10 Dec 2022 01:57:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4182AC433D2;
        Sat, 10 Dec 2022 01:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670637442;
        bh=2gJ07OKkA+zaZzD6aKfgZpQroSc26tyYxBx3Rncgjec=;
        h=Date:To:From:Subject:From;
        b=sWl7l02LaSdaszYLN8mYuZdTxUL+5wg0Z/p+/4nXlFAZGk6EqdcbuuO2jsNisEWZj
         4m+XuwTsnjvsPg1c9C7IqhL2ug6Z8YFCU5y0wvLkoQaT4eF4kAaR/YfAdfIkwCzRq5
         p37CDBgdDp6VVIacAUOnxmlqy5LPGY9paX8GZto0=
Date:   Fri, 09 Dec 2022 17:57:21 -0800
To:     mm-commits@vger.kernel.org, zhengjun.xing@linux.intel.com,
        yujie.liu@intel.com, ying.huang@intel.com, willy@infradead.org,
        shy828301@gmail.com, riel@surriel.com, regressions@leemhuis.info,
        nathan@kernel.org, fengwei.yin@intel.com, feng.tang@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] revert-mm-align-larger-anonymous-mappings-on-thp-boundaries.patch removed from -mm tree
Message-Id: <20221210015722.4182AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: revert "mm: align larger anonymous mappings on THP boundaries"
has been removed from the -mm tree.  Its filename was
     revert-mm-align-larger-anonymous-mappings-on-thp-boundaries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "mm: align larger anonymous mappings on THP boundaries"
Date: Thu Dec  1 01:22:56 PM PST 2022

Several testers are seeing large slowdowns from this commit.  The reasons
for this are unclear.  Revert it from 6.1-rcX so this can be better
examined.

Fixes: f35b5d7d676e ("mm: align larger anonymous mappings on THP boundaries")
Reported-by: kernel test robot <yujie.liu@intel.com>
  Link: https://lkml.kernel.org/r/202210181535.7144dd15-yujie.liu@intel.com
Reported-by: Nathan Chancellor <nathan@kernel.org>
  Link: https://lkml.kernel.org/r/Y1DNQaoPWxE+rGce@dev-arch.thelio-3990X
Reported-by: Thorsten Leemhuis <regressions@leemhuis.info>
  Link: https://lkml.kernel.org/r/e919e5a3-1118-043e-8bbd-5ee35f2ab411@leemhuis.info
Acked-by: Yang Shi <shy828301@gmail.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Cc: "Yin, Fengwei" <fengwei.yin@intel.com>
Cc: Yujie Liu <yujie.liu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/mmap.c~revert-mm-align-larger-anonymous-mappings-on-thp-boundaries
+++ a/mm/mmap.c
@@ -1779,9 +1779,6 @@ get_unmapped_area(struct file *file, uns
 		 */
 		pgoff = 0;
 		get_area = shmem_get_unmapped_area;
-	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
-		/* Ensures that larger anonymous mappings are THP aligned. */
-		get_area = thp_get_unmapped_area;
 	}
 
 	addr = get_area(file, addr, len, pgoff, flags);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-gup-remove-foll_migration-fix.patch
fsdax-zero-the-edges-if-source-is-hole-or-unwritten-fix.patch
mm-disable-top-tier-fallback-to-reclaim-on-proactive-reclaim-fix.patch

