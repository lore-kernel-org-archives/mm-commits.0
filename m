Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72131C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbiEJEPK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235937AbiEJEOm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:14:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C22EE23
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:10:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBA866172E
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299B2C385C5;
        Tue, 10 May 2022 04:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155844;
        bh=vfaa8LblQqgk2ZEF96Q9FbD+rSntnKhZ1wWC8fej7s4=;
        h=Date:To:From:Subject:From;
        b=LSG9uihOWFxIKbfH688/IkWJrSi2LqDPYnJ3qtnjrh1hLZYNxsAu2OT6H8ag9j2ok
         NQdHI7Cr2VccLhB6KR2oSsweY+qcDeKqiQv4Mqem9lsQTpOMb62lV9sI/x/kvckO+6
         i1q2ISLImrSnaaJdkQczXdBJ+p50EBUmZeasGoMw=
Date:   Mon, 09 May 2022 21:10:43 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com, tj@kernel.org,
        shakeelb@google.com, mhocko@kernel.org, lizefan.x@bytedance.com,
        hannes@cmpxchg.org, chris@chrisdown.name, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kselftests-memcg-speed-up-the-memoryhigh-test.patch removed from -mm tree
Message-Id: <20220510041044.299B2C385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kselftests: memcg: speed up the memory.high test
has been removed from the -mm tree.  Its filename was
     kselftests-memcg-speed-up-the-memoryhigh-test.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: kselftests: memcg: speed up the memory.high test

After commit 0e4b01df8659 ("mm, memcg: throttle allocators when failing
reclaim over memory.high") allocating memory over memory.high became very
time consuming.  But it's exactly what the memory.high test from cgroup
kselftests is doing: it tries to allocate 100M with 30M memory.high value.
It takes forever to complete.

In order to keep it passing (or failing) in a reasonable amount of time
let's try to allocate only a little over 30M: 31M to be precise.

With this change test_memcontrol finishes in a reasonable amount of
time:
  $ time ./test_memcontrol
  ok 1 test_memcg_subtree_control
  ok 2 test_memcg_current
  ok 3 test_memcg_min
  ok 4 test_memcg_low
  ok 5 test_memcg_high
  ok 6 test_memcg_max
  ok 7 test_memcg_oom_events
  ok 8 test_memcg_swap_max
  ok 9 test_memcg_sock
  ok 10 test_memcg_oom_group_leaf_events
  ok 11 test_memcg_oom_group_parent_events
  ok 12 test_memcg_oom_group_score_events

  real	0m2.273s
  user	0m0.064s
  sys	0m0.739s

Link: https://lkml.kernel.org/r/20220415000133.3955987-3-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: David Vernet <void@manifault.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~kselftests-memcg-speed-up-the-memoryhigh-test
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -607,7 +607,7 @@ static int test_memcg_high(const char *r
 	if (cg_write(memcg, "memory.high", "30M"))
 		goto cleanup;
 
-	if (cg_run(memcg, alloc_anon, (void *)MB(100)))
+	if (cg_run(memcg, alloc_anon, (void *)MB(31)))
 		goto cleanup;
 
 	if (!cg_run(memcg, alloc_pagecache_50M_check, NULL))
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are


