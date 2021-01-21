Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B6BEC433E0
	for <mm-commits@archiver.kernel.org>; Thu, 21 Jan 2021 22:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEB7E23A62
	for <mm-commits@archiver.kernel.org>; Thu, 21 Jan 2021 22:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbhAUWeF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Jan 2021 17:34:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726122AbhAUWd6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Jan 2021 17:33:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1A94239EF;
        Thu, 21 Jan 2021 22:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611268396;
        bh=eeld3OAg41Xagv+oihja9SInUhNz/YzbXb9X8gNur0g=;
        h=Date:From:To:Subject:From;
        b=FMMUoz/vgtNNbEOiDh3ezsBPk3ztWtNAsfTqth8GwueDLwxCFQdNO5tmEEr9u8+m7
         O5VMeh3iy8/9ww7naVX/pfW6FFxQiiT9fIyz9xHqbUJKyOLrhw+F/qrh2p5lAgi/qL
         x1NUYQGq0Emq+Jpn2HP07+KHp9/+eE/IXU0vHGH0=
Date:   Thu, 21 Jan 2021 14:33:15 -0800
From:   akpm@linux-foundation.org
To:     abaci-bugfix@linux.alibaba.com, abaci@linux.alibaba.com,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + mm-memcontrol-remove-redundant-null-check.patch added
 to -mm tree
Message-ID: <20210121223315.n11kRWGjX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol: remove redundant NULL check
has been added to the -mm tree.  Its filename is
     mm-memcontrol-remove-redundant-null-check.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-remove-redundant-null-check.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-remove-redundant-null-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memcontrol-remove-redundant-null-check.patch
vmalloc-remove-redundant-null-check.patch

