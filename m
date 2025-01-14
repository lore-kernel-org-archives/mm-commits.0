Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E2423353A
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837170; cv=none; b=BbRVY6AW9ovC9LaZ2xju3JyiHt7Eo/l2PG9QdgYbdjZfP+nDT5kCaK8ClOzLxYjdYAJxWmg4h+AZMG5RpqqZ1/Wo7DHra8NkycHt5iduo1q2z1ZXVO0yat0cGFtzuOU0bcS+C/7HwejkNgZ7u229LxTF6JZO0GQyHLpS46Z9NTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837170; c=relaxed/simple;
	bh=NI+iu5jBUx6ml7qr0gLeLP8u8YAry0366a+JWcuhcwo=;
	h=Date:To:From:Subject:Message-Id; b=pm4pno4rlwMXyQhTQ9iJC5qIbxILl/vVBhAHxx9UIK3RDZoce5e/AXY9TBfGIMH4PR78STyW8FP/tjDZIDZwqXyEIPgqmlqmQqJocLlcUxXKfwJGV7G6c8P+IW6UiBIh79S/Ngr92ILkQkGwbyTRPKGUSnvOzVgk7oU7FySnbkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UsT5IREI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UsT5IREI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD9EC4CEDD;
	Tue, 14 Jan 2025 06:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837170;
	bh=NI+iu5jBUx6ml7qr0gLeLP8u8YAry0366a+JWcuhcwo=;
	h=Date:To:From:Subject:From;
	b=UsT5IREIX7d945SY2I5UjKFIOB+jtv/fC+tTAKfnN/dQaA5mgI0qBipfFT6f8OOA1
	 nNGn1MlL9qdEAkEuYlW5xA3wrzO0fwTAMvUfssvpE6HjOfBLIEOTAJWP728JXy8ecM
	 wVzEVm0OFwpHOSO8ALRpsCsqCGuSHBNyCX9PbGpg=
Date: Mon, 13 Jan 2025 22:46:10 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-document-per-region-sz_filter_passed-stat.patch removed from -mm tree
Message-Id: <20250114064610.9AD9EC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: document per-region sz_filter_passed stat
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-document-per-region-sz_filter_passed-stat.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: document per-region sz_filter_passed stat
Date: Mon, 6 Jan 2025 11:33:59 -0800

Update 'Regions Walking' section of design document for the newly added
per-region operations set handling DAMOS filters-passed bytes.

Link: https://lkml.kernel.org/r/20250106193401.109161-15-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-per-region-sz_filter_passed-stat
+++ a/Documentation/mm/damon/design.rst
@@ -587,7 +587,8 @@ Regions Walking
 
 DAMOS feature allowing users access each region that a DAMOS action has just
 applied.  Using this feature, DAMON :ref:`API <damon_design_api>` allows users
-access full properties of the regions including the access monitoring results.
+access full properties of the regions including the access monitoring results
+and amount of the region's internal memory that passed the DAMOS filters.
 :ref:`DAMON sysfs interface <sysfs_interface>` also allows users read the data
 via special :ref:`files <sysfs_schemes_tried_regions>`.
 
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

