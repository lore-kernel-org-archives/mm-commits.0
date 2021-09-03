Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19373C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F17116113A
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238770AbhICU7G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:59:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235866AbhICU7E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:59:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E46C61107;
        Fri,  3 Sep 2021 20:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702684;
        bh=dTN4HK9KSyJAUDs5VGJEtxDlBRwaX0Lgj3ZmOSRXSiI=;
        h=Date:From:To:Subject:From;
        b=vvE/Q4/tLYpTwZMwcFIpzYAJe9phoTwJVWGRcixHnjfZVQnPwZwIkDqrtMvDGIuo7
         UqSzFd+vQwBMaYlHuUCtbLXr/oeS4qJ3N+67DrucKUZYiIvoFhG7XYtmdTZCaTUGy1
         PJQd9jbm49tXPsBUePh9UCLhlLuorgEIiARiK4rQ=
Date:   Fri, 03 Sep 2021 13:58:04 -0700
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcontrol-set-the-correct-memcg-swappiness-restriction.patch removed
 from -mm tree
Message-ID: <20210903205804.n6efAnwaq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: set the correct memcg swappiness restriction
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-set-the-correct-memcg-swappiness-restriction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-migrate-simplify-the-file-backed-pages-validation-when-migrating-its-mapping.patch
mm-migrate-introduce-a-local-variable-to-get-the-number-of-pages.patch
mm-migrate-fix-the-incorrect-function-name-in-comments.patch
mm-migrate-change-to-use-bool-type-for-page_was_mapped.patch

