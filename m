Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E30168AE8
	for <mm-commits@vger.kernel.org>; Tue,  7 May 2024 16:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715099005; cv=none; b=D1BI100f5TZmvMZVp4dh46BdBkN23jPl0EyL/QJlXiVtENJVZQ9wOIte9YK83mvclJv6HQlTXKzqO7Z96zc99g5YY/AJs00U95Vw6nOR3u2RkPm1qbTq86s1CyCAoXV9Eua1aOBds3dJkvnGIeaz8/YIdBzogWi/oUNFUQB6OHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715099005; c=relaxed/simple;
	bh=f9qMj6syz7z7u2TYY7AYcrj0TQi7oEmVtaWloUcTd1U=;
	h=Date:To:From:Subject:Message-Id; b=nzl+A8DF6DGcncoNcY64I69BEymLzXgDcGWXESK0BDz2QViKr1otLzpwcVsX7SSWMyzBCfDYusqJ3cROTEgc4B+TnEe13fpSNkYa0CCU6ZSYOGU575OJyHlne9GEiooxPEBEXJmlf7X51FBMUqy9rERpvR5gO1DFj/JFV1V5fyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CgdeKlDE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CgdeKlDE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7981C2BBFC;
	Tue,  7 May 2024 16:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715099004;
	bh=f9qMj6syz7z7u2TYY7AYcrj0TQi7oEmVtaWloUcTd1U=;
	h=Date:To:From:Subject:From;
	b=CgdeKlDEhEs16PwOB2QYkuW6jT42+KbuiJEHrp4Z2H71hcNJz1vbpL3MFsoB2D2GM
	 KBWr/C1nr+BymZpTtjL5EshhA6IH/qFmPWH1gV2ay6sebGl7sHGJ3uG6rFN5PtH18V
	 1KfK+w2eZdu8VGzTdcsT+B9PPnPYHIq7shE1J74o=
Date: Tue, 07 May 2024 09:23:24 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-use-a-list-for-supported-filters-fix.patch added to mm-unstable branch
Message-Id: <20240507162324.A7981C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: fix build warning
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-use-a-list-for-supported-filters-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-use-a-list-for-supported-filters-fix.patch

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
Subject: Docs/mm/damon/design: fix build warning
Date: Tue, 7 May 2024 09:17:47 -0700

Commit b7138c7d40b0 ("Docs/mm/damon/design: use a list for supported
filters") of mm-unstable tree is causing below warning and error with
'make htmldocs'.

    Documentation/mm/damon/design.rst:482: ERROR: Unexpected indentation.
    Documentation/mm/damon/design.rst:483: WARNING: Block quote ends without a blank line; unexpected unindent.

The problem caused by wrong indentation for nested list items.  Fix the
wrong indentation.

Link: https://lkml.kernel.org/r/20240507161747.52430-1-sj@kernel.org
Fixes: b7138c7d40b0 ("Docs/mm/damon/design: use a list for supported filters")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/20240507162623.4d94d455@canb.auug.org.au
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-use-a-list-for-supported-filters-fix
+++ a/Documentation/mm/damon/design.rst
@@ -472,21 +472,21 @@ counted as the scheme has tried.  This d
 Below types of filters are currently supported.
 
 - anonymous page
-  - Applied to pages that containing data that not stored in files.
-  - Handled by operations set layer.  Supported by only ``paddr`` set.
+    - Applied to pages that containing data that not stored in files.
+    - Handled by operations set layer.  Supported by only ``paddr`` set.
 - memory cgroup
-  - Applied to pages that belonging to a given cgroup.
-  - Handled by operations set layer.  Supported by only ``paddr`` set.
+    - Applied to pages that belonging to a given cgroup.
+    - Handled by operations set layer.  Supported by only ``paddr`` set.
 - young page
-  - Applied to pages that are accessed after the last access check from the
-    scheme.
-  - Handled by operations set layer.  Supported by only ``paddr`` set.
+    - Applied to pages that are accessed after the last access check from the
+      scheme.
+    - Handled by operations set layer.  Supported by only ``paddr`` set.
 - address range
-  - Applied to pages that belonging to a given address range.
-  - Handled by the core logic.
+    - Applied to pages that belonging to a given address range.
+    - Handled by the core logic.
 - DAMON monitoring target
-  - Applied to pages that belonging to a given DAMON monitoring target.
-  - Handled by the core logic.
+    - Applied to pages that belonging to a given DAMON monitoring target.
+    - Handled by the core logic.
 
 
 Application Programming Interface
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
docs-mm-damon-design-use-a-list-for-supported-filters-fix.patch
docs-mm-damon-maintainer-profile-change-the-maintainers-timezone-from-pst-to-pt.patch
docs-mm-damon-maintainer-profile-allow-posting-patches-based-on-damon-next-tree.patch

