Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036303C38
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 02:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719886014; cv=none; b=LPqI7qQCBHZH01ldOLLA1sLJCR6x6q0E+B6eO2N0Wq9Eey1+ZPymnTHAiCndgnkjx5AGUJdaIJLAYLCIOAntpIcxmmGnbBLqyxuvF3hy09qLzgj68P1PnIIqiJMaQ5ecfflR7bVCPHIQWIYOSlPIjZtL3mv7I5qYbl93E5SP108=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719886014; c=relaxed/simple;
	bh=y5wr6/9IxwlyDLaRmFqeQVgqfu5tw/FdZ/ZZFcAaqtg=;
	h=Date:To:From:Subject:Message-Id; b=WWPSauImzfqJgd/WoPYmxGVNoeAj3XBZSRXnWzMqmQfgcjr3QixdlEdhB863pYeebvgU4ZPoqmC3zWEI8HYEXrOLqm7v4mg6Q9oy7vXRDXWokqYA+XXhdhULGiT8aarcBYSur71IUrTkP77+Tu/2YafT6OJvrH0EIG68enV9y7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Emjhe1pX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Emjhe1pX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930D1C116B1;
	Tue,  2 Jul 2024 02:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719886013;
	bh=y5wr6/9IxwlyDLaRmFqeQVgqfu5tw/FdZ/ZZFcAaqtg=;
	h=Date:To:From:Subject:From;
	b=Emjhe1pXYa8rSWMZBif5eZ2tTNRWc+znT2w5YBszpu3h65ero5Gt9bhdYXbeWvMju
	 5TWfm7JSfBEcBUw4VCGtx/TaVaaEyw2O+fBnwQ3F+Q7n/p8YAqMai6g7XZYPjElnej
	 3JqHiQBoOhpIBfNn29K0oH+bH9u55ey8Ej4gUltY=
Date: Mon, 01 Jul 2024 19:06:53 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-index-add-links-to-admin-guide-doc.patch added to mm-unstable branch
Message-Id: <20240702020653.930D1C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/index: add links to admin-guide doc
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-index-add-links-to-admin-guide-doc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-index-add-links-to-admin-guide-doc.patch

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
Subject: Docs/mm/damon/index: add links to admin-guide doc
Date: Mon, 1 Jul 2024 12:27:06 -0700

Readers of DAMON subsystem documents index would want to further learn how
they can use DAMON from the user-space.  Add the link to the admin guide.

Link: https://lkml.kernel.org/r/20240701192706.51415-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/index.rst |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/Documentation/mm/damon/index.rst~docs-mm-damon-index-add-links-to-admin-guide-doc
+++ a/Documentation/mm/damon/index.rst
@@ -16,16 +16,16 @@ monitoring :ref:`mechanisms <damon_desig
    of the size of target workloads).
 
 Using this framework, therefore, the kernel can operate system in an
-access-aware fashion.  Because the features are also exposed to the user space,
-users who have special information about their workloads can write personalized
-applications for better understanding and optimizations of their workloads and
-systems.
+access-aware fashion.  Because the features are also exposed to the :doc:`user
+space </admin-guide/mm/damon/index>`, users who have special information about
+their workloads can write personalized applications for better understanding
+and optimizations of their workloads and systems.
 
 For easier development of such systems, DAMON provides a feature called
 :ref:`DAMOS <damon_design_damos>` (DAMon-based Operation Schemes) in addition
-to the monitoring.  Using the feature, DAMON users in both kernel and user
-spaces can do access-aware system operations with no code but simple
-configurations.
+to the monitoring.  Using the feature, DAMON users in both kernel and :doc:`user
+spaces </admin-guide/mm/damon/index>` can do access-aware system operations
+with no code but simple configurations.
 
 .. toctree::
    :maxdepth: 2
@@ -34,3 +34,6 @@ configurations.
    design
    api
    maintainer-profile
+
+To utilize and control DAMON from the user-space, please refer to the
+administration :doc:`guide </admin-guide/mm/damon/index>`.
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

