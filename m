Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E352C4332F
	for <mm-commits@archiver.kernel.org>; Fri,  2 Dec 2022 21:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbiLBVE3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Dec 2022 16:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234297AbiLBVE2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2022 16:04:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0646CCFD9
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 13:04:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FDA5623E9
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 21:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85821C433C1;
        Fri,  2 Dec 2022 21:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670015066;
        bh=Nls8PNHZ9/kwZ/27t/aMar9s4cuU9O1RiOP3IICaWSc=;
        h=Date:To:From:Subject:From;
        b=Szy20Hd1uAPBfNidUqNkTm9DdXwWnCemTS58ibXY8QtltmrG6gxMt7auM/4J+EqwH
         hHavDV3pQ76nuPDSE6YivUzHVvn6ivqQOtG2ntAhS0rj8jgCzqKu3abZzJU/ORvkQU
         vnROPjSHuyxVyIdylsoCXFJ6B+4ib5W1GOJK+yzk=
Date:   Fri, 02 Dec 2022 13:04:25 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, vasily.averin@linux.dev, tj@kernel.org,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, rientjes@google.com, mhocko@suse.com,
        hannes@cmpxchg.org, chris@chrisdown.name, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-refactor-proactive-reclaim-code-to-reclaim_until.patch added to mm-unstable branch
Message-Id: <20221202210426.85821C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: cgroup: refactor proactive reclaim code to reclaim_until()
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-cgroup-refactor-proactive-reclaim-code-to-reclaim_until.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-refactor-proactive-reclaim-code-to-reclaim_until.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: selftests: cgroup: refactor proactive reclaim code to reclaim_until()
Date: Fri, 2 Dec 2022 03:15:11 +0000

Refactor the code that drives writing to memory.reclaim (retrying, error
handling, etc) from test_memcg_reclaim() to a helper called
reclaim_until(), which proactively reclaims from a memcg until its usage
reaches a certain value.

While we are at it, refactor and simplify the reclaim loop.

This will be used in a following patch in another test.

Link: https://lkml.kernel.org/r/20221202031512.1365483-3-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Suggested-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Chris Down <chris@chrisdown.name>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vasily Averin <vasily.averin@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_memcontrol.c |   80 +++++++------
 1 file changed, 44 insertions(+), 36 deletions(-)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~selftests-cgroup-refactor-proactive-reclaim-code-to-reclaim_until
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -646,6 +646,48 @@ cleanup:
 }
 
 /*
+ * Reclaim from @memcg until usage reaches @goal by writing to
+ * memory.reclaim.
+ *
+ * This function will return false if the usage is already below the
+ * goal.
+ *
+ * This function assumes that writing to memory.reclaim is the only
+ * source of change in memory.current (no concurrent allocations or
+ * reclaim).
+ *
+ * This function makes sure memory.reclaim is sane. It will return
+ * false if memory.reclaim's error codes do not make sense, even if
+ * the usage goal was satisfied.
+ */
+static bool reclaim_until(const char *memcg, long goal)
+{
+	char buf[64];
+	int retries, err;
+	long current, to_reclaim;
+	bool reclaimed = false;
+
+	for (retries = 5; retries > 0; retries--) {
+		current = cg_read_long(memcg, "memory.current");
+
+		if (current < goal || values_close(current, goal, 3))
+			break;
+		/* Did memory.reclaim return 0 incorrectly? */
+		else if (reclaimed)
+			return false;
+
+		to_reclaim = current - goal;
+		snprintf(buf, sizeof(buf), "%ld", to_reclaim);
+		err = cg_write(memcg, "memory.reclaim", buf);
+		if (!err)
+			reclaimed = true;
+		else if (err != -EAGAIN)
+			return false;
+	}
+	return reclaimed;
+}
+
+/*
  * This test checks that memory.reclaim reclaims the given
  * amount of memory (from both anon and file, if possible).
  */
@@ -653,8 +695,7 @@ static int test_memcg_reclaim(const char
 {
 	int ret = KSFT_FAIL, fd, retries;
 	char *memcg;
-	long current, expected_usage, to_reclaim;
-	char buf[64];
+	long current, expected_usage;
 
 	memcg = cg_name(root, "memcg_test");
 	if (!memcg)
@@ -705,41 +746,8 @@ static int test_memcg_reclaim(const char
 	 * Reclaim until current reaches 30M, this makes sure we hit both anon
 	 * and file if swap is enabled.
 	 */
-	retries = 5;
-	while (true) {
-		int err;
-
-		current = cg_read_long(memcg, "memory.current");
-		to_reclaim = current - MB(30);
-
-		/*
-		 * We only keep looping if we get EAGAIN, which means we could
-		 * not reclaim the full amount.
-		 */
-		if (to_reclaim <= 0)
-			goto cleanup;
-
-
-		snprintf(buf, sizeof(buf), "%ld", to_reclaim);
-		err = cg_write(memcg, "memory.reclaim", buf);
-		if (!err) {
-			/*
-			 * If writing succeeds, then the written amount should have been
-			 * fully reclaimed (and maybe more).
-			 */
-			current = cg_read_long(memcg, "memory.current");
-			if (!values_close(current, MB(30), 3) && current > MB(30))
-				goto cleanup;
-			break;
-		}
-
-		/* The kernel could not reclaim the full amount, try again. */
-		if (err == -EAGAIN && retries--)
-			continue;
-
-		/* We got an unexpected error or ran out of retries. */
+	if (!reclaim_until(memcg, MB(30)))
 		goto cleanup;
-	}
 
 	ret = KSFT_PASS;
 cleanup:
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-memcg-fix-stale-protection-of-reclaim-target-memcg.patch
selftests-cgroup-refactor-proactive-reclaim-code-to-reclaim_until.patch
selftests-cgroup-make-sure-reclaim-target-memcg-is-unprotected.patch

