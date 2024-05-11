Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E4BA921
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 22:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467201; cv=none; b=MZ+BC2B3hwxFYIgO4ht/eha5sqpmINpGjnM+ur4VU9P13LEbqHyfSrEBiReLoIb9o5uit8+REtezoaPGnTi/K3DMuMiUOcMTdYo7CiCpeydE7+VwKos7udQ25Ne9owuNzVrAbQ8ZFKEVCk3UXrglBG0ZySv/+tf5ZFXwwMAY/bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467201; c=relaxed/simple;
	bh=WHJsavZT6BJ4NYch4wqHOAjxA5qtu5Oma6dwsc7G1Lc=;
	h=Date:To:From:Subject:Message-Id; b=X0Zu7pxXwo1ggvIbFxaRHVFIWHkhFUpVCceZUnBKY1Xxz80T3+D4In++Dfqj4UWOj3nK0pOBLeKdaS1/G3RJm6nh7K8aCMj8KRX1VowuA6k95yYseZpoU1++aw1QvGlPAaVxByd9VZPPBH0HunoReQveJGBwYIDZ/1gAHQVlQYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CrBi1Q5W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CrBi1Q5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5DCC2BBFC;
	Sat, 11 May 2024 22:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467200;
	bh=WHJsavZT6BJ4NYch4wqHOAjxA5qtu5Oma6dwsc7G1Lc=;
	h=Date:To:From:Subject:From;
	b=CrBi1Q5WzF07PdqTXmvX1ZnFUj8sPXsFRc8No0mNVTv1lFv9CJXuSPH/5pRjqzT68
	 wbJd7NbylwoSZyQ3uTCCokugXR/6bhDKiTaLXPhURApjgwTPVZJca8lnzNLg4xuazY
	 hj1GIflN60DnnpwELNLkHktai3MKiYTpxudhAwLM=
Date: Sat, 11 May 2024 15:40:00 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] docs-mm-damon-design-use-a-list-for-supported-filters-fix.patch removed from -mm tree
Message-Id: <20240511224000.BC5DCC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: fix build warning
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-use-a-list-for-supported-filters-fix.patch

This patch was dropped because it was folded into docs-mm-damon-design-use-a-list-for-supported-filters.patch

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
docs-mm-damon-maintainer-profile-change-the-maintainers-timezone-from-pst-to-pt.patch
docs-mm-damon-maintainer-profile-allow-posting-patches-based-on-damon-next-tree.patch

