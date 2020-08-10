Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2100DC433E1
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E82322073E
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027017;
	bh=M8LNsQiTQ9U6M0fi9gzr96HaWASTtxHjQC9rTEc0gP8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=uP8PsQ8GGjwWdilkrwDKEx0Zh8QG1UyAfWvXFRvsZwgh/OkT0NP8B2bIh9imlNLht
	 4OOu35aNgepLP4NA73pezIF6ISqevfR2HWWhYCDWflv39Kio0xNkwbf1pDwz6I5tTe
	 99zMLa8P8Xq77ClKeP5Ze3EGVfvHzSdC152MqowE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgHJCg4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:36:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgHJCg4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:36:56 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92491206CD;
        Mon, 10 Aug 2020 02:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027015;
        bh=M8LNsQiTQ9U6M0fi9gzr96HaWASTtxHjQC9rTEc0gP8=;
        h=Date:From:To:Subject:From;
        b=bq8dDcfjo5ps9F/wYZSbgP3GhxKTvr6yM+rKs7gfg7OB3ISziWEAd60B7XqoAU80Y
         YzcUEJWjZPqtm8T+n2gZQHllA7H7H0rOjJ83gSZ9h91FuMIDbjH7AOsC36pVkQ9nfs
         9r6wmKlT37K/nUDFmS04tMFNBjBGcRnK1FeY0LNY=
Date:   Sun, 09 Aug 2020 19:36:55 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        vbabka@suse.cz
Subject:  [merged]
 mm-memcg-slab-remove-redundant-check-in-memcg_accumulate_slabinfo.patch
 removed from -mm tree
Message-ID: <20200810023655.BVZYb7DZp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: remove redundant check in memcg_accumulate_slabinfo()
has been removed from the -mm tree.  Its filename was
     mm-memcg-slab-remove-redundant-check-in-memcg_accumulate_slabinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg/slab: remove redundant check in memcg_accumulate_slabinfo()

memcg_accumulate_slabinfo() is never called with a non-root kmem_cache as
a first argument, so the is_root_cache(s) check is redundant and can be
removed without any functional change.

Link: http://lkml.kernel.org/r/20200623174037.3951353-17-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/slab_common.c~mm-memcg-slab-remove-redundant-check-in-memcg_accumulate_slabinfo
+++ a/mm/slab_common.c
@@ -1104,9 +1104,6 @@ memcg_accumulate_slabinfo(struct kmem_ca
 	struct kmem_cache *c;
 	struct slabinfo sinfo;
 
-	if (!is_root_cache(s))
-		return;
-
 	c = memcg_cache(s);
 	if (c) {
 		memset(&sinfo, 0, sizeof(sinfo));
_

Patches currently in -mm which might be from guro@fb.com are

percpu-return-number-of-released-bytes-from-pcpu_free_area.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics-v3.patch
mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup.patch
kselftests-cgroup-add-perpcu-memory-accounting-test.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

