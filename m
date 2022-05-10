Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F5A1C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:16:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236163AbiEJEUj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236109AbiEJESv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:18:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFBE2817B5
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 897A86173F
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD381C385C2;
        Tue, 10 May 2022 04:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156066;
        bh=nSHrcgt25AnDu2Ou7i1vbcKs4U9KZcvclg6vRuxVS88=;
        h=Date:To:From:Subject:From;
        b=bqS2kupdHy9VrfFDeEnElROAvbdTHK0sQUrSPBfMsl0Qu1Y8d4+Kuqo4iYltckHjL
         heKU/XlrxV8Qix2ZILEwaIgzmI0JfUx2+k2qJv815njrz2VXjyNt73JSYQ4Yf2wqFr
         GmixQMQnoGYq4LOYzFBYMLHhzOdK/rShGBA0jtec=
Date:   Mon, 09 May 2022 21:14:25 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, weixugc@google.com,
        vaibhav@linux.ibm.com, tj@kernel.org, tim.c.chen@linux.intel.com,
        shuah@kernel.org, shakeelb@google.com, roman.gushchin@linux.dev,
        rientjes@google.com, mkoutny@suse.com, mhocko@suse.com,
        lizefan.x@bytedance.com, hannes@cmpxchg.org, gthelen@google.com,
        dave.hansen@linux.intel.com, corbet@lwn.net, chenwandun@huawei.com,
        yosryahmed@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-cgroup-add-a-selftest-for-memoryreclaim.patch removed from -mm tree
Message-Id: <20220510041425.DD381C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: cgroup: add a selftest for memory.reclaim
has been removed from the -mm tree.  Its filename was
     selftests-cgroup-add-a-selftest-for-memoryreclaim.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: selftests: cgroup: add a selftest for memory.reclaim

Add a new test for memory.reclaim that verifies that the interface
correctly reclaims memory as intended, from both anon and file pages.

Link: https://lkml.kernel.org/r/20220425190040.2475377-5-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Chen Wandun <chenwandun@huawei.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Michal Koutn" <mkoutny@suse.com>
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

 tools/testing/selftests/cgroup/test_memcontrol.c |  106 +++++++++++++
 1 file changed, 106 insertions(+)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~selftests-cgroup-add-a-selftest-for-memoryreclaim
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -760,6 +760,111 @@ cleanup:
 	return ret;
 }
 
+/*
+ * This test checks that memory.reclaim reclaims the given
+ * amount of memory (from both anon and file, if possible).
+ */
+static int test_memcg_reclaim(const char *root)
+{
+	int ret = KSFT_FAIL, fd, retries;
+	char *memcg;
+	long current, expected_usage, to_reclaim;
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
+	fd = get_temp_fd();
+	if (fd < 0)
+		goto cleanup;
+
+	cg_run_nowait(memcg, alloc_pagecache_50M_noexit, (void *)(long)fd);
+
+	/*
+	 * If swap is enabled, try to reclaim from both anon and file, else try
+	 * to reclaim from file only.
+	 */
+	if (is_swap_enabled()) {
+		cg_run_nowait(memcg, alloc_anon_noexit, (void *) MB(50));
+		expected_usage = MB(100);
+	} else
+		expected_usage = MB(50);
+
+	/*
+	 * Wait until current usage reaches the expected usage (or we run out of
+	 * retries).
+	 */
+	retries = 5;
+	while (!values_close(cg_read_long(memcg, "memory.current"),
+			    expected_usage, 10)) {
+		if (retries--) {
+			sleep(1);
+			continue;
+		} else {
+			fprintf(stderr,
+				"failed to allocate %ld for memcg reclaim test\n",
+				expected_usage);
+			goto cleanup;
+		}
+	}
+
+	/*
+	 * Reclaim until current reaches 30M, this makes sure we hit both anon
+	 * and file if swap is enabled.
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
@@ -1264,6 +1369,7 @@ struct memcg_test {
 	T(test_memcg_high),
 	T(test_memcg_high_sync),
 	T(test_memcg_max),
+	T(test_memcg_reclaim),
 	T(test_memcg_oom_events),
 	T(test_memcg_swap_max),
 	T(test_memcg_sock),
_

Patches currently in -mm which might be from yosryahmed@google.com are


