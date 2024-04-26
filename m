Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B33224C9
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 22:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714169866; cv=none; b=Mt7ykNyKC25yVJXvqhT5pYLi0ll5gDKRhsgcSVD2X9jgMvtQIniFAIpfedAF23QjVKntvuGD/xpbN9u7vPQypVBWwEQb02RSxqWRUpUFARQg1MFHle1aMAydaikIizzUPujCuZXkqLt8noXIT+kDJIduQuxG4qs1jVPhGk0++iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714169866; c=relaxed/simple;
	bh=ng4fLsORXJwLmPfw389cuxY840q2AonxCcbiyFkLPqI=;
	h=Date:To:From:Subject:Message-Id; b=W8fuTkfSfKYwpEnI4aS7WAJmJ4vJOCVcJupPQZlMaHmMnUXowt347eObf7BElfjUZkDvbdCFG1hdZkvwDcvBsybf6ZinzDrhnGyP8aNpfa1QlsEPD09bNz5v1VgvtgCZfr1/XCS+FYUHKzHsjOYqOVs64xAvAOxYRhUy4jYM9QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uM2voa/V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uM2voa/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C04C113CD;
	Fri, 26 Apr 2024 22:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714169865;
	bh=ng4fLsORXJwLmPfw389cuxY840q2AonxCcbiyFkLPqI=;
	h=Date:To:From:Subject:From;
	b=uM2voa/VPa9ipELT5RNkvZy99GCBvnD/gMJvyv4nmPLveI/aH53Nf4Vopunn+0oxR
	 IbIe0hIOIwsE8y0UAgpuIFweFzVDhOhDBYqixKFhV1dH45aKykCLrA/8wgHwhkqiWW
	 uTJPfIbX/89ISPyB5zecJlLjI6CCcrt+o/rdwm9g=
Date: Fri, 26 Apr 2024 15:17:45 -0700
To: mm-commits@vger.kernel.org,honggyu.kim@sk.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-document-young-page-type-damos-filter.patch added to mm-unstable branch
Message-Id: <20240426221745.87C04C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: document 'young page' type DAMOS filter
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-document-young-page-type-damos-filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-document-young-page-type-damos-filter.patch

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
Subject: Docs/mm/damon/design: document 'young page' type DAMOS filter
Date: Fri, 26 Apr 2024 12:52:44 -0700

Update DAMON design document for the newly added DAMOS filter type, 'young
page'.

Link: https://lkml.kernel.org/r/20240426195247.100306-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-young-page-type-damos-filter
+++ a/Documentation/mm/damon/design.rst
@@ -461,15 +461,17 @@ number of filters for each scheme.  Each
 memory, and whether it should exclude the memory of the type (filter-out), or
 all except the memory of the type (filter-in).
 
-Currently, anonymous page, memory cgroup, address range, and DAMON monitoring
-target type filters are supported by the feature.  Some filter target types
-require additional arguments.  The memory cgroup filter type asks users to
-specify the file path of the memory cgroup for the filter.  The address range
-type asks the start and end addresses of the range.  The DAMON monitoring
-target type asks the index of the target from the context's monitoring targets
-list.  Hence, users can apply specific schemes to only anonymous pages,
-non-anonymous pages, pages of specific cgroups, all pages excluding those of
-specific cgroups, pages in specific address range, pages in specific DAMON
+Currently, anonymous page, memory cgroup, young page, address range, and DAMON
+monitoring target type filters are supported by the feature.  Some filter
+target types require additional arguments.  The memory cgroup filter type asks
+users to specify the file path of the memory cgroup for the filter.  The
+address range type asks the start and end addresses of the range.  The DAMON
+monitoring target type asks the index of the target from the context's
+monitoring targets list.  Hence, users can apply specific schemes to only
+anonymous pages, non-anonymous pages, pages of specific cgroups, all pages
+excluding those of specific cgroups, pages that not accessed after the last
+access check from the scheme, pages that accessed after the last access check
+from the scheme, pages in specific address range, pages in specific DAMON
 monitoring targets, and any combination of those.
 
 To handle filters efficiently, the address range and DAMON monitoring target
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-paddr-implement-damon_folio_young.patch
mm-damon-paddr-implement-damon_folio_mkold.patch
mm-damon-add-damos-filter-type-young.patch
mm-damon-paddr-implement-damos-filter-type-young.patch
docs-mm-damon-design-document-young-page-type-damos-filter.patch
docs-admin-guide-mm-damon-usage-update-for-young-page-type-damos-filter.patch
docs-abi-damon-update-for-youg-page-type-damos-filter.patch

