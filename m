Return-Path: <SRS0=BOB0=CX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC65EC43461
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 00:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE1D020771
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 00:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600042903;
	bh=hVjqGb1zXwIWj2ao+rf7/+SNSfgwb7hjB4nPVKaxAf0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=E4aIokLnSs7NucX8RnjBUrNzPV2KVUeQQ56msdB5V0pfn+RzqwXefwnJORQnrIJqn
	 CfnMZ9s9/IrkVHizPdCUSZp9/h0k3FORZGorLODIT7mSUDcb96MzUGp9ncnY2qNR46
	 OlpQBK3u2jBoda8u5DjwWeNDqUoBn4ErSI2hP4aM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgINAVm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 13 Sep 2020 20:21:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725950AbgINAVm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 13 Sep 2020 20:21:42 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E975820756;
        Mon, 14 Sep 2020 00:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600042901;
        bh=hVjqGb1zXwIWj2ao+rf7/+SNSfgwb7hjB4nPVKaxAf0=;
        h=Date:From:To:Subject:From;
        b=py61LZNb5aIVeLlxiuNlu18aP6QSp752nnFXkJD2TW9HZi8bYFrBKAzrfii3lO6or
         m46oV5IGZdVYtNicTIvn9IS37YnIG93wvZiu/bALKRgmKPO+esWsfTiMQ2uqe/FCgO
         OX5uPXVQYQVlqk9oCGZz7gCdFshbYuY4wlXODnDM=
Date:   Sun, 13 Sep 2020 17:21:40 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        mhocko@kernel.org, hannes@cmpxchg.org, linmiaohe@huawei.com
Subject:  +
 mm-memcontrol-correct-the-comment-of-mem_cgroup_iter.patch added to -mm tree
Message-ID: <20200914002140.qsyE5%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: correct the comment of mem_cgroup_iter()
has been added to the -mm tree.  Its filename is
     mm-memcontrol-correct-the-comment-of-mem_cgroup_iter.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-correct-the-comment-of-mem_cgroup_iter.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-correct-the-comment-of-mem_cgroup_iter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: memcontrol: correct the comment of mem_cgroup_iter()

Since commit bbec2e15170a ("mm: rename page_counter's count/limit into
usage/max"), the arg @reclaim has no priority field anymore.

Link: https://lkml.kernel.org/r/20200913094129.44558-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
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

mm-swap-fix-confusing-comment-in-release_pages.patch
mm-memcontrol-correct-the-comment-of-mem_cgroup_iter.patch
mm-vmstat-use-helper-macro-abs.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

