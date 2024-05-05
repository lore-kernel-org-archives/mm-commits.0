Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8987580E
	for <mm-commits@vger.kernel.org>; Sun,  5 May 2024 21:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714942886; cv=none; b=bLOOfXD07gcWcbgI28uJk+VXJhZqUeRh3dqDfo41u6xRtXlJvxGP4WXBFFo3cCNVMXRo/WFPkD32hDSXjkNyhX/E/8B5mCvlj7yctmtp0cbbYuvhESmXqUEU1plJA8x70sFWvDuC4stml5QKYChhCdPWenfps/m9ruRqUfkrM20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714942886; c=relaxed/simple;
	bh=fsGFUxxrZ3vecHtIBjN3MvHHAFSPpNP8s6yYTUHccoc=;
	h=Date:To:From:Subject:Message-Id; b=XO73MUquNb1O+eS9NQGOdgNYwK/DwemQ1a9+d9vXe+gieYK9nTWsrk2scG+IHqK5h07c72JeKRWL2ZnES1/pg02geb2Wg0SbfyIebd9DjrB5kymiRL6tjb5Zyc1HMzmbFwNOwNoy+GpuqKbU/3fXkvryI9JaHvsuuDbhsJrzxYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SkoxZRa7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SkoxZRa7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9027BC116B1;
	Sun,  5 May 2024 21:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714942886;
	bh=fsGFUxxrZ3vecHtIBjN3MvHHAFSPpNP8s6yYTUHccoc=;
	h=Date:To:From:Subject:From;
	b=SkoxZRa7kYw4wf5Lq1CxnIQsjYbsNulGB4G8de8KmbLWtTe5KS5XXavyUmkmSg66v
	 LL8f13wUqBECAjVZD/frLKC/E1GNsuKY10xuRhHEnMY4TPz/n45OOp1Wt4b29Dl29Q
	 OC4WDLfNmuy/jBzYyAcF5PbLg5BKa5yRSCpIPFr4=
Date: Sun, 05 May 2024 14:01:26 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-maintainer-profile-change-the-maintainers-timezone-from-pst-to-pt.patch added to mm-unstable branch
Message-Id: <20240505210126.9027BC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/maintainer-profile: change the maintainer's timezone from PST to PT
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-maintainer-profile-change-the-maintainers-timezone-from-pst-to-pt.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-maintainer-profile-change-the-maintainers-timezone-from-pst-to-pt.patch

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
Subject: Docs/mm/damon/maintainer-profile: change the maintainer's timezone from PST to PT
Date: Fri, 3 May 2024 11:03:17 -0700

The document says the maintainer is working on only PST.  The maintainer
respects daylight saving system, though.  Update the time zone to PT.

Link: https://lkml.kernel.org/r/20240503180318.72798-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/maintainer-profile.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-mm-damon-maintainer-profile-change-the-maintainers-timezone-from-pst-to-pt
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -48,9 +48,9 @@ Review cadence
 --------------
 
 The DAMON maintainer does the work on the usual work hour (09:00 to 17:00,
-Mon-Fri) in PST.  The response to patches will occasionally be slow.  Do not
-hesitate to send a ping if you have not heard back within a week of sending a
-patch.
+Mon-Fri) in PT (Pacific Time).  The response to patches will occasionally be
+slow.  Do not hesitate to send a ping if you have not heard back within a week
+of sending a patch.
 
 
 .. [1] https://git.kernel.org/akpm/mm/h/mm-unstable
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

