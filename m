Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F2B8C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C904164ECE
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbhBYTZe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:25:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:35730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234536AbhBYTXP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:23:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A530064F6C;
        Thu, 25 Feb 2021 19:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280467;
        bh=0XhnC4EFvGCfZWlpgnwiGdkeCHuvn1KzOBhabxsSoOc=;
        h=Date:From:To:Subject:From;
        b=lTIysdZ/Ye+m5uFBgnJPJBMXo8Qt3NJwk0VSa07EGZ5o50Powy9oqUhtphkGH6E9l
         mFjiRwBuUZ7LbgjyRcNecKCAPCd3mnDbSMgo8O85UO3AixDWAva4b/mjjPXekIF7ID
         FoWx+z5pKKc7/2VfS8VzPO/eDxkg5NBQiLRhKXOo=
Date:   Thu, 25 Feb 2021 11:14:26 -0800
From:   akpm@linux-foundation.org
To:     abaci-bugfix@linux.alibaba.com, abaci@linux.alibaba.com,
        akpm@linux-foundation.org, david@redhat.com,
        mm-commits@vger.kernel.org
Subject:  [merged] mm-memcontrol-remove-redundant-null-check.patch
 removed from -mm tree
Message-ID: <20210225191426.PoAEMl-X6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol: remove redundant NULL check
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-remove-redundant-null-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from abaci-bugfix@linux.alibaba.com are


