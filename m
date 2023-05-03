Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77DA4C7EE21
	for <mm-commits@archiver.kernel.org>; Wed,  3 May 2023 00:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjECAWO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 20:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjECAWN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 20:22:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9BC1997
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 17:22:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A671629D6
        for <mm-commits@vger.kernel.org>; Wed,  3 May 2023 00:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC702C433EF;
        Wed,  3 May 2023 00:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683073330;
        bh=+0koOXTfHi0Eqndwr1BwDFOw5UbpI+2fMpySVA7fSXA=;
        h=Date:To:From:Subject:From;
        b=Mb+PIERX9a8U420ZKJ3xHhWBIX1zQYXDruCY3KvQo9q+eeBgs9cBp7PKy9VGVvZ6n
         kcFL4vWh45oEmRgcklHp0NlUk+JzWNg93hYZ3oXKo8A45XnbvT+Zo6fmcjoPkmrhkb
         rGSO/vLcVUTAxyg8lggzE4BvxrkYF3fErwwIuuDE=
Date:   Tue, 02 May 2023 17:22:09 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-minor-refactor-of-damon_pa_mark_accessed_or_deactivate.patch removed from -mm tree
Message-Id: <20230503002210.BC702C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/paddr: minor refactor of damon_pa_mark_accessed_or_deactivate()
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-minor-refactor-of-damon_pa_mark_accessed_or_deactivate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm/damon/paddr: minor refactor of damon_pa_mark_accessed_or_deactivate()
Date: Wed, 8 Mar 2023 16:33:10 +0800

Omit one line by unified folio_put(), and make code more clear.

Link: https://lkml.kernel.org/r/20230308083311.120951-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-minor-refactor-of-damon_pa_mark_accessed_or_deactivate
+++ a/mm/damon/paddr.c
@@ -268,16 +268,15 @@ static inline unsigned long damon_pa_mar
 		if (!folio)
 			continue;
 
-		if (damos_pa_filter_out(s, folio)) {
-			folio_put(folio);
-			continue;
-		}
+		if (damos_pa_filter_out(s, folio))
+			goto put_folio;
 
 		if (mark_accessed)
 			folio_mark_accessed(folio);
 		else
 			folio_deactivate(folio);
 		applied += folio_nr_pages(folio);
+put_folio:
 		folio_put(folio);
 	}
 	return applied * PAGE_SIZE;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


