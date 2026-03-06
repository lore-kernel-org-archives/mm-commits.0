Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE9D54654
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 22:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772837070; cv=none; b=fmzyqwF8KZ+3tCgZ4jtN4NBWSoZizj/zZvveG3kyJBHJd/OT5/HKJMVqIv6Fcd3KgGiwIHkpkzVrortR2NN1zA3X9wtVpBClPUZBEq9ns5eKS3QIa859pSDYCXZ4sze/CLj2MuehFsRbhPxaSrB2VV03pliuLbE/odXTiFulWxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772837070; c=relaxed/simple;
	bh=LhTJqSFpMXvMwRDTpcAsbGMV5Y1wXblpnrEJ3fQlqCU=;
	h=Date:To:From:Subject:Message-Id; b=rHJNh1FUjwesILbsdtvovbQlSXDa/gsMIcN41/hGMJ3KfvDnqRewHrW480Fg6sEuAs73iDpj4IFvm8ZjY5Alqco+VOafcI/miP4bew6QkhfBNNx8To1+el9L8PMQL4/We4T//N7Uhq+6ZkqHdQSv9hrhvUtjX/HP77f7Q6vmvBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RdJjQ+CP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RdJjQ+CP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9247DC4CEF7;
	Fri,  6 Mar 2026 22:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772837069;
	bh=LhTJqSFpMXvMwRDTpcAsbGMV5Y1wXblpnrEJ3fQlqCU=;
	h=Date:To:From:Subject:From;
	b=RdJjQ+CPjBBAczeVND16+Xxc6Ik949qZXHlo600tcsPOKLDJoqkrxHRRWq3KbZI4A
	 UxbJAYBTfEIXQkfjiVI6yQwY+Cd7zR2sxzM8VOaOFAurmitojcekmGTht6rdnEJ5p/
	 bLP9EirRQy1R2xrzbcmYTYYYHHE+U2A2X3VWf0u4=
Date: Fri, 06 Mar 2026 14:44:28 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-add-config_damon_debug_sanity.patch added to mm-new branch
Message-Id: <20260306224429.9247DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: add CONFIG_DAMON_DEBUG_SANITY
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-add-config_damon_debug_sanity.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-add-config_damon_debug_sanity.patch

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
Subject: mm/damon: add CONFIG_DAMON_DEBUG_SANITY
Date: Fri, 6 Mar 2026 07:29:04 -0800

Patch series "mm/damon: add optional debugging-purpose sanity checks".

DAMON code has a few assumptions that can be critical if violated. 
Validating the assumptions in code can be useful at finding such critical
bugs.  I was actually adding some such additional sanity checks in my
personal tree, and those were useful at finding bugs that I made during
the development of new patches.  We also found [1] sometimes the
assumptions are misunderstood.  The validation can work as good
documentation for such cases.

Add some of such debugging purpose sanity checks.  Because those
additional checks can impose more overhead, make those only optional via
new config, CONFIG_DAMON_DEBUG_SANITY, that is recommended for only
development and test setups.  And as recommended, enable it for DAMON
kunit tests and selftests.

Note that the verification only WARN_ON() for each of the insanity.  The
developer or tester may better to set panic_on_oops together, like
damon-tests/corr did [2].


This patch (of 10):

Add a new build config that will enable additional DAMON sanity checks. 
It is recommended to be enabled on only development and test setups, since
it can impose additional overhead.

Link: https://lkml.kernel.org/r/20260306152914.86303-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20260306152914.86303-2-sj@kernel.org
Link: https://lore.kernel.org/20251231070029.79682-1-sj@kernel.org [1]
Link: https://github.com/damonitor/damon-tests/commit/a80fbee55e272f151b4e5809ee85898aea33e6ff [2]
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/Kconfig |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/damon/Kconfig~mm-damon-add-config_damon_debug_sanity
+++ a/mm/damon/Kconfig
@@ -12,6 +12,17 @@ config DAMON
 	  See https://www.kernel.org/doc/html/latest/mm/damon/index.html for
 	  more information.
 
+config DAMON_DEBUG_SANITY
+	bool "Check sanity of DAMON code"
+	depends on DAMON
+	help
+	  This enables additional DAMON debugging-purpose sanity checks in
+	  DAMON code.  This can be useful for finding bugs, but impose
+	  additional overhead.  This is therefore recommended to be enabled on
+	  only development and test setups.
+
+	  If unsure, say N.
+
 config DAMON_KUNIT_TEST
 	bool "Test for damon" if !KUNIT_ALL_TESTS
 	depends on DAMON && KUNIT=y
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-set-quota-score-histogram-with-core-filters.patch
mm-damon-core-do-non-safe-region-walk-on-kdamond_apply_schemes.patch
mm-damon-core-split-regions-for-min_nr_regions.patch
mm-damon-vaddr-do-not-split-regions-for-min_nr_regions.patch
mm-damon-test-core-kunit-add-damon_apply_min_nr_regions-test.patch
mm-damon-add-config_damon_debug_sanity.patch
mm-damon-core-add-damon_new_region-debug_sanity-check.patch
mm-damon-core-add-damon_del_region-debug_sanity-check.patch
mm-damon-core-add-damon_nr_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_two_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_regions_of-debug_sanity-check.patch
mm-damon-core-add-damon_split_region_at-debug_sanity-check.patch
mm-damon-core-add-damon_reset_aggregated-debug_sanity-check.patch
mm-damon-tests-kunitconifg-enable-damon_debug_sanity.patch
selftests-damon-config-enable-damon_debug_sanity.patch

