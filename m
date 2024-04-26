Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D3238396
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 22:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714169867; cv=none; b=G4h3cEse//pqINVoOoE5Z/kXgclUx6nxbIZSZfveUhLTJ6GJh3bT3tHv4yySgewRQN15v7wRAwc9OkaRmEfZxSPQLmNUC8Qk/CQU/gX7oT5wMMcR8puoqrX8zT/odsBSLYUP28SNb1M5YmwTibK6F5DRRiEawJtjLEeAaPkRHQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714169867; c=relaxed/simple;
	bh=eAoz07ungXfY6k+JuyDB7mVjlhsxQ+NcUfd7N9XFSdc=;
	h=Date:To:From:Subject:Message-Id; b=bpS3e4aj3hX8wFkJkGkL4rBP77Z3RDBDjt9Z76wRR/5dvHxX5nDB/efavWhUHgXeE0fFUK2QqXuiXsZLKzU3VnCAKHglBmS8YLESg3ByflTBa+oM3+RgDeAiqTmoLtOFn8iY30mCYmxnoHLh/BdJJ+h34wMV+ghlEnZQn0iBqq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W9x1hEoq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W9x1hEoq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB27C113CD;
	Fri, 26 Apr 2024 22:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714169867;
	bh=eAoz07ungXfY6k+JuyDB7mVjlhsxQ+NcUfd7N9XFSdc=;
	h=Date:To:From:Subject:From;
	b=W9x1hEoqa9UZLsVtueSubUjExgL8pqWwsWdL5BPmSB02BYyrmpGpIS3qMTuWDU9KX
	 UIOB0LkiOhApfnUMIf+fQ1Qai7b2WHvdyS9cocP5k31/qE10pZuz8DSQ6qZw2Xnmhb
	 0WDMiImrVUltmpom/0AwXrgVTDl1h8KYlUwyN9vg=
Date: Fri, 26 Apr 2024 15:17:46 -0700
To: mm-commits@vger.kernel.org,honggyu.kim@sk.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-update-for-young-page-type-damos-filter.patch added to mm-unstable branch
Message-Id: <20240426221747.4EB27C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for young page type DAMOS filter
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-update-for-young-page-type-damos-filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-update-for-young-page-type-damos-filter.patch

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

mm-damon-paddr-implement-damon_folio_young.patch
mm-damon-paddr-implement-damon_folio_mkold.patch
mm-damon-add-damos-filter-type-young.patch
mm-damon-paddr-implement-damos-filter-type-young.patch
docs-mm-damon-design-document-young-page-type-damos-filter.patch
docs-admin-guide-mm-damon-usage-update-for-young-page-type-damos-filter.patch
docs-abi-damon-update-for-youg-page-type-damos-filter.patch

