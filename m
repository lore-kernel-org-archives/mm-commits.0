Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDCCCC433E9
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CF7364F24
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235096AbhBXUF4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:05:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:55902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235126AbhBXUFO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:05:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBBF264F2B;
        Wed, 24 Feb 2021 20:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197046;
        bh=AW6VtjcalHNtIglQEhdtRWcN5XijATaQZwWBHKishGU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WOwYQg0f0aShgkmdreL9Hx32w6yw0L7F8+ZyE5kQ4jXvQweMy+p1zHpAGYTSv/S3e
         2b0FqLI898ujScdYYPTdc8AvX2W4wXiCLr0JBnyCmrHgxyUQvb3dKIrSHsSkQg5iXO
         1KMwRIAqWTbiOya19RwIMc0QfF+QX1SjfFQ2P1SM=
Date:   Wed, 24 Feb 2021 12:04:05 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     abaci-bugfix@linux.alibaba.com, abaci@linux.alibaba.com,
        akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 069/173] mm/memcontrol: remove redundant NULL
 check
Message-ID: <20210224200405.jNrV0hE5t%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yang Li <abaci-bugfix@linux.alibaba.com>
Subject: mm/memcontrol: remove redundant NULL check

Fix below warnings reported by coccicheck:
./mm/memcontrol.c:451:3-9: WARNING: NULL check before some freeing
functions is not needed.

Link: https://lkml.kernel.org/r/1611216029-34397-1-git-send-email-abaci-bugfix@linux.alibaba.com
Signed-off-by: Yang Li <abaci-bugfix@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-remove-redundant-null-check
+++ a/mm/memcontrol.c
@@ -452,8 +452,7 @@ static void memcg_free_shrinker_maps(str
 	for_each_node(nid) {
 		pn = mem_cgroup_nodeinfo(memcg, nid);
 		map = rcu_dereference_protected(pn->shrinker_map, true);
-		if (map)
-			kvfree(map);
+		kvfree(map);
 		rcu_assign_pointer(pn->shrinker_map, NULL);
 	}
 }
_
