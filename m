Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA54C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 24 Apr 2022 20:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239579AbiDXUhB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 24 Apr 2022 16:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbiDXUg7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 24 Apr 2022 16:36:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21807156E25
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 13:33:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8244B80EF0
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 20:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F472C385A9;
        Sun, 24 Apr 2022 20:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650832435;
        bh=T93k/fa9Iupc4IbP7S1po3aEIGDU80CpTm0hKQXOQn0=;
        h=Date:To:From:Subject:From;
        b=13sSz26BReYdPeZimeA6TjF88UqBwJdx5OArpIZD+MEYoO92VtCxwrVtc5jtTqB1H
         fhkrrGDcO8I56YEtE3XA0WNLv3EOL3ahCXLDlRmc2sll8Mx7HrYdiYVcHZjtr7ytbz
         MPsllhpB6DaZi4Tgxrt4QPGB4lHfcXy5ytFEwO3Y=
Date:   Sun, 24 Apr 2022 13:33:54 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        void@manifault.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + cgroups-refactor-children-cgroups-in-memcg-tests.patch added to -mm tree
Message-Id: <20220424203355.4F472C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cgroups: refactor children cgroups in memcg tests
has been added to the -mm tree.  Its filename is
     cgroups-refactor-children-cgroups-in-memcg-tests.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/cgroups-refactor-children-cgroups-in-memcg-tests.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/cgroups-refactor-children-cgroups-in-memcg-tests.patch

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
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
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

cgroups-refactor-children-cgroups-in-memcg-tests.patch
cgroup-account-for-memory_recursiveprot-in-test_memcg_low.patch
cgroup-account-for-memory_localevents-in-test_memcg_oom_group_leaf_events.patch
cgroup-removing-racy-check-in-test_memcg_sock.patch
cgroup-fix-racy-check-in-alloc_pagecache_max_30m-helper-function.patch

