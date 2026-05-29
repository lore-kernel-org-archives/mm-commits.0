Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE5636EA84
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027591; cv=none; b=O/WGU3GQB9SviHFT7CsZCpuCw1Ss4Paz5JOkeR8rNIfCenGQn2fTNBi3sSHI3LLHhoRG1n6U+W6g7X8kL3rz59nBkCIOUq6ZLJYZs+mK4MN/9vapdK+d3kQdE1nI+aG1PBV7nzO9WGHF79p10a3vClUd78qbli/mwyej0EqKh6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027591; c=relaxed/simple;
	bh=DNLIUru741ziq756Ow8+Z5VsArVepKUVXWvuTRHS24Y=;
	h=Date:To:From:Subject:Message-Id; b=Z2ZQxlxJ8v2K6i+oqnOymffZ0gtEO6DtwlGXZ+lMDMAxv/TssB82Gzvjx4yVUjJQ3wT8bo5UuIXPvfJxxBV0ogp7DDiAYMr7lb8etnUMWLuXl4blF5s9alDkAhwc4Xk/QiC0jOp0NFVtr2cVDMsa0ac226NAfnRaVOn+E/XHFvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V7rukkOs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V7rukkOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC481F00893;
	Fri, 29 May 2026 04:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027590;
	bh=j3cQ8jRqVLVYyxrwYBLPpGjrQCcCbuajXHYzkpwTwGQ=;
	h=Date:To:From:Subject;
	b=V7rukkOsamlkKgVh+AJEZ7QNweNvgzSW7SwG97Reyk8+hjwHC/3DWBjCWTLpECShe
	 MvihR0ADQuNfN/T+lhvlkNuQ/YH1MB5J6OnS20AbErdcG6ax3ywJsAhjVukkUdGl62
	 NnNqgopTemNl552bXmJzpkXehhp9C8SM9qC9EVqk=
Date: Thu, 28 May 2026 21:06:30 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,yosryahmed@google.com,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,longman@redhat.com,jiayuan.chen@linux.dev,hannes@cmpxchg.org,chengming.zhou@linux.dev,li.wang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-cgroup-use-runtime-page-size-for-zswpin-check.patch removed from -mm tree
Message-Id: <20260529040630.8BC481F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/cgroup: use runtime page size for zswpin check
has been removed from the -mm tree.  Its filename was
     selftests-cgroup-use-runtime-page-size-for-zswpin-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Wang <li.wang@linux.dev>
Subject: selftests/cgroup: use runtime page size for zswpin check
Date: Fri, 24 Apr 2026 12:00:54 +0800

test_zswapin compares memory.stat:zswpin (counted in pages) against a byte
threshold converted with PAGE_SIZE.  In cgroup selftests, PAGE_SIZE is
hardcoded to 4096, which makes the conversion wrong on systems with non-4K
base pages (e.g.  64K).

As a result, the test requires too many pages to pass and fails spuriously
even when zswap is working.

Use sysconf(_SC_PAGESIZE) for the zswpin threshold conversion so the check
matches the actual system page size.

Link: https://lore.kernel.org/20260424040059.12940-4-li.wang@linux.dev
Signed-off-by: Li Wang <li.wang@linux.dev>
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Waiman Long <longman@redhat.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-use-runtime-page-size-for-zswpin-check
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -245,7 +245,7 @@ static int test_zswapin(const char *root
 		goto out;
 	}
 
-	if (zswpin < MB(24) / PAGE_SIZE) {
+	if (zswpin < MB(24) / sysconf(_SC_PAGESIZE)) {
 		ksft_print_msg("at least 24MB should be brought back from zswap\n");
 		goto out;
 	}
_

Patches currently in -mm which might be from li.wang@linux.dev are


