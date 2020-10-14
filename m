Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CBD3C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:00:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E0232224E
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709212;
	bh=irn/MG/uIdLbzXywxGokvevLQqxQq5sCYmmn16B4Jx8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ymzb9jwUAu4o8lZkjti19/qSNhdo1X9y0AdG4KM6Tf5dgdaggPsladI1muZtc+d+O
	 tCZTBAxovLXL2J10IOffTVnXKpiNfDasYq/UBzDYmkmwgTXiIvcXOTYYbJUu/FF/y1
	 Khmw3RcYZS10uSzq9P93U91E2xVCJzxHFzzJsDIw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbgJNVAL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:00:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbgJNVAL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:00:11 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E08E22248;
        Wed, 14 Oct 2020 21:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709210;
        bh=irn/MG/uIdLbzXywxGokvevLQqxQq5sCYmmn16B4Jx8=;
        h=Date:From:To:Subject:From;
        b=S05ztBXvodkwmlD1M42UabJOSmiGFnakcw6gbGWGF+WDrbwG7j6z+ODvR1I9gwMZo
         rTW6/smzfyJb1fRoTv0IpM8Vvg9MuZhHZfbLS28jezo0uEpzq7L8hfK/9+76Bp2tnp
         zeX2DoFzgtOGL+zr0fs+mAQT9bAanvpv09fgNpE4=
Date:   Wed, 14 Oct 2020 14:00:10 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, linmiaohe@huawei.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcontrol-correct-the-comment-of-mem_cgroup_iter.patch removed from -mm
 tree
Message-ID: <20201014210010.YCuftA5gH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: correct the comment of mem_cgroup_iter()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-correct-the-comment-of-mem_cgroup_iter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: memcontrol: correct the comment of mem_cgroup_iter()

Since commit bbec2e15170a ("mm: rename page_counter's count/limit into
usage/max"), the arg @reclaim has no priority field anymore.

Link: https://lkml.kernel.org/r/20200913094129.44558-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-correct-the-comment-of-mem_cgroup_iter
+++ a/mm/memcontrol.c
@@ -1102,9 +1102,9 @@ static __always_inline struct mem_cgroup
  * invocations for reference counting, or use mem_cgroup_iter_break()
  * to cancel a hierarchy walk before the round-trip is complete.
  *
- * Reclaimers can specify a node and a priority level in @reclaim to
- * divide up the memcgs in the hierarchy among all concurrent
- * reclaimers operating on the same node and priority.
+ * Reclaimers can specify a node in @reclaim to divide up the memcgs
+ * in the hierarchy among all concurrent reclaimers operating on the
+ * same node.
  */
 struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 				   struct mem_cgroup *prev,
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-vmstat-use-helper-macro-abs.patch
mm-fix-some-broken-comments.patch
mm-use-helper-function-put_write_access.patch
percpu_counter-use-helper-macro-abs.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

