Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 497B3C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3663D6112F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235926AbhICVAi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235866AbhICVAi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:00:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D27B6112F;
        Fri,  3 Sep 2021 20:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702777;
        bh=QrFkti6rcH2LRznnrq7o563fbfco8rGYzq8+Lg50LIw=;
        h=Date:From:To:Subject:From;
        b=V6VA6MPp/r3F7HFTFYrGMOQSUph+WvdiIZpqWUCfxPVvFkn/Bn7tBbBhYqy7hFpFo
         6tWaKn1HLmHwdrRnbGGOwykaXI+494AWP/60n7b8kf8L9KlPtXJG4UxOe+GLtYo3kp
         3hDmFQquG3P/ZurCarXAgoji39XVsO3bP0eWfIPg=
Date:   Fri, 03 Sep 2021 13:59:37 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, npache@redhat.com, rppt@linux.ibm.com
Subject:  [merged]
 fix-zone_id-may-be-used-uninitialized-in-this-function-warning.patch
 removed from -mm tree
Message-ID: <20210903205937.j1lfaTmun%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: fix 'zone_id' may be used uninitialized in this function warning
has been removed from the -mm tree.  Its filename was
     fix-zone_id-may-be-used-uninitialized-in-this-function-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: mm/page_alloc.c: fix 'zone_id' may be used uninitialized in this function warning

When compiling with -Werror, cc1 will warn that 'zone_id' may be used
uninitialized in this function warning.

Initialize the zone_id as 0.

Its safe to assume that if the code reaches this point it has at least one
numa node with memory, so no need for an assertion before
init_unavilable_range.

Link: https://lkml.kernel.org/r/20210716210336.1114114-1-npache@redhat.com
Fixes: 122e093c1734 ("mm/page_alloc: fix memory map initialization for descending nodes")
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~fix-zone_id-may-be-used-uninitialized-in-this-function-warning
+++ a/mm/page_alloc.c
@@ -6715,7 +6715,7 @@ static void __init memmap_init(void)
 {
 	unsigned long start_pfn, end_pfn;
 	unsigned long hole_pfn = 0;
-	int i, j, zone_id, nid;
+	int i, j, zone_id = 0, nid;
 
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
 		struct pglist_data *node = NODE_DATA(nid);
_

Patches currently in -mm which might be from npache@redhat.com are


