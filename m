Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC9718C02E;
	Tue, 13 Oct 2026 04:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865900; cv=none; b=B3/A6ZzuBdIxnFFQW4ECsNUdn/Uw55T9NZIX4dxVx3wJVQcF+8Cfc59AneVX9WRDTiq1KBKnKOv3aEAZTWSRqlsYH00PQGmlmpHd4pFNvQV6JZWZHmpLpx814LWk1dWHVY+l1u+UxGsXj0n5kOBfgyI8Pl+BnN4YrzQe1voI50o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865900; c=relaxed/simple;
	bh=3hXQDE4d0p10KXVEIiyOABznM7KtITb9xWr0ErOsuMs=;
	h=Date:To:From:Subject:Message-Id; b=FMWyXwQ9QvkLceFecTZC+Y2sAre87grkKmt4J2E42gZmtQ+OmcHV+dotn3c3tIIDjryzjay0hFtiz7VoydgIQV7we0Qe+z/Fs9vh6TuxnTb/P0Tyg6zJMCtPa+NY+lnoVB6tssJ7TIvwIuepmG5cGohqyjZcHO7MA3h6DF1BUrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YgQJDqGY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YgQJDqGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CEA71F000FF;
	Tue, 13 Oct 2026 04:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865898;
	bh=eFE4RKWKopjCfJDRdiBpWysL7TpZEr63C2+lQt8EWa8=;
	h=Date:To:From:Subject;
	b=YgQJDqGY+U6PMJyK7iwyUKduUGdjXGwCdgRfY4WPw8nXprm9msgjirwWkKqrRIDn9
	 KEhBN0K0ou6FGoWbng/NevIppXBk+KzlnHDJpUNIDb7v/kHbU31DhmWeAESFEdzdb2
	 3I2nFHPu8t8T/OXJVyzdXZ35bVtH7fylbuzpdoQc=
Date: Mon, 12 Oct 2026 21:31:38 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,stable@vger.kernel.org,davidgow@davidgow.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-read-sysfs_filter-addr_range-only-once.patch removed from -mm tree
Message-Id: <20261013043138.9CEA71F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: read sysfs_filter->addr_range only once
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-read-sysfs_filter-addr_range-only-once.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: read sysfs_filter->addr_range only once
Date: Mon, 14 Sep 2026 07:23:18 -0700

Patch series "mm/damon: move damos filter range arguments validation to
core".

DAMOS filter range arguments are being validated in the DAMON sysfs
interface.  Some of those have minor time-of-check to time-of-use (TOCTOU)
bugs.  In future, other callers might have duplicated validations with
similar bugs.

Fix the bugs and further refactor the code to move the validation to the
core layer.  Also add kunit test cases for the validations.

Patches 1 and 2 fix the existing TOCTOU bugs.  Patches 3 and 4 adds the
validation in the core layer.  Patch 5 drops the replicated validation in
DAMON sysfs interface.  Patch 6 further cleanup the code.  Patches 7 and 8
extends kunit tests to test the validation.


This patch (of 8):

DAMON sysfs interface reads the user-provided address range arguments for
addr type DAMOS filter twice.  Once for validation, and once again for
assignments to the variable that will be passed to the core layer.  If the
user updates the argument in parallel, an invalid address range could be
passed to the core layer.  Avoid it by doing the assignments first, and
then validating the assigned variables before passing those to the core
layer.

User impact of the bug should be trivial.  From the core layer's
perspective, the invalid address range is not really invalid.  It just
works as having a weird address range.  No critical issues such as a crash
or a leak could happen.  And sane users ain't do such parallel arguments
update anyway.  If they do, such racy behavior is arguably somewhat
expected and deserved.  That said, there is no reason to keep such races.

Link: https://lore.kernel.org/20260914142327.92510-1-sj@kernel.org
Link: https://lore.kernel.org/20260914142327.92510-2-sj@kernel.org
Fixes: 2f1abcfccd86 ("mm/damon/sysfs-schemes: support address range type DAMOS filter")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/damon/sysfs-schemes.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-read-sysfs_filter-addr_range-only-once
+++ a/mm/damon/sysfs-schemes.c
@@ -2831,12 +2831,12 @@ static int damon_sysfs_add_scheme_filter
 				return err;
 			}
 		} else if (filter->type == DAMOS_FILTER_TYPE_ADDR) {
-			if (sysfs_filter->addr_range.end <
-					sysfs_filter->addr_range.start) {
+			filter->addr_range = sysfs_filter->addr_range;
+			if (filter->addr_range.end <
+					filter->addr_range.start) {
 				damos_destroy_filter(filter);
 				return -EINVAL;
 			}
-			filter->addr_range = sysfs_filter->addr_range;
 		} else if (filter->type == DAMOS_FILTER_TYPE_TARGET) {
 			filter->target_idx = sysfs_filter->target_idx;
 		} else if (filter->type == DAMOS_FILTER_TYPE_HUGEPAGE_SIZE) {
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damos_quota_goal-complement.patch
mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch
mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch
mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch
selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch
docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch
docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch
docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch

