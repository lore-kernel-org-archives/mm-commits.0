Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38BCCC43462
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D3906145D
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhD3GDL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:03:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230366AbhD3GDI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:03:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA793613AD;
        Fri, 30 Apr 2021 06:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762540;
        bh=oNZkf3QGMC3lUig76TjE/B5MjgSDKb9vkfo4cJVnLKY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bRKDbyBJTEpIT6kk3XRcqzVZwEPg/6nJ85cSuYZ3vmTVAp4FccYowCG7WpUbTGYmk
         W/Cw3MEQP0KlLx58qW6lEgCNNgTtvqVIvrTEXbTyfiXulm9jjdB9iQzOz8EEslehEI
         wu+vEMb2a+OYlrZJSQ4oJ9W7I87AUJh3VRxMMxSM=
Date:   Thu, 29 Apr 2021 23:02:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        dave.jiang@intel.com, jane.chu@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        torvalds@linux-foundation.org
Subject:  [patch 178/178] mm/memory-failure: unnecessary amount of
 unmapping
Message-ID: <20210430060219.X3LNNMWL0%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jane Chu <jane.chu@oracle.com>
Subject: mm/memory-failure: unnecessary amount of unmapping

It appears that unmap_mapping_range() actually takes a 'size' as its third
argument rather than a location, the current calling fashion causes
unnecessary amount of unmapping to occur.

Link: https://lkml.kernel.org/r/20210420002821.2749748-1-jane.chu@oracle.com
Fixes: 6100e34b2526e ("mm, memory_failure: Teach memory_failure() about dev_pagemap pages")
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failure-unecessary-amount-of-unmapping
+++ a/mm/memory-failure.c
@@ -1368,7 +1368,7 @@ static int memory_failure_dev_pagemap(un
 		 * communicated in siginfo, see kill_proc()
 		 */
 		start = (page->index << PAGE_SHIFT) & ~(size - 1);
-		unmap_mapping_range(page->mapping, start, start + size, 0);
+		unmap_mapping_range(page->mapping, start, size, 0);
 	}
 	kill_procs(&tokill, flags & MF_MUST_KILL, !unmap_success, pfn, flags);
 	rc = 0;
_
