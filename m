Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 788BDC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:20:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28ED2224BD
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgLODUW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:20:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:36030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727723AbgLODLY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:11:24 -0500
Date:   Mon, 14 Dec 2020 19:09:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001743;
        bh=K7Y4Fdl4u07UjNvujag/pQbqMUcakgkGi5MxXNqcYHs=;
        h=From:To:Subject:In-Reply-To:From;
        b=KZpTwUsybzMao6Ic/oHTN8GMegQut2WOVvjUlNFiEbMxrOimYqCmfxpaPDL5twxD1
         lbXHTHARvlcEhsbTiFFOVuemle9gytqaFg8tVsTWz+Ux9aF7FiEa4aWR7QHVlN4wzj
         Nm5HF4zojUfYXGGuvwgmN28oaBig3gqA9ICL4D4k=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        corbet@lwn.net, kirill.shutemov@linux.intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org,
        yang.shi@linux.alibaba.com, ziy@nvidia.com
Subject:  [patch 099/200] docs/vm: remove unused 3 items
 explanation for /proc/vmstat
Message-ID: <20201215030902.nOlCCkLtw%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: docs/vm: remove unused 3 items explanation for /proc/vmstat

Commit 5647bc293ab1 ("mm: compaction: Move migration fail/success
stats to migrate.c"), removed 3 items in /proc/vmstat. but the docs
still has their explanation. let's remove them.

"compact_blocks_moved",
"compact_pages_moved",
"compact_pagemigrate_failed",

Link: https://lkml.kernel.org/r/1605520282-51993-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |   15 ---------------
 1 file changed, 15 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~docs-vm-remove-unused-3-items-explanation-for-proc-vmstat
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -401,21 +401,6 @@ compact_fail
 	is incremented if the system tries to compact memory
 	but failed.
 
-compact_pages_moved
-	is incremented each time a page is moved. If
-	this value is increasing rapidly, it implies that the system
-	is copying a lot of data to satisfy the huge page allocation.
-	It is possible that the cost of copying exceeds any savings
-	from reduced TLB misses.
-
-compact_pagemigrate_failed
-	is incremented when the underlying mechanism
-	for moving a page failed.
-
-compact_blocks_moved
-	is incremented each time memory compaction examines
-	a huge page aligned range of pages.
-
 It is possible to establish how long the stalls were using the function
 tracer to record how long was spent in __alloc_pages_nodemask and
 using the mm_page_alloc tracepoint to identify which allocations were
_
