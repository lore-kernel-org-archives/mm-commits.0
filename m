Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE3424332A
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837159; cv=none; b=F5fBkmzsiML9rkIVbjyCysawFK7Sy6mSub6bqTpKAPCp5HjwzyESS4KqTm8AbsCDLxkGY3twYSH0QxnUr5eSHD2VpD3BaEbId3UXxSB++ulGygaLrr42Q30hVO1Pd6qNSiwzUlqReD9AagJnlyGMiJa+XjunjiVxOGzodnvHGAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837159; c=relaxed/simple;
	bh=IBaYTf3ZOvWVg6KYIN48jE57N9Xhuwg1mG+5laX9EOw=;
	h=Date:To:From:Subject:Message-Id; b=FX+WztzJPrD7fSvvv3p9u9TltJgK0fVgTt/yw2XUdoTZXE/tGL2P43Lj7iBI0A84psPAyKUIOXqPOwpkQ+y6CF497a165mKd7uSYjMvVCGov1DGvhD2+JvjkPHAaKzNQjhlMb+0g27njvCPam2Wsen2VottMTu5dRejHBLDvRbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dhR2WozT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dhR2WozT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CE5C4CEDF;
	Tue, 14 Jan 2025 06:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837159;
	bh=IBaYTf3ZOvWVg6KYIN48jE57N9Xhuwg1mG+5laX9EOw=;
	h=Date:To:From:Subject:From;
	b=dhR2WozTvyGagSY6Ek1QRD0hJdvN/olVuWrkD/iJr5p41YpYeIotvBFBhGqW0Hywi
	 jaW49KRfdv9kxTd6gzFvjDgq9DF9fmgVerkisfLutBRPLrGyzuTIzCwFGd/h3DGTL1
	 SHJmXm+5G1BJe6D7ANqCm3Q+7iQ22psV86TnGfwg=
Date: Mon, 13 Jan 2025 22:45:58 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-link-damos-stat-design-doc.patch removed from -mm tree
Message-Id: <20250114064559.03CE5C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: link damos stat design doc
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-link-damos-stat-design-doc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: link damos stat design doc
Date: Mon, 6 Jan 2025 11:33:48 -0800

DAMON sysfs usage document focuses on usage, rather than the detail of the
stat metric itself.  Add a link to the design document on DAMOS stat usage
section.

Link: https://lkml.kernel.org/r/20250106193401.109161-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    3 ++-
 Documentation/mm/damon/design.rst            |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-link-damos-stat-design-doc
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -457,7 +457,8 @@ schemes/<N>/stats/
 DAMON counts the total number and bytes of regions that each scheme is tried to
 be applied, the two numbers for the regions that each scheme is successfully
 applied, and the total number of the quota limit exceeds.  This statistics can
-be used for online analysis or tuning of the schemes.
+be used for online analysis or tuning of the schemes.  Refer to :ref:`design
+doc <damon_design_damos_stat>` for more details about the stats.
 
 The statistics can be retrieved by reading the files under ``stats`` directory
 (``nr_tried``, ``sz_tried``, ``nr_applied``, ``sz_applied``, and
--- a/Documentation/mm/damon/design.rst~docs-admin-guide-mm-damon-usage-link-damos-stat-design-doc
+++ a/Documentation/mm/damon/design.rst
@@ -539,6 +539,8 @@ To know how user-space can set the water
 <sysfs_interface>`, refer to :ref:`filters <sysfs_filters>` part of the
 documentation.
 
+.. _damon_design_damos_stat:
+
 Statistics
 ~~~~~~~~~~
 
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

