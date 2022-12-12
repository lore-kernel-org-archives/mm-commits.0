Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A212CC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:17:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbiLLCRQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:17:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbiLLCQE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:16:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929F0DEEC
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2ED2C60EC3
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C38C433F1;
        Mon, 12 Dec 2022 02:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811292;
        bh=+f4bTi8dqlTgskmD6nNLGc/Bogm4EZizL1FRy1R9fWk=;
        h=Date:To:From:Subject:From;
        b=MIvHAUbirwl9v+/2Dmcdri4+Sy5yfBHeYpro9JX5k+ppN8xB1ZQyBHEvI1LgItwYS
         HeVoap6Qq92QVEkoA3+NWjetwLxDxxkX4QdMsTrL3jcX3q4yet+P1LuV7gOGymftQw
         uLifRvqX9PfleC+gJ3Rqq6pMYCvJ+DjESgIL3nmI=
Date:   Sun, 11 Dec 2022 18:14:51 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, vasily.averin@linux.dev, tj@kernel.org,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, rientjes@google.com, mhocko@suse.com,
        hannes@cmpxchg.org, chris@chrisdown.name, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-cgroup-refactor-proactive-reclaim-code-to-reclaim_until.patch removed from -mm tree
Message-Id: <20221212021452.87C38C433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: cgroup: refactor proactive reclaim code to reclaim_until()
has been removed from the -mm tree.  Its filename was
     selftests-cgroup-refactor-proactive-reclaim-code-to-reclaim_until.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
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


