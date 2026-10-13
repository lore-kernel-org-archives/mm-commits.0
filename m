Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE95F2D7DD7;
	Tue, 13 Oct 2026 04:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865901; cv=none; b=Z2BtE2k4AYuJ8xT1PIZ5GW1cqE1etIMfQWAkn8odkUapoIFnPa+wRTyfwQQC0JGJa1ZOLjulxhzEGr4HjcDuK9HmjxBUIU4fWqCDBTPaTp47N3f81xyIUirrqz9vyO4p/c+/9coTbkf2apBcEh04aFDtukiWhdbi8UNsWM4nhBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865901; c=relaxed/simple;
	bh=Vj32opdFG4XvwE+ymJPVuf18GxNiho9sEtsxtpIrYDA=;
	h=Date:To:From:Subject:Message-Id; b=CIt7Inb3AHVgDqbDlte+ESNh0K+KmAEgTc4NVQrUgTxTCz6JuWDmIr4OI/Rn4Q6CyJiLriEsPaYxCWV15qQucBPYGcWixbhSAkpeWSMhWpjGOivwkUOrs6SOtDSYi+0pqE1DjjVNnLG95us/vNarvsUEeGJFkh3YeXHMGwcMgCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rjuuye4L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rjuuye4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F8C1F00893;
	Tue, 13 Oct 2026 04:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865899;
	bh=f0IBM6ddcyxOJh3lVLvNghmFwfNsxTLxn71K9B7DINg=;
	h=Date:To:From:Subject;
	b=Rjuuye4LEw1re8n96wqCt8nbpM8ykGbE6lbbuRI6hv5ADhJ0nTBFTMZSWZQ36QmD8
	 YTQN+semci5cX72SeR+4V5kF1cq1fi4W/zQnl5bxvmXc9myhEgPJTEkl8oGlC0M7C5
	 +YIrNwaRGZ5dXZdKSta1+kfv04XYOiv/BenY3UXA=
Date: Mon, 12 Oct 2026 21:31:39 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,stable@vger.kernel.org,davidgow@davidgow.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-read-sysfs_filter-sz_range-only-once.patch removed from -mm tree
Message-Id: <20261013043139.A9F8C1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: read sysfs_filter->sz_range only once
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-read-sysfs_filter-sz_range-only-once.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: read sysfs_filter->sz_range only once
Date: Mon, 14 Sep 2026 07:23:19 -0700

DAMON sysfs interface reads the user-provided size range arguments for
hugepage_size type DAMOS filter twice.  Once for validation, and once
again for assignments to the variable that will be passed to the core
layer.  If the user updates the arguments in parallel, an invalid size
range could be passed to the core layer.  Avoid it by doing the
assignments first, and then validating the assigned variables before
passing those to the core layer.

User impact of the bug should be trivial.  From the core layer's
perspective, the invalid size range is not really invalid.  It just works
as having a weird size range.  No critical issues such as a crash or a
leak could happen.  And sane users ain't do such parallel arguments update
anyway.  If they do, such racy behavior is arguably somewhat expected and
deserved.  That said, there is no reason to keep such races.

Link: https://lore.kernel.org/20260914142327.92510-3-sj@kernel.org
Fixes: ea1f204ba29a ("mm/damon/sysfs-schemes: add files for setting damos_filter->sz_range")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/damon/sysfs-schemes.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-read-sysfs_filter-sz_range-only-once
+++ a/mm/damon/sysfs-schemes.c
@@ -2840,13 +2840,12 @@ static int damon_sysfs_add_scheme_filter
 		} else if (filter->type == DAMOS_FILTER_TYPE_TARGET) {
 			filter->target_idx = sysfs_filter->target_idx;
 		} else if (filter->type == DAMOS_FILTER_TYPE_HUGEPAGE_SIZE) {
-			if (sysfs_filter->range_min >
-					sysfs_filter->range_max) {
+			filter->sz_range.min = sysfs_filter->range_min;
+			filter->sz_range.max = sysfs_filter->range_max;
+			if (filter->range_min > filter->range_max) {
 				damos_destroy_filter(filter);
 				return -EINVAL;
 			}
-			filter->sz_range.min = sysfs_filter->range_min;
-			filter->sz_range.max = sysfs_filter->range_max;
 		} else if (filter->type == DAMOS_FILTER_TYPE_PROBE_HITS_WSUM) {
 			filter->range_min = sysfs_filter->range_min;
 			filter->range_max = sysfs_filter->range_max;
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

