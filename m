Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B868FC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357413AbiCYBe0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357591AbiCYBd3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A7F3DA66
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E72F0B826FE
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C34C340ED;
        Fri, 25 Mar 2022 01:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171913;
        bh=IbviXoR9Nc5jXkX6RwytWi9xUpLxpc+eBhtuPBac3nM=;
        h=Date:To:From:Subject:From;
        b=g5VYo3HUyi626oKCub3uc395/0o99q9cRoHFFM70LZiPv/szMkht/WqpmuGqAw1kQ
         O3E9lKKORG9ng08pczO+sa/WM2eUmueRomydAdLGTwTXaIWDU0xMoKotmjPA5M3A0j
         CJMMFTDAQ6RihyMQBLluKHkcJ9qLNTdDeBYoL6FE=
Date:   Thu, 24 Mar 2022 18:31:53 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mgorman@techsingularity.net, david@redhat.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-fault-injection-declare-should_fail_alloc_page.patch removed from -mm tree
Message-Id: <20220325013153.A8C34C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, fault-injection: declare should_fail_alloc_page()
has been removed from the -mm tree.  Its filename was
     mm-fault-injection-declare-should_fail_alloc_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, fault-injection: declare should_fail_alloc_page()

The mm/ directory can almost fully be built with W=1, which would help in
local development.  One remaining issue is missing prototype for
should_fail_alloc_page().  Thus add it next to the should_failslab()
prototype.

Note the previous attempt by commit f7173090033c ("mm/page_alloc: make
should_fail_alloc_page() static") had to be reverted by commit
54aa386661fe as it caused an unresolved symbol error with
CONFIG_DEBUG_INFO_BTF=y

Link: https://lkml.kernel.org/r/20220314165724.16071-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fault-inject.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/fault-inject.h~mm-fault-injection-declare-should_fail_alloc_page
+++ a/include/linux/fault-inject.h
@@ -64,6 +64,8 @@ static inline struct dentry *fault_creat
 
 struct kmem_cache;
 
+bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order);
+
 int should_failslab(struct kmem_cache *s, gfp_t gfpflags);
 #ifdef CONFIG_FAILSLAB
 extern bool __should_failslab(struct kmem_cache *s, gfp_t gfpflags);
_

Patches currently in -mm which might be from vbabka@suse.cz are


