Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B726D35C1AB
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 22:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772837079; cv=none; b=LghHHcq6Nr4KZ3KpzV3qCGW4v7PHGZnoKvAqOIyfb4KDrzFgJpbxxn8PyimI0F08+rdBQBvuIJQYkdl2bDehQcXsTwR1nk1GYoa3fB/OSy+2Wd/6KTPPbnWdnCHkcKufZke0pa25LyIyBTXCKY/9pHQ8ZgQK1AFg70U6ufyhTak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772837079; c=relaxed/simple;
	bh=v6ex45q2/eAs2SzReoHfcdoOMtCZx+8vVdEj+SjHEOs=;
	h=Date:To:From:Subject:Message-Id; b=C9Gz8OGSLItrC7tC6pVEjp7qBLsWCguHNAtBKps2M1U0T9DirBB12WzneMW4lS/0caO0sjDpmvI1erWv+bwCxlqwQuLcTBsoxZYdQMV4LUDi6mURdIOiRWjzugkWraP9c+VFkBJA9PFcZGX+xUf8bakJAXgQ5f7Yq9E1MtCqY5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NxgJQQ1j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NxgJQQ1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8961DC4CEF7;
	Fri,  6 Mar 2026 22:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772837079;
	bh=v6ex45q2/eAs2SzReoHfcdoOMtCZx+8vVdEj+SjHEOs=;
	h=Date:To:From:Subject:From;
	b=NxgJQQ1jYvZZKTy5JmtS7XRSEVEAuZpwPu7ggNjxS/F7LfyMxY1TjoNUmtunTZZj8
	 GN7H7jPYP/Td9/tOaACeUhwTxJXr0IYrRpg0g6OUN6K9lyEMWO4KlKiJ2dg/IZRpCp
	 1hXhzmV4GpOo3P0rI17r+/0RbCHXjD/YCd4WYHSM=
Date: Fri, 06 Mar 2026 14:44:38 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-kunitconifg-enable-damon_debug_sanity.patch added to mm-new branch
Message-Id: <20260306224439.8961DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/.kunitconifg: enable DAMON_DEBUG_SANITY
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-kunitconifg-enable-damon_debug_sanity.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-kunitconifg-enable-damon_debug_sanity.patch

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
Subject: mm/damon/tests/.kunitconifg: enable DAMON_DEBUG_SANITY
Date: Fri, 6 Mar 2026 07:29:12 -0800

CONFIG_DAMON_DEBUG_SANITY is recommended for DAMON development and test
setups.  Enable it on the default configurations for DAMON kunit test run.

Link: https://lkml.kernel.org/r/20260306152914.86303-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/.kunitconfig |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/tests/.kunitconfig~mm-damon-tests-kunitconifg-enable-damon_debug_sanity
+++ a/mm/damon/tests/.kunitconfig
@@ -13,3 +13,6 @@ CONFIG_DAMON_VADDR_KUNIT_TEST=y
 CONFIG_SYSFS=y
 CONFIG_DAMON_SYSFS=y
 CONFIG_DAMON_SYSFS_KUNIT_TEST=y
+
+# enable DAMON_DEBUG_SANITY to catch any bug
+CONFIG_DAMON_DEBUG_SANITY=y
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

