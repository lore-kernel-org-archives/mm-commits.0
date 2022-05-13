Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ECEBC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:21:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355094AbiEMTVs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383856AbiEMTVT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A41DDE
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6203C6225A
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5EECC34100;
        Fri, 13 May 2022 19:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469676;
        bh=s2zgFTa59a19BJ/QFxFmRLLlhAp4m+hFQCW9X89VEYk=;
        h=Date:To:From:Subject:From;
        b=iOArz012k6fkh2ZDT4tAaHpoeDz4KlSPaBm3IPkj/wIsMXhaRRdkQcQSS650tDBUB
         lSvLFNr1ZTFvLpzE7JDjLQv8M0JNhDIAItDfzkIlXsNUjZCtAUbdLwZyToD3IZwfHN
         zQ2TH2c4y3+Ae+u6e2C7+yy3jxJhPI4jOgcPoJOI=
Date:   Fri, 13 May 2022 12:21:16 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        void@manifault.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] cgroups-refactor-children-cgroups-in-memcg-tests.patch removed from -mm tree
Message-Id: <20220513192116.B5EECC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: cgroups: refactor children cgroups in memcg tests
has been removed from the -mm tree.  Its filename was
     cgroups-refactor-children-cgroups-in-memcg-tests.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Vernet <void@manifault.com>
Subject: cgroups: refactor children cgroups in memcg tests

Patch series "Fix bugs in memcontroller cgroup tests", v2.

tools/testing/selftests/cgroup/test_memcontrol.c contains a set of
testcases which validate expected behavior of the cgroup memory
controller.  Roman Gushchin recently sent out a patchset that fixed a few
issues in the test.  This patchset continues that effort by fixing a few
more issues that were causing non-deterministic failures in the suite. 
With this patchset, I'm unable to reproduce any more errors after running
the tests in a continuous loop for many iterations.  Before, I was able to
reproduce at least one of the errors fixed in this patchset with just one
or two runs.


This patch (of 5):

In test_memcg_min() and test_memcg_low(), there is an array of four
sibling cgroups.  All but one of these sibling groups does a 50MB
allocation, and the group that does no allocation is the third of four in
the array.  This is not a problem per se, but makes it a bit tricky to do
some assertions in test_memcg_low(), as we want to make assertions on the
siblings based on whether or not they performed allocations.  Having a
static index before which all groups have performed an allocation makes
this cleaner.

This patch therefore reorders the sibling groups so that the group that
performs no allocations is the last in the array.  A follow-on patch will
leverage this to fix a bug in the test that incorrectly asserts that a
sibling group that had performed an allocation, but only had protection
from its parent, will not observe any memory.events.low events during
reclaim.

Link: https://lkml.kernel.org/r/20220423155619.3669555-1-void@manifault.com
Link: https://lkml.kernel.org/r/20220423155619.3669555-2-void@manifault.com
Signed-off-by: David Vernet <void@manifault.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_memcontrol.c |   28 ++++++-------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~cgroups-refactor-children-cgroups-in-memcg-tests
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -248,8 +248,8 @@ static int cg_test_proc_killed(const cha
  * A/B     memory.min = 50M,  memory.current = 50M
  * A/B/C   memory.min = 75M,  memory.current = 50M
  * A/B/D   memory.min = 25M,  memory.current = 50M
- * A/B/E   memory.min = 500M, memory.current = 0
- * A/B/F   memory.min = 0,    memory.current = 50M
+ * A/B/E   memory.min = 0,    memory.current = 50M
+ * A/B/F   memory.min = 500M, memory.current = 0
  *
  * Usages are pagecache, but the test keeps a running
  * process in every leaf cgroup.
@@ -259,7 +259,7 @@ static int cg_test_proc_killed(const cha
  * A/B    memory.current ~= 50M
  * A/B/C  memory.current ~= 33M
  * A/B/D  memory.current ~= 17M
- * A/B/E  memory.current ~= 0
+ * A/B/F  memory.current ~= 0
  *
  * After that it tries to allocate more than there is
  * unprotected memory in A available, and checks
@@ -325,7 +325,7 @@ static int test_memcg_min(const char *ro
 		if (cg_create(children[i]))
 			goto cleanup;
 
-		if (i == 2)
+		if (i > 2)
 			continue;
 
 		cg_run_nowait(children[i], alloc_pagecache_50M_noexit,
@@ -340,9 +340,9 @@ static int test_memcg_min(const char *ro
 		goto cleanup;
 	if (cg_write(children[1], "memory.min", "25M"))
 		goto cleanup;
-	if (cg_write(children[2], "memory.min", "500M"))
+	if (cg_write(children[2], "memory.min", "0"))
 		goto cleanup;
-	if (cg_write(children[3], "memory.min", "0"))
+	if (cg_write(children[3], "memory.min", "500M"))
 		goto cleanup;
 
 	attempts = 0;
@@ -368,7 +368,7 @@ static int test_memcg_min(const char *ro
 	if (!values_close(c[1], MB(17), 10))
 		goto cleanup;
 
-	if (!values_close(c[2], 0, 1))
+	if (c[3] != 0)
 		goto cleanup;
 
 	if (!cg_run(parent[2], alloc_anon, (void *)MB(170)))
@@ -405,8 +405,8 @@ cleanup:
  * A/B     memory.low = 50M,  memory.current = 50M
  * A/B/C   memory.low = 75M,  memory.current = 50M
  * A/B/D   memory.low = 25M,  memory.current = 50M
- * A/B/E   memory.low = 500M, memory.current = 0
- * A/B/F   memory.low = 0,    memory.current = 50M
+ * A/B/E   memory.low = 0,    memory.current = 50M
+ * A/B/F   memory.low = 500M, memory.current = 0
  *
  * Usages are pagecache.
  * Then it creates A/G an creates a significant
@@ -416,7 +416,7 @@ cleanup:
  * A/B    memory.current ~= 50M
  * A/B/   memory.current ~= 33M
  * A/B/D  memory.current ~= 17M
- * A/B/E  memory.current ~= 0
+ * A/B/F  memory.current ~= 0
  *
  * After that it tries to allocate more than there is
  * unprotected memory in A available,
@@ -480,7 +480,7 @@ static int test_memcg_low(const char *ro
 		if (cg_create(children[i]))
 			goto cleanup;
 
-		if (i == 2)
+		if (i > 2)
 			continue;
 
 		if (cg_run(children[i], alloc_pagecache_50M, (void *)(long)fd))
@@ -495,9 +495,9 @@ static int test_memcg_low(const char *ro
 		goto cleanup;
 	if (cg_write(children[1], "memory.low", "25M"))
 		goto cleanup;
-	if (cg_write(children[2], "memory.low", "500M"))
+	if (cg_write(children[2], "memory.low", "0"))
 		goto cleanup;
-	if (cg_write(children[3], "memory.low", "0"))
+	if (cg_write(children[3], "memory.low", "500M"))
 		goto cleanup;
 
 	if (cg_run(parent[2], alloc_anon, (void *)MB(148)))
@@ -515,7 +515,7 @@ static int test_memcg_low(const char *ro
 	if (!values_close(c[1], MB(17), 10))
 		goto cleanup;
 
-	if (!values_close(c[2], 0, 1))
+	if (c[3] != 0)
 		goto cleanup;
 
 	if (cg_run(parent[2], alloc_anon, (void *)MB(166))) {
_

Patches currently in -mm which might be from void@manifault.com are


