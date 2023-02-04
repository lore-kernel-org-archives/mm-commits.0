Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25D78C05027
	for <mm-commits@archiver.kernel.org>; Sat,  4 Feb 2023 01:53:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233172AbjBDBxH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 20:53:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbjBDBxF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 20:53:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB856E9B
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 17:53:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CAE3B815C8
        for <mm-commits@vger.kernel.org>; Sat,  4 Feb 2023 01:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22B7C433EF;
        Sat,  4 Feb 2023 01:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675475580;
        bh=GjcNOOveihLkJfXK0l4lbB2OfAVEMuGkg1arSBEN6k4=;
        h=Date:To:From:Subject:From;
        b=LNp9byHImslKAt6gHjzevlTSsXDmRYPkJcXz9TknLIZ99tAnHpWtuit2ZIGIGyy5w
         p1eFM/3n5m2YpcEFY/tnC2x41et1pMtqb8rOTkOdlwwe9NM3PZJb3K4ruPOkl6pLWq
         wZF98Bf1bzqlFuoWkpjkpC6gA/b1VtYMYI/8qjUs=
Date:   Fri, 03 Feb 2023 17:52:58 -0800
To:     mm-commits@vger.kernel.org, matthias.bgg@gmail.com,
        jhubbard@nvidia.com, david@redhat.com, chinwen.chang@mediatek.com,
        baolin.wang@linux.alibaba.com, apopple@nvidia.com,
        andrew.yang@mediatek.com, Kuan-Ying.Lee@mediatek.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-gup-add-folio-to-list-when-folio_isolate_lru-succeed.patch removed from -mm tree
Message-Id: <20230204015300.A22B7C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: add folio to list when folio_isolate_lru() succeed
has been removed from the -mm tree.  Its filename was
     mm-gup-add-folio-to-list-when-folio_isolate_lru-succeed.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Subject: mm/gup: add folio to list when folio_isolate_lru() succeed
Date: Tue, 31 Jan 2023 14:32:06 +0800

If we call folio_isolate_lru() successfully, we will get return value 0. 
We need to add this folio to the movable_pages_list.

Link: https://lkml.kernel.org/r/20230131063206.28820-1-Kuan-Ying.Lee@mediatek.com
Fixes: 67e139b02d99 ("mm/gup.c: refactor check_and_migrate_movable_pages()")
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Andrew Yang <andrew.yang@mediatek.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/gup.c~mm-gup-add-folio-to-list-when-folio_isolate_lru-succeed
+++ a/mm/gup.c
@@ -1914,7 +1914,7 @@ static unsigned long collect_longterm_un
 			drain_allow = false;
 		}
 
-		if (!folio_isolate_lru(folio))
+		if (folio_isolate_lru(folio))
 			continue;
 
 		list_add_tail(&folio->lru, movable_page_list);
_

Patches currently in -mm which might be from Kuan-Ying.Lee@mediatek.com are

kasan-infer-allocation-size-by-scanning-metadata.patch

