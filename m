Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B3EC433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99E422086A
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596779467;
	bh=4VTlevQsVlPkC2ra2MeIt2uroaXjOLCwJd8b+lTdzZg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=KIz+ZkBqfkQQlWBSn0c3KUH8wWouCWAM0wRBtxctdWite8tfgY0R1Go8n+vjdXujh
	 Ggt4xC7dtA5+lR6x3HS/MwoYiMQ54XwLZGc/KlBW558b1xwVvEywlaEiqZSagvJMpP
	 fxV85O9zD0NMR/aPEzxRi04F6XjV1lMfJXNjUS88=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgHGFvH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 01:51:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGFvH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 01:51:07 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BD2420866;
        Fri,  7 Aug 2020 05:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596779466;
        bh=4VTlevQsVlPkC2ra2MeIt2uroaXjOLCwJd8b+lTdzZg=;
        h=Date:From:To:Subject:From;
        b=EErbxSA9TivB7cK8TaDgCKnPP2J/74Fv4bW+Ljn6Q7zLxa/Srx4NwbWt4V4uPwoEN
         QemOhQUJpMWdA24pnKrJMXsl+J9c8mvG4TSUZG/xdvataQBhZ33Vpsf4DfxYu2de9M
         1WXEpLRA28sTi5NKeWvzZw70X9vzf9v7cyywpprA=
Date:   Thu, 06 Aug 2020 22:51:05 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org, hughd@google.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com,
        tj@kernel.org, vbabka@suse.cz
Subject:  [folded-merged]
 mm-memcontrol-decouple-reference-counting-from-page-accounting-fix.patch
 removed from -mm tree
Message-ID: <20200807055105.o1VAUTSAK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: decouple reference counting from page accounting fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-decouple-reference-counting-from-page-accounting-fix.patch

This patch was dropped because it was folded into mm-memcontrol-decouple-reference-counting-from-page-accounting.patch

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

mm-memcontrol-decouple-reference-counting-from-page-accounting.patch
khugepaged-collapse_pte_mapped_thp-flush-the-right-range.patch
khugepaged-collapse_pte_mapped_thp-protect-the-pmd-lock.patch
khugepaged-retract_page_tables-remember-to-test-exit.patch
khugepaged-khugepaged_test_exit-check-mmget_still_valid.patch

