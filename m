Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C7C3C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 05:03:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbiDSFFs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Apr 2022 01:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235757AbiDSFFr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Apr 2022 01:05:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1C4140B9
        for <mm-commits@vger.kernel.org>; Mon, 18 Apr 2022 22:03:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E72BB811A2
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 05:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCED8C385AB;
        Tue, 19 Apr 2022 05:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650344583;
        bh=6KF2SMyd/lrO6R6eev47ux5ahz0WNbUlJaPR/LJzw3c=;
        h=Date:To:From:Subject:From;
        b=ylpteF/k2yWfQtNH5NO2Ww6SW1IeT7ZeTuvj8WcI22WQHE8V1azIWXw4LcPGHLuNI
         7IGIWqeyIIG2AOveFY9hATWIPhvxW15mvI5s3oGYTBuxd/opZJe0O/EEbeCDbhZidl
         ZaqpolCQYoezTFtcTgswNJvGB5FsHickR5A2WxNU=
Date:   Mon, 18 Apr 2022 22:03:03 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com, tj@kernel.org,
        shakeelb@google.com, mhocko@kernel.org, lizefan.x@bytedance.com,
        hannes@cmpxchg.org, chris@chrisdown.name, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftests-memcg-speed-up-the-memoryhigh-test.patch added to -mm tree
Message-Id: <20220419050303.BCED8C385AB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kselftests: memcg: speed up the memory.high test
has been added to the -mm tree.  Its filename is
     kselftests-memcg-speed-up-the-memoryhigh-test.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kselftests-memcg-speed-up-the-memoryhigh-test.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kselftests-memcg-speed-up-the-memoryhigh-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kselftests-memcg-update-the-oom-group-leaf-events-test.patch
kselftests-memcg-speed-up-the-memoryhigh-test.patch
maintainers-add-corresponding-kselftests-to-cgroup-entry.patch
maintainers-add-corresponding-kselftests-to-memcg-entry.patch
mm-do-not-call-add_nr_deferred-with-zero-deferred.patch

