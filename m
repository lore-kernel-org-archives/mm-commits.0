Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E590C4338F
	for <mm-commits@archiver.kernel.org>; Sun,  1 Aug 2021 20:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0498E61059
	for <mm-commits@archiver.kernel.org>; Sun,  1 Aug 2021 20:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhHAU2f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Aug 2021 16:28:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:35250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229955AbhHAU2f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 1 Aug 2021 16:28:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA80760FC1;
        Sun,  1 Aug 2021 20:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627849706;
        bh=ycHWPilx29A9nIvBGJAJd0V7gbbBN6WNUDo8mgAIWmE=;
        h=Date:From:To:Subject:From;
        b=IVlxuGJzmCqFWDM3LCdDcAaDzznzH53Exw3O5eb8S6rvOd4cBhueUDwGLzjfqsZ/T
         PapFNHYUSao2ANz4zJE7abUUSIUs7pdCAc0YfxxvQkMsag+mTUO4iQ/f9BzhpFI0g7
         P9jgKivLiRQUsGltrJ9J+tjAxsEcs8igDsyG1Q6o=
Date:   Sun, 01 Aug 2021 13:28:24 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        mhocko@suse.com, hannes@cmpxchg.org, baolin.wang@linux.alibaba.com
Subject:  +
 mm-memcontrol-set-the-correct-memcg-swappiness-restriction.patch added to -mm
 tree
Message-ID: <20210801202824.wn2i_%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: set the correct memcg swappiness restriction
has been added to the -mm tree.  Its filename is
     mm-memcontrol-set-the-correct-memcg-swappiness-restriction.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-set-the-correct-memcg-swappiness-restriction.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-set-the-correct-memcg-swappiness-restriction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: memcontrol: set the correct memcg swappiness restriction

Since commit c843966c556d ("mm: allow swappiness that prefers reclaiming
anon over the file workingset") has expended the swappiness value to make
swap to be preferred in some systems.  We should also change the memcg
swappiness restriction to allow memcg swap-preferred.

Link: https://lkml.kernel.org/r/d77469b90c45c49953ccbc51e54a1d465bc18f70.1627626255.git.baolin.wang@linux.alibaba.com
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
@@ -4060,7 +4060,7 @@ static int mem_cgroup_swappiness_write(s
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
-	if (val > 100)
+	if (val > 200)
 		return -EINVAL;
 
 	if (!mem_cgroup_is_root(memcg))
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-memcontrol-set-the-correct-memcg-swappiness-restriction.patch
mm-mempolicy-use-readable-numa_no_node-macro-instead-of-magic-numer.patch

