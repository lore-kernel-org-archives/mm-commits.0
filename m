Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E3C362120
	for <mm-commits@vger.kernel.org>; Mon, 31 Aug 2026 23:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788218020; cv=none; b=LdrVJq2B7jVvz87G1ijaaRL9RISB3DiH2tbzJTSshHkDgLD3Qm2dhI+acNiq+wNisGm7mNAkQrYiVVjIZV7rPhep5wJRcGs0eZqfoefU3hBi3+4IuxtEJDEHg/H+NF+WEO0vW6BPTr3Ldhaf1zXCYGh0WrC2B1KISBe/+wEs/+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788218020; c=relaxed/simple;
	bh=GRNNt2kyZUL8mZjCQhVg31vL/alKdrEf0dnVVAF36HM=;
	h=Date:To:From:Subject:Message-Id; b=DoKcIfEIR2rNiHl0lcrkyTD4YGoJsCYGvKHQf+x93a0kjLVhgd7xR/eOPWM+F/QhCKnTC73IJvMjP0elSwEuK8wcoE2VcW238n2tC4+x4sgD3DCnNzaZ3ndTl/dG/eHDFYZctoQIDZIKoEMgVHq/DdavtqrNWtJsPIWGDG9G5Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lv3eN301; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lv3eN301"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4F61F00A3D;
	Mon, 31 Aug 2026 23:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788218018;
	bh=4tGLFdopCv1fRsrEIpCy3rrDEhmiLkxG+FFl8bbu1QI=;
	h=Date:To:From:Subject;
	b=Lv3eN301nk/rHdsVRv9awxr5dWVqN2yr84ocntaVqQ4m+kFL7WX0RuAzR4ePDtyIO
	 B650l9S4l/VACFIEqW/qlxxDy0uwISYlmnEy2LYG95ivo3YNGszkDrWULix07E8H64
	 vwLUJdoibGIPjlV3WWeMu56w6TNqS+0HgZmbRcLQ=
Date: Mon, 31 Aug 2026 16:13:38 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,davidgow@davidgow.net,brendan.higgins@linux.dev,jasonangelov@ucla.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-kunit-test-probe_hits-handling-at-region-split-and-merge.patch added to mm-new branch
Message-Id: <20260831231338.BD4F61F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core-kunit: test probe_hits handling at region split and merge
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-kunit-test-probe_hits-handling-at-region-split-and-merge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-kunit-test-probe_hits-handling-at-region-split-and-merge.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Jason Angelov <jasonangelov@ucla.edu>
Subject: mm/damon/core-kunit: test probe_hits handling at region split and merge
Date: Mon, 31 Aug 2026 08:06:48 -0700

Patch series "mm/damon: add kunit tests for probe_hits handling and probe
params validation", v2.

DAMON recently introduced probes and probe weights.  Add kunit tests for
the propagation of probe_hits at region split and merge, and the rejection
of invalid probe parameters by damon_valid_probe_params().


This patch (of 2):

damon_split_region_at() copies probe_hits[] and last_probe_hits[] to the
new split region.

damon_merge_two_regions() sets probe_hits[] to the size-weighted
average of the merged regions.

Extend damon_test_split_at() and damon_test_merge_two() tests to cover
those fields.

Link: https://lore.kernel.org/20260831150650.84829-1-sj@kernel.org
Link: https://lore.kernel.org/20260831150650.84829-2-sj@kernel.org
Signed-off-by: Jason Angelov <jasonangelov@ucla.edu>
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: David Gow <davidgow@davidgow.net>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-core-kunit-test-probe_hits-handling-at-region-split-and-merge
+++ a/mm/damon/tests/core-kunit.h
@@ -152,6 +152,8 @@ static void damon_test_split_at(struct k
 	}
 	r->nr_accesses = 42;
 	r->last_nr_accesses = 15;
+	r->probe_hits[0] = 7;
+	r->last_probe_hits[0] = 3;
 	r->age = 10;
 	damon_add_region(r, t);
 	damon_split_region_at(t, r, 25);
@@ -168,6 +170,8 @@ static void damon_test_split_at(struct k
 
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, r_new->nr_accesses);
 	KUNIT_EXPECT_EQ(test, r->last_nr_accesses, r_new->last_nr_accesses);
+	KUNIT_EXPECT_EQ(test, r->probe_hits[0], r_new->probe_hits[0]);
+	KUNIT_EXPECT_EQ(test, r->last_probe_hits[0], r_new->last_probe_hits[0]);
 	KUNIT_EXPECT_EQ(test, r->age, r_new->age);
 
 out:
@@ -189,6 +193,7 @@ static void damon_test_merge_two(struct
 		kunit_skip(test, "region alloc fail");
 	}
 	r->nr_accesses = 10;
+	r->probe_hits[0] = 6;
 	r->age = 9;
 	damon_add_region(r, t);
 	r2 = damon_new_region(100, 300);
@@ -197,6 +202,7 @@ static void damon_test_merge_two(struct
 		kunit_skip(test, "second region alloc fail");
 	}
 	r2->nr_accesses = 20;
+	r2->probe_hits[0] = 14;
 	r2->age = 21;
 	damon_add_region(r2, t);
 
@@ -204,6 +210,7 @@ static void damon_test_merge_two(struct
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 300ul);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 16u);
+	KUNIT_EXPECT_EQ(test, r->probe_hits[0], 11);
 	KUNIT_EXPECT_EQ(test, r->age, 17u);
 
 	i = 0;
_

Patches currently in -mm which might be from jasonangelov@ucla.edu are

mm-damon-core-kunit-test-probe_hits-handling-at-region-split-and-merge.patch
mm-damon-core-kunit-test-damon_valid_probe_params.patch

