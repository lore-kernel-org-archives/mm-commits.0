Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 390B0C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357335AbiCYBcL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357315AbiCYBbw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7363E30F55
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F42861946
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E59C340EC;
        Fri, 25 Mar 2022 01:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171817;
        bh=XSvqA98AKFOepFkSzu5rmYlH7Z+WI5t/8jIY3FzA6gQ=;
        h=Date:To:From:Subject:From;
        b=DotImdpuR/rKBMmLYwlvTCLmYAqalmtSNGyyCHNN7sMlzwS0uHpXAjyIb2Gz4d/Oq
         TLwl8nTtAaEyzZIEyOt9ftJh6Zu4CmZ7WyRexDNRxHqj/A54dgFN9SgO1fxRyz7aVp
         UUmLCkaUA71fTd3AccD2p7JY9fGfOZzIgfkc8Ky0=
Date:   Thu, 24 Mar 2022 18:30:16 -0700
To:     mm-commits@vger.kernel.org, roman.gushchin@linux.dev,
        mhocko@suse.com, hannes@cmpxchg.org, guro@fb.com,
        chris@chrisdown.name, shakeelb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] selftests-memcg-test-high-limit-for-single-entry-allocation.patch removed from -mm tree
Message-Id: <20220325013017.67E59C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: memcg: test high limit for single entry allocation
has been removed from the -mm tree.  Its filename was
     selftests-memcg-test-high-limit-for-single-entry-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: selftests: memcg: test high limit for single entry allocation

Test the enforcement of memory.high limit for large amount of memory
allocation within a single kernel entry.  There are valid use-cases where
the application can trigger large amount of memory allocation within a
single syscall e.g.  mlock() or mmap(MAP_POPULATE).  Make sure memory.high
limit enforcement works for such use-cases.

Link: https://lkml.kernel.org/r/20220211064917.2028469-4-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/cgroup_util.c     |   15 ++
 tools/testing/selftests/cgroup/cgroup_util.h     |    1 
 tools/testing/selftests/cgroup/test_memcontrol.c |   78 +++++++++++++
 3 files changed, 91 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/cgroup/cgroup_util.c~selftests-memcg-test-high-limit-for-single-entry-allocation
+++ a/tools/testing/selftests/cgroup/cgroup_util.c
@@ -583,7 +583,7 @@ int clone_into_cgroup_run_wait(const cha
 	return 0;
 }
 
-int cg_prepare_for_wait(const char *cgroup)
+static int __prepare_for_wait(const char *cgroup, const char *filename)
 {
 	int fd, ret = -1;
 
@@ -591,8 +591,7 @@ int cg_prepare_for_wait(const char *cgro
 	if (fd == -1)
 		return fd;
 
-	ret = inotify_add_watch(fd, cg_control(cgroup, "cgroup.events"),
-				IN_MODIFY);
+	ret = inotify_add_watch(fd, cg_control(cgroup, filename), IN_MODIFY);
 	if (ret == -1) {
 		close(fd);
 		fd = -1;
@@ -601,6 +600,16 @@ int cg_prepare_for_wait(const char *cgro
 	return fd;
 }
 
+int cg_prepare_for_wait(const char *cgroup)
+{
+	return __prepare_for_wait(cgroup, "cgroup.events");
+}
+
+int memcg_prepare_for_wait(const char *cgroup)
+{
+	return __prepare_for_wait(cgroup, "memory.events");
+}
+
 int cg_wait_for(int fd)
 {
 	int ret = -1;
--- a/tools/testing/selftests/cgroup/cgroup_util.h~selftests-memcg-test-high-limit-for-single-entry-allocation
+++ a/tools/testing/selftests/cgroup/cgroup_util.h
@@ -55,4 +55,5 @@ extern int clone_reap(pid_t pid, int opt
 extern int clone_into_cgroup_run_wait(const char *cgroup);
 extern int dirfd_open_opath(const char *dir);
 extern int cg_prepare_for_wait(const char *cgroup);
+extern int memcg_prepare_for_wait(const char *cgroup);
 extern int cg_wait_for(int fd);
--- a/tools/testing/selftests/cgroup/test_memcontrol.c~selftests-memcg-test-high-limit-for-single-entry-allocation
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -16,6 +16,7 @@
 #include <netinet/in.h>
 #include <netdb.h>
 #include <errno.h>
+#include <sys/mman.h>
 
 #include "../kselftest.h"
 #include "cgroup_util.h"
@@ -628,6 +629,82 @@ cleanup:
 	return ret;
 }
 
+static int alloc_anon_mlock(const char *cgroup, void *arg)
+{
+	size_t size = (size_t)arg;
+	void *buf;
+
+	buf = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON,
+		   0, 0);
+	if (buf == MAP_FAILED)
+		return -1;
+
+	mlock(buf, size);
+	munmap(buf, size);
+	return 0;
+}
+
+/*
+ * This test checks that memory.high is able to throttle big single shot
+ * allocation i.e. large allocation within one kernel entry.
+ */
+static int test_memcg_high_sync(const char *root)
+{
+	int ret = KSFT_FAIL, pid, fd = -1;
+	char *memcg;
+	long pre_high, pre_max;
+	long post_high, post_max;
+
+	memcg = cg_name(root, "memcg_test");
+	if (!memcg)
+		goto cleanup;
+
+	if (cg_create(memcg))
+		goto cleanup;
+
+	pre_high = cg_read_key_long(memcg, "memory.events", "high ");
+	pre_max = cg_read_key_long(memcg, "memory.events", "max ");
+	if (pre_high < 0 || pre_max < 0)
+		goto cleanup;
+
+	if (cg_write(memcg, "memory.swap.max", "0"))
+		goto cleanup;
+
+	if (cg_write(memcg, "memory.high", "30M"))
+		goto cleanup;
+
+	if (cg_write(memcg, "memory.max", "140M"))
+		goto cleanup;
+
+	fd = memcg_prepare_for_wait(memcg);
+	if (fd < 0)
+		goto cleanup;
+
+	pid = cg_run_nowait(memcg, alloc_anon_mlock, (void *)MB(200));
+	if (pid < 0)
+		goto cleanup;
+
+	cg_wait_for(fd);
+
+	post_high = cg_read_key_long(memcg, "memory.events", "high ");
+	post_max = cg_read_key_long(memcg, "memory.events", "max ");
+	if (post_high < 0 || post_max < 0)
+		goto cleanup;
+
+	if (pre_high == post_high || pre_max != post_max)
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	if (fd >= 0)
+		close(fd);
+	cg_destroy(memcg);
+	free(memcg);
+
+	return ret;
+}
+
 /*
  * This test checks that memory.max limits the amount of
  * memory which can be consumed by either anonymous memory
@@ -1180,6 +1257,7 @@ struct memcg_test {
 	T(test_memcg_min),
 	T(test_memcg_low),
 	T(test_memcg_high),
+	T(test_memcg_high_sync),
 	T(test_memcg_max),
 	T(test_memcg_oom_events),
 	T(test_memcg_swap_max),
_

Patches currently in -mm which might be from shakeelb@google.com are

memcg-sync-flush-only-if-periodic-flush-is-delayed.patch

