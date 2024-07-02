Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA2C3C38
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 02:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719886005; cv=none; b=s14zA30OzOx+by283NNGccTT3s+x5Wlct2ulf4o1YcHVj/Kh360ePyHWmL2m/FctrJ5b2kAjCdy6hKnNp8AZBPgNsT12Zpm6eYmk8rXW1S8oOf+gXP/nrviphdLqaGkeHtgSfojANNPcR/l9e8FmZr/ms3mvrLKkoZC37TG1Bpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719886005; c=relaxed/simple;
	bh=2YkKBXr5qnH8FEqt78CqV1DWtD3r/i1A/djzLfTKe1k=;
	h=Date:To:From:Subject:Message-Id; b=kOCNVuSkSs7gssDbcBbKy5WQ1HEii9OEdbC13zjXySCW6X56ZG14QonWoQRYsww5PdFUTbSChuWNqYJZT2Bew/8SN2sITlHu8gU5uZsf3FPfyJ1sL7pczfVlqkIJN31jcs8Vw86e2PNuDkII+lX5yb0+6XhD5fuxO8dlxWxJER8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T0GyyFZS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T0GyyFZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BFDC116B1;
	Tue,  2 Jul 2024 02:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719886004;
	bh=2YkKBXr5qnH8FEqt78CqV1DWtD3r/i1A/djzLfTKe1k=;
	h=Date:To:From:Subject:From;
	b=T0GyyFZSnDi20dk1kzm0wekTb+RTImiAryO751dXigxxNMrBatIN9jMTWktsenv3V
	 KfZKCS01j4BMvvGHyKiyPt3yyLlQdOwTtDbi1jNzrNkS90eDPFgaTnftwaGIWSLwn8
	 7D7EUN8hgFmTYDzoWdjy3q5G7rJqaT6m0YX6vDLE=
Date: Mon, 01 Jul 2024 19:06:43 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-add-links-from-overall-architecture-to-sections-of-details.patch added to mm-unstable branch
Message-Id: <20240702020644.53BFDC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: add links from overall architecture to sections of details
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-add-links-from-overall-architecture-to-sections-of-details.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-add-links-from-overall-architecture-to-sections-of-details.patch

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
Subject: Docs/mm/damon/design: add links from overall architecture to sections of details
Date: Mon, 1 Jul 2024 12:27:01 -0700

DAMON design document briefly explains the overall layers architecture
first, and then provides detailed explanations of each layer with
dedicated sections.  Letting readers go directly to the detailed sections
for specific layers could help easy browsing of the not-very-short
document.  Add links from the overall summary to the sections of details.

Link: https://lkml.kernel.org/r/20240701192706.51415-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-add-links-from-overall-architecture-to-sections-of-details
+++ a/Documentation/mm/damon/design.rst
@@ -22,13 +22,15 @@ Overall Architecture
 
 DAMON subsystem is configured with three layers including
 
-- Operations Set: Implements fundamental operations for DAMON that depends on
-  the given monitoring target address-space and available set of
-  software/hardware primitives,
-- Core: Implements core logics including monitoring overhead/accuracy control
-  and access-aware system operations on top of the operations set layer, and
-- Modules: Implements kernel modules for various purposes that provides
-  interfaces for the user space, on top of the core layer.
+- :ref:`Operations Set <damon_operations_set>`: Implements fundamental
+  operations for DAMON that depends on the given monitoring target
+  address-space and available set of software/hardware primitives,
+- :ref:`Core <damon_core_logic>`: Implements core logics including monitoring
+  overhead/accuracy control and access-aware system operations on top of the
+  operations set layer, and
+- :ref:`Modules <damon_modules>`: Implements kernel modules for various
+  purposes that provides interfaces for the user space, on top of the core
+  layer.
 
 
 .. _damon_design_configurable_operations_set:
@@ -140,6 +142,8 @@ conflict with the reclaim logic using ``
 as Idle page tracking does.
 
 
+.. _damon_core_logic:
+
 Core Logics
 ===========
 
@@ -512,6 +516,8 @@ interface, namely ``include/linux/damon.
 :doc:`document </mm/damon/api>` for details of the interface.
 
 
+.. _damon_modules:
+
 Modules
 =======
 
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

