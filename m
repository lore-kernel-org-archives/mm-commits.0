Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4803D330B
	for <mm-commits@vger.kernel.org>; Fri, 20 Mar 2026 17:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774029130; cv=none; b=XOIa8tjOG+ygDvoELrDSHHQEA3ss76CTHbQ0A4j1ozHIBARxsLVQt9N1KhN+Jhkn+zVHZRbl4vHnpuAewpnM0eZANAZz4gkQoJmVxrlSxppPrnf2Dfd2T8xMtv5ZgMYW1Hcb7mxHlMOqo00JTwRLiK3yAoZDsrY3x/LlSYC2XgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774029130; c=relaxed/simple;
	bh=zThHW5mmPIsZ9lXOQAhCV/6qibAEmpNBga5lk3OxSYU=;
	h=Date:To:From:Subject:Message-Id; b=qwP2mreOI2s1ZFfkNnaItjXiJS77SrrV0tG7d3vY+UZvjnrFsUYJATX7ztw/9UbVr9VoA8131pijFIrCzr9d2OnLPrbK3Pyk4j7w6Vv0LkRKB9E9xV0pAonPvxbrE9B7jltT+r+9zmKzQZi6Xq/yzsy4sNmuc2qmR3DYlOaQ+Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wtW1fj4y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wtW1fj4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C339C4CEF7;
	Fri, 20 Mar 2026 17:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774029129;
	bh=zThHW5mmPIsZ9lXOQAhCV/6qibAEmpNBga5lk3OxSYU=;
	h=Date:To:From:Subject:From;
	b=wtW1fj4yaaKNuVEE4xkPUWctJoPeDJQNY6n1BEmSD40ryO7Km+h18HiNCsp/+GtoR
	 L4FevBVT61WtkzNNC4R1JasJ0SfDeapGxiiPyptSUCyPHuA8VfU0G398E5odhNI8m2
	 y5WB1Rq16Y2tKeLD6g1G9aVeYycdW9hIO6CO/OIg=
Date: Fri, 20 Mar 2026 10:52:09 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,aethernet65535@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-document-min_nr_regions-constraint-and-rationale.patch added to mm-new branch
Message-Id: <20260320175209.8C339C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon: document min_nr_regions constraint and rationale
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-document-min_nr_regions-constraint-and-rationale.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-document-min_nr_regions-constraint-and-rationale.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Liew Rui Yan <aethernet65535@gmail.com>
Subject: Docs/mm/damon: document min_nr_regions constraint and rationale
Date: Fri, 20 Mar 2026 13:24:28 +0800

The current DAMON implementation requires 'min_nr_regions' to be at least
3.  However, this constraint is not explicitly documented in the
admin-guide documents, nor is its design rationale explained in the design
document.

Add a section in design.rst to explain the rationale: the virtual address
space monitoring design needs to handle at least three regions to
accommodate two large unmapped areas.  While this is specific to 'vaddr',
DAMON currently enforces it across all operation sets for consistency.

Also update reclaim.rst and lru_sort.rst by adding cross-references to
this constraint within their respective 'min_nr_regions' parameter
description sections, ensuring users are aware of the lower bound.

This change is motivated from a recent discussion [1].

Link: https://lkml.kernel.org/r/20260320052428.213230-1-aethernet65535@gmail.com
Link: https://lore.kernel.org/damon/20260319151528.86490-1-sj@kernel.org/T/#t [1]
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/lru_sort.rst |    4 ++++
 Documentation/admin-guide/mm/damon/reclaim.rst  |    4 ++++
 Documentation/mm/damon/design.rst               |    7 +++++++
 3 files changed, 15 insertions(+)

--- a/Documentation/admin-guide/mm/damon/lru_sort.rst~docs-mm-damon-document-min_nr_regions-constraint-and-rationale
+++ a/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -221,6 +221,10 @@ But, setting this too high could result
 Please refer to the DAMON documentation (:doc:`usage`) for more detail.  10 by
 default.
 
+Note that this must be 3 or higher. Please refer to the :ref:`Monitoring
+<damon_design_monitoring>` section of the design document for the rationale
+behind this lower bound.
+
 max_nr_regions
 --------------
 
--- a/Documentation/admin-guide/mm/damon/reclaim.rst~docs-mm-damon-document-min_nr_regions-constraint-and-rationale
+++ a/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -204,6 +204,10 @@ monitoring.  This can be used to set low
 But, setting this too high could result in increased monitoring overhead.
 Please refer to the DAMON documentation (:doc:`usage`) for more detail.
 
+Note that this must be 3 or higher. Please refer to the :ref:`Monitoring
+<damon_design_monitoring>` section of the design document for the rationale
+behind this lower bound.
+
 max_nr_regions
 --------------
 
--- a/Documentation/mm/damon/design.rst~docs-mm-damon-document-min_nr_regions-constraint-and-rationale
+++ a/Documentation/mm/damon/design.rst
@@ -167,6 +167,13 @@ monitoring attributes, ``sampling interv
 ``update interval``, ``minimum number of regions``, and ``maximum number of
 regions``.
 
+Note that ``minimum number of regions`` must be 3 or higher. This is because the
+virtual address space monitoring is designed to handle at least three regions to
+accommodate two large unmapped areas commonly found in normal virtual address
+spaces. While this restriction might not be strictly necessary for other
+operation sets like ``paddr``, it is currently enforced across all DAMON
+operations for consistency.
+
 To know how user-space can set the attributes via :ref:`DAMON sysfs interface
 <sysfs_interface>`, refer to :ref:`monitoring_attrs <sysfs_monitoring_attrs>`
 part of the documentation.
_

Patches currently in -mm which might be from aethernet65535@gmail.com are

docs-mm-damon-document-exclusivity-of-special-purpose-modules.patch
docs-mm-damon-document-min_nr_regions-constraint-and-rationale.patch

