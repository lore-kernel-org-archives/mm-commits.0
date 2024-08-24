Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3948C14A60E
	for <mm-commits@vger.kernel.org>; Sat, 24 Aug 2024 05:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724477162; cv=none; b=hbHipJ+ZvVMI/9yd2k9lJo3BA6uJKI/LvdeVUXhdg7PuOu7DHUWWENebB2+wD2GVTzESgJXeVsLeB+SLs7l5rcoAN+LJjt29oR4XMEpi1qlyasgpl5XH1qeubuq6JiIA2+dU1YnEf3uVqs7phyJBWk1tD8W+hGTz+KyJxVHNGZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724477162; c=relaxed/simple;
	bh=qIK1f35WnOTGMniayT0MBg45I6ivzcvx6NQFPXSE/Ro=;
	h=Date:To:From:Subject:Message-Id; b=GhB0XhPdJ1RBoCx/0BAoeR3eqqL2nMR903Ah7y63BQr9udWrHx4V9/uwbQ4jgf7pO1/isvjqYs687CyqyHgI+BXk+Ms2Ph2TjpUbHfOL5T2kXzwA5mQSqK7s4PlUcMCdscV1Wq71uFfzu+BPXx1MZZZHGo8E4umV0fWWEBsmhgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fm505gQr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fm505gQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0CD0C32781;
	Sat, 24 Aug 2024 05:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724477161;
	bh=qIK1f35WnOTGMniayT0MBg45I6ivzcvx6NQFPXSE/Ro=;
	h=Date:To:From:Subject:From;
	b=fm505gQrSkuUyod1Mo/9+gCq34n4XKe4JFqfrI3EueZx45221HStDcIJgqIafbZqu
	 knW9om9Vj4AwDI9uxkKFS7ty3sABN3G0pt/zCkFaL0os+TmTWANjoRfPotm2dLWaFj
	 gymBWpY2FCnPz+JvJAlBKFBGvKmd8JUUqnG83YAM=
Date: Fri, 23 Aug 2024 22:26:01 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,me@yhndnzj.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-cgroup-v2-clarify-that-zswapwriteback-is-ignored-if-zswap-is-disabled.patch added to mm-unstable branch
Message-Id: <20240824052601.A0CD0C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation/cgroup-v2: clarify that zswap.writeback is ignored if zswap is disabled
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-cgroup-v2-clarify-that-zswapwriteback-is-ignored-if-zswap-is-disabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-cgroup-v2-clarify-that-zswapwriteback-is-ignored-if-zswap-is-disabled.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Mike Yuan <me@yhndnzj.com>
Subject: Documentation/cgroup-v2: clarify that zswap.writeback is ignored if zswap is disabled
Date: Fri, 23 Aug 2024 16:27:11 +0000

As discussed in [1], zswap-related settings natually lose their effect
when zswap is disabled, specifically zswap.writeback here.  Be explicit
about this behavior.

[1] https://lore.kernel.org/linux-kernel/CAKEwX=3DMhbwhh-=3DxxCU-RjMXS_n=3D=
RpV3Gtznb2m_3JgL+jzz++g@mail.gmail.com/

Link: https://lkml.kernel.org/r/20240823162506.12117-3-me@yhndnzj.com
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

--- a/tools/testing/selftests/cgroup/test_zswap.c~documentation-cgroup-v2-clarify-that-zswapwriteback-is-ignored-if-zswap-is-disabled
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

mm-memcontrol-respect-zswapwriteback-setting-from-parent-cg-too.patch
documentation-cgroup-v2-clarify-that-zswapwriteback-is-ignored-if-zswap-is-disabled.patch
selftests-test_zswap-add-test-for-hierarchical-zswapwriteback.patch

