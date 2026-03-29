Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9401D27AC28
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744951; cv=none; b=WZvvyw6uHcwT3gGiB+ObqM8CKoEbM1H0ro61aJq0+aD3gM48I158TkraW5dfRzrQd6If9fzcRcLu2vx/cS6eD6CSf6EgFH9oaUff4pis2RzfceJqOi9nZsycwdvWOmC79ThbJc9YIy/Uv769egRwgdiK0od7lHW5JxEDCRJTNVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744951; c=relaxed/simple;
	bh=K773nc7Px1O/sOHae3Bcfixfa7coXxGRUsv5eMFU0uY=;
	h=Date:To:From:Subject:Message-Id; b=WETb3G39XZSbjA4o+uhmLKVKHBCgF5IkUCsGy2jR/qU/3BdR6Gn+yyKdb9Orz0wfKcomSKA8tRkfEALrr9qScLFIfxkxS/Um+HLyrw5d9fB8fWjU9DgOgoNhmPVJZastEk8eSefvPNaroRChhaAhp5szisJwC+05Vy6aKNuYINY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=09rFRH7X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="09rFRH7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BEC7C4CEF7;
	Sun, 29 Mar 2026 00:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744951;
	bh=K773nc7Px1O/sOHae3Bcfixfa7coXxGRUsv5eMFU0uY=;
	h=Date:To:From:Subject:From;
	b=09rFRH7XB9NQHkFypOXMi4/1GM38ej/u+xSyQ/37ltlBr4451JA5B4FbabGc4uZpS
	 uJAmoUqSb5FI2TQ2FNm/rx1h0WX4C+AY2Zc6cV7jtz4wGrfzgiyoNItMXqg/jdyerG
	 7kdSBAbB+JDtUwBsoP13ylXw/bdkAZqFhVUiIqVE=
Date: Sat, 28 Mar 2026 17:42:30 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,aethernet65535@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-document-min_nr_regions-constraint-and-rationale.patch removed from -mm tree
Message-Id: <20260329004231.6BEC7C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon: document min_nr_regions constraint and rationale
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-document-min_nr_regions-constraint-and-rationale.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


