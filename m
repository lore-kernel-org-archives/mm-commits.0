Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5983C38
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 02:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719886006; cv=none; b=RooKWZTGp4DeUq42w33Sa5n7p1hTNpHgXMCNyV0tQfYNzER5zJHfVmzK+rww8tPIgtqiJ9mQhibYLhUCNOUZzz7YyL9h2hbSm4geOWSVXHzQDyidL+Rn8Q6Zjq5+misdXzrgqlEZK45T34Yvk2QNdXnq+7JH4TvSTdFgxs3RGWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719886006; c=relaxed/simple;
	bh=WxjsufzQfflI7jHp2u4gh+gqCsjSNQ2HfUdb89w8VIs=;
	h=Date:To:From:Subject:Message-Id; b=WQ6uRUsPmio6EyAkb4yfMUHTgO1V/xQuXA+eTj2CPW3AlWJ6y55EdqqsiwsjHn9QovxDEPC6b7x0lKuGpB9q8uIYNgKj7Ph8BbUcA0QAk6u8JQBdblTSL4DDdiEQYTQtK4NMXS0qu8+Xgc0ITDIHbJDHosOvuQ2pcfSWsdemkyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=psw2HoZp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="psw2HoZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B16C116B1;
	Tue,  2 Jul 2024 02:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719886006;
	bh=WxjsufzQfflI7jHp2u4gh+gqCsjSNQ2HfUdb89w8VIs=;
	h=Date:To:From:Subject:From;
	b=psw2HoZprYTW3K63Y6FAq0zgeMn0Xyn06AH/NzFlPRZnD/ve1c4CMKyOZUkuGuDGQ
	 NX/aX33cUVDq95+cCDtODppp0wMywYVvsffj0VBKf1yScuR5YvJOmYj//jSRnQZV5e
	 Vr+DD4pWpuN5g4iX9lrMbT7hvf5zHUVWBVWg2ARE=
Date: Mon, 01 Jul 2024 19:06:45 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-move-configurable-operations-set-section-into-operations-set-layer-section.patch added to mm-unstable branch
Message-Id: <20240702020646.36B16C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: move 'Configurable Operations Set' section into 'Operations Set Layer' section
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-move-configurable-operations-set-section-into-operations-set-layer-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-move-configurable-operations-set-section-into-operations-set-layer-section.patch

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
Subject: Docs/mm/damon/design: move 'Configurable Operations Set' section into 'Operations Set Layer' section
Date: Mon, 1 Jul 2024 12:27:02 -0700

'Configurable Operations Set' section is for providing a description of
the pluggability of the operations set layer.  Just after that,
'Operations Set Layer' section, which is dedicated for the entire things
of the layer, follows.  The layout is odd, and some descriptions are
duplicated.  Move 'Configurable Operations Set' section into 'Operations
Set Layer' and re-write some of the detailed descriptions.

Link: https://lkml.kernel.org/r/20240701192706.51415-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   47 +++++++++++++---------------
 1 file changed, 22 insertions(+), 25 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-move-configurable-operations-set-section-into-operations-set-layer-section
+++ a/Documentation/mm/damon/design.rst
@@ -33,30 +33,6 @@ DAMON subsystem is configured with three
   layer.
 
 
-.. _damon_design_configurable_operations_set:
-
-Configurable Operations Set
----------------------------
-
-For data access monitoring and additional low level work, DAMON needs a set of
-implementations for specific operations that are dependent on and optimized for
-the given target address space.  On the other hand, the accuracy and overhead
-tradeoff mechanism, which is the core logic of DAMON, is in the pure logic
-space.  DAMON separates the two parts in different layers, namely DAMON
-Operations Set and DAMON Core Logics Layers, respectively.  It further defines
-the interface between the layers to allow various operations sets to be
-configured with the core logic.
-
-Due to this design, users can extend DAMON for any address space by configuring
-the core logic to use the appropriate operations set.  If any appropriate set
-is unavailable, users can implement one on their own.
-
-For example, physical memory, virtual memory, swap space, those for specific
-processes, NUMA nodes, files, and backing memory devices would be supportable.
-Also, if some architectures or devices supporting special optimized access
-check primitives, those will be easily configurable.
-
-
 Programmable Modules
 --------------------
 
@@ -72,11 +48,32 @@ used by the user space end users.
 Operations Set Layer
 ====================
 
-The monitoring operations are defined in two parts:
+.. _damon_design_configurable_operations_set:
+
+For data access monitoring and additional low level work, DAMON needs a set of
+implementations for specific operations that are dependent on and optimized for
+the given target address space.  For example, below two operations for access
+monitoring are address-space dependent.
 
 1. Identification of the monitoring target address range for the address space.
 2. Access check of specific address range in the target space.
 
+DAMON consolidates these implementations in a layer called DAMON Operations
+Set, and defines the interface between it and the upper layer.  The upper layer
+is dedicated for DAMON's core logics including the mechanism for control of the
+monitoring accruracy and the overhead.
+
+Hence, DAMON can easily be extended for any address space and/or available
+hardware features by configuring the core logic to use the appropriate
+operations set.  If there is no available operations set for a given purpose, a
+new operations set can be implemented following the interface between the
+layers.
+
+For example, physical memory, virtual memory, swap space, those for specific
+processes, NUMA nodes, files, and backing memory devices would be supportable.
+Also, if some architectures or devices support special optimized access check
+features, those will be easily configurable.
+
 DAMON currently provides below three operation sets.  Below two subsections
 describe how those work.
 
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

