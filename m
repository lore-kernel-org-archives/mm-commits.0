Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D25AC77B78
	for <mm-commits@archiver.kernel.org>; Wed,  3 May 2023 00:22:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjECAWU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 20:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjECAWN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 20:22:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFAD2680
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 17:22:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C11E629B3
        for <mm-commits@vger.kernel.org>; Wed,  3 May 2023 00:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1993C433EF;
        Wed,  3 May 2023 00:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683073331;
        bh=hus77NIfPfTIVsmJJo+48f/Clnxu8z3kgUgFtXsbyuk=;
        h=Date:To:From:Subject:From;
        b=zxkikX6GDz1pKGfXLMBlcNRE6N6FzGg9BTn8UBv2LplAWqyGjkWQa2cfWivFseLor
         s9ibFTLKB9EcK1D5wE+zKy0vHX6+QiNfQA23Wds/f/HqtsNHuANCps08l0sCqcDRTX
         f7CGvQRjo6Dp0+AyG0aKYX20A+QXSR8kohvjIaFY=
Date:   Tue, 02 May 2023 17:22:11 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-fix-missing-folio_sz-update-in-damon_pa_young.patch removed from -mm tree
Message-Id: <20230503002211.C1993C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/paddr: fix missing folio_sz update in damon_pa_young()
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-fix-missing-folio_sz-update-in-damon_pa_young.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm/damon/paddr: fix missing folio_sz update in damon_pa_young()
Date: Wed, 8 Mar 2023 16:33:11 +0800

The *folio_sz in damon_pa_young() will be used(as last_folio_sz) by
__damon_pa_check_access(), so it's need to be updated, fix missing branch.

Link: https://lkml.kernel.org/r/20230308083311.120951-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-fix-missing-folio_sz-update-in-damon_pa_young
+++ a/mm/damon/paddr.c
@@ -134,10 +134,8 @@ static bool damon_pa_young(unsigned long
 	}
 
 	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
-	if (need_lock && !folio_trylock(folio)) {
-		folio_put(folio);
-		return false;
-	}
+	if (need_lock && !folio_trylock(folio))
+		goto out;
 
 	rmap_walk(folio, &rwc);
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


