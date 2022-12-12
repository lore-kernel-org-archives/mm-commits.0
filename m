Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79987C001B2
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:17:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbiLLCRS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbiLLCQR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:16:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B73DFBB
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DB0DB80B6A
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE24C433EF;
        Mon, 12 Dec 2022 02:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811293;
        bh=A+99Wj1ViaCqvVoE+O+NI/adea7jkfgFt0K4L5GXhxQ=;
        h=Date:To:From:Subject:From;
        b=hTCqcfB5pg9kW5gjs0R4Z9u7J0G37NRIlgKJ65X7xKBt94yVeyDd75fLZXpmA3x8o
         ODFMuitbmeNX2ytGiL2XY96qCJgMUk5aO9wlcYvgEWUkvqS16spSa2RekqTzl2WPyY
         Ris3TKlZFqqnmlfwayf2STfM6HUVUto7gZOlooug=
Date:   Sun, 11 Dec 2022 18:14:53 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, vasily.averin@linux.dev, tj@kernel.org,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, rientjes@google.com, mhocko@suse.com,
        hannes@cmpxchg.org, chris@chrisdown.name, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-cgroup-make-sure-reclaim-target-memcg-is-unprotected.patch removed from -mm tree
Message-Id: <20221212021453.CFE24C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: cgroup: make sure reclaim target memcg is unprotected
has been removed from the -mm tree.  Its filename was
     selftests-cgroup-make-sure-reclaim-target-memcg-is-unprotected.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: selftests: cgroup: make sure reclaim target memcg is unprotected
Date: Fri, 2 Dec 2022 03:15:12 +0000

Make sure that we ignore protection of a memcg that is the target of memcg
reclaim.

Link: https://lkml.kernel.org/r/20221202031512.1365483-4-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
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

 tools/testing/selftests/cgroup/test_memcontrol.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~selftests-cgroup-make-sure-reclaim-target-memcg-is-unprotected
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -238,6 +238,8 @@ static int cg_test_proc_killed(const cha
 	return -1;
 }
 
+static bool reclaim_until(const char *memcg, long goal);
+
 /*
  * First, this test creates the following hierarchy:
  * A       memory.min = 0,    memory.max = 200M
@@ -266,6 +268,12 @@ static int cg_test_proc_killed(const cha
  * unprotected memory in A available, and checks that:
  * a) memory.min protects pagecache even in this case,
  * b) memory.low allows reclaiming page cache with low events.
+ *
+ * Then we try to reclaim from A/B/C using memory.reclaim until its
+ * usage reaches 10M.
+ * This makes sure that:
+ * (a) We ignore the protection of the reclaim target memcg.
+ * (b) The previously calculated emin value (~29M) should be dismissed.
  */
 static int test_memcg_protection(const char *root, bool min)
 {
@@ -385,6 +393,9 @@ static int test_memcg_protection(const c
 	if (!values_close(cg_read_long(parent[1], "memory.current"), MB(50), 3))
 		goto cleanup;
 
+	if (!reclaim_until(children[0], MB(10)))
+		goto cleanup;
+
 	if (min) {
 		ret = KSFT_PASS;
 		goto cleanup;
_

Patches currently in -mm which might be from yosryahmed@google.com are


