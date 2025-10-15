Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F7A2C15A8;
	Wed, 15 Oct 2025 20:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760559907; cv=none; b=hmMhecFXDYGxz+9GesgxMCcrMdkd+/kbJ/rLprU4P3HhCTGL7Saf63n5NYPm2cGGY5cPcIxzmYL4qXhLq8G0VNExW5fvqYVhu4uwp6axIo7IPCIHtxRSTYXNAznj7Us6GwChhcB5EPzYIO+RBERCfb/I5WHMzCle5lgF5BlSrG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760559907; c=relaxed/simple;
	bh=0SAQvtwWaIwgSEfNAKkLIC4TJ8TQw3EtOv47sBDXvtc=;
	h=Date:To:From:Subject:Message-Id; b=UudlwX8luZKf7UKe0WTBxbeMYYRJ0ICVzEBgB5hu2TH0qyiUq+0nexa/W0ocIOrklY9+fXRpG91R0kef3k/L4fvplcH8SZ8nstgpP8AyI5k7vgwBXjQoWMEIMifsELQVDHmsjCZQygOuvhCBmoySqhxB9XQrLF2twHbWTC4RwSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GhadSrxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GhadSrxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC08C4CEFB;
	Wed, 15 Oct 2025 20:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760559905;
	bh=0SAQvtwWaIwgSEfNAKkLIC4TJ8TQw3EtOv47sBDXvtc=;
	h=Date:To:From:Subject:From;
	b=GhadSrxtgNfRLLs6JA8P0m39GdrsQ+8vFv9AxUIDyGC8dByHf1bhyznV1wVfR6+4m
	 I5iRVtOgMRdmQFDnXKLXJ6a3DbWB0VELojJqBZII2vhpX3IYl347+0w0HGCR+s96UX
	 p9huuy7WqiYYuRD7WPx6cmRscCInppUkGbwYGaKE=
Date: Wed, 15 Oct 2025 13:25:05 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-sysfs-catch-commit-test-ctx-alloc-failure.patch removed from -mm tree
Message-Id: <20251015202505.8DC08C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: catch commit test ctx alloc failure
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-catch-commit-test-ctx-alloc-failure.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: catch commit test ctx alloc failure
Date: Fri, 3 Oct 2025 13:14:54 -0700

Patch series "mm/damon/sysfs: fix commit test damon_ctx [de]allocation".

DAMON sysfs interface dynamically allocates and uses a damon_ctx object
for testing if given inputs for online DAMON parameters update is valid.
The object is being used without an allocation failure check, and leaked
when the test succeeds.  Fix the two bugs.


This patch (of 2):

The damon_ctx for testing online DAMON parameters commit inputs is used
without its allocation failure check.  This could result in an invalid
memory access.  Fix it by directly returning an error when the allocation
failed.

Link: https://lkml.kernel.org/r/20251003201455.41448-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20251003201455.41448-2-sj@kernel.org
Fixes: 4c9ea539ad59 ("mm/damon/sysfs: validate user inputs from damon_sysfs_commit_input()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-catch-commit-test-ctx-alloc-failure
+++ a/mm/damon/sysfs.c
@@ -1473,6 +1473,8 @@ static int damon_sysfs_commit_input(void
 	if (IS_ERR(param_ctx))
 		return PTR_ERR(param_ctx);
 	test_ctx = damon_new_ctx();
+	if (!test_ctx)
+		return -ENOMEM;
 	err = damon_commit_ctx(test_ctx, param_ctx);
 	if (err) {
 		damon_destroy_ctx(test_ctx);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-fix-list_add_tail-call-on-damon_call.patch
mm-damon-core-use-damos_commit_quota_goal-for-new-goal-commit.patch
mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch
mm-zswap-fix-typos-s-zwap-zswap.patch
mm-zswap-s-red-black-tree-xarray.patch
docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch

