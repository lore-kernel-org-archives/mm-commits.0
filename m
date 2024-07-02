Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05F03C38
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 02:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719886001; cv=none; b=EKOcKMokOU+kMP77/Ji/84Rekn4ojOp2m8WGOG3uzip4cSa6SriV9PTMJPvEuuiM9x8SGOU1q1i3S8yfSwXjL5/0dPPs+xExG4DV6GjHlhhro3zw+V2FWjX1x++xN/hC29aBQ7pKgV1qJlpDOs8xWiENnCNOijY7SN459uPiab0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719886001; c=relaxed/simple;
	bh=isrOtO0ob+xrMRRueQzsG58zjzwebbj0q8PZDP/H4eg=;
	h=Date:To:From:Subject:Message-Id; b=Ft+fbIYWQ9vR2J0SNX0McUlVQxN3HI/4/jGX4IgNqPk3eBQ5Et7tdtRJLOJzRn8fX5/O5+yigB+juPj1To/LTR99IUgmBs+AWLZOdzTIAEpspN/DfgjzDKg8M+0yRgOQPEbXobCcKX131M7DhYr0NVqquBjEOcMDYl4tgL9XdMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M3g5vE7z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M3g5vE7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DEA8C116B1;
	Tue,  2 Jul 2024 02:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719886000;
	bh=isrOtO0ob+xrMRRueQzsG58zjzwebbj0q8PZDP/H4eg=;
	h=Date:To:From:Subject:From;
	b=M3g5vE7zRjqysC3Pv3em2gr10NRgYwz9CPyPOPrYIHCL7qRNFjeTGivhN/TZcHoOb
	 uPlZp466TywLD2JF4WP4qUGRNId8NgX+kPvJOW41wmzFFUZPN+JRNK7+cmg2CL8mRv
	 +9Mhh+M2ED0n2PB7SnKY9SPQlOxZ6sjdeNTqJg+Y=
Date: Mon, 01 Jul 2024 19:06:40 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-clarify-regions-merging-operation.patch added to mm-unstable branch
Message-Id: <20240702020640.9DEA8C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: clarify regions merging operation
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-clarify-regions-merging-operation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-clarify-regions-merging-operation.patch

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
Subject: Docs/mm/damon/design: clarify regions merging operation
Date: Mon, 1 Jul 2024 12:26:59 -0700

DAMON design document is not explaining how min_nr_regions limit is kept,
and what happens if the number of regions exceeds max_nr_regions.  Add
more clarification for those.

Link: https://lkml.kernel.org/r/20240701192706.51415-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-clarify-regions-merging-operation
+++ a/Documentation/mm/damon/design.rst
@@ -209,11 +209,18 @@ the data access pattern can be dynamical
 monitoring quality.  To keep the assumption as much as possible, DAMON
 adaptively merges and splits each region based on their access frequency.
 
-For each ``aggregation interval``, it compares the access frequencies of
-adjacent regions and merges those if the frequency difference is small.  Then,
-after it reports and clears the aggregated access frequency of each region, it
-splits each region into two or three regions if the total number of regions
-will not exceed the user-specified maximum number of regions after the split.
+For each ``aggregation interval``, it compares the access frequencies
+(``nr_accesses``) of adjacent regions.  If the difference is small, and if the
+sum of the two regions' sizes is smaller than the size of total regions divided
+by the ``minimum number of regions``, DAMON merges the two regions.  If the
+resulting number of total regions is still higher than ``maximum number of
+regions``, it repeats the merging with increasing access frequenceis difference
+threshold until the upper-limit of the number of regions is met, or the
+threshold becomes higher than possible maximum value (``aggregation interval``
+divided by ``sampling interval``).   Then, after it reports and clears the
+aggregated access frequency of each region, it splits each region into two or
+three regions if the total number of regions will not exceed the user-specified
+maximum number of regions after the split.
 
 In this way, DAMON provides its best-effort quality and minimal overhead while
 keeping the bounds users set for their trade-off.
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix-2.patch
docs-mm-damon-design-fix-two-typos.patch
docs-mm-damon-design-clarify-regions-merging-operation.patch
docs-admin-guide-mm-damon-start-add-access-pattern-snapshot-example.patch
docs-mm-damon-design-add-links-from-overall-architecture-to-sections-of-details.patch
docs-mm-damon-design-move-configurable-operations-set-section-into-operations-set-layer-section.patch
docs-mm-damon-design-remove-programmable-modules-section-in-favor-of-modules-section.patch
docs-mm-damon-design-add-links-to-sections-of-damon-sysfs-interface-usage-doc.patch
docs-mm-damon-index-add-links-to-design.patch
docs-mm-damon-index-add-links-to-admin-guide-doc.patch

