Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C29E477281
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865934; cv=none; b=YDKaLuFK5kH9v4R9XwMTpzoam7kCZQtx0zV9lcML6G5UsSjZqMXDdXu4irD8RPyqdEQImLhsHNG+TXG72cD5CLo9nv2GnSBhbKX3Wnvoyeh0qz+KRcF1uywRq6pWZ2DX49zIBeoS4gPV/nFkqLueCwSeUPURi2bWVnA1iG+BYG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865934; c=relaxed/simple;
	bh=6Z3IWlCgJyFMJNxZHeYn4cR3NRZ+SFKKyapQJEN7Ghs=;
	h=Date:To:From:Subject:Message-Id; b=YVjfM+DUv+gdDMYkFNFLmDFi7WGJ7PMeORw/jSD7xLSCw0Ei0TVHKZmjURU9W6LSvoTF61R7HaJArZB8aShHMwQBOgRjt7RUG/hN4rHrD2Aj7VA901XyTc5fdqf2y2CGwkK2XMzZsjMYtRPnMA8sHWhxK/+HgC5+qn0JUeLi8WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h63EZ2vr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h63EZ2vr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E6E1F000FF;
	Tue, 13 Oct 2026 04:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865933;
	bh=JzwP9cSo52fxVFizl4y2lTV/BKRi0sUiXcFihY9YhUg=;
	h=Date:To:From:Subject;
	b=h63EZ2vr+GkkRLB1LoVTtt0lR2xLzEszLOh+3MqHfG6BKjH+ghkMzX5wMUAfHNC7+
	 zIwynqoFdC3szgBR3jC5HYgYjLxITsFlYTgnwymJ9+WOpDlo/WA4eGATJEr+7+yQEO
	 4lDTyrrkTx8fGQjdAeWPhu875ja7xehImpUDB5OE=
Date: Mon, 12 Oct 2026 21:32:13 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-update-for-hugepage_size-probe-filter.patch removed from -mm tree
Message-Id: <20261013043213.70E6E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: update for hugepage_size probe filter
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-update-for-hugepage_size-probe-filter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: Docs/mm/damon/design: update for hugepage_size probe filter
Date: Tue, 15 Sep 2026 07:33:55 -0700

Update DAMON design document for the newly added hugepage_size data
attribute probe filter type.

Link: https://lore.kernel.org/20260915143359.91472-7-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 Documentation/mm/damon/design.rst |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-update-for-hugepage_size-probe-filter
+++ a/Documentation/mm/damon/design.rst
@@ -300,6 +300,8 @@ filter types.  Currently below filter ty
 - ``pgidle_unset``: Matches if the page for the memory is marked as not
   access-idle.
 - ``pgidle_set``: Matches if the page for the memory is marked as access-idle.
+- ``hugepage_size``: Matches if the page for the memory is a part of a hugepage
+  of a given size range.
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damos_quota_goal-complement.patch
mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch
mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch
mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch
selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch
docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch
docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch
docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch

