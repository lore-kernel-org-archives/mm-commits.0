Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770133C38
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 02:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719885999; cv=none; b=bPBZJ/zAp6C72WKObb9Ugl53kREhVY6DlZfIEAi8Qiupg1a+2AwE7FsurXBMoqQdZJAxf5/78iNqm8Rb/RV9G2pC0v16ByX9iRi7SRL9HIV0EtN4kPLazex7EsC0jLhnSjpYrxIuw9FIsA3pufruxxXcPL/9Sp1VsG1oHli4IRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719885999; c=relaxed/simple;
	bh=/M3f2xCS+AZs/4b6cI5tgUMDbyKxGalA8zq22uKytAw=;
	h=Date:To:From:Subject:Message-Id; b=RCnHTVkdX78OVRebvfWbWuxf+oJg7OwXpxdBDlSqAibeA4RsoOKncAOAoZ2A5z/PMQd9UDey/3dqc9VkMIOuO2HxOwiJB3v00SWPMBBxzzxbDeZJMg1G0/fkli3wZmj6OgephPWwy+zKxnUKiD4jQTQELcwxW1sXryJddiQrb0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NgYfmc2z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NgYfmc2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6EA6C116B1;
	Tue,  2 Jul 2024 02:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719885998;
	bh=/M3f2xCS+AZs/4b6cI5tgUMDbyKxGalA8zq22uKytAw=;
	h=Date:To:From:Subject:From;
	b=NgYfmc2z/zjZHKH/Ug/Fc0oWsUnUDWmrnryAEVLxmhhAu8GVSiEvGGq4jYcxhdYXF
	 GtCXv2LDsaxOhUxpKn9Czi7csSLKnuw4Jw/qD90QidMS65XSw6Fq1xvcMeu/rHR/jf
	 +/MBWj2PfyM2CGZBy1I3zf+qZ/AgyN0a88zzUup4=
Date: Mon, 01 Jul 2024 19:06:33 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-fix-two-typos.patch added to mm-unstable branch
Message-Id: <20240702020638.D6EA6C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: fix two typos
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-fix-two-typos.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-fix-two-typos.patch

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
Subject: Docs/mm/damon/design: fix two typos
Date: Mon, 1 Jul 2024 12:26:58 -0700

Patch series "Docs/damon: minor fixups and improvements".

Fixup typos, clarify regions merging operation design with recent change,
add access pattern snapshot example use case, and improve readability of
the design document and subsystem documents index by
reorganizing/wordsmithing and adding links to other sections and/or
documents for easy browsing.


This patch (of 9):

Fix two typos.  The first one is just a simple typo: s/accurach/accuracy/

The second one is made by the author being out of their mind.  'Region
Based Sampling' section of the doc is mistakenly calling the access
frequency counter of region as 'nr_regions'.  Fix it with the correct
name, 'nr_accesses'.

Link: https://lkml.kernel.org/r/20240701192706.51415-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20240701192706.51415-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-fix-two-typos
+++ a/Documentation/mm/damon/design.rst
@@ -25,7 +25,7 @@ DAMON subsystem is configured with three
 - Operations Set: Implements fundamental operations for DAMON that depends on
   the given monitoring target address-space and available set of
   software/hardware primitives,
-- Core: Implements core logics including monitoring overhead/accurach control
+- Core: Implements core logics including monitoring overhead/accuracy control
   and access-aware system operations on top of the operations set layer, and
 - Modules: Implements kernel modules for various purposes that provides
   interfaces for the user space, on top of the core layer.
@@ -192,7 +192,7 @@ one page in the region is required to be
 interval``, DAMON randomly picks one page in each region, waits for one
 ``sampling interval``, checks whether the page is accessed meanwhile, and
 increases the access frequency counter of the region if so.  The counter is
-called ``nr_regions`` of the region.  Therefore, the monitoring overhead is
+called ``nr_accesses`` of the region.  Therefore, the monitoring overhead is
 controllable by setting the number of regions.  DAMON allows users to set the
 minimum and the maximum number of regions for the trade-off.
 
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

