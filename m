Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C0BC433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:26:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DB0222CAE
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781563;
	bh=uPxPl7fj33NhHRitqMtGFKS3Mnq8K9kSTW0t/ChhI14=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=DGtfzRACh1dzgvjgjxgSYm/1kRoDYv3M309HUuRHyEUEPpJxt8DQPEmHm4FrgFUET
	 HrmfHK1KgHQYNqMBqJ4ILjdgHizjf+iALPtL+PFoXtMHWVDO+VUtZkpGLpdLz1F/T1
	 RIzY4B0rN+ZiElEwenp8N89ASoXWIwiJUlfmm4BU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHGG0D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:26:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgHGG0C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:26:02 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E450322CF6;
        Fri,  7 Aug 2020 06:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781562;
        bh=uPxPl7fj33NhHRitqMtGFKS3Mnq8K9kSTW0t/ChhI14=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=y4RP1TvTtg/yPdNs0LItx5l6U3pKW+NFeEM/9YDekHY/dK3BeeDA7HHI39lJENkhT
         sCaYGtgyKxsokC9uBkPm9v2Pye8v3jWBCknmgBLyIGuh8yxcxaxGpyvPWwnSxOv77M
         RYW5bLTRzMyjXrRpsyT4+rBuTEjc9+2IcMnz2NrQ=
Date:   Thu, 06 Aug 2020 23:26:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        songmuchun@bytedance.com, torvalds@linux-foundation.org
Subject:  [patch 154/163] mm/page_alloc.c: skip setting nodemask
 when we are in interrupt
Message-ID: <20200807062601.7kNJ1Pi0Y%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/page_alloc.c: skip setting nodemask when we are in interrupt

When we are in the interrupt context, it is irrelevant to the current task
context.  If we use current task's mems_allowed, we can be fair to alloc
pages in the fast path and fall back to slow path memory allocation when
the current node(which is the current task mems_allowed) does not have
enough memory to allocate.  In this case, it slows down the memory
allocation speed of interrupt context.  So we can skip setting the
nodemask to allow any node to allocate memory, so that fast path
allocation can success.

Link: http://lkml.kernel.org/r/20200706025921.53683-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-skip-setting-nodemask-when-we-are-in-interrupt
+++ a/mm/page_alloc.c
@@ -4788,7 +4788,11 @@ static inline bool prepare_alloc_pages(g
 
 	if (cpusets_enabled()) {
 		*alloc_mask |= __GFP_HARDWALL;
-		if (!ac->nodemask)
+		/*
+		 * When we are in the interrupt context, it is irrelevant
+		 * to the current task context. It means that any node ok.
+		 */
+		if (!in_interrupt() && !ac->nodemask)
 			ac->nodemask = &cpuset_current_mems_allowed;
 		else
 			*alloc_flags |= ALLOC_CPUSET;
_
