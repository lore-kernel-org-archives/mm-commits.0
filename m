Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3080A921
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 22:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467334; cv=none; b=T1tOIfu0E0nadqbi8zH+yv3tfUMREmeJzPyV/dgxeIgtPjRwT+QpPcURyqCvXmDJ0BNkdalBMbnOwVh3zfcG9H4Ta5ekPtq6stXeyoHAXxRUrVLBIkDnsxC+Q+LTZygQpzctyFnd3QP7KOwNr4q7vRhfdvNr4RtGQ1wogAwXaM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467334; c=relaxed/simple;
	bh=qPR1KHpzQNHeOS5HQic/MJm3m3Vjl9dKseN2bITluV0=;
	h=Date:To:From:Subject:Message-Id; b=Dk49KKDkM27p0X1MDA3lbiToXYqSK4WSiuNDSHeNRY9NFJW9xgsW3/7IY8hYiepxnGRwujWoF7bSlkLKk4KRs6ywJp+DIRNr0o5tEgjeiizLoZ2WsQeOyqdybnQMk1J//BVJgHnK/2xaRKHWIHmo093eMgJM5VIobS0kUYEsWtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NwkBMDiq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NwkBMDiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45439C2BBFC;
	Sat, 11 May 2024 22:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467334;
	bh=qPR1KHpzQNHeOS5HQic/MJm3m3Vjl9dKseN2bITluV0=;
	h=Date:To:From:Subject:From;
	b=NwkBMDiq78CDa96VZl6JVr95/VaYwMSJyHPTfkH95tvzFy9kyDTuQSeX4XeRA01lK
	 2lpXoWfk0tMQlq8WMKcNoKUcEHEQl7/ddZ4CK9DbsDb22+6Mkh1DsYhrhVmymZlqKZ
	 mvtxL5stNC5EQaACVWNqvFv0wW9Jamx096TRVyU0=
Date: Sat, 11 May 2024 15:42:13 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-use-a-list-for-supported-filters.patch removed from -mm tree
Message-Id: <20240511224214.45439C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: use a list for supported filters
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-use-a-list-for-supported-filters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: use a list for supported filters
Date: Fri, 3 May 2024 11:03:16 -0700

Filters section is listing currently supported filter types in a normal
paragraph.  Since the number of types are higher than four, it is not easy
to read for only specific types.  Use a list for easier finding of
specific types.

[sj@kernel.org: fix build warning]
  Link: https://lkml.kernel.org/r/20240507161747.52430-1-sj@kernel.org
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
+    - Applied to pages that containing data that not stored in files.
+    - Handled by operations set layer.  Supported by only ``paddr`` set.
+- memory cgroup
+    - Applied to pages that belonging to a given cgroup.
+    - Handled by operations set layer.  Supported by only ``paddr`` set.
+- young page
+    - Applied to pages that are accessed after the last access check from the
+      scheme.
+    - Handled by operations set layer.  Supported by only ``paddr`` set.
+- address range
+    - Applied to pages that belonging to a given address range.
+    - Handled by the core logic.
+- DAMON monitoring target
+    - Applied to pages that belonging to a given DAMON monitoring target.
+    - Handled by the core logic.
 
 
 Application Programming Interface
_

Patches currently in -mm which might be from sj@kernel.org are


