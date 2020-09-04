Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34011C2BB84
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E93D62087C
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599262530;
	bh=McC9JkzlgiqDtm84S0OpJILFQ702Wqlavhc8g5GZztc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=QpzmMKRDKuEZC1mAVh8pHcp37GxujsvqQyEKU3PsIB+Nst3FjYuyp+a2wyp/e8oSh
	 EO4e/tLM85YipVd0yIgDCvyJXeQV4WovdMWU7qoM5rau3a49dJYQA/FJezY4ta59EK
	 /uLpcyartxtcQiSJjDia+WekYujIqVVVPGKaOeGI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgIDXf3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 19:35:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgIDXf2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 19:35:28 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCED6208FE;
        Fri,  4 Sep 2020 23:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599262528;
        bh=McC9JkzlgiqDtm84S0OpJILFQ702Wqlavhc8g5GZztc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pqjIXMYLfrZM5NKaZzZurJ38iskOUrKhJy79fjYeRysgPQ7w+LSzym6M9JyN/LQDS
         jFXt65OR2N88BJu0GbDvdsxfmSNVwbQySBZKHZKs3Id4si7A8ORKW7U0Oa8Lzw4o9g
         3T+xfZKPNV0RycWgjRzlaEIbAsDDgxF8EisjpEIw=
Date:   Fri, 04 Sep 2020 16:35:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        xlpang@linux.alibaba.com
Subject:  [patch 02/19] mm: memcg: fix memcg reclaim soft lockup
Message-ID: <20200904233527.1lOZT1GXC%akpm@linux-foundation.org>
In-Reply-To: <20200904163454.4db0e6ce0c4584d2653678a3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Xunlei Pang <xlpang@linux.alibaba.com>
Subject: mm: memcg: fix memcg reclaim soft lockup

We've met softlockup with "CONFIG_PREEMPT_NONE=y", when the target memcg
doesn't have any reclaimable memory.

It can be easily reproduced as below:
 watchdog: BUG: soft lockup - CPU#0 stuck for 111s![memcg_test:2204]
 CPU: 0 PID: 2204 Comm: memcg_test Not tainted 5.9.0-rc2+ #12
 Call Trace:
  shrink_lruvec+0x49f/0x640
  shrink_node+0x2a6/0x6f0
  do_try_to_free_pages+0xe9/0x3e0
  try_to_free_mem_cgroup_pages+0xef/0x1f0
  try_charge+0x2c1/0x750
  mem_cgroup_charge+0xd7/0x240
  __add_to_page_cache_locked+0x2fd/0x370
  add_to_page_cache_lru+0x4a/0xc0
  pagecache_get_page+0x10b/0x2f0
  filemap_fault+0x661/0xad0
  ext4_filemap_fault+0x2c/0x40
  __do_fault+0x4d/0xf9
  handle_mm_fault+0x1080/0x1790

It only happens on our 1-vcpu instances, because there's no chance for oom
reaper to run to reclaim the to-be-killed process.

Add a cond_resched() at the upper shrink_node_memcgs() to solve this
issue, this will mean that we will get a scheduling point for each memcg
in the reclaimed hierarchy without any dependency on the reclaimable
memory in that memcg thus making it more predictable.

Link: http://lkml.kernel.org/r/1598495549-67324-1-git-send-email-xlpang@linux.alibaba.com
Signed-off-by: Xunlei Pang <xlpang@linux.alibaba.com>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/vmscan.c~mm-memcg-fix-memcg-reclaim-soft-lockup
+++ a/mm/vmscan.c
@@ -2615,6 +2615,14 @@ static void shrink_node_memcgs(pg_data_t
 		unsigned long reclaimed;
 		unsigned long scanned;
 
+		/*
+		 * This loop can become CPU-bound when target memcgs
+		 * aren't eligible for reclaim - either because they
+		 * don't have any reclaimable pages, or because their
+		 * memory is explicitly protected. Avoid soft lockups.
+		 */
+		cond_resched();
+
 		mem_cgroup_calculate_protection(target_memcg, memcg);
 
 		if (mem_cgroup_below_min(memcg)) {
_
