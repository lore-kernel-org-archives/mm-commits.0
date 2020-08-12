Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E4A1C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 281992078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266354;
	bh=lCBLQK6SJPk4qS1NAQ47eTuFzgthFCdqJdYGrNX+VRU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Y2u5Q/rp0yBd+h6QjYKpx0BEu50ZaEjB8/+Z18GksSV3QwYvSrRl0hng5BjLn4N5R
	 laHZ7kfbPuWAwMhm30WPHQJfJ+EQoJ5YxuztQGMWs/BGbCRZuZ6mpta7MLqEaGf8Ti
	 NBVChoggHiw05s1bLqE124AmaiDojnl2bBDjmTT0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgHLVFx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgHLVFx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:05:53 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB07F20774;
        Wed, 12 Aug 2020 21:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266353;
        bh=lCBLQK6SJPk4qS1NAQ47eTuFzgthFCdqJdYGrNX+VRU=;
        h=Date:From:To:Subject:From;
        b=uN2kAP9VTCk+tsQ5qReaVWjj3iSA/uit9Cq455kkDNGa8pLrI2PQLSlKBpxpPg3NU
         oiM+walLGrNsW6v9HpJorZB53MKtsKF/kCH/zxY5Pbk1W7s3GSeV47jsW0YqmX4/nj
         mcE4nFA3jli8gfOPmpWqtOcuuU3zTWisYEh9ocYs=
Date:   Wed, 12 Aug 2020 14:05:52 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hch@infradead.org, iamjoonsoo.kim@lge.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        vbabka@suse.cz
Subject:  [merged]
 mm-page_isolation-prefer-the-node-of-the-source-page.patch removed from -mm
 tree
Message-ID: <20200812210552.TTm1sf2dn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation: prefer the node of the source page
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-prefer-the-node-of-the-source-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/page_isolation: prefer the node of the source page

Patch series "clean-up the migration target allocation functions", v5.


This patch (of 9):

For locality, it's better to migrate the page to the same node rather than
the node of the current caller's cpu.

Link: http://lkml.kernel.org/r/1594622517-20681-1-git-send-email-iamjoonsoo.kim@lge.com
Link: http://lkml.kernel.org/r/1594622517-20681-2-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/page_isolation.c~mm-page_isolation-prefer-the-node-of-the-source-page
+++ a/mm/page_isolation.c
@@ -309,5 +309,7 @@ int test_pages_isolated(unsigned long st
 
 struct page *alloc_migrate_target(struct page *page, unsigned long private)
 {
-	return new_page_nodemask(page, numa_node_id(), &node_states[N_MEMORY]);
+	int nid = page_to_nid(page);
+
+	return new_page_nodemask(page, nid, &node_states[N_MEMORY]);
 }
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-memory-failure-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory_hotplug-remove-a-wrapper-for-alloc_migration_target.patch

