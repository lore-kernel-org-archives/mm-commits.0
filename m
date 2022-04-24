Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3428C433FE
	for <mm-commits@archiver.kernel.org>; Sun, 24 Apr 2022 20:34:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239580AbiDXUhJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 24 Apr 2022 16:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239581AbiDXUhF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 24 Apr 2022 16:37:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E6D156E2E
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 13:34:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F406F612B4
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 20:34:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EDEC385A7;
        Sun, 24 Apr 2022 20:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650832443;
        bh=cma6a7LfRraO8A3Ds5GeRRuej5damAJ4ZsKlhtMJE4s=;
        h=Date:To:From:Subject:From;
        b=YwGAbjYfCixu3DqXLc9m8TJNi1wZITyBeVSX1kYOfjaV1wcBMrUXmBztzASj+93yL
         /iCbnYe3lw82O+E09WwOR309wkaZZhi64WZXN7UXmgiNRxzW4Zu4SiTAXolcjaH48T
         Gq17IDjkgBp1oW7s6liqv8DvRyi4lIB+iNw9jjOc=
Date:   Sun, 24 Apr 2022 13:34:02 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        void@manifault.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + cgroup-fix-racy-check-in-alloc_pagecache_max_30m-helper-function.patch added to -mm tree
Message-Id: <20220424203403.55EDEC385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: fix racy check in alloc_pagecache_max_30M() helper function
has been added to the -mm tree.  Its filename is
     cgroup-fix-racy-check-in-alloc_pagecache_max_30m-helper-function.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/cgroup-fix-racy-check-in-alloc_pagecache_max_30m-helper-function.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/cgroup-fix-racy-check-in-alloc_pagecache_max_30m-helper-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Vernet <void@manifault.com>
Subject: cgroup: fix racy check in alloc_pagecache_max_30M() helper function

alloc_pagecache_max_30M() in the cgroup memcg tests performs a 50MB
pagecache allocation, which it expects to be capped at 30MB due to the
calling process having a memory.high setting of 30MB.  After the
allocation, the function contains a check that verifies that MB(29) <
memory.current <= MB(30).  This check can actually fail
non-deterministically.

The testcases that use this function are test_memcg_high() and
test_memcg_max(), which set memory.min and memory.max to 30MB respectively
for the cgroup under test.  The allocation can slightly exceed this number
in both cases, and for memory.max, the process performing the allocation
will not have the OOM killer invoked as it's performing a pagecache
allocation.  This patchset therefore updates the above check to instead
use the verify_close() helper function.

Link: https://lkml.kernel.org/r/20220423155619.3669555-6-void@manifault.com
Signed-off-by: David Vernet <void@manifault.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_memcontrol.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~cgroup-fix-racy-check-in-alloc_pagecache_max_30m-helper-function
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -568,9 +568,14 @@ static int alloc_pagecache_max_30M(const
 {
 	size_t size = MB(50);
 	int ret = -1;
-	long current;
+	long current, high, max;
 	int fd;
 
+	high = cg_read_long(cgroup, "memory.high");
+	max = cg_read_long(cgroup, "memory.max");
+	if (high != MB(30) && max != MB(30))
+		goto cleanup;
+
 	fd = get_temp_fd();
 	if (fd < 0)
 		return -1;
@@ -579,7 +584,7 @@ static int alloc_pagecache_max_30M(const
 		goto cleanup;
 
 	current = cg_read_long(cgroup, "memory.current");
-	if (current <= MB(29) || current > MB(30))
+	if (!values_close(current, MB(30), 5))
 		goto cleanup;
 
 	ret = 0;
_

Patches currently in -mm which might be from void@manifault.com are

cgroups-refactor-children-cgroups-in-memcg-tests.patch
cgroup-account-for-memory_recursiveprot-in-test_memcg_low.patch
cgroup-account-for-memory_localevents-in-test_memcg_oom_group_leaf_events.patch
cgroup-removing-racy-check-in-test_memcg_sock.patch
cgroup-fix-racy-check-in-alloc_pagecache_max_30m-helper-function.patch

