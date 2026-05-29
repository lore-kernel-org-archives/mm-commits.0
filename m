Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7384236AB49
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027595; cv=none; b=rhdu7Eumqij8+Mk+pOinUBvJDcv+/aMFCNdmeBN4p6w61pVe5ImX2WorvBfMzKiSD/Pi8d7KB7/XeMbHuhYQWrPM2usuWt0dovoT+rLaHjJCqm+DvKhY+XCU0MO1qveuXETi7cpbDGhgK7X5qqv9x7q2QCh6S+32o+hQfUD08E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027595; c=relaxed/simple;
	bh=vYNi3dqRowMwtZ9g8JTkbxgw5e/oLVsnEvvJaaElv8s=;
	h=Date:To:From:Subject:Message-Id; b=fXRgVgdHSnvL1nqBbhLH326G7pHiwVdqm1yKpH62Tm0CLBCv5FY0Bb26iO/UMGxVHyKYSvr9slzLnftDz1Hd/lbrRD2YK48QArxfd0o0sNbhmOWOEpG4FaRg71Z7B9U1h7QtshlMdnwbMPuoiRjYZZtf7dAHCpOGLvmyN95Ahs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sj156Dyt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sj156Dyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484AE1F00898;
	Fri, 29 May 2026 04:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027594;
	bh=1Iz54Gi6zP7xz1WhAgtoF0nekTBH5TS0W/GAmb9F/QI=;
	h=Date:To:From:Subject;
	b=Sj156Dytny68TFNlR3JQ+qjm1FbV3/7I2YhpQjtOx01XXBv6hpPhQN34NH8WYw6e/
	 8sXdZ6ndHPPzcNPWmjOS/KrKVyS+2Z/WNr0NlOD3fUHgxKlbmqMq58bTntV/jmXO1B
	 PKg+C6cJRlf79cBv3Fh0mWdY65fnT1O/qCGcoqrA=
Date: Thu, 28 May 2026 21:06:33 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,yosryahmed@google.com,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,longman@redhat.com,jiayuan.chen@linux.dev,hannes@cmpxchg.org,chengming.zhou@linux.dev,li.wang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftest-cgroup-fix-zswap-test_no_invasive_cgroup_shrink-on-large-pagesize-system.patch removed from -mm tree
Message-Id: <20260529040634.484AE1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftest/cgroup: fix zswap test_no_invasive_cgroup_shrink on large pagesize system
has been removed from the -mm tree.  Its filename was
     selftest-cgroup-fix-zswap-test_no_invasive_cgroup_shrink-on-large-pagesize-system.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Wang <li.wang@linux.dev>
Subject: selftest/cgroup: fix zswap test_no_invasive_cgroup_shrink on large pagesize system
Date: Fri, 24 Apr 2026 12:00:57 +0800

test_no_invasive_cgroup_shrink sets up two cgroups: wb_group, which is
expected to trigger zswap writeback, and a control group (renamed to
zw_group), which should only have pages sitting in zswap without any
writeback.

There are two problems with the current test:

1) The data patterns are reversed. wb_group uses allocate_bytes(), which
   writes only a single byte per page — trivially compressible,
   especially by zstd — so compressed pages fit within zswap.max and
   writeback is never triggered. Meanwhile, the control group uses
   getrandom() to produce hard-to-compress data, but it is the group
   that does *not* need writeback.

2) The test uses fixed sizes (10K zswap.max, 10MB allocation) that are
   too small on systems with large PAGE_SIZE (e.g. 64K), failing to
   build enough memory pressure to trigger writeback reliably.

Fix both issues by:
  - Swapping the data patterns: fill wb_group pages with partially
    random data (getrandom for page_size/4 bytes) to resist compression
    and trigger writeback, and fill zw_group pages with simple repeated
    data to stay compressed in zswap.
  - Making all size parameters PAGE_SIZE-aware: set allocation size to
    PAGE_SIZE * 1024, memory.zswap.max to PAGE_SIZE, and memory.max to
    allocation_size / 2 for both cgroups.
  - Allocating memory inline instead of via cg_run() so the pages
    remain resident throughout the test.

=== Error Log ===
 # getconf PAGESIZE
 65536

 # ./test_zswap
 TAP version 13
 ...
 ok 5 test_zswap_writeback_disabled
 ok 6 # SKIP test_no_kmem_bypass
 not ok 7 test_no_invasive_cgroup_shrink

Link: https://lore.kernel.org/20260424040059.12940-7-li.wang@linux.dev
Signed-off-by: Li Wang <li.wang@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Waiman Long <longman@redhat.com>
Cc: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_zswap.c |   72 ++++++++++++------
 1 file changed, 50 insertions(+), 22 deletions(-)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftest-cgroup-fix-zswap-test_no_invasive_cgroup_shrink-on-large-pagesize-system
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -11,6 +11,7 @@
 #include <string.h>
 #include <sys/wait.h>
 #include <sys/mman.h>
+#include <sys/random.h>
 
 #include "kselftest.h"
 #include "cgroup_util.h"
@@ -426,44 +427,71 @@ static int test_zswap_writeback_disabled
 static int test_no_invasive_cgroup_shrink(const char *root)
 {
 	int ret = KSFT_FAIL;
-	size_t control_allocation_size = MB(10);
-	char *control_allocation = NULL, *wb_group = NULL, *control_group = NULL;
+	unsigned int off;
+	size_t allocation_size = page_size * 1024;
+	unsigned int nr_pages = allocation_size / page_size;
+	char zswap_max_buf[32], mem_max_buf[32];
+	char *zw_allocation = NULL, *wb_allocation = NULL;
+	char *zw_group = NULL, *wb_group = NULL;
+
+	snprintf(zswap_max_buf, sizeof(zswap_max_buf), "%d", page_size);
+	snprintf(mem_max_buf, sizeof(mem_max_buf), "%zu", allocation_size / 2);
 
 	wb_group = setup_test_group_1M(root, "per_memcg_wb_test1");
 	if (!wb_group)
 		return KSFT_FAIL;
-	if (cg_write(wb_group, "memory.zswap.max", "10K"))
+	if (cg_write(wb_group, "memory.zswap.max", zswap_max_buf))
 		goto out;
-	control_group = setup_test_group_1M(root, "per_memcg_wb_test2");
-	if (!control_group)
+	if (cg_write(wb_group, "memory.max", mem_max_buf))
 		goto out;
 
-	/* Push some test_group2 memory into zswap */
-	if (cg_enter_current(control_group))
+	zw_group = setup_test_group_1M(root, "per_memcg_wb_test2");
+	if (!zw_group)
 		goto out;
-	control_allocation = malloc(control_allocation_size);
-	for (int i = 0; i < control_allocation_size; i += page_size)
-		control_allocation[i] = 'a';
-	if (cg_read_key_long(control_group, "memory.stat", "zswapped") < 1)
+	if (cg_write(zw_group, "memory.max", mem_max_buf))
 		goto out;
 
-	/* Allocate 10x memory.max to push wb_group memory into zswap and trigger wb */
-	if (cg_run(wb_group, allocate_bytes, (void *)MB(10)))
+	/* Push some zw_group memory into zswap (simple data, easy to compress) */
+	if (cg_enter_current(zw_group))
+		goto out;
+	zw_allocation = malloc(allocation_size);
+	for (int i = 0; i < nr_pages; i++) {
+		off = (unsigned long)i * page_size;
+		memset(&zw_allocation[off], 0, page_size);
+		memset(&zw_allocation[off], 'a', page_size/4);
+	}
+	if (cg_read_key_long(zw_group, "memory.stat", "zswapped") < 1)
 		goto out;
 
+	/* Push wb_group memory into zswap with hard-to-compress data to trigger wb */
+	if (cg_enter_current(wb_group))
+		goto out;
+	wb_allocation = malloc(allocation_size);
+	if (!wb_allocation)
+		goto out;
+	for (int i = 0; i < nr_pages; i++) {
+		off = (unsigned long)i * page_size;
+		memset(&wb_allocation[off], 0, page_size);
+		getrandom(&wb_allocation[off], page_size/4, 0);
+	}
+
 	/* Verify that only zswapped memory from gwb_group has been written back */
-	if (get_cg_wb_count(wb_group) > 0 && get_cg_wb_count(control_group) == 0)
+	if (get_cg_wb_count(wb_group) > 0 && get_cg_wb_count(zw_group) == 0)
 		ret = KSFT_PASS;
 out:
 	cg_enter_current(root);
-	if (control_group) {
-		cg_destroy(control_group);
-		free(control_group);
-	}
-	cg_destroy(wb_group);
-	free(wb_group);
-	if (control_allocation)
-		free(control_allocation);
+	if (zw_group) {
+		cg_destroy(zw_group);
+		free(zw_group);
+	}
+	if (wb_group) {
+		cg_destroy(wb_group);
+		free(wb_group);
+	}
+	if (zw_allocation)
+		free(zw_allocation);
+	if (wb_allocation)
+		free(wb_allocation);
 	return ret;
 }
 
_

Patches currently in -mm which might be from li.wang@linux.dev are


