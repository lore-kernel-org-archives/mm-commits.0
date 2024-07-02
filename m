Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13BB3C38
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 02:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719886012; cv=none; b=SyVD7Z0TJXnOwT3Pt+2uCrZX2vI89yKQwrJVZH0ybIbGlmvV8+JVJMDet1SreLHLMLW3ciIIF83pMd8ePTCsupJjLwBP+TdV9mi6gKCMUxJ0k82syjrOvpUqtC48OJtbMDcyhndppSkQjwqir96SaHYoAYTSUyY+7VJJCTNKyE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719886012; c=relaxed/simple;
	bh=QKC7xsHzWNCXZis+oGmjrDbA/205nHDg/jXbNCZDUo0=;
	h=Date:To:From:Subject:Message-Id; b=DkIq0Ufuo30FHaiU2qDxMHYLK84EBFfZ+NjxkogmIgXfw2nLai9sRvdlG3hUG2KWYbiRxbkBgSdvHQcPam0P0WDq+ww6JqA5EuLEyhZt7E9brb0xXsGk1s6OyUiu6uPY/8C3CUCcqHMEhObbiiVMKPKzNdZJQlsq9Qdm9DeMkNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qu3i/EvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qu3i/EvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794F2C116B1;
	Tue,  2 Jul 2024 02:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719886011;
	bh=QKC7xsHzWNCXZis+oGmjrDbA/205nHDg/jXbNCZDUo0=;
	h=Date:To:From:Subject:From;
	b=Qu3i/EvRbN1o1SRgMYhxuTvLlCS8EJ39yaCNYNDkwn0NxvVZzV/aqq8GRzDlIHWXK
	 iqoFdUoAsSc6WvbfRYhebLqq9Db/oA5eg/aeHHy208aGBaKzMF/9Ns7mGOTAlstNW9
	 wCCkIiUvxyJ9VrH2COy5LI+aU6ZkmClzJAShC3tI=
Date: Mon, 01 Jul 2024 19:06:50 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-index-add-links-to-design.patch added to mm-unstable branch
Message-Id: <20240702020651.794F2C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/index: add links to design
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-index-add-links-to-design.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-index-add-links-to-design.patch

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
Subject: Docs/mm/damon/index: add links to design
Date: Mon, 1 Jul 2024 12:27:05 -0700

DAMON subsystem documents index page provides a short intro of DAMON core
concepts.  Add links to sections of the design document to let users
easily browse to the details.

Link: https://lkml.kernel.org/r/20240701192706.51415-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    1 +
 Documentation/mm/damon/index.rst  |   11 ++++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-index-add-links-to-design
+++ a/Documentation/mm/damon/design.rst
@@ -141,6 +141,7 @@ as Idle page tracking does.
 Core Logics
 ===========
 
+.. _damon_design_monitoring:
 
 Monitoring
 ----------
--- a/Documentation/mm/damon/index.rst~docs-mm-damon-index-add-links-to-design
+++ a/Documentation/mm/damon/index.rst
@@ -6,7 +6,7 @@ DAMON: Data Access MONitor
 
 DAMON is a Linux kernel subsystem that provides a framework for data access
 monitoring and the monitoring results based system operations.  The core
-monitoring mechanisms of DAMON (refer to :doc:`design` for the detail) make it
+monitoring :ref:`mechanisms <damon_design_monitoring>` of DAMON make it
 
  - *accurate* (the monitoring output is useful enough for DRAM level memory
    management; It might not appropriate for CPU Cache levels, though),
@@ -21,10 +21,11 @@ users who have special information about
 applications for better understanding and optimizations of their workloads and
 systems.
 
-For easier development of such systems, DAMON provides a feature called DAMOS
-(DAMon-based Operation Schemes) in addition to the monitoring.  Using the
-feature, DAMON users in both kernel and user spaces can do access-aware system
-operations with no code but simple configurations.
+For easier development of such systems, DAMON provides a feature called
+:ref:`DAMOS <damon_design_damos>` (DAMon-based Operation Schemes) in addition
+to the monitoring.  Using the feature, DAMON users in both kernel and user
+spaces can do access-aware system operations with no code but simple
+configurations.
 
 .. toctree::
    :maxdepth: 2
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

