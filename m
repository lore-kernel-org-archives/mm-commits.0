Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9157DC41535
	for <mm-commits@archiver.kernel.org>; Fri, 22 Apr 2022 22:06:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbiDVWJO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Apr 2022 18:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbiDVWIf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2022 18:08:35 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33EF179EB3
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 13:55:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 10CCDCE2D04
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 20:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485A1C385A4;
        Fri, 22 Apr 2022 20:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650658843;
        bh=/FGWoVi+1AeASYwXkv4fKbUbMRgS2N6K8yl7Lb5zyxQ=;
        h=Date:To:From:Subject:From;
        b=OqugX7OBPWSE1Vm+t1C5o4d6arF372/ZqfwtWBiU92ko03ueI54zxP4JmrbFUKJ5H
         r47+62XFmeM74vie2TUp2S0dtLNQJ03fg2CB5QjxH6y4f4ZKLJ7mEnHyxxFGMnwv9/
         TQixabakSaILKcxRuY22Tn4fpUZpaUsSN880vh9M=
Date:   Fri, 22 Apr 2022 13:20:42 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        void@manifault.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + cgroup-account-for-memory_recursiveprot-in-test_memcg_low.patch added to -mm tree
Message-Id: <20220422202043.485A1C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: account for memory_recursiveprot in test_memcg_low()
has been added to the -mm tree.  Its filename is
     cgroup-account-for-memory_recursiveprot-in-test_memcg_low.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/cgroup-account-for-memory_recursiveprot-in-test_memcg_low.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/cgroup-account-for-memory_recursiveprot-in-test_memcg_low.patch

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
Subject: cgroup: account for memory_recursiveprot in test_memcg_low()

The test_memcg_low() testcase in test_memcontrol.c verifies the expected
behavior of groups using the memory.low knob.  Part of the testcase
verifies that a group with memory.low that experiences reclaim due to
memory pressure elsewhere in the system, observes memory.events.low events
as a result of that reclaim.

In commit 8a931f801340 ("mm: memcontrol: recursive memory.low
protection"), the memory controller was updated to propagate memory.low
and memory.min protection from a parent group to its children via a
configurable memory_recursiveprot mount option.  This unfortunately broke
the memcg tests, which asserts that a sibling that experienced reclaim but
had a memory.low value of 0, would not observe any memory.low events. 
This patch updates test_memcg_low() to account for the new behavior
introduced by memory_recursiveprot.

So as to make the test resilient to multiple configurations, the patch
also adds a new proc_mount_contains() helper that checks for a string in
/proc/mounts, and is used to toggle behavior based on whether the default
memory_recursiveprot was present.

Link: https://lkml.kernel.org/r/20220422155728.3055914-3-void@manifault.com
Signed-off-by: David Vernet <void@manifault.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/cgroup_util.c     |   12 +++++++++
 tools/testing/selftests/cgroup/cgroup_util.h     |    1 
 tools/testing/selftests/cgroup/test_memcontrol.c |   16 ++++++++++---
 3 files changed, 26 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/cgroup/cgroup_util.c~cgroup-account-for-memory_recursiveprot-in-test_memcg_low
+++ a/tools/testing/selftests/cgroup/cgroup_util.c
@@ -535,6 +535,18 @@ int set_oom_adj_score(int pid, int score
 	return 0;
 }
 
+int proc_mount_contains(const char *option)
+{
+	char buf[4 * PAGE_SIZE];
+	ssize_t read;
+
+	read = read_text("/proc/mounts", buf, sizeof(buf));
+	if (read < 0)
+		return read;
+
+	return strstr(buf, option) != NULL;
+}
+
 ssize_t proc_read_text(int pid, bool thread, const char *item, char *buf, size_t size)
 {
 	char path[PATH_MAX];
--- a/tools/testing/selftests/cgroup/cgroup_util.h~cgroup-account-for-memory_recursiveprot-in-test_memcg_low
+++ a/tools/testing/selftests/cgroup/cgroup_util.h
@@ -48,6 +48,7 @@ extern int is_swap_enabled(void);
 extern int set_oom_adj_score(int pid, int score);
 extern int cg_wait_for_proc_count(const char *cgroup, int count);
 extern int cg_killall(const char *cgroup);
+int proc_mount_contains(const char *option);
 extern ssize_t proc_read_text(int pid, bool thread, const char *item, char *buf, size_t size);
 extern int proc_read_strstr(int pid, bool thread, const char *item, const char *needle);
 extern pid_t clone_into_cgroup(int cgroup_fd);
--- a/tools/testing/selftests/cgroup/test_memcontrol.c~cgroup-account-for-memory_recursiveprot-in-test_memcg_low
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -21,6 +21,8 @@
 #include "../kselftest.h"
 #include "cgroup_util.h"
 
+static bool has_recursiveprot;
+
 /*
  * This test creates two nested cgroups with and without enabling
  * the memory controller.
@@ -521,15 +523,18 @@ static int test_memcg_low(const char *ro
 	}
 
 	for (i = 0; i < ARRAY_SIZE(children); i++) {
+		int no_low_events_index = has_recursiveprot ? 2 : 1;
+
 		oom = cg_read_key_long(children[i], "memory.events", "oom ");
 		low = cg_read_key_long(children[i], "memory.events", "low ");
 
 		if (oom)
 			goto cleanup;
-		if (i < 2 && low <= 0)
+		if (i <= no_low_events_index && low <= 0)
 			goto cleanup;
-		if (i >= 2 && low)
+		if (i > no_low_events_index && low)
 			goto cleanup;
+
 	}
 
 	ret = KSFT_PASS;
@@ -1272,7 +1277,7 @@ struct memcg_test {
 int main(int argc, char **argv)
 {
 	char root[PATH_MAX];
-	int i, ret = EXIT_SUCCESS;
+	int i, proc_status, ret = EXIT_SUCCESS;
 
 	if (cg_find_unified_root(root, sizeof(root)))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
@@ -1288,6 +1293,11 @@ int main(int argc, char **argv)
 		if (cg_write(root, "cgroup.subtree_control", "+memory"))
 			ksft_exit_skip("Failed to set memory controller\n");
 
+	proc_status = proc_mount_contains("memory_recursiveprot");
+	if (proc_status < 0)
+		ksft_exit_skip("Failed to query cgroup mount option\n");
+	has_recursiveprot = proc_status;
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

