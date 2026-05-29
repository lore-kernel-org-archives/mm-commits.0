Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A2736C5A9
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027598; cv=none; b=TXKFi9PVxy3LcnhH/GYWyssuZdhNMXcyDG5elQ/WgZoV9IlLBGyQNqxhX6qFFtBScrrRgXMGZm9rf0aJN/PK+NOHTqvVkXNe211Y6rKQDoMws5Ik8fhYC6oxGfSzeaqOPQuy7CiYO3zMEBP059Y8brKgkDoz1BfdUaG/d+T3lNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027598; c=relaxed/simple;
	bh=fIeNOIX5iFkKS9VLk6W4/TE6czS0niwKpeMIOvCI9os=;
	h=Date:To:From:Subject:Message-Id; b=oGDntmquaqhHAh1LPjVU4G24rlcVGNsrlxoRL+ZEnXFrFDOSFM9II5ehNMjaoEM8YaZvopJCVldggIYhTz2iDwDOTOeFIrrBzmBIHCz6p/V3Hgn/0YQ/4D3bKgZzOhKbCMlWc/7HK8kuRrtN55uTcX+mW7SIoV8+nH/AaZxt6pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kwzVj2xo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kwzVj2xo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC361F00898;
	Fri, 29 May 2026 04:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027596;
	bh=Zd/oqQ8aeLNEQ7tLzU4C+zCBKy06n9pUn6Zuvn8rUwY=;
	h=Date:To:From:Subject;
	b=kwzVj2xoC1ZDxmNDySzn21RUTnJ9kB4QkwS1eZ3DjTYbBseGxEiFKzP0O3zSNBbFb
	 EP/3eC8oiNMdjQLPfPuzr2RBN+w6ds3lhPSFSgGTZ4Peq69CaGlOCQBI2ngjRHEbP6
	 BhaZLl4Kwnu7VM77kUT/zL9l87T9uTKzvN4EDxvA=
Date: Thu, 28 May 2026 21:06:36 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,yosryahmed@google.com,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,longman@redhat.com,jiayuan.chen@linux.dev,hannes@cmpxchg.org,chengming.zhou@linux.dev,li.wang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-cgroup-test_zswap-wait-for-asynchronous-writeback.patch removed from -mm tree
Message-Id: <20260529040636.BDC361F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/cgroup: test_zswap: wait for asynchronous writeback
has been removed from the -mm tree.  Its filename was
     selftests-cgroup-test_zswap-wait-for-asynchronous-writeback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Wang <li.wang@linux.dev>
Subject: selftests/cgroup: test_zswap: wait for asynchronous writeback
Date: Fri, 24 Apr 2026 12:00:59 +0800

zswap writeback is asynchronous, but test_zswap.c checks writeback
counters immediately after reclaim/trigger paths.  On some platforms (e.g.
ppc64le), this can race with background writeback and cause spurious
failures even when behavior is correct.

Add wait_for_writeback() to poll get_cg_wb_count() with a bounded
timeout, and use it in:

  test_zswap_writeback_one() when writeback is expected
  test_no_invasive_cgroup_shrink() for the wb_group check

This keeps the original before/after assertion style while making the
tests robust against writeback completion latency.

No test behavior change, selftest stability improvement only.

Link: https://lore.kernel.org/20260424040059.12940-9-li.wang@linux.dev
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

 tools/testing/selftests/cgroup/test_zswap.c |   28 ++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-test_zswap-wait-for-asynchronous-writeback
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -121,6 +121,27 @@ fail:
 }
 
 /*
+ * Writeback is asynchronous; poll until at least one writeback has
+ * been recorded for @cg, or until @timeout_ms has elapsed.
+ */
+static long wait_for_writeback(const char *cg, int timeout_ms)
+{
+	long elapsed, count;
+	for (elapsed = 0; elapsed < timeout_ms; elapsed += 100) {
+		count = get_cg_wb_count(cg);
+
+		if (count < 0)
+			return -1;
+		if (count > 0)
+			return count;
+
+		usleep(100000);
+	}
+
+	return 0;
+}
+
+/*
  * Sanity test to check that pages are written into zswap.
  */
 static int test_zswap_usage(const char *root)
@@ -345,7 +366,10 @@ static int test_zswap_writeback_one(cons
 		return -1;
 
 	/* Verify that zswap writeback occurred only if writeback was enabled */
-	zswpwb_after = get_cg_wb_count(cgroup);
+	if (wb)
+		zswpwb_after = wait_for_writeback(cgroup, 5000);
+	else
+		zswpwb_after = get_cg_wb_count(cgroup);
 	if (zswpwb_after < 0)
 		return -1;
 
@@ -476,7 +500,7 @@ static int test_no_invasive_cgroup_shrin
 	}
 
 	/* Verify that only zswapped memory from gwb_group has been written back */
-	if (get_cg_wb_count(wb_group) > 0 && get_cg_wb_count(zw_group) == 0)
+	if (wait_for_writeback(wb_group, 5000) > 0 && get_cg_wb_count(zw_group) == 0)
 		ret = KSFT_PASS;
 out:
 	cg_enter_current(root);
_

Patches currently in -mm which might be from li.wang@linux.dev are


