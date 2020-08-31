Return-Path: <SRS0=vJaG=CJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA08C433E2
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 01:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4D03207DA
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 01:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598836351;
	bh=SGIdpbyiTGz1MQIvbYow4DjnwBRvmcChqeFOCyeGp3U=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=KxwvRsbeQGLfmjcolA4ljzQooWSnkRR4Fgq7qNeOA6c1pVXoe3z/UcyqkkCOAh/mv
	 kkv9nW2gIJ+Urd9c0nwvPL2Kc/dOSlLrXv+zzST1jrL+a46JuGD0Hmy0H7Pz7sK2EJ
	 PiT+kHGjYv8NThrA3F7A8waUa60aCM4zeI9HaD1E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgHaBMb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 30 Aug 2020 21:12:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726601AbgHaBMb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 30 Aug 2020 21:12:31 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8330F20782;
        Mon, 31 Aug 2020 01:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598836350;
        bh=SGIdpbyiTGz1MQIvbYow4DjnwBRvmcChqeFOCyeGp3U=;
        h=Date:From:To:Subject:From;
        b=uXVC6oI2wt82jYoIJC9OwyK5OZjSE4QF4lEhtZ16rTlMVMoGmWm/G3IX4sAJsZZQp
         EVQOU6eQoKSWp3aCPb6y1SCJV4NU2OT2YRQceE7qNdlX0pQv0rw8ZbxPQHbjLMRC4T
         0UKHUIcaRTrPsXz/tiNDudJwxbPilS7CJ74JDQmw=
Date:   Sun, 30 Aug 2020 18:12:29 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mhocko@suse.com, hannes@cmpxchg.org,
        chris@chrisdown.name, xlpang@linux.alibaba.com
Subject:  + mm-memcg-fix-memcg-reclaim-soft-lockup.patch added to -mm
 tree
Message-ID: <20200831011229.hqkzD%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: fix memcg reclaim soft lockup
has been added to the -mm tree.  Its filename is
     mm-memcg-fix-memcg-reclaim-soft-lockup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-fix-memcg-reclaim-soft-lockup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-fix-memcg-reclaim-soft-lockup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from xlpang@linux.alibaba.com are

mm-memcg-fix-memcg-reclaim-soft-lockup.patch

