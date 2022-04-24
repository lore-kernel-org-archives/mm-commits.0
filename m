Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ED40C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 24 Apr 2022 20:34:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239582AbiDXUhJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 24 Apr 2022 16:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239578AbiDXUhE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 24 Apr 2022 16:37:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54366156E25
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 13:34:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CBABB80EF0
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 20:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA7CC385A7;
        Sun, 24 Apr 2022 20:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650832439;
        bh=l5wC3zX5p36vuz2ylCeNicARQZicJ5Simf9JaMmi2mY=;
        h=Date:To:From:Subject:From;
        b=N4EKInGjz7bOaYMaq8sYm5FjRoo5HKAuKdHxAAzdEwCTf1sF9UtyHYVCvYdTzOjt6
         lyxyzaZf8MLIJm9dr5ixbswwz3SRo61ODMfO0PlXB1EzeMIFQjk4nHiqZVUAt51dTE
         1n+O1h7oBeuJxk7Vlf1fV25bE6TeSppX0ZUR6WNc=
Date:   Sun, 24 Apr 2022 13:33:59 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        void@manifault.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + cgroup-account-for-memory_localevents-in-test_memcg_oom_group_leaf_events.patch added to -mm tree
Message-Id: <20220424203359.AEA7CC385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: account for memory_localevents in test_memcg_oom_group_leaf_events()
has been added to the -mm tree.  Its filename is
     cgroup-account-for-memory_localevents-in-test_memcg_oom_group_leaf_events.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/cgroup-account-for-memory_localevents-in-test_memcg_oom_group_leaf_events.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/cgroup-account-for-memory_localevents-in-test_memcg_oom_group_leaf_events.patch

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

 tools/testing/selftests/cgroup/test_memcontrol.c |   21 ++++++++++---
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~cgroup-account-for-memory_localevents-in-test_memcg_oom_group_leaf_events
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -21,6 +21,7 @@
 #include "../kselftest.h"
 #include "cgroup_util.h"
 
+static bool has_localevents;
 static bool has_recursiveprot;
 
 /*
@@ -1180,6 +1181,7 @@ static int test_memcg_oom_group_leaf_eve
 {
 	int ret = KSFT_FAIL;
 	char *parent, *child;
+	long parent_oom_events;
 
 	parent = cg_name(root, "memcg_test_0");
 	child = cg_name(root, "memcg_test_0/memcg_test_1");
@@ -1217,10 +1219,16 @@ static int test_memcg_oom_group_leaf_eve
 	if (cg_read_key_long(child, "memory.events", "oom_kill ") <= 0)
 		goto cleanup;
 
-	if (cg_read_key_long(parent, "memory.events", "oom_kill ") <= 0)
-		goto cleanup;
-
-	ret = KSFT_PASS;
+	parent_oom_events = cg_read_key_long(
+			parent, "memory.events", "oom_kill ");
+	/*
+	 * If memory_localevents is not enabled (the default), the parent should
+	 * count OOM events in its children groups. Otherwise, it should not
+	 * have observed any events.
+	 */
+	if ((has_localevents && parent_oom_events == 0) ||
+	    parent_oom_events > 0)
+		ret = KSFT_PASS;
 
 cleanup:
 	if (child)
@@ -1388,6 +1396,11 @@ int main(int argc, char **argv)
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

cgroups-refactor-children-cgroups-in-memcg-tests.patch
cgroup-account-for-memory_recursiveprot-in-test_memcg_low.patch
cgroup-account-for-memory_localevents-in-test_memcg_oom_group_leaf_events.patch
cgroup-removing-racy-check-in-test_memcg_sock.patch
cgroup-fix-racy-check-in-alloc_pagecache_max_30m-helper-function.patch

