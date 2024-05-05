Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90E275818;
	Sun,  5 May 2024 21:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714942884; cv=none; b=ecZZgW76nTKZM3xgH/KizkKLwctDaIzh45Svt4iEnSpFJ6t6Q6bRh1leCKLRWNOwsEDLvmn6zd6VZ22Z1JKm3dzKUY7tEzDxt0WOJjESTRWTgU3DrV2MNWA/t8jkgPVvtutVCnvsW0s9CyE5VcbXwArA3A7RyNTFhnhoPvJTsUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714942884; c=relaxed/simple;
	bh=8e1RpfK47ikZQpKEZw8JcRNaSCFH6oazqpXfZ0qNmBM=;
	h=Date:To:From:Subject:Message-Id; b=A3fZviXvYWhSvdU8L8r7qToP5XrdbaFg1qn/HEpNcHGwv3a37fV8Hd4ocbI9XXXPuSbj8/pQ7TE0YKZoVpgbZ99YUBcE2SiOXRNBAotpt0kM5WVoosy8QgTW921ZnTeJV+477YoHIyARDTIlOFpVGBVbUwQbEZrLeSJeAhYaNoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ClAg436e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ClAg436e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0239C113CC;
	Sun,  5 May 2024 21:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714942883;
	bh=8e1RpfK47ikZQpKEZw8JcRNaSCFH6oazqpXfZ0qNmBM=;
	h=Date:To:From:Subject:From;
	b=ClAg436e873iUa85NiTvYGS9HQh53WuxJxpSjHkYWQc4QrRO7YwJ4vGR/sqlep8vz
	 Rk/p1RrnkyEwg6ZeAY3bSwLR1AwuI/h0HBFCUDBiweAJEFm07W1Xi2A7Y/jxrdt562
	 i7jsHmoBy4ISmViJQwq4ZO1Fx+BNRd0hAdsJ27pA=
Date: Sun, 05 May 2024 14:01:23 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-fix-wrong-example-of-damos-filter-matching-sysfs-file.patch added to mm-unstable branch
Message-Id: <20240505210123.B0239C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: fix wrong example of DAMOS filter matching sysfs file
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-fix-wrong-example-of-damos-filter-matching-sysfs-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-fix-wrong-example-of-damos-filter-matching-sysfs-file.patch

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
Subject: Docs/admin-guide/mm/damon/usage: fix wrong example of DAMOS filter matching sysfs file
Date: Fri, 3 May 2024 11:03:14 -0700

The example usage of DAMOS filter sysfs files, specifically the part of
'matching' file writing for memcg type filter, is wrong.  The intention is
to exclude pages of a memcg that already getting enough care from a given
scheme, but the example is setting the filter to apply the scheme to only
the pages of the memcg.  Fix it.

Link: https://lkml.kernel.org/r/20240503180318.72798-7-sj@kernel.org
Fixes: 9b7f9322a530 ("Docs/admin-guide/mm/damon/usage: document DAMOS filters of sysfs")
Closes: https://lore.kernel.org/r/20240317191358.97578-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.3.x]
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-fix-wrong-example-of-damos-filter-matching-sysfs-file
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -434,7 +434,7 @@ pages of all memory cgroups except ``/ha
     # # further filter out all cgroups except one at '/having_care_already'
     echo memcg > 1/type
     echo /having_care_already > 1/memcg_path
-    echo N > 1/matching
+    echo Y > 1/matching
 
 Note that ``anon`` and ``memcg`` filters are currently supported only when
 ``paddr`` :ref:`implementation <sysfs_context>` is being used.
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-paddr-implement-damon_folio_young.patch
mm-damon-paddr-implement-damon_folio_mkold.patch
mm-damon-add-damos-filter-type-young.patch
mm-damon-paddr-implement-damos-filter-type-young.patch
docs-mm-damon-design-document-young-page-type-damos-filter.patch
docs-admin-guide-mm-damon-usage-update-for-young-page-type-damos-filter.patch
docs-abi-damon-update-for-youg-page-type-damos-filter.patch
mm-damon-paddr-avoid-unnecessary-page-level-access-check-for-pageout-damos-action.patch
mm-damon-paddr-do-page-level-access-check-for-pageout-damos-action-on-its-own.patch
mm-vmscan-remove-ignore_references-argument-of-reclaim_pages.patch
mm-vmscan-remove-ignore_references-argument-of-reclaim_folio_list.patch
selftests-damon-_damon_sysfs-support-quota-goals.patch
selftests-damon-add-a-test-for-damos-quota-goal.patch
mm-damon-core-initialize-esz_bp-from-damos_quota_init_priv.patch
selftests-damon-_damon_sysfs-check-errors-from-nr_schemes-file-reads.patch
selftests-damon-_damon_sysfs-find-sysfs-mount-point-from-proc-mounts.patch
selftests-damon-_damon_sysfs-use-is-instead-of-==-for-none.patch
selftests-damon-classify-tests-for-functionalities-and-regressions.patch
docs-admin-guide-mm-damon-usage-fix-wrong-example-of-damos-filter-matching-sysfs-file.patch
docs-admin-guide-mm-damon-usage-fix-wrong-schemes-effective-quota-update-command.patch
docs-mm-damon-design-use-a-list-for-supported-filters.patch
docs-mm-damon-maintainer-profile-change-the-maintainers-timezone-from-pst-to-pt.patch
docs-mm-damon-maintainer-profile-allow-posting-patches-based-on-damon-next-tree.patch

