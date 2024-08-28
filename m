Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC3E11CA0
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 01:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724807263; cv=none; b=jZIjDoMEdOeMS3p8pnMcOdsTAltTzDx3VWpxF+76bgRxJtjhszw75MsQXTyxHYzeZKTDl7aJHYUdZnrmw45pEquJE7pztUO9gnkU46kNp4DFMy6tx3YVX54YhU/5VCeFWCHykVCeRadvA3D38QE917Lz5k/ToBrzzF7ry9HVr6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724807263; c=relaxed/simple;
	bh=MBmJcIYD8FC0lZC2Xlfmoy8t/Est8ExskDlI/E0kn5g=;
	h=Date:To:From:Subject:Message-Id; b=hFKXqLpktwlyA5Gzp5pTWSO3NZQp0PS1CMu/Iovq1E5qEINgCMhoxjl3SBy/KM6d6wVFbJ5bg/awjVngWgA3NqtdsoSVrhCPfmkCNTlgwXpIR6M2pbU+vbKxnNceyckqRC4hy4iidgufTuEqQBntArCj4KxzSEX8zYEk/9vMQv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JoGjfAT5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JoGjfAT5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F174C4AF68;
	Wed, 28 Aug 2024 01:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724807263;
	bh=MBmJcIYD8FC0lZC2Xlfmoy8t/Est8ExskDlI/E0kn5g=;
	h=Date:To:From:Subject:From;
	b=JoGjfAT5+q3jrHripvek75O/npB0hfd2cX1Mtg2WrJJQ1chnCQj1TTwXoj4sriUwb
	 Jm6NebpIDUMjulNN4MLpgh+OFfDxETGpYPlmXpgg3oJe4PXsILpPf25+vE2zsc8x8T
	 SCXH/VStUzLRV0aX6q7TDwWHz53QRvVZE6oRNOCc=
Date: Tue, 27 Aug 2024 18:07:43 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation.patch added to mm-unstable branch
Message-Id: <20240828010743.9F174C4AF68@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "mm/damon/lru_sort: adjust local variable to dynamic allocation"
has been added to the -mm mm-unstable branch.  Its filename is
     revert-mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: Revert "mm/damon/lru_sort: adjust local variable to dynamic allocation"
Date: Sun, 25 Aug 2024 21:23:23 -0700

This reverts commit 0742cadf5e4c ("mm/damon/lru_sort: adjust local
variable to dynamic allocation").

The commit was introduced to avoid unnecessary usage of stack memory for
per-scheme region priorities histogram buffer.  The fix is nice, but the
point of the fix looks not very clear if the commit message is not read
together.  That's mainly because the buffer is a private field, which
means it is hidden from the DAMON API users.  That's not the fault of the
fix but the underlying data structure.

Now the per-scheme histogram buffer is gone, so the problem that the
commit was fixing is also removed.  The use of kmemdup() has no more point
but just making the code bit difficult to understand.  Revert the fix.

Link: https://lkml.kernel.org/r/20240826042323.87025-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/mm/damon/lru_sort.c~revert-mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation
+++ a/mm/damon/lru_sort.c
@@ -148,17 +148,12 @@ static struct damon_target *target;
 static struct damos *damon_lru_sort_new_scheme(
 		struct damos_access_pattern *pattern, enum damos_action action)
 {
-	struct damos *damos;
-	struct damos_quota *quota = kmemdup(&damon_lru_sort_quota,
-				    sizeof(damon_lru_sort_quota), GFP_KERNEL);
-
-	if (!quota)
-		return NULL;
+	struct damos_quota quota = damon_lru_sort_quota;
 
 	/* Use half of total quota for hot/cold pages sorting */
-	quota->ms = quota->ms / 2;
+	quota.ms = quota.ms / 2;
 
-	damos = damon_new_scheme(
+	return damon_new_scheme(
 			/* find the pattern, and */
 			pattern,
 			/* (de)prioritize on LRU-lists */
@@ -166,12 +161,10 @@ static struct damos *damon_lru_sort_new_
 			/* for each aggregation interval */
 			0,
 			/* under the quota. */
-			quota,
+			&quota,
 			/* (De)activate this according to the watermarks. */
 			&damon_lru_sort_wmarks,
 			NUMA_NO_NODE);
-	kfree(quota);
-	return damos;
 }
 
 /* Create a DAMON-based operation scheme for hot memory regions */
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-add-access_memory_even-to-gitignore.patch
selftests-damon-cleanup-__pycache__-with-make-clean.patch
selftests-damon-add-execute-permissions-to-test-scripts.patch
mm-damon-core-test-test-only-vaddr-case-on-ops-registration-test.patch
mm-damon-core-test-fix-damon_test_ops_registration-for-damon_vaddr-unset-case.patch
mm-damon-dbgfs-test-skip-dbgfs_set_targets-test-if-paddr-is-not-registered.patch
mm-damon-dbgfs-test-skip-dbgfs_set_init_regions-test-if-paddr-is-not-registered.patch
mm-damon-move-kunit-tests-to-tests-subdirectory-with-_kunit-suffix.patch
mm-damon-tests-add-kunitconfig-file-for-damon-kunit-tests.patch
mm-damon-core-intorduce-per-context-region-priorities-histogram-buffer.patch
mm-damon-core-replace-per-quota-regions-priority-histogram-buffer-usage-with-per-context-one.patch
mm-damon-core-remove-per-scheme-region-priority-histogram-buffer.patch
revert-mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation.patch

