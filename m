Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D76BC433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:21:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25415221E5
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781310;
	bh=5EErJWA38wl42unJIOii+c8EWiSGmCmFx+nSjMA4Av4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=isAM5CmncGGrWKguLNQBA7ZYCRIeyjpkWYEXKHmfjIvHmkPoPJ1OCMtDCHqVAWO67
	 Gm244rAc2o9ZJExpduLfMH2cmZ0qbGWgTbe5mcQEaY5YG5Ls79Nu4+kelCQb+2mrwx
	 kghbxs94gTop+sJ9HH4qsP7nZoXiTXgisVUphM9A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbgHGGVt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:21:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgHGGVt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:21:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D2C42177B;
        Fri,  7 Aug 2020 06:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781308;
        bh=5EErJWA38wl42unJIOii+c8EWiSGmCmFx+nSjMA4Av4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lCqRl/zTeKDz1KHviVYbGaN6PcVajkxMg9ZXwrKoCj2RXIjHAGQkrD7ZjCvzFYzAB
         lbPAFoHQdE+WrJOUtaWZVF0+XUz8ZzROinIIwsQsMEMl+RJaFJCRNrBV5MZHyNeDxs
         +Po0+Lpq51FOKVJbz5V4y1TMLJcrpvxMpLnXvqbA=
Date:   Thu, 06 Aug 2020 23:21:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, guro@fb.com,
        hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, linux-mm@kvack.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, shakeelb@google.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 084/163] mm: kmem: switch to
 static_branch_likely() in memcg_kmem_enabled()
Message-ID: <20200807062147.3pKXVD4Kh%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Roman Gushchin <guro@fb.com>
Subject: mm: kmem: switch to static_branch_likely() in memcg_kmem_enabled()

Currently memcg_kmem_enabled() is optimized for the kernel memory
accounting being off.  It was so for a long time, and arguably the reason
behind was that the kernel memory accounting was initially an opt-in
feature.  However, now it's on by default on both cgroup v1 and cgroup v2,
and it's on for all cgroups.  So let's switch over to
static_branch_likely() to reflect this fact.

Unlikely there is a significant performance difference, as the cost of a
memory allocation and its accounting significantly exceeds the cost of a
jump.  However, the conversion makes the code look more logically.

Link: http://lkml.kernel.org/r/20200707173612.124425-3-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~mm-kmem-switch-to-static_branch_likely-in-memcg_kmem_enabled
+++ a/include/linux/memcontrol.h
@@ -1448,7 +1448,7 @@ void memcg_put_cache_ids(void);
 
 static inline bool memcg_kmem_enabled(void)
 {
-	return static_branch_unlikely(&memcg_kmem_enabled_key);
+	return static_branch_likely(&memcg_kmem_enabled_key);
 }
 
 static inline bool memcg_kmem_bypass(void)
_
