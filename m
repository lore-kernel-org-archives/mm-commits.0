Return-Path: <SRS0=f579=BK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13EE0C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:26:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3B3722B43
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596227209;
	bh=h63HSJxwShppPLjW6eQRbZ3pOgDDC/310ZhqNi+CuQE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=B9R/gkuE3AcP0h2yimbbS9m99cJbpPN0z1OhVVTqZoFSIT9oJgszx3NhR3Vmk/qr4
	 dtXmLA6IWk/pmbHayD+gvMJ2AyV8SXiErcv952DlxiitnfY8WEZarMhMkHle00Z484
	 CbUC2HuKnr/jZ1whfKnQdn00kL+2CzyI5WMAw+mI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgGaU0t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Jul 2020 16:26:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgGaU0t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jul 2020 16:26:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC7B82087C;
        Fri, 31 Jul 2020 20:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596227209;
        bh=h63HSJxwShppPLjW6eQRbZ3pOgDDC/310ZhqNi+CuQE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0g8xJIWr/gMcAZEHD3JHWypmEqIcSiQY8I0USfw47CY5epFNtF+ho/KvSZAe0efzD
         GbbgR4lPJS6fvqx5qlAq/ttXg08ItdxbmyAH/XNaeE+dFOo5mltwgBhc8cikpWiOg8
         NHOZTS0sX+sN1N/0ucCsM5IjQ/FwV0oO6LPcFbwQ=
Date:   Fri, 31 Jul 2020 13:26:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org, hughd@google.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com,
        tj@kernel.org, vbabka@suse.cz
Subject:  +
 mm-memcontrol-decouple-reference-counting-from-page-accounting-fix.patch
 added to -mm tree
Message-ID: <20200731202648.RSzv-hEA_%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: decouple reference counting from page accounting fix
has been added to the -mm tree.  Its filename is
     mm-memcontrol-decouple-reference-counting-from-page-accounting-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-decouple-reference-counting-from-page-accounting-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-decouple-reference-counting-from-page-accounting-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: memcontrol: decouple reference counting from page accounting fix

Moving tasks between mem cgroups with memory.move_charge_at_immigrate 3,
while swapping, crashes soon on mmotm (and so presumably on linux-next):
for example, spinlock found corrupted when lock_page_memcg() is called. 
It's as if the mem cgroup structures have been freed too early.

Stab in the dark: what if all the accounting is right, except that the
css_put_many() in __mem_cgroup_clear_mc() is now (worse than) redundant? 
Removing it fixes the crashes, but that's hardly surprising; and stats
temporarily hacked into mem_cgroup_css_alloc() and mem_cgroup_css_free()
showed that mem cgroups were not being leaked with this change.

Note: this removes the last call to css_put_many() from the tree; and
mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-accounted-allocations.patch
removes the last call to css_get_many(): now that their last references
have gone, I expect them soon to be freed from include/linux/cgroup.h.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2007302011450.2347@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-decouple-reference-counting-from-page-accounting-fix
+++ a/mm/memcontrol.c
@@ -5680,8 +5680,6 @@ static void __mem_cgroup_clear_mc(void)
 		if (!mem_cgroup_is_root(mc.to))
 			page_counter_uncharge(&mc.to->memory, mc.moved_swap);
 
-		css_put_many(&mc.to->css, mc.moved_swap);
-
 		mc.moved_swap = 0;
 	}
 	memcg_oom_recover(from);
_

Patches currently in -mm which might be from hughd@google.com are

mm-memcontrol-decouple-reference-counting-from-page-accounting-fix.patch

