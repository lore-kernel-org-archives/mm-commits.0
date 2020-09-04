Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8714EC433E2
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 04:18:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59E4520791
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 04:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599193082;
	bh=pLaN6cgjDqrL0hnBQ29krdJWTlnEvFvzKfWHvomMovE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=byhAIk6LnlyyyCdcxhHbwR+4CmZYAhaoJqPo3wg8jyn4WPeDOqcBNLXRVrg7nTNsy
	 C9JzPLDFkeuHGlIlsj7AUNjUJk2q4cvCSB4JDhxXdEsb3t2CoOUbQLnBJwZApRIUvn
	 YsOn0uPB8r4gzlTNR+/LKb7KN0MKYATuhdtKL1Cg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgIDESC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 00:18:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbgIDESB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 00:18:01 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8299920748;
        Fri,  4 Sep 2020 04:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599193079;
        bh=pLaN6cgjDqrL0hnBQ29krdJWTlnEvFvzKfWHvomMovE=;
        h=Date:From:To:Subject:From;
        b=zOW8IILvi00OUdE0MHRUSMaltUTQsWhAU6lBlqya3bIMX493ylK6/F7GboTSswFbL
         rwWErArQe2VkyaSiMAhRRTmLqxSqG4L+/QyxWqsD7C++qfdxyWxpfK6JIWFFJW8por
         ww7ToncEUVBBo0p32mAEIjmgl5XCv7+aDjS0mA84=
Date:   Thu, 03 Sep 2020 21:17:58 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, shakeelb@google.com, mhocko@suse.com,
        hannes@cmpxchg.org, guro@fb.com
Subject:  +
 mm-workingset-ignore-slab-memory-size-when-calculating-shadows-pressure.patch
 added to -mm tree
Message-ID: <20200904041758.XhpP3%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: workingset: ignore slab memory size when calculating shadows pressure
has been added to the -mm tree.  Its filename is
     mm-workingset-ignore-slab-memory-size-when-calculating-shadows-pressure.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-workingset-ignore-slab-memory-size-when-calculating-shadows-pressure.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-workingset-ignore-slab-memory-size-when-calculating-shadows-pressure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-workingset-ignore-slab-memory-size-when-calculating-shadows-pressure.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch
mm-rework-remote-memcg-charging-api-to-support-nesting.patch
mm-kmem-move-memcg_kmem_bypass-calls-to-get_mem-obj_cgroup_from_current.patch
mm-kmem-remove-redundant-checks-from-get_obj_cgroup_from_current.patch
mm-kmem-prepare-remote-memcg-charging-infra-for-interrupt-contexts.patch
mm-kmem-enable-kernel-memcg-accounting-from-interrupt-contexts.patch

