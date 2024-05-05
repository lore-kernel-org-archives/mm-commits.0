Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9D27580E
	for <mm-commits@vger.kernel.org>; Sun,  5 May 2024 21:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714942885; cv=none; b=VVh/RYGSZdzEPhKHb3uRYe1+UlVKv95i8mZU1RAGnj8XExNv0ai87xM3sWcfSBJ5obMmr7DKkfLoVeLKm+WIQeiqNP+AbEIqXk9iRB96S0Ipsg6LJIUPyMcNBKFe4zrvIYRMk4ca25DkywBFBwRo7A0Ec+c2qgXo3fpgEVh1tns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714942885; c=relaxed/simple;
	bh=MctphoIWZ7Y3rcbZEaNf5izCsPEWL7RvQpEEMU7NhNA=;
	h=Date:To:From:Subject:Message-Id; b=gnKf2tLqf6KVeZSt3kPwR/K66+EdVWVsp1+2XpYJneMax3z/7nRD37+GItzVYjUqB3nzyrsWe7kGroFnD7NZbw/dR9Vooxu7mr0ctuQYJJupczVOUgm4E84NRdEIRzjfbWPRQ6BmKRa3p4dF9rs8lb098Fe0VokVhNc9uGNcXyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C+UUdyiH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C+UUdyiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A442CC113CC;
	Sun,  5 May 2024 21:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714942885;
	bh=MctphoIWZ7Y3rcbZEaNf5izCsPEWL7RvQpEEMU7NhNA=;
	h=Date:To:From:Subject:From;
	b=C+UUdyiHAoZnonFDfSrOfXgL8FN6eq14OSsKNbYiPAym2A5FCZ28kKwYOyw0BxclC
	 3QNJJ4tZR2w23hcTomCCLCxcy1l0JsZVBSKaWVrh7Qh9rOmEnExfIjql2+b6yqWOsr
	 JvErM0TbCSEAo0xDFBvwZHhI7CTmznghOBIuAdeo=
Date: Sun, 05 May 2024 14:01:25 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-use-a-list-for-supported-filters.patch added to mm-unstable branch
Message-Id: <20240505210125.A442CC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: use a list for supported filters
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-use-a-list-for-supported-filters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-use-a-list-for-supported-filters.patch

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
Subject: Docs/mm/damon/design: use a list for supported filters
Date: Fri, 3 May 2024 11:03:16 -0700

Filters section is listing currently supported filter types in a normal
paragraph.  Since the number of types are higher than four, it is not easy
to read for only specific types.  Use a list for easier finding of
specific types.

Link: https://lkml.kernel.org/r/20240503180318.72798-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   44 +++++++++++++++-------------
 1 file changed, 25 insertions(+), 19 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-use-a-list-for-supported-filters
+++ a/Documentation/mm/damon/design.rst
@@ -461,26 +461,32 @@ number of filters for each scheme.  Each
 memory, and whether it should exclude the memory of the type (filter-out), or
 all except the memory of the type (filter-in).
 
-Currently, anonymous page, memory cgroup, young page, address range, and DAMON
-monitoring target type filters are supported by the feature.  Some filter
-target types require additional arguments.  The memory cgroup filter type asks
-users to specify the file path of the memory cgroup for the filter.  The
-address range type asks the start and end addresses of the range.  The DAMON
-monitoring target type asks the index of the target from the context's
-monitoring targets list.  Hence, users can apply specific schemes to only
-anonymous pages, non-anonymous pages, pages of specific cgroups, all pages
-excluding those of specific cgroups, pages that not accessed after the last
-access check from the scheme, pages that accessed after the last access check
-from the scheme, pages in specific address range, pages in specific DAMON
-monitoring targets, and any combination of those.
+For efficient handling of filters, some types of filters are handled by the
+core layer, while others are handled by operations set.  In the latter case,
+hence, support of the filter types depends on the DAMON operations set.  In
+case of the core layer-handled filters, the memory regions that excluded by the
+filter are not counted as the scheme has tried to the region.  In contrast, if
+a memory regions is filtered by an operations set layer-handled filter, it is
+counted as the scheme has tried.  This difference affects the statistics.
 
-To handle filters efficiently, the address range and DAMON monitoring target
-type filters are handled by the core layer, while others are handled by
-operations set.  If a memory region is filtered by a core layer-handled filter,
-it is not counted as the scheme has tried to the region.  In contrast, if a
-memory regions is filtered by an operations set layer-handled filter, it is
-counted as the scheme has tried.  The difference in accounting leads to changes
-in the statistics.
+Below types of filters are currently supported.
+
+- anonymous page
+  - Applied to pages that containing data that not stored in files.
+  - Handled by operations set layer.  Supported by only ``paddr`` set.
+- memory cgroup
+  - Applied to pages that belonging to a given cgroup.
+  - Handled by operations set layer.  Supported by only ``paddr`` set.
+- young page
+  - Applied to pages that are accessed after the last access check from the
+    scheme.
+  - Handled by operations set layer.  Supported by only ``paddr`` set.
+- address range
+  - Applied to pages that belonging to a given address range.
+  - Handled by the core logic.
+- DAMON monitoring target
+  - Applied to pages that belonging to a given DAMON monitoring target.
+  - Handled by the core logic.
 
 
 Application Programming Interface
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

