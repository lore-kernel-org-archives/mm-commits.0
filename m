Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6F3EC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 852552076C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196232;
	bh=RfbFLjOPMA5SSuEGyVjVv9gJr9ZbV1wuUX5oFpzNdy8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=wIwbXVpwd805QVGTbNsG9fKRJOgzGE+yFY/jRuVIGBbzqW4ysDl8JfPq2XhdT/ut9
	 TryCtFKFZqwHzctFviDxzY5EZyf5cnRHR/G8nMg0IqXuEOhkQVBgS7x9zuRVfxhnDm
	 SZ0aFG5B/9ue+iiAkfMen7hxwnawlcRdSgLSJdbM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgHLBhM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBhM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:37:12 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A4E420658;
        Wed, 12 Aug 2020 01:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196231;
        bh=RfbFLjOPMA5SSuEGyVjVv9gJr9ZbV1wuUX5oFpzNdy8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cJO0WozDmfSncWcIT/pgJDWlDa6rM9gXYIXVHj5GmqeYjdkPHx8y3WFsC+4R1SLaG
         BvaY2YEmpBiGqXaHh71VxUgt51PePRih3YOwzlHqsa7j7GaHmmo2Wf9/z0SRhuTgOF
         OZz5BC9yzaPsKI7uj2JT3AJK1YtYIFQ/KfE57JXg=
Date:   Tue, 11 Aug 2020 18:37:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hch@infradead.org,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        n-horiguchi@ah.jp.nec.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 131/165] mm/page_isolation: prefer the node of the
 source page
Message-ID: <20200812013711.qkv1icdkY%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
