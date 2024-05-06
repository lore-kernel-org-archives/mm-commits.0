Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF65B38DE0
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957135; cv=none; b=mQjrYVyYmLDCDk9wD5CLeryQCrMm4DOqbfoKnoMYR/LnRMBkiDA0xO1qf2SvDLQd0O2Xt89Igj6cG3XvhnIjzYF2dCIFGn91TGYyZYRFeli0+mJ4ft65zJCNgucPIDZHnnBnw/5x4cEImUdF4BVgoG1V57WrKW6rEXZJAv2wnks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957135; c=relaxed/simple;
	bh=fRH95y1MH1bS6BzTZHpAuHIclm9IY41u5KtvOl7RaOc=;
	h=Date:To:From:Subject:Message-Id; b=Ie1c3yOQwMXnwvl7fFI0EI3aoWK+Pz22Gu0lY9oaT52seDsEgIwNQ2zdwkZX+X0kiIlQ7Ojcq+c37ZUiCxXUBAquvhBjVZ2C95WVkUlV3wKlIZzfZql49qopxvfDBL+9zCtOQ09e3WtM/ngzza0Akhm5GpxfKgkIWjGJSNXaRSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R987+E16; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R987+E16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828BDC116B1;
	Mon,  6 May 2024 00:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957134;
	bh=fRH95y1MH1bS6BzTZHpAuHIclm9IY41u5KtvOl7RaOc=;
	h=Date:To:From:Subject:From;
	b=R987+E16FI8/Q06rwdq1MKfPxN18DkQlsv0Q2k/NU7n1H4w2/mDYhxCnAbua0j+Oe
	 A0dFLVkjphgstlQ7ZrPRjXZT/cGdG4cqAupNT3IG889vPiQGEvzOKuulCB73iOCqj1
	 +eSeCFloFm4CEPyXUBEvAT3OoZnu+beXGKgzES3w=
Date: Sun, 05 May 2024 17:58:54 -0700
To: mm-commits@vger.kernel.org,honggyu.kim@sk.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-update-for-young-page-type-damos-filter.patch removed from -mm tree
Message-Id: <20240506005854.828BDC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for young page type DAMOS filter
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-update-for-young-page-type-damos-filter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: update for young page type DAMOS filter
Date: Fri, 26 Apr 2024 12:52:45 -0700

Update DAMON usage document for the newly added DAMOS filter type, 'young
page'.

Link: https://lkml.kernel.org/r/20240426195247.100306-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   26 ++++++++---------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-young-page-type-damos-filter
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -410,19 +410,19 @@ in the numeric order.
 
 Each filter directory contains six files, namely ``type``, ``matcing``,
 ``memcg_path``, ``addr_start``, ``addr_end``, and ``target_idx``.  To ``type``
-file, you can write one of four special keywords: ``anon`` for anonymous pages,
-``memcg`` for specific memory cgroup, ``addr`` for specific address range (an
-open-ended interval), or ``target`` for specific DAMON monitoring target
-filtering.  In case of the memory cgroup filtering, you can specify the memory
-cgroup of the interest by writing the path of the memory cgroup from the
-cgroups mount point to ``memcg_path`` file.  In case of the address range
-filtering, you can specify the start and end address of the range to
-``addr_start`` and ``addr_end`` files, respectively.  For the DAMON monitoring
-target filtering, you can specify the index of the target between the list of
-the DAMON context's monitoring targets list to ``target_idx`` file.  You can
-write ``Y`` or ``N`` to ``matching`` file to filter out pages that does or does
-not match to the type, respectively.  Then, the scheme's action will not be
-applied to the pages that specified to be filtered out.
+file, you can write one of five special keywords: ``anon`` for anonymous pages,
+``memcg`` for specific memory cgroup, ``young`` for young pages, ``addr`` for
+specific address range (an open-ended interval), or ``target`` for specific
+DAMON monitoring target filtering.  In case of the memory cgroup filtering, you
+can specify the memory cgroup of the interest by writing the path of the memory
+cgroup from the cgroups mount point to ``memcg_path`` file.  In case of the
+address range filtering, you can specify the start and end address of the range
+to ``addr_start`` and ``addr_end`` files, respectively.  For the DAMON
+monitoring target filtering, you can specify the index of the target between
+the list of the DAMON context's monitoring targets list to ``target_idx`` file.
+You can write ``Y`` or ``N`` to ``matching`` file to filter out pages that does
+or does not match to the type, respectively.  Then, the scheme's action will
+not be applied to the pages that specified to be filtered out.
 
 For example, below restricts a DAMOS action to be applied to only non-anonymous
 pages of all memory cgroups except ``/having_care_already``.::
_

Patches currently in -mm which might be from sj@kernel.org are

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

