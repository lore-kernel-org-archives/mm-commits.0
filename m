Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE502874F8
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 23:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766962923; cv=none; b=u4r5cYTn6V3eduQGjdJ91R1BrfuA0cFka8osidicuDPRwKhQEQETai6FrbDt9cJWezd/+jIXNms/Dthejtlrqv/mFXzFS7fCGi1tc7n/GPai7WiqkbWrI2P3BcoBjJW4ebHlRn5J2y0BTQkpgjlMqFG27zmAXieiQU0nRA7pZ3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766962923; c=relaxed/simple;
	bh=Cc5kam93aI9PiSoqw3pvtrhh05eJWZAyytFTNb5e+4w=;
	h=Date:To:From:Subject:Message-Id; b=NAL3bmcH+z7El7TxozzducRcjEX1ls+zPv6Y9e2aUhWr8lu0EfxMxGm658zacUCgY2FDv9FdgQ3VYXNvpv84XzgKeoUKwtd6N68pEX6JQrQvDwQInZ3URwihylYQIwkYow4GP7DfbjTdLTUW5RJCWJEcoLi55aNV2ukPFsFeOW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UGPaljpL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UGPaljpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C601C116D0;
	Sun, 28 Dec 2025 23:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766962921;
	bh=Cc5kam93aI9PiSoqw3pvtrhh05eJWZAyytFTNb5e+4w=;
	h=Date:To:From:Subject:From;
	b=UGPaljpLiVvyOJdlzvKfxnMrlNIINjmZU3I/EFOEzsLcX2GPpo+Rr1etdSZwtiDSz
	 cUO1KF3/C6jp3PmXk1A5iVRDkQwul8ieaZszRuoYYN1ckjbjeAprGqGkr8DKqQTnLF
	 gwt4tupEVIdUOpk6fKrIEgUt5Ho+0rp9+pc7Qfyg=
Date: Sun, 28 Dec 2025 15:02:00 -0800
To: mm-commits@vger.kernel.org,shu17az@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of-fix.patch added to mm-new branch
Message-Id: <20251228230201.3C601C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: SeongJae Park <sj@kernel.org>
Subject: mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of-fix
Date: Wed, 24 Dec 2025 07:27:04 -0800

damon_test_split_regions_of() has braces for a single statement, which is
unnecessary.  Remove it.

Link: https://lkml.kernel.org/r/20251224153125.69194-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shu Anzai <shu17az@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of-fix
+++ a/mm/damon/tests/core-kunit.h
@@ -318,9 +318,8 @@ static void damon_test_split_regions_of(
 	}
 	damon_split_regions_of(t, 4, 5);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 12u);
-	damon_for_each_region(r, t) {
+	damon_for_each_region(r, t)
 		KUNIT_EXPECT_GE(test, damon_sz_region(r) % 5ul, 0ul);
-	}
 	damon_free_target(t);
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-remove-call_control-in-inactive-contexts.patch
mm-damon-core-introduce-nr_snapshots-damos-stat.patch
mm-damon-sysfs-schemes-introduce-nr_snapshots-damos-stat-file.patch
docs-mm-damon-design-update-for-nr_snapshots-damos-stat.patch
docs-admin-guide-mm-damon-usage-update-for-nr_snapshots-damos-stat.patch
docs-abi-damon-update-for-nr_snapshots-damos-stat.patch
mm-damon-update-damos-kerneldoc-for-stat-field.patch
mm-damon-core-implement-max_nr_snapshots.patch
mm-damon-sysfs-schemes-implement-max_nr_snapshots-file.patch
docs-mm-damon-design-update-for-max_nr_snapshots.patch
docs-admin-guide-mm-damon-usage-update-for-max_nr_snapshots.patch
docs-abi-damon-update-for-max_nr_snapshots.patch
mm-damon-core-add-trace-point-for-damos-stat-per-apply-interval.patch
mm-damon-sysfs-cleanup-intervals-subdirs-on-attrs-dir-setup-failure.patch
mm-damon-sysfs-cleanup-attrs-subdirs-on-context-dir-setup-failure.patch
mm-damon-sysfs-scheme-cleanup-quotas-subdirs-on-scheme-dir-setup-failure.patch
mm-damon-sysfs-scheme-cleanup-access_pattern-subdirs-on-scheme-dir-setup-failure.patch
mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of-fix.patch

