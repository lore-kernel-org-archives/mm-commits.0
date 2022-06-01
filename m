Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F9DFCCA473
	for <mm-commits@archiver.kernel.org>; Wed,  1 Jun 2022 22:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbiFAW64 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Jun 2022 18:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232443AbiFAW6z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2022 18:58:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3A3DFF41
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 15:58:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F13E611A0
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 22:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D526AC385B8;
        Wed,  1 Jun 2022 22:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654124332;
        bh=edbL3W5+kLHLZOhpMAOOJIhC+L7S2ZuxXhAgT2e0aJ0=;
        h=Date:To:From:Subject:From;
        b=IXePUQyPlSsZM02UliHrCWGLfsxx+SD6StRcGUIB6tX2Bvq2kZr+s6F6H7bxFQzyf
         6ALoUigO7lVBWDH8LAwGsVL3YYbN2XfOqRWLayazddWxlLcChwyp5JqY5UOLNTOBtw
         vvb8KNR8eS1rDZhlW+bRB+NnLlLY8MIN3hR4ShBY=
Date:   Wed, 01 Jun 2022 15:58:52 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        songmuchun@bytedance.com, rppt@kernel.org, renzhengeek@gmail.com,
        quic_qiancai@quicinc.com, osalvador@suse.de,
        mgorman@techsingularity.net, linmiaohe@huawei.com,
        david@redhat.com, christophe.leroy@csgroup.eu,
        anshuman.khandual@arm.com, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_isolation-use-compound_nr-correctly-in-isolate_single_pageblock.patch removed from -mm tree
Message-Id: <20220601225852.D526AC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_isolation: use compound_nr() correctly in isolate_single_pageblock()
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-use-compound_nr-correctly-in-isolate_single_pageblock.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm: page_isolation: use compound_nr() correctly in isolate_single_pageblock()
Date: Mon, 30 May 2022 22:44:50 -0400

When compound_nr(page) was used, page was not guaranteed to be the head of
the compound page and it could cause an infinite loop.  Fix it by calling
it on the head page.

Link: https://lkml.kernel.org/r/20220531024450.2498431-1-zi.yan@sent.com
Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock granularity")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: Anshuman Khandual <anshuman.khandual@arm.com>
  Link: https://lore.kernel.org/linux-mm/20220530115027.123341-1-anshuman.khandual@arm.com/
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Qian Cai <quic_qiancai@quicinc.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Eric Ren <renzhengeek@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_isolation.c~mm-page_isolation-use-compound_nr-correctly-in-isolate_single_pageblock
+++ a/mm/page_isolation.c
@@ -385,9 +385,9 @@ static int isolate_single_pageblock(unsi
 		 * above do the rest. If migration is not possible, just fail.
 		 */
 		if (PageCompound(page)) {
-			unsigned long nr_pages = compound_nr(page);
 			struct page *head = compound_head(page);
 			unsigned long head_pfn = page_to_pfn(head);
+			unsigned long nr_pages = compound_nr(head);
 
 			if (head_pfn + nr_pages <= boundary_pfn) {
 				pfn = head_pfn + nr_pages;
_

Patches currently in -mm which might be from ziy@nvidia.com are


