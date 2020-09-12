Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C17C43461
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EBCB21D40
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599938956;
	bh=NeTIUwWuq1yD7PjYkBl54HaWMtKXKDvk7c07YbjFAZg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=QWIVBMMNGFv/KnNChaer0/VBipdZIuRiqYSf+XFmVmP5AijGPpU4VNlbGgg4jMz3p
	 YqPB0mSSuNWg/HAUGRUXIpxCiTCqYQG8dBtLrkDeqtY/pkkqHwmQXFLRIPlFMzOrm0
	 hPUC+97FrjD7ZstHXEpd7pV4cubkANmGi/1AC1cE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgILT3P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 15:29:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgILT3O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 15:29:14 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C6D721531;
        Sat, 12 Sep 2020 19:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599938953;
        bh=NeTIUwWuq1yD7PjYkBl54HaWMtKXKDvk7c07YbjFAZg=;
        h=Date:From:To:Subject:From;
        b=U3jnjcjSs5C/s4ie9OlG5jGxUc/zxhzBG2LwjpNeQkl7uZDFk1pAPCnbGHlxIVDbS
         7/dKaWNIne1A4lXmcimfxRBxweb7EXOI37xlzfc54FxoIT0Z0rLmhSoDMVfR8cpKDx
         0LhKm9qEImTwLLwOqpcsw3ichiqY3ExiuamhZoug=
Date:   Sat, 12 Sep 2020 12:29:12 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, shakeelb@google.com, mhocko@suse.com,
        hannes@cmpxchg.org, guro@fb.com
Subject:  [nacked]
 mm-workingset-ignore-slab-memory-size-when-calculating-shadows-pressure.patch
 removed from -mm tree
Message-ID: <20200912192912.WHeIo%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: workingset: ignore slab memory size when calculating shadows pressure
has been removed from the -mm tree.  Its filename was
     mm-workingset-ignore-slab-memory-size-when-calculating-shadows-pressure.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: workingset: ignore slab memory size when calculating shadows pressure

In the memcg case count_shadow_nodes() sums the number of pages in lru
lists and the amount of slab memory (reclaimable and non-reclaimable) as a
baseline for the allowed number of shadow entries.

It seems to be a good analogy for the !memcg case, where
node_present_pages() is used.  However, it's not quite true, as there two
problems:

1) Due to slab reparenting introduced by commit fb2f2b0adb98 ("mm:
   memcg/slab: reparent memcg kmem_caches on cgroup removal") local
   per-lruvec slab counters might be inaccurate on non-leaf levels.  It's
   the only place where local slab counters are used.

2) Shadow nodes by themselves are backed by slabs.  So there is a loop
   dependency: the more shadow entries are there, the less pressure the
   kernel applies to reclaim them.

Fortunately, there is a simple way to solve both problems: slab counters
shouldn't be taken into the account by count_shadow_nodes().

Link: https://lkml.kernel.org/r/20200903230055.1245058-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/workingset.c~mm-workingset-ignore-slab-memory-size-when-calculating-shadows-pressure
+++ a/mm/workingset.c
@@ -495,10 +495,6 @@ static unsigned long count_shadow_nodes(
 		for (pages = 0, i = 0; i < NR_LRU_LISTS; i++)
 			pages += lruvec_page_state_local(lruvec,
 							 NR_LRU_BASE + i);
-		pages += lruvec_page_state_local(
-			lruvec, NR_SLAB_RECLAIMABLE_B) >> PAGE_SHIFT;
-		pages += lruvec_page_state_local(
-			lruvec, NR_SLAB_UNRECLAIMABLE_B) >> PAGE_SHIFT;
 	} else
 #endif
 		pages = node_present_pages(sc->nid);
_

Patches currently in -mm which might be from guro@fb.com are

mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch
mm-rework-remote-memcg-charging-api-to-support-nesting.patch
mm-kmem-move-memcg_kmem_bypass-calls-to-get_mem-obj_cgroup_from_current.patch
mm-kmem-remove-redundant-checks-from-get_obj_cgroup_from_current.patch
mm-kmem-prepare-remote-memcg-charging-infra-for-interrupt-contexts.patch
mm-kmem-enable-kernel-memcg-accounting-from-interrupt-contexts.patch

