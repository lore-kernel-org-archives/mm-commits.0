Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE521C548C
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837209; cv=none; b=YgsbZgRw2QMDg9rxTatJEbB3C4iIXj+kgy9u4gfa100NndMS8GtExnOSgpH+35peD0la5IadkHlLLPMJSOGG/W+Fiv+koE/vKXozf8/SIvc4dpCjqsmMipc/i0cxr/JYgreUVQ/VzPlCgktEYctT/K46ZhPxgAI67L1MXQWK2+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837209; c=relaxed/simple;
	bh=Qa0lo1EPiJgLoCx21kMx97sNpDAPQHXGo2H+Td4Rqkc=;
	h=Date:To:From:Subject:Message-Id; b=qOaQn3U04LDpnwtLUvk6aQPLV34mN1oHXif3sS81I1CTTgMPdTirlR8H4P/RmXsTFbF8x0IxlfICc6M470WuvWFwY5YqL+4dPt76tEU4J+/Xcf82P/t0Fg27tQk9+9jVkGKE8XGsLpYqRwgQTY0J4UCtWiJ0fRkH9axLSkBrEGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1rAwycT1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1rAwycT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6CC3C4CEDD;
	Tue, 14 Jan 2025 06:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837208;
	bh=Qa0lo1EPiJgLoCx21kMx97sNpDAPQHXGo2H+Td4Rqkc=;
	h=Date:To:From:Subject:From;
	b=1rAwycT1kJr7f8xSJstdBJw3p9kvm5AfOijtsIPBW1d4XTDNekZQDYQ6V49qntATW
	 E77rsKNXBnWre0h+aflX5vUQzdnX19mRSo5qtLefEDeQ0NrHAII2uSH/ndNwACul+6
	 rVr8AgfqMaaLpwQKRKE5UntNF+gJ3AmW8EQPeIv4=
Date: Mon, 13 Jan 2025 22:46:48 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-document-allow-reject-damos-filter-behaviors.patch removed from -mm tree
Message-Id: <20250114064648.D6CC3C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: document allow/reject DAMOS filter behaviors
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-document-allow-reject-damos-filter-behaviors.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: document allow/reject DAMOS filter behaviors
Date: Thu, 9 Jan 2025 09:51:23 -0800

Update DAMOS filters design document to describe the allow/reject behavior
of filters.

Link: https://lkml.kernel.org/r/20250109175126.57878-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   33 ++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-allow-reject-damos-filter-behaviors
+++ a/Documentation/mm/damon/design.rst
@@ -504,9 +504,34 @@ have a list of latency-critical processe
 
 To let users optimize DAMOS schemes with such special knowledge, DAMOS provides
 a feature called DAMOS filters.  The feature allows users to set an arbitrary
-number of filters for each scheme.  Each filter specifies the type of target
-memory, and whether it should exclude the memory of the type (filter-out), or
-all except the memory of the type (filter-in).
+number of filters for each scheme.  Each filter specifies
+
+- a type of memory (``type``),
+- whether it is for the memory of the type or all except the type
+  (``matching``), and
+- whether it is to allow (include) or reject (exclude) applying
+  the scheme's action to the memory (``allow``).
+
+When multiple filters are installed, each filter is evaluated in the installed
+order.  If a part of memory is matched to one of the filter, next filters are
+ignored.  If the memory passes through the filters evaluation stage because it
+is not matched to any of the filters, applying the scheme's action to it is
+allowed, same to the behavior when no filter exists.
+
+For example, let's assume 1) a filter for allowing anonymous pages and 2)
+another filter for rejecting young pages are installed in the order.  If a page
+of a region that eligible to apply the scheme's action is an anonymous page,
+the scheme's action will be applied to the page regardless of whether it is
+young or not, since it matches with the first allow-filter.  If the page is
+not anonymous but young, the scheme's action will not be applied, since the
+second reject-filter blocks it.  If the page is neither anonymous nor young,
+the page will pass through the filters evaluation stage since there is no
+matching filter, and the action will be applied to the page.
+
+Note that the action can equally be applied to memory that either explicitly
+filter-allowed or filters evaluation stage passed.  It means that installing
+allow-filters at the end of the list makes no practical change but only
+filters-checking overhead.
 
 For efficient handling of filters, some types of filters are handled by the
 core layer, while others are handled by operations set.  In the latter case,
@@ -516,7 +541,7 @@ filter are not counted as the scheme has
 a memory regions is filtered by an operations set layer-handled filter, it is
 counted as the scheme has tried.  This difference affects the statistics.
 
-Below types of filters are currently supported.
+Below ``type`` of filters are currently supported.
 
 - anonymous page
     - Applied to pages that containing data that not stored in files.
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

