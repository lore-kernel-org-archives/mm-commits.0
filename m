Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF52243334
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837158; cv=none; b=MJ+yIjGOvgIJxOf6jiThT8T17XE5S53INw1fTeLpWBorRE+WTN0DmjvyAR4wstsXSZumPRUOjFAG+ciSFA2aY/X41lMbYqYgCf4WzrSBjI5NzfoU1B3PMeB3lVWbt+bzcoS6k9tf6sW/HyCNQ1SfFo/14fNRNZUhmFMM8PobyWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837158; c=relaxed/simple;
	bh=Ddyvi0mPxsJQQZHex5ujyQ6HWvVX+/cSvey0Tm/fLS8=;
	h=Date:To:From:Subject:Message-Id; b=OJkIFQdjdq3nWWkDi6T7x6iNLtlE71yLqR63TYQh3RPtbsDQh20bGMeMvWG0AAEFOg9NQKpRYeAKXRbEEt1cS0JE5bnrAwB//inIzdJ1+sH3fZX5NN58U2mbVi0xziBG/kv4QMyx/rHKVNEwLPCijnUA9hIpf74zf2/5xYCw8aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QU9S/h8u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QU9S/h8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F18C4CEDF;
	Tue, 14 Jan 2025 06:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837158;
	bh=Ddyvi0mPxsJQQZHex5ujyQ6HWvVX+/cSvey0Tm/fLS8=;
	h=Date:To:From:Subject:From;
	b=QU9S/h8uR8dEDxK92cF6t9kdj19WIiuMqSl36+qhTWnQmVE6JUh+58fYUqEhIgp18
	 QeTt1wZujb4U1S4voT67h7l7hJTiFcX388iGaaEC1eDvulR/rU6AjdpRiJPkyuAfan
	 AMrHTMeuY9btLjhd+lggdT23eMtAO536o5sbqrtc=
Date: Mon, 13 Jan 2025 22:45:57 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-add-statistics-section.patch removed from -mm tree
Message-Id: <20250114064557.E5F18C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: add 'statistics' section
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-add-statistics-section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: add 'statistics' section
Date: Mon, 6 Jan 2025 11:33:47 -0800

DAMOS stats are important feature for tuning of DAMOS-based access-aware
system operation, and efficient access pattern monitoring.  But not well
documented on the design document.  Add a section on the document.

Link: https://lkml.kernel.org/r/20250106193401.109161-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   38 ++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-add-statistics-section
+++ a/Documentation/mm/damon/design.rst
@@ -539,6 +539,44 @@ To know how user-space can set the water
 <sysfs_interface>`, refer to :ref:`filters <sysfs_filters>` part of the
 documentation.
 
+Statistics
+~~~~~~~~~~
+
+The statistics of DAMOS behaviors that designed to help monitoring, tuning and
+debugging of DAMOS.
+
+DAMOS accounts below statistics for each scheme, from the beginning of the
+scheme's execution.
+
+- ``nr_tried``: Total number of regions that the scheme is tried to be applied.
+- ``sz_trtied``: Total size of regions that the scheme is tried to be applied.
+- ``nr_applied``: Total number of regions that the scheme is applied.
+- ``sz_applied``: Total size of regions that the scheme is applied.
+- ``qt_exceeds``: Total number of times the quota of the scheme has exceeded.
+
+"A scheme is tried to be applied to a region" means DAMOS core logic determined
+the region is eligible to apply the scheme's :ref:`action
+<damon_design_damos_action>`.  The :ref:`access pattern
+<damon_design_damos_access_pattern>`, :ref:`quotas
+<damon_design_damos_quotas>`, :ref:`watermarks
+<damon_design_damos_watermarks>`, and :ref:`filters
+<damon_design_damos_filters>` that handled on core logic could affect this.
+The core logic will only ask the underlying :ref:`operation set
+<damon_operations_set>` to do apply the action to the region, so whether the
+action is really applied or not is unclear.  That's why it is called "tried".
+
+"A scheme is applied to a region" means the :ref:`operation set
+<damon_operations_set>` has applied the action to at least a part of the
+region.  The :ref:`filters <damon_design_damos_filters>` that handled by the
+operation set, and the types of the :ref:`action <damon_design_damos_action>`
+and the pages of the region can affect this.  For example, if a filter is set
+to exclude anonymous pages and the region has only anonymous pages, or if the
+action is ``pageout`` while all pages of the region are unreclaimable, applying
+the action to the region will fail.
+
+To know how user-space can read the stats via :ref:`DAMON sysfs interface
+<sysfs_interface>`, refer to :ref:s`stats <sysfs_stats>` part of the
+documentation.
 
 Regions Walking
 ~~~~~~~~~~~~~~~
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

