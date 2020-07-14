Return-Path: <SRS0=97KN=AZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92BBDC433E2
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:21:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CC0721548
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594689697;
	bh=B6GeVehUnVk2SIrX+2Vk6lv0K8yd+Jy7HKB7wKQYJB0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ss5IK/UTsvULCdfCMLo4j/Jbby9cApLGVsEstHsuueZdbJAs022T4h14/9RxOGM7J
	 EDNmRGG/H/NPBiv3Fo+tPg3Z0ACRapBVcpjZ3wqYXS7UQaF+kXeAcf1gA1OU9ZVppC
	 2bahAkopwOdA9BmjIlplkJFmcPrFUX4p576ZDx1g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgGNBVh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jul 2020 21:21:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbgGNBVh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jul 2020 21:21:37 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2675206F0;
        Tue, 14 Jul 2020 01:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594689696;
        bh=B6GeVehUnVk2SIrX+2Vk6lv0K8yd+Jy7HKB7wKQYJB0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pKLKQMzMVk4BUBJofpMwBGyMl8SC7gFeu7hfBciPdJ0jznH9JdGL2gFCWk1VFlJuE
         YFHXog/WK3X8ZnUBHxokeemL6BogsIcMYV+RNlJ9RtVQ02U9HMxy76HkjkyosndlKb
         Fttd+PyEViO4ybZvESS9bMPXfgHWzYhDIPjbE39M=
Date:   Mon, 13 Jul 2020 18:21:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     guro@fb.com, hch@infradead.org, iamjoonsoo.kim@lge.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        vbabka@suse.cz
Subject:  +
 mm-page_isolation-prefer-the-node-of-the-source-page.patch added to -mm
 tree
Message-ID: <20200714012135.iNhl3nwfh%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation: prefer the node of the source page
has been added to the -mm tree.  Its filename is
     mm-page_isolation-prefer-the-node-of-the-source-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_isolation-prefer-the-node-of-the-source-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_isolation-prefer-the-node-of-the-source-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page_isolation-prefer-the-node-of-the-source-page.patch
mm-migrate-move-migration-helper-from-h-to-c.patch
mm-hugetlb-unify-migration-callbacks.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations.patch
mm-migrate-make-a-standard-migration-target-allocation-function.patch
mm-mempolicy-use-a-standard-migration-target-allocation-callback.patch
mm-page_alloc-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory-failure-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory_hotplug-remove-a-wrapper-for-alloc_migration_target.patch

