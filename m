Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12134C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E22132177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781302;
	bh=sCu/LXHeNRB3b7T1bXZGPdiJpSQ0GevMbRfzdCd1y8k=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=atuOYLGmqwJdr7X12gdMhJ/ezXRpX0hDgSnnPU0fVQAgzzTj7Hpi5GqFVHCMmcUXI
	 3MROJU4eZuZxcsNysj1VZ+gTepNxuYKfV6KPbtn6jPgLYtzTnAxxw7Pa+jmHVP+OqO
	 23Ogre3+O2p7bgAuabXqca+a12lSUbimBKwu+EFw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgHGGVm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:21:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgHGGVm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:21:42 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4955C22CAF;
        Fri,  7 Aug 2020 06:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781301;
        bh=sCu/LXHeNRB3b7T1bXZGPdiJpSQ0GevMbRfzdCd1y8k=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cwhzIOQos2CPex616yp3EZv9cVfFH7Ss3tk6Oj+DZPkhqn10ypvZWoxV1OC2gLWBL
         5N9kuvXRxf8jtAAx0jXBX1xd+OTRCZPFbGiC/jxKlocY1R7/iDzT4QpwRFTRJCdxvq
         5aBMH1RqrniwOkyIKsSULpKimYNBf8fglxD3DvP0=
Date:   Thu, 06 Aug 2020 23:21:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, guro@fb.com,
        hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, linux-mm@kvack.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, shakeelb@google.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 082/163] mm: memcg/slab: remove unused argument by
 charge_slab_page()
Message-ID: <20200807062140.bVEg7TBZa%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg/slab: remove unused argument by charge_slab_page()

charge_slab_page() is not using the gfp argument anymore,
remove it.

Link: http://lkml.kernel.org/r/20200707173612.124425-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 mm/slab.h |    3 +--
 mm/slub.c |    2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

--- a/mm/slab.c~mm-memcg-slab-remove-unused-argument-by-charge_slab_page
+++ a/mm/slab.c
@@ -1379,7 +1379,7 @@ static struct page *kmem_getpages(struct
 		return NULL;
 	}
 
-	charge_slab_page(page, flags, cachep->gfporder, cachep);
+	charge_slab_page(page, cachep->gfporder, cachep);
 	__SetPageSlab(page);
 	/* Record if ALLOC_NO_WATERMARKS was set when allocating the slab */
 	if (sk_memalloc_socks() && page_is_pfmemalloc(page))
--- a/mm/slab.h~mm-memcg-slab-remove-unused-argument-by-charge_slab_page
+++ a/mm/slab.h
@@ -423,8 +423,7 @@ static inline struct kmem_cache *virt_to
 	return page->slab_cache;
 }
 
-static __always_inline void charge_slab_page(struct page *page,
-					     gfp_t gfp, int order,
+static __always_inline void charge_slab_page(struct page *page, int order,
 					     struct kmem_cache *s)
 {
 	mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
--- a/mm/slub.c~mm-memcg-slab-remove-unused-argument-by-charge_slab_page
+++ a/mm/slub.c
@@ -1621,7 +1621,7 @@ static inline struct page *alloc_slab_pa
 		page = __alloc_pages_node(node, flags, order);
 
 	if (page)
-		charge_slab_page(page, flags, order, s);
+		charge_slab_page(page, order, s);
 
 	return page;
 }
_
