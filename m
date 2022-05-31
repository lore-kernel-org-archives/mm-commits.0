Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B478DC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 31 May 2022 04:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiEaEXs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 May 2022 00:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243804AbiEaEXq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2022 00:23:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4130F76297
        for <mm-commits@vger.kernel.org>; Mon, 30 May 2022 21:23:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C03ACB80E5A
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 04:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D619C385A9;
        Tue, 31 May 2022 04:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653971022;
        bh=K7sHv3SISnlVIyIKbTTMKTzbazBe+Z/1y/CP+8+HXVE=;
        h=Date:To:From:Subject:From;
        b=u2NOXSmG5NsiRaDDjBB4zuTzn/luhiXwXN7s/Nb7QQjCUETFQKTkcmNeA59T2YF7q
         s0WpLf2oyxqa5QXXiq4vnFU/Au0zNWFUiYIg+UzhBHjKtJSl1q3VnQqpjfHgp7fNdx
         WCBhHEex6a1EmoVz0I8XTMlS0bERCFefxDRPXPbw=
Date:   Mon, 30 May 2022 21:23:41 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org,
        renzhengeek@gmail.com, quic_qiancai@quicinc.com, osalvador@suse.de,
        mgorman@techsingularity.net, david@redhat.com,
        christophe.leroy@csgroup.eu, anshuman.khandual@arm.com,
        ziy@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-use-compound_nr-correctly-in-isolate_single_pageblock.patch added to mm-hotfixes-unstable branch
Message-Id: <20220531042342.6D619C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_isolation: use compound_nr() correctly in isolate_single_pageblock()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_isolation-use-compound_nr-correctly-in-isolate_single_pageblock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_isolation-use-compound_nr-correctly-in-isolate_single_pageblock.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: David Hildenbrand <david@redhat.com>
Cc: Qian Cai <quic_qiancai@quicinc.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Eric Ren <renzhengeek@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
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

mm-page_isolation-use-compound_nr-correctly-in-isolate_single_pageblock.patch

