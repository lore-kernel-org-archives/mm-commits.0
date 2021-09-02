Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C182C4332F
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EA82603E9
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347572AbhIBV5C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:57:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347865AbhIBV4w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:56:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69E21610CE;
        Thu,  2 Sep 2021 21:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619753;
        bh=h9seeeRFFFKYEYWPDU7XEJE0ctPZvg6UoV4HxYCpPc4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=tZpFXhBtES2T+g6hiAEml3YWwCfC3/BQULZVka/iOeXOhcZ2c5Wi4ZWy4CaEdL9Zw
         baqchXkTFXLkZPT03UdSWsCL99+/8kAlobpYgafAfoaSE9ats1YnPN8AeGyiYv4/Co
         5Pj3f/iGtGH9HvtidlRMP5bjqUjwYMn2oZDueg68=
Date:   Thu, 02 Sep 2021 14:55:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vdavydov.dev@gmail.com
Subject:  [patch 110/212] mm: memcontrol: set the correct memcg
 swappiness restriction
Message-ID: <20210902215553.nJueeBnx-%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: memcontrol: set the correct memcg swappiness restriction

Since commit c843966c556d ("mm: allow swappiness that prefers reclaiming
anon over the file workingset") has expended the swappiness value to make
swap to be preferred in some systems.  We should also change the memcg
swappiness restriction to allow memcg swap-preferred.

Link: https://lkml.kernel.org/r/d77469b90c45c49953ccbc51e54a1d465bc18f70.1627626255.git.baolin.wang@linux.alibaba.com
Fixes: c843966c556d ("mm: allow swappiness that prefers reclaiming anon over the file workingset")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-set-the-correct-memcg-swappiness-restriction
+++ a/mm/memcontrol.c
@@ -4062,7 +4062,7 @@ static int mem_cgroup_swappiness_write(s
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
-	if (val > 100)
+	if (val > 200)
 		return -EINVAL;
 
 	if (!mem_cgroup_is_root(memcg))
_
