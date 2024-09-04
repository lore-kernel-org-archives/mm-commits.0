Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE0A78C73
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423545; cv=none; b=Ome7qe+LywOLkoJRpt2Scf0K1I6CfWan988uynnP3wymK+w2J62ovMfJyyDYrO1V3dPfjSVwDRaF53BmHxecELen2gd3Q6KvMVUxC6cE4pRU2Q5DuBARFvSD/G6Wm2zOYOa08q5asYhfoQX2RgCluMuNjQmBdkFUW23SVxLoTlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423545; c=relaxed/simple;
	bh=rJPCoUgm0iF+phj8LuSY6TO0Nrq4HJVqC91YvC0n6nY=;
	h=Date:To:From:Subject:Message-Id; b=MOgGXCBcb5RMg4+JJAV5XqkTb+XObewA5KQ3wP3W3AwVB/L3c6nY0LPIwFsPlO61g/7VgS3xQN6Pf75OqgraVEhEwFX3Lhz4Vc1bTSqNzK4qOWm0y1cNSTbx2lOl52ahXLY3EV1Jb2dIQVzfi2mNIQ8RLMCU5+Obl2jv9FEgcSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EBF2W7H9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EBF2W7H9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10538C4CEC2;
	Wed,  4 Sep 2024 04:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423545;
	bh=rJPCoUgm0iF+phj8LuSY6TO0Nrq4HJVqC91YvC0n6nY=;
	h=Date:To:From:Subject:From;
	b=EBF2W7H91MdqtmusTVuFx2IMQXoS+eU66yC9sBxe9E+eao+roVO4CJffracZY5Jfi
	 2TkQmX7LdZqk/aNe7dNcwcelWmslCWcgj2h29guJiN5WvDT1JtlG6RxRWSPa063+BN
	 DHH3hpBBw9kOhzx598LNU6E08zTARKgfp7PHhdaY=
Date: Tue, 03 Sep 2024 21:19:04 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,me@yhndnzj.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-test_zswap-add-test-for-hierarchical-zswapwriteback.patch removed from -mm tree
Message-Id: <20240904041905.10538C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: test_zswap: add test for hierarchical zswap.writeback
has been removed from the -mm tree.  Its filename was
     selftests-test_zswap-add-test-for-hierarchical-zswapwriteback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Yuan <me@yhndnzj.com>
Subject: selftests: test_zswap: add test for hierarchical zswap.writeback
Date: Fri, 23 Aug 2024 16:27:09 +0000

Ensure that zswap.writeback check goes up the cgroup tree, i.e.  is
hierarchical.  Create a subcgroup which has zswap.writeback set to 1, and
the upper hierarchy's restrictions shall apply.

Link: https://lkml.kernel.org/r/20240823162506.12117-2-me@yhndnzj.com
Signed-off-by: Mike Yuan <me@yhndnzj.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_zswap.c |   75 ++++++++++++------
 1 file changed, 54 insertions(+), 21 deletions(-)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-test_zswap-add-test-for-hierarchical-zswapwriteback
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -263,15 +263,13 @@ out:
 static int attempt_writeback(const char *cgroup, void *arg)
 {
 	long pagesize = sysconf(_SC_PAGESIZE);
-	char *test_group = arg;
 	size_t memsize = MB(4);
 	char buf[pagesize];
 	long zswap_usage;
-	bool wb_enabled;
+	bool wb_enabled = *(bool *) arg;
 	int ret = -1;
 	char *mem;
 
-	wb_enabled = cg_read_long(test_group, "memory.zswap.writeback");
 	mem = (char *)malloc(memsize);
 	if (!mem)
 		return ret;
@@ -288,12 +286,12 @@ static int attempt_writeback(const char
 		memcpy(&mem[i], buf, pagesize);
 
 	/* Try and reclaim allocated memory */
-	if (cg_write_numeric(test_group, "memory.reclaim", memsize)) {
+	if (cg_write_numeric(cgroup, "memory.reclaim", memsize)) {
 		ksft_print_msg("Failed to reclaim all of the requested memory\n");
 		goto out;
 	}
 
-	zswap_usage = cg_read_long(test_group, "memory.zswap.current");
+	zswap_usage = cg_read_long(cgroup, "memory.zswap.current");
 
 	/* zswpin */
 	for (int i = 0; i < memsize; i += pagesize) {
@@ -303,7 +301,7 @@ static int attempt_writeback(const char
 		}
 	}
 
-	if (cg_write_numeric(test_group, "memory.zswap.max", zswap_usage/2))
+	if (cg_write_numeric(cgroup, "memory.zswap.max", zswap_usage/2))
 		goto out;
 
 	/*
@@ -312,7 +310,7 @@ static int attempt_writeback(const char
 	 * If writeback is disabled, memory reclaim will fail as zswap is limited and
 	 * it can't writeback to swap.
 	 */
-	ret = cg_write_numeric(test_group, "memory.reclaim", memsize);
+	ret = cg_write_numeric(cgroup, "memory.reclaim", memsize);
 	if (!wb_enabled)
 		ret = (ret == -EAGAIN) ? 0 : -1;
 
@@ -321,12 +319,41 @@ out:
 	return ret;
 }
 
+static int test_zswap_writeback_one(const char *cgroup, bool wb)
+{
+	long zswpwb_before, zswpwb_after;
+
+	zswpwb_before = get_cg_wb_count(cgroup);
+	if (zswpwb_before != 0) {
+		ksft_print_msg("zswpwb_before = %ld instead of 0\n", zswpwb_before);
+		return -1;
+	}
+
+	if (cg_run(cgroup, attempt_writeback, (void *) &wb))
+		return -1;
+
+	/* Verify that zswap writeback occurred only if writeback was enabled */
+	zswpwb_after = get_cg_wb_count(cgroup);
+	if (zswpwb_after < 0)
+		return -1;
+
+	if (wb != !!zswpwb_after) {
+		ksft_print_msg("zswpwb_after is %ld while wb is %s",
+				zswpwb_after, wb ? "enabled" : "disabled");
+		return -1;
+	}
+
+	return 0;
+}
+
 /* Test to verify the zswap writeback path */
 static int test_zswap_writeback(const char *root, bool wb)
 {
-	long zswpwb_before, zswpwb_after;
 	int ret = KSFT_FAIL;
-	char *test_group;
+	char *test_group, *test_group_child = NULL;
+
+	if (cg_read_strcmp(root, "memory.zswap.writeback", "1"))
+		return KSFT_SKIP;
 
 	test_group = cg_name(root, "zswap_writeback_test");
 	if (!test_group)
@@ -336,29 +363,35 @@ static int test_zswap_writeback(const ch
 	if (cg_write(test_group, "memory.zswap.writeback", wb ? "1" : "0"))
 		goto out;
 
-	zswpwb_before = get_cg_wb_count(test_group);
-	if (zswpwb_before != 0) {
-		ksft_print_msg("zswpwb_before = %ld instead of 0\n", zswpwb_before);
+	if (test_zswap_writeback_one(test_group, wb))
 		goto out;
-	}
 
-	if (cg_run(test_group, attempt_writeback, (void *) test_group))
+	/* Reset memory.zswap.max to max (modified by attempt_writeback), and
+	 * set up child cgroup, whose memory.zswap.writeback is hardcoded to 1.
+	 * Thus, the parent's setting shall be what's in effect. */
+	if (cg_write(test_group, "memory.zswap.max", "max"))
+		goto out;
+	if (cg_write(test_group, "cgroup.subtree_control", "+memory"))
 		goto out;
 
-	/* Verify that zswap writeback occurred only if writeback was enabled */
-	zswpwb_after = get_cg_wb_count(test_group);
-	if (zswpwb_after < 0)
+	test_group_child = cg_name(test_group, "zswap_writeback_test_child");
+	if (!test_group_child)
+		goto out;
+	if (cg_create(test_group_child))
+		goto out;
+	if (cg_write(test_group_child, "memory.zswap.writeback", "1"))
 		goto out;
 
-	if (wb != !!zswpwb_after) {
-		ksft_print_msg("zswpwb_after is %ld while wb is %s",
-				zswpwb_after, wb ? "enabled" : "disabled");
+	if (test_zswap_writeback_one(test_group_child, wb))
 		goto out;
-	}
 
 	ret = KSFT_PASS;
 
 out:
+	if (test_group_child) {
+		cg_destroy(test_group_child);
+		free(test_group_child);
+	}
 	cg_destroy(test_group);
 	free(test_group);
 	return ret;
_

Patches currently in -mm which might be from me@yhndnzj.com are


