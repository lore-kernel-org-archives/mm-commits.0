Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A188CC388F2
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:04:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F691223C7
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604459048;
	bh=McDlsjditqkCkcMhdKTGHka4584YlSsUaxdpDk7KaK4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=BPl5s998xTK3wOhHcdMVs7wwmrtD7yRwywtCDjv5HCwYPKfeh1E35qy96f6qBE1iW
	 ethCrnhAoqasTC2zZHefIUDPLCk9NDHGnMvwgLhjUkxq9jD1k6c6PuaI6s0+Hhywp1
	 xbHJKut492secxSrTlJ9xyG290wbvHGp5xCetxrw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbgKDDEH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 22:04:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:47956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729801AbgKDDEH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 22:04:07 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3046C2236F;
        Wed,  4 Nov 2020 03:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604459046;
        bh=McDlsjditqkCkcMhdKTGHka4584YlSsUaxdpDk7KaK4=;
        h=Date:From:To:Subject:From;
        b=e7fvG3vmPjJWEEYgChe6D0EYkNzwtkqTKIUXjIfCv6pAF5CdZm5ChPRYYLJw4jHgI
         K92C8sZew5yoNmoUI59/MD1hiWuUbewqhYKr/xqHylOl3goNrGKhjhIcN9H3IESwyG
         40e/V5EL/YSSrvYzna4/FDKJa2pTgf55bsBng2jk=
Date:   Tue, 03 Nov 2020 19:03:57 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        mhocko@suse.com, hughd@google.com, hannes@cmpxchg.org, guro@fb.com,
        alex.shi@linux.alibaba.com
Subject:  +
 mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch added to -mm
 tree
Message-ID: <20201104030357.LgRCO%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: bail early from swap accounting if memcg disabled
has been added to the -mm tree.  Its filename is
     mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/memcg: bail early from swap accounting if memcg disabled

Patch series "bail out early for memcg disable".

These 2 patches are indepenedent from per memcg lru lock, and may
encounter unexpected warning, so let's move out them from per memcg
lru locking patchset.


This patch (of 2):

We could bail out early when memcg wasn't enabled.

Link: https://lkml.kernel.org/r/1604283436-18880-1-git-send-email-alex.shi@linux.alibaba.com
Link: https://lkml.kernel.org/r/1604283436-18880-2-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memcontrol.c~mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled
+++ a/mm/memcontrol.c
@@ -7157,6 +7157,9 @@ void mem_cgroup_swapout(struct page *pag
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 	VM_BUG_ON_PAGE(page_count(page), page);
 
+	if (mem_cgroup_disabled())
+		return;
+
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return;
 
@@ -7221,6 +7224,9 @@ int mem_cgroup_try_charge_swap(struct pa
 	struct mem_cgroup *memcg;
 	unsigned short oldid;
 
+	if (mem_cgroup_disabled())
+		return 0;
+
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return 0;
 
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
mm-memcg-warning-on-memcg-after-readahead-page-charged.patch

