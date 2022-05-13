Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3FFAC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378229AbiEMTVw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383456AbiEMTVX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E66A26F1
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 96746CE330E
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9089C34113;
        Fri, 13 May 2022 19:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469679;
        bh=UcMC2dD+Dys6kSIby54z5TG4Ys916j8GODsVKat/wpI=;
        h=Date:To:From:Subject:From;
        b=0aQJSXZ3on/fTTnUJuehxT+2Y20+9OlaYHvu7pHpab5b5AdpKb3cR2rzEiWhsPxR7
         qQTEhxS3N+kcRBeId3539AltuX+N3BvEVsgvD2c9fRlNlHKenVikEjCVd/epOLzFlH
         b4p3BCBKmXQ75paS60+tStcxc999Wf79u/dyhTVE=
Date:   Fri, 13 May 2022 12:21:18 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        void@manifault.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] cgroup-account-for-memory_localevents-in-test_memcg_oom_group_leaf_events.patch removed from -mm tree
Message-Id: <20220513192118.E9089C34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: cgroup: account for memory_localevents in test_memcg_oom_group_leaf_events()
has been removed from the -mm tree.  Its filename was
     cgroup-account-for-memory_localevents-in-test_memcg_oom_group_leaf_events.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Vernet <void@manifault.com>
Subject: cgroup: account for memory_localevents in test_memcg_oom_group_leaf_events()

The test_memcg_oom_group_leaf_events() testcase in the cgroup memcg tests
validates that processes in a group that perform allocations exceeding
memory.oom.group are killed.  It also validates that the
memory.events.oom_kill events are properly propagated in this case.

Commit 06e11c907ea4 ("kselftests: memcg: update the oom group leaf events
test") fixed test_memcg_oom_group_leaf_events() to account for the fact
that the memory.events.oom_kill events in a child cgroup is propagated up
to its parent.  This behavior can actually be configured by the
memory_localevents mount option, so this patch updates the testcase to
properly account for the possible presence of this mount option.

Link: https://lkml.kernel.org/r/20220423155619.3669555-4-void@manifault.com
Signed-off-by: David Vernet <void@manifault.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_memcontrol.c |   22 ++++++++++---
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~cgroup-account-for-memory_localevents-in-test_memcg_oom_group_leaf_events
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -21,6 +21,7 @@
 #include "../kselftest.h"
 #include "cgroup_util.h"
 
+static bool has_localevents;
 static bool has_recursiveprot;
 
 /*
@@ -1200,6 +1201,7 @@ static int test_memcg_oom_group_leaf_eve
 {
 	int ret = KSFT_FAIL;
 	char *parent, *child;
+	long parent_oom_events;
 
 	parent = cg_name(root, "memcg_test_0");
 	child = cg_name(root, "memcg_test_0/memcg_test_1");
@@ -1345,14 +1347,20 @@ static int test_memcg_oom_group_score_ev
 	if (!cg_run(memcg, alloc_anon, (void *)MB(100)))
 		goto cleanup;
 
-	if (cg_read_key_long(memcg, "memory.events", "oom_kill ") != 3)
-		goto cleanup;
+	parent_oom_events = cg_read_key_long(
+			parent, "memory.events", "oom_kill ");
+	/*
+	 * If memory_localevents is not enabled (the default), the parent should
+	 * count OOM events in its children groups. Otherwise, it should not
+	 * have observed any events.
+	 */
+	if ((has_localevents && parent_oom_events == 0) ||
+	     parent_oom_events > 0)
+		ret = KSFT_PASS;
 
 	if (kill(safe_pid, SIGKILL))
 		goto cleanup;
 
-	ret = KSFT_PASS;
-
 cleanup:
 	if (memcg)
 		cg_destroy(memcg);
@@ -1361,7 +1369,6 @@ cleanup:
 	return ret;
 }
 
-
 #define T(x) { x, #x }
 struct memcg_test {
 	int (*fn)(const char *root);
@@ -1408,6 +1415,11 @@ int main(int argc, char **argv)
 		ksft_exit_skip("Failed to query cgroup mount option\n");
 	has_recursiveprot = proc_status;
 
+	proc_status = proc_mount_contains("memory_localevents");
+	if (proc_status < 0)
+		ksft_exit_skip("Failed to query cgroup mount option\n");
+	has_localevents = proc_status;
+
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
_

Patches currently in -mm which might be from void@manifault.com are


