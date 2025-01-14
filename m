Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173E923353A
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837172; cv=none; b=Vx4m2FJQlzWY34+EsnMcd5p5pr2+hu7lR6xEHraU+5DqaX10iJT9f+f5uzSR5mrvl+FYqEs7hLbnTNieKLAdhvBcpq1+Z2m5SMOa6YWm39tUdB550y2r7oOCmlzWQi9SBQLjkhbxRqJZfyQrD/EFb7zdy61qar+ngCcoYX6Wtik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837172; c=relaxed/simple;
	bh=AwNPT5yuGLs0IxWftDVXh95Gk0DQCHyyreXBypx8ooE=;
	h=Date:To:From:Subject:Message-Id; b=glEDVs3Rpauq0ghrqM/tLyR1nT9m+uMtLXXdIcCDqgJ8uOPeMu6yCZ9sTmJGQfN6j5wi7T6GU5DH5UID1th97jKLvtisAGGq/ueAIw+Phb7e5G3ylByU768HeBkNGFThjpa8Dr6TvK+YzR7Y0wwoR66S39KgCcgxsA04jNtIvtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jZiMbApy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jZiMbApy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDCDC4CEDD;
	Tue, 14 Jan 2025 06:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837171;
	bh=AwNPT5yuGLs0IxWftDVXh95Gk0DQCHyyreXBypx8ooE=;
	h=Date:To:From:Subject:From;
	b=jZiMbApyK/8aH7nepTBiy8riEodnJU2WokOsuVnNhg+0DtrEgaF8haj6t2f4OQY/A
	 6WBFhnBwReMBc3nliFL4cSQczsoo/pWkWJ0r7nfZwE5sISb6v/2TlHSjlUIuzFlgEb
	 It0RIP5uiebRo2VWFAgqqCve/eZFGQkw9tlWfpKQ=
Date: Mon, 13 Jan 2025 22:46:11 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-document-sz_filtered_out-of-scheme-tried-region-directories.patch removed from -mm tree
Message-Id: <20250114064611.9BDCDC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document sz_filtered_out of scheme tried region directories
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-document-sz_filtered_out-of-scheme-tried-region-directories.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: document sz_filtered_out of scheme tried region directories
Date: Mon, 6 Jan 2025 11:34:00 -0800

Document the newly added DAMON sysfs interface file for per-scheme-tried
region's bytes that passed the operations set handling DAMOS filters.

Link: https://lkml.kernel.org/r/20250106193401.109161-16-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-sz_filtered_out-of-scheme-tried-region-directories
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -92,7 +92,7 @@ comma (",").
     │ │ │ │ │ │ │ │ 0/type,matching,memcg_id
     │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds
     │ │ │ │ │ │ │ :ref:`tried_regions <sysfs_schemes_tried_regions>`/total_bytes
-    │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age
+    │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age,sz_filter_passed
     │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ ...
     │ │ │ │ ...
@@ -500,10 +500,10 @@ set the ``access pattern`` as their inte
 tried_regions/<N>/
 ------------------
 
-In each region directory, you will find four files (``start``, ``end``,
-``nr_accesses``, and ``age``).  Reading the files will show the start and end
-addresses, ``nr_accesses``, and ``age`` of the region that corresponding
-DAMON-based operation scheme ``action`` has tried to be applied.
+In each region directory, you will find five files (``start``, ``end``,
+``nr_accesses``, ``age``, and ``sz_filter_passed``).  Reading the files will
+show the properties of the region that corresponding DAMON-based operation
+scheme ``action`` has tried to be applied.
 
 Example
 ~~~~~~~
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

