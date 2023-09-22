Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1A3CCD4847
	for <mm-commits@archiver.kernel.org>; Fri, 22 Sep 2023 18:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbjIVSDZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Sep 2023 14:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbjIVSDX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Sep 2023 14:03:23 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6D299
        for <mm-commits@vger.kernel.org>; Fri, 22 Sep 2023 11:03:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523D3C433C8;
        Fri, 22 Sep 2023 18:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695405797;
        bh=XvWlhmd1e2WXxQLTX5br7MpFJIxo/VcCSweeOEb8XcY=;
        h=Date:To:From:Subject:From;
        b=N+8ub30kGQl2ym0EucunSTDcy4nZLUFr6lJnis9MowOdaJNdHi8RFdN96X1On1oDj
         uEZNWuAPTe9IX9mcytpIHcWeL0d0Lc5V5p1bezuFpG4W9y5+52XTuH2bPaBAbxubLQ
         SCDI49MoQk9sbn3RYlqYnKmnK5i1JSE8wOofcDj4=
Date:   Fri, 22 Sep 2023 11:03:16 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mkoutny@suse.com,
        mhocko@kernel.org, hannes@cmpxchg.org, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-normalize-the-value-passed-into-memcg_rstat_updated.patch added to mm-unstable branch
Message-Id: <20230922180317.523D3C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: normalize the value passed into memcg_rstat_updated()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-normalize-the-value-passed-into-memcg_rstat_updated.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-normalize-the-value-passed-into-memcg_rstat_updated.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: memcg: normalize the value passed into memcg_rstat_updated()
Date: Fri, 22 Sep 2023 17:57:40 +0000

memcg_rstat_updated() uses the value of the state update to keep track of
the magnitude of pending updates, so that we only do a stats flush when
it's worth the work.  Most values passed into memcg_rstat_updated() are in
pages, however, a few of them are actually in bytes or KBs.

To put this into perspective, a 512 byte slab allocation today would look
the same as allocating 512 pages.  This may result in premature flushes,
which means unnecessary work and latency.

Normalize all the state values passed into memcg_rstat_updated() to pages.
Round up non-zero sub-page to 1 page, because memcg_rstat_updated()
ignores 0 page updates.

Link: https://lkml.kernel.org/r/20230922175741.635002-3-yosryahmed@google.com
Fixes: 5b3be698a872 ("memcg: better bounds on the memcg stats updates")
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-normalize-the-value-passed-into-memcg_rstat_updated
+++ a/mm/memcontrol.c
@@ -763,6 +763,22 @@ unsigned long memcg_page_state(struct me
 	return x;
 }
 
+static int memcg_page_state_unit(int item);
+
+/*
+ * Normalize the value passed into memcg_rstat_updated() to be in pages. Round
+ * up non-zero sub-page updates to 1 page as zero page updates are ignored.
+ */
+static int memcg_state_val_in_pages(int idx, int val)
+{
+	int unit = memcg_page_state_unit(idx);
+
+	if (!val || unit == PAGE_SIZE)
+		return val;
+	else
+		return max(val * unit / PAGE_SIZE, 1UL);
+}
+
 /**
  * __mod_memcg_state - update cgroup memory statistics
  * @memcg: the memory cgroup
@@ -775,7 +791,7 @@ void __mod_memcg_state(struct mem_cgroup
 		return;
 
 	__this_cpu_add(memcg->vmstats_percpu->state[idx], val);
-	memcg_rstat_updated(memcg, val);
+	memcg_rstat_updated(memcg, memcg_state_val_in_pages(idx, val));
 }
 
 /* idx can be of type enum memcg_stat_item or node_stat_item. */
@@ -826,7 +842,7 @@ void __mod_memcg_lruvec_state(struct lru
 	/* Update lruvec */
 	__this_cpu_add(pn->lruvec_stats_percpu->state[idx], val);
 
-	memcg_rstat_updated(memcg, val);
+	memcg_rstat_updated(memcg, memcg_state_val_in_pages(idx, val));
 	memcg_stats_unlock();
 }
 
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-memcg-refactor-page-state-unit-helpers.patch
mm-memcg-normalize-the-value-passed-into-memcg_rstat_updated.patch

