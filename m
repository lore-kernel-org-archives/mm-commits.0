Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D28DEC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:21:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383683AbiEMTVv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378229AbiEMTVW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5A66274
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF6BF62245
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8DDC34113;
        Fri, 13 May 2022 19:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469681;
        bh=3IaOOjdmLgLLxS1YD4hRRwEm8QS6KrmCLfuQt+RVVEQ=;
        h=Date:To:From:Subject:From;
        b=QGXI9Q+f+RDeeu1K9CKU57kJsV9pgiVkmCyfCGMJx5hEy4flQeGiqnfsHUGG4QE37
         Jb/fR6ubgbEeymjzNQczWCq48kjjC3LSXBDF/et+VEuaX9RPFBHKrU4H7eItKhsveU
         3VsGnFrkx/3ky6r/RaQBM7TWMQ+qcWJhxTh3FBeY=
Date:   Fri, 13 May 2022 12:21:20 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        void@manifault.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] cgroup-fix-racy-check-in-alloc_pagecache_max_30m-helper-function.patch removed from -mm tree
Message-Id: <20220513192121.2D8DDC34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: cgroup: fix racy check in alloc_pagecache_max_30M() helper function
has been removed from the -mm tree.  Its filename was
     cgroup-fix-racy-check-in-alloc_pagecache_max_30m-helper-function.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


