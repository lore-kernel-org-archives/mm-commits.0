Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1693CC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:21:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383809AbiEMTVs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383861AbiEMTVU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9D226F1
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CF876220A
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D37CFC34100;
        Fri, 13 May 2022 19:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469677;
        bh=kzNeJd5rw7DzQH/mDHQZ65/r/bdz2/cI6m2sidp/ip0=;
        h=Date:To:From:Subject:From;
        b=m/2Sh7Xbq9x1AjizQr5dHL5/pgpLZbEFy3Ig+Ib65+mOMlPIXyJeXfshzqXnyenwn
         kfp5EATM6yYddwUZLZBnBjoyS+pPj44qeEtAnyH5dTIuw0jRQnDkE0gHT9QHAlfpa7
         nJrh3Q2XL2/b1SZaifr46Afs6OZ46obk8ahjCTlA=
Date:   Fri, 13 May 2022 12:21:17 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        void@manifault.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] cgroup-account-for-memory_recursiveprot-in-test_memcg_low.patch removed from -mm tree
Message-Id: <20220513192117.D37CFC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: cgroup: account for memory_recursiveprot in test_memcg_low()
has been removed from the -mm tree.  Its filename was
     cgroup-account-for-memory_recursiveprot-in-test_memcg_low.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lkml.kernel.org/r/20220423155619.3669555-3-void@manifault.com
Signed-off-by: David Vernet <void@manifault.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
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
@@ -528,6 +528,18 @@ int set_oom_adj_score(int pid, int score
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
@@ -525,15 +527,18 @@ static int test_memcg_low(const char *ro
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
@@ -1382,7 +1387,7 @@ struct memcg_test {
 int main(int argc, char **argv)
 {
 	char root[PATH_MAX];
-	int i, ret = EXIT_SUCCESS;
+	int i, proc_status, ret = EXIT_SUCCESS;
 
 	if (cg_find_unified_root(root, sizeof(root)))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
@@ -1398,6 +1403,11 @@ int main(int argc, char **argv)
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


