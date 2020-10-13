Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1580C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA1C22223F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633343;
	bh=LVguj2JzhvnfLCa6fi7ifW7HaSlIjGzHxYQM2RtovCg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=bIHo6uKTDxGB4CHiQ1cHjMineBFdpjy2jsoA/3HsrBQDZ+5PiSWWvULKsmlrjpk7p
	 UN3giMmzEgLDjuCwl2Gb55ZnfkGqUtIvykRoY5Gf0l/BJ0QGWOvaKbXHXGmr9BiX0j
	 b7i1pNor2+YZRcDtGkLLnlEmXtqrwBTwrz1VgAMs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388496AbgJMXzn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:55:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgJMXzn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:55:43 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC2212222E;
        Tue, 13 Oct 2020 23:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633342;
        bh=LVguj2JzhvnfLCa6fi7ifW7HaSlIjGzHxYQM2RtovCg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Rqa5AUVWqC0zzL0YaVmkJsL3mQmdNofA87CBAdtcCP07lL0OYD6JksudBxf/up3Rc
         CFkykpgrHLrqIGJ3Qi2dy3YVXCRSNSARaYGGJQJ3pI4upfwArd9QiXueQj5SxDL9+N
         frp0gHYohEDAQiNgNSnss1DNVymEd0RwlQi7Ex8A=
Date:   Tue, 13 Oct 2020 16:55:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mateusznosek0@gmail.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 132/181] mm/page_alloc.c: clean code by removing
 unnecessary initialization
Message-ID: <20201013235542.4GYzvcvIh%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mm/page_alloc.c: clean code by removing unnecessary initialization

Previously variable 'tmp' was initialized, but was not read later before
reassigning.  So the initialization can be removed.

[akpm@linux-foundation.org: remove `tmp' altogether]
Link: https://lkml.kernel.org/r/20200904132422.17387-1-mateusznosek0@gmail.com
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-clean-code-by-removing-unnecessary-initialization
+++ a/mm/page_alloc.c
@@ -5651,7 +5651,6 @@ static int find_next_best_node(int node,
 	int n, val;
 	int min_val = INT_MAX;
 	int best_node = NUMA_NO_NODE;
-	const struct cpumask *tmp = cpumask_of_node(0);
 
 	/* Use the local node if we haven't already */
 	if (!node_isset(node, *used_node_mask)) {
@@ -5672,8 +5671,7 @@ static int find_next_best_node(int node,
 		val += (n < node);
 
 		/* Give preference to headless and unused nodes */
-		tmp = cpumask_of_node(n);
-		if (!cpumask_empty(tmp))
+		if (!cpumask_empty(cpumask_of_node(n)))
 			val += PENALTY_FOR_NODE_WITH_CPUS;
 
 		/* Slight preference for less loaded node */
_
