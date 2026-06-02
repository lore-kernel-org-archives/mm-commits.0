Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCD31DC198
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439147; cv=none; b=R1a9pw9iNDczGRUpUp3NbArUdd0kCGJTnXrD5pS8qrVKbaABnlFEa7UDawR8WlLi5dQq3aYOmdQwgShxPUOHoXpKcBcBhtAcU/phHVBSyOVdCUuuuPHrCacq8A/2N6G1225tqc/HJPzyJfLtn6wAn/TMokbztX2JUf2tVk0ybtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439147; c=relaxed/simple;
	bh=tHrgVRIXkpgGK0PKN865nSEfaUp/OvV8gpuI4yS84WA=;
	h=Date:To:From:Subject:Message-Id; b=rZBEo9P3uWEhzoDBsIucWaR02AHz+JeUSW/z6JHQ3TQsHyCpCnDAhxji6s+joVOMNtWsR20bdhKnq2cxQhhuyGlgel9uJRPbROfNqMzyKkIL0j5IgI4vsQIlg9xJ/myIP1ASzUB5oX/ME6hI/UBx1yKNRDjp0rHoPZ/yMWvkUvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cDoxhjU2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cDoxhjU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E541F00898;
	Tue,  2 Jun 2026 22:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439146;
	bh=mhcbFoGDohTJuaYx6ZX2qaELLDtltJ0RyxOt+BfqFXQ=;
	h=Date:To:From:Subject;
	b=cDoxhjU2YTDjZPkTUWp51X4SebTtSi0feyz+Y/9YN8pNvLXSmxPi9x2Bl+f+/4UsN
	 z7AE7PkPhyHDUMRc1THP+AewEnepYIGCqm7V0a6iHBrfNemGnHILJpFGhKqGHdhBcf
	 exM0nxec04HpQbkaImA0vShYKfQQl4V7OHS9t7VQ=
Date: Tue, 02 Jun 2026 15:25:45 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-safely-handle-no-region-case-in-damon_set_regions.patch removed from -mm tree
Message-Id: <20260602222546.01E541F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: safely handle no region case in damon_set_regions()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-safely-handle-no-region-case-in-damon_set_regions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: safely handle no region case in damon_set_regions()
Date: Fri, 22 May 2026 08:40:12 -0700

Patch series "mm/damon: minor improvements for code readability and tests".

Implement minor improvements on code readability and tests for DAMON.

First seven patches are for DAMON code readability and resulting
maintenance.  Patches 1 and 2 make damon_set_regions() safer and easier to
read.  Patches 3 and 4 remove fragmented DAMON API use cases.  Patches 5-7
hides unused core functions that are unnecessarily exposed to API callers.

The following seven patches are for DAMON tests improvement.  Patches 8
and 9 adds and removes DAMON_DEBUG_SANITY verifications to ensure
reasonable test coverage without too high overhead.  Patch 10 adds a new
kunit test for damon_set_regions().  Patch 11 makes sysfs.py selftest more
gracefully finishes under test failures.  Patches 12-13 adds simple
sysfs.sh test cases for the monitoring intervals goal directory, the
addr_unit file and the pause file.


This patch (of 14):

damon_set_regions() calls damon_first_region() regardless of the number of
DAMON regions in a given DAMON target.  damon_first_region() internally
uses list_first_entry(), which clearly documents the list is expected to
be not empty.  Due to the internal implementation of the macro,
damon_set_regions() is safe for now.  But the internal implementation of
the macro can be changed in future.  Refactor the function to explicitly
and safely handle the empty region list case without depending on the
internal implementation.

No behavioral change is intended.

Link: https://lore.kernel.org/20260522154026.80546-1-sj@kernel.org
Link: https://lore.kernel.org/20260522154026.80546-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-safely-handle-no-region-case-in-damon_set_regions
+++ a/mm/damon/core.c
@@ -356,6 +356,19 @@ int damon_set_regions(struct damon_targe
 			damon_destroy_region(r, t);
 	}
 
+	if (!damon_nr_regions(t)) {
+		for (i = 0; i < nr_ranges; i++) {
+			r = damon_new_region(
+					ALIGN_DOWN(ranges[i].start,
+						min_region_sz),
+					ALIGN(ranges[i].end, min_region_sz));
+			if (!r)
+				return -ENOMEM;
+			damon_add_region(r, t);
+		}
+		return 0;
+	}
+
 	r = damon_first_region(t);
 	/* Add new regions or resize existing regions to fit in the ranges */
 	for (i = 0; i < nr_ranges; i++) {
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch

