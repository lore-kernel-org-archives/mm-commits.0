Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A7B1C25B6E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:49:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbjJYXtg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbjJYXst (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8800D18B
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5504FC433C7;
        Wed, 25 Oct 2023 23:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277726;
        bh=iA38UQnChMEOrbfFvX/Q/9Ugxtf2DJfMjNNk3Nz9Htw=;
        h=Date:To:From:Subject:From;
        b=IaGXW/C0ZTKLZLS80QeqNqRurk2rrpYvcOdyZQpJqIPaLc83CRN0yxRJlbuCTyiJy
         W1YBEg2Rh44/NMxkdmAVDBpcqXRhyDMovH0kitIXFjXyZy7/BW9QeZDQP/Pxui9s34
         jz/xE9GBb3asVVqsFznlzaMJ2upaDj6t1P0dxXUk=
Date:   Wed, 25 Oct 2023 16:48:45 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vincent.guittot@linaro.org,
        peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-use-folio_xchg_last_cpupid-in-__split_huge_page_tail.patch removed from -mm tree
Message-Id: <20231025234846.5504FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: huge_memory: use folio_xchg_last_cpupid() in __split_huge_page_tail()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-use-folio_xchg_last_cpupid-in-__split_huge_page_tail.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: huge_memory: use folio_xchg_last_cpupid() in __split_huge_page_tail()
Date: Wed, 18 Oct 2023 22:08:02 +0800

Convert to use folio_xchg_last_cpupid() in __split_huge_page_tail().

Link: https://lkml.kernel.org/r/20231018140806.2783514-16-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-folio_xchg_last_cpupid-in-__split_huge_page_tail
+++ a/mm/huge_memory.c
@@ -2515,7 +2515,7 @@ static void __split_huge_page_tail(struc
 	if (page_is_idle(head))
 		set_page_idle(page_tail);
 
-	page_cpupid_xchg_last(page_tail, folio_last_cpupid(folio));
+	folio_xchg_last_cpupid(new_folio, folio_last_cpupid(folio));
 
 	/*
 	 * always add to the tail because some iterators expect new
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


