Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E35FCC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBF7E61D06
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbhF2Ckj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:40:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231219AbhF2Ckj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:40:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FA9861D04;
        Tue, 29 Jun 2021 02:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934293;
        bh=zoyHW6BPLd1mT/rXhn4QM3JKy7B6ahqslnOcQB69B4U=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=RF/+zGNu4NL+ify1cZninbptcWzTfk0gqYWfRUI6mgGrMz5omdYC1vV6lsvTP4dQi
         +W+QyltFetwNfTXTXX2LGCSWRD0gu9fVXsG28GxGRpW5Efp07gX52eRZwVScizzKy4
         tpmEs1U8pa+PyuRJJbe48fYvf6KXaTOPQxF3cKP4=
Date:   Mon, 28 Jun 2021 19:38:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexander.h.duyck@linux.intel.com,
        alexs@kernel.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, shakeelb@google.com,
        shy828301@gmail.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, wenhui@gwmail.gwu.edu
Subject:  [patch 093/192] memcontrol: use flexible-array member
Message-ID: <20210629023812.K18OmQfVV%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: wenhuizhang <wenhui@gwmail.gwu.edu>
Subject: memcontrol: use flexible-array member

Change deprecated zero-length-and-one-element-arrays into flexible array
member.Zero-length and one-element arrays detected by Lukas's CodeChecker.
Zero/one element arrays cause undefined behaviours if sizeof() used.

Link: https://lkml.kernel.org/r/20210518200910.29912-1-wenhui@gwmail.gwu.edu
Signed-off-by: wenhuizhang <wenhui@gwmail.gwu.edu>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/memcontrol.h~memcontrol-use-flexible-array-member
+++ a/include/linux/memcontrol.h
@@ -349,8 +349,7 @@ struct mem_cgroup {
 	struct deferred_split deferred_split_queue;
 #endif
 
-	struct mem_cgroup_per_node *nodeinfo[0];
-	/* WARNING: nodeinfo must be the last member here */
+	struct mem_cgroup_per_node *nodeinfo[];
 };
 
 /*
_
