Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0AD4C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 22 Apr 2022 22:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233220AbiDVWrT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Apr 2022 18:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233556AbiDVWqz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2022 18:46:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E012EFF19
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 14:37:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7D8AB83298
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 21:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70182C385A0;
        Fri, 22 Apr 2022 21:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650663474;
        bh=OReMBWlI7O4y4/muwnWKzLvW9PFhuxQ41iDS8RRPwD4=;
        h=Date:To:From:Subject:From;
        b=xl62Ci6EAxJI4zC4cqzS/6/OOqvAkWPovfqZQADK5zYdfUoEELhWodvhegb3z87Wb
         /dvBGu8zGrx5bzoZB6IrTIkmH6g+oCkVzlZLfeJCE26o5HNGr3RqtELZaRG85w+dBv
         ICf6vCR5RgVH3Uc0C8+DYSeAjCFb1UlvIfzpEke8=
Date:   Fri, 22 Apr 2022 14:37:53 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, weixugc@google.com,
        vaibhav@linux.ibm.com, tj@kernel.org, tim.c.chen@linux.intel.com,
        shuah@kernel.org, shakeelb@google.com, schatzberg.dan@gmail.com,
        roman.gushchin@linux.dev, rientjes@google.com, mkoutny@suse.com,
        mhocko@suse.com, lizefan.x@bytedance.com, hannes@cmpxchg.org,
        gthelen@google.com, dave.hansen@linux.intel.com, corbet@lwn.net,
        chenwandun@huawei.com, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-add-a-selftest-for-memoryreclaim.patch added to -mm tree
Message-Id: <20220422213754.70182C385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: cgroup: add a selftest for memory.reclaim
has been added to the -mm tree.  Its filename is
     selftests-cgroup-add-a-selftest-for-memoryreclaim.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-cgroup-add-a-selftest-for-memoryreclaim.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-cgroup-add-a-selftest-for-memoryreclaim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: selftests: cgroup: add a selftest for memory.reclaim

Add a new test for memory.reclaim that verifies that the interface
correctly reclaims memory as intended, from both anon and file pages.

Link: https://lkml.kernel.org/r/20220421234426.3494842-5-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Chen Wandun <chenwandun@huawei.com>
Cc: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Michal Koutný" <mkoutny@suse.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_memcontrol.c |   86 +++++++++++++
 1 file changed, 86 insertions(+)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~selftests-cgroup-add-a-selftest-for-memoryreclaim
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -771,6 +771,91 @@ cleanup:
 	return ret;
 }
 
+/*
+ * This test checks that memory.reclaim reclaims the given
+ * amount of memory (from both anon and file).
+ */
+static int test_memcg_reclaim(const char *root)
+{
+	int ret = KSFT_FAIL, fd, retries;
+	char *memcg;
+	long current, to_reclaim;
+	char buf[64];
+
+	memcg = cg_name(root, "memcg_test");
+	if (!memcg)
+		goto cleanup;
+
+	if (cg_create(memcg))
+		goto cleanup;
+
+	current = cg_read_long(memcg, "memory.current");
+	if (current != 0)
+		goto cleanup;
+
+	cg_run_nowait(memcg, alloc_anon_noexit, (void *) MB(50));
+	sleep(1);
+
+	fd = get_temp_fd();
+	if (fd < 0)
+		goto cleanup;
+
+	cg_run_nowait(memcg, alloc_pagecache_50M_noexit, (void *)(long)fd);
+	sleep(1);
+
+	current = cg_read_long(memcg, "memory.current");
+	if (!values_close(current, MB(100), 10))
+		goto cleanup;
+
+	/*
+	 * Reclaim until current reaches 30M, make sure to reclaim over 50M to
+	 * hit both anon and file.
+	 */
+	retries = 5;
+	while (true) {
+		int err;
+
+		current = cg_read_long(memcg, "memory.current");
+		to_reclaim = current - MB(30);
+
+		/*
+		 * We only keep looping if we get EAGAIN, which means we could
+		 * not reclaim the full amount.
+		 */
+		if (to_reclaim <= 0)
+			goto cleanup;
+
+
+		snprintf(buf, sizeof(buf), "%ld", to_reclaim);
+		err = cg_write(memcg, "memory.reclaim", buf);
+		if (!err) {
+			/*
+			 * If writing succeeds, then the written amount should have been
+			 * fully reclaimed (and maybe more).
+			 */
+			current = cg_read_long(memcg, "memory.current");
+			if (!values_close(current, MB(30), 3) && current > MB(30))
+				goto cleanup;
+			break;
+		}
+
+		/* The kernel could not reclaim the full amount, try again. */
+		if (err == -EAGAIN && retries--)
+			continue;
+
+		/* We got an unexpected error or ran out of retries. */
+		goto cleanup;
+	}
+
+	ret = KSFT_PASS;
+cleanup:
+	cg_destroy(memcg);
+	free(memcg);
+	close(fd);
+
+	return ret;
+}
+
 static int alloc_anon_50M_check_swap(const char *cgroup, void *arg)
 {
 	long mem_max = (long)arg;
@@ -1281,6 +1366,7 @@ struct memcg_test {
 	T(test_memcg_high),
 	T(test_memcg_high_sync),
 	T(test_memcg_max),
+	T(test_memcg_reclaim),
 	T(test_memcg_oom_events),
 	T(test_memcg_swap_max),
 	T(test_memcg_sock),
_

Patches currently in -mm which might be from yosryahmed@google.com are

selftests-cgroup-return-errno-from-cg_read-cg_write-on-failure.patch
selftests-cgroup-fix-alloc_anon_noexit-instantly-freeing-memory.patch
selftests-cgroup-add-a-selftest-for-memoryreclaim.patch

