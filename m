Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 165AAC433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCBD52065D
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027049;
	bh=CATPg4knbaqTUnNJtuNnE6kKXOQ/r+Z1swl1AeFS4xY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=b91yuvYCrOB+JoH/Xo0ahT92fNrZ9w0vm4yf1mDidxKRVWbGNRarLV3fYEpJzcyy8
	 ER/tZ5LoHK5WpgOT1mxQUVtP/O5U55dZBiQ4oFHpzbF/WVYRuUGKNINPF/TqLKclkM
	 s9quUZO00BaASK++GCzvk2ARKkxZr8FrdWYeYpq0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgHJCh3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:37:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726389AbgHJCh3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:37:29 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 937BE206C3;
        Mon, 10 Aug 2020 02:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027048;
        bh=CATPg4knbaqTUnNJtuNnE6kKXOQ/r+Z1swl1AeFS4xY=;
        h=Date:From:To:Subject:From;
        b=zwbKkl06E5hp5rmouKvOrEe74jSJktDiO/4V1magfpTwaEkIzlDALAQqn6LXmuelj
         +l4YPznhN57YRq2ebe6Qsyx0fgNMBIkEFjo+ms/PL/A6ze2CMaAt+AFzN5Rbeb5BMn
         u9IlQZ2OR8BsQFaJ5NqcOxG63NvonW0AFHUWUd0U=
Date:   Sun, 09 Aug 2020 19:37:28 -0700
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  [merged]
 mm-memcontrol-restore-proper-dirty-throttling-when-memoryhigh-changes.patch
 removed from -mm tree
Message-ID: <20200810023728.fKamxyMZu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: restore proper dirty throttling when memory.high changes
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-restore-proper-dirty-throttling-when-memoryhigh-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: restore proper dirty throttling when memory.high changes

Commit 8c8c383c04f6 ("mm: memcontrol: try harder to set a new
memory.high") inadvertently removed a callback to recalculate the
writeback cache size in light of a newly configured memory.high limit.

Without letting the writeback cache know about a potentially heavily
reduced limit, it may permit too many dirty pages, which can cause
unnecessary reclaim latencies or even avoidable OOM situations.

This was spotted while reading the code, it hasn't knowingly caused any
problems in practice so far.

Link: http://lkml.kernel.org/r/20200728135210.379885-1-hannes@cmpxchg.org
Fixes: 8c8c383c04f6 ("mm: memcontrol: try harder to set a new memory.high")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memcontrol.c~mm-memcontrol-restore-proper-dirty-throttling-when-memoryhigh-changes
+++ a/mm/memcontrol.c
@@ -6273,6 +6273,8 @@ static ssize_t memory_high_write(struct
 
 	page_counter_set_high(&memcg->memory, high);
 
+	memcg_wb_domain_size_changed(memcg);
+
 	return nbytes;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


