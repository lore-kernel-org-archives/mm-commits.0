Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B999623ED56
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837153; cv=none; b=QnSDXkJHtGNJH49JgLuol4SFugZXS3W7Pr4qzxCVkhQSLPqWP9eyuPhc8V1hGMDsUOxpjEkWFGQ1ZmWPgKTXZtjsILjFL1cKspmVfrHz1msgB7Y1iKFvVo7U0Bh5gYzJLCNyS7KrsZl94E1eGl1GWGhUZmtSN/6FBZVNbAJ6g34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837153; c=relaxed/simple;
	bh=J5vb+gaDyo5xph1+2Eh/TW5QMK1pjJR0lKJfTW0Lyh4=;
	h=Date:To:From:Subject:Message-Id; b=LBYD3u4gFwjjGBPh0+q3ApH2r+qARjpQ4Lfh1OjTUWYj61V2p11VZu+M4x9TWHfNko+B+KcH8rhaikQidyARojYn0CR6AJ9h8pBrL8JAc7RjkdeEn73ezbkBrVpZQytyiCNqbfHhe+FtNuZVJzFNleOXzHsMSNKDiGXrJf7Pztg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0LCVezZS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0LCVezZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA19C4CEDD;
	Tue, 14 Jan 2025 06:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837153;
	bh=J5vb+gaDyo5xph1+2Eh/TW5QMK1pjJR0lKJfTW0Lyh4=;
	h=Date:To:From:Subject:From;
	b=0LCVezZSTWYSnJ6vrxgMmM2jN1qdIwID7fkiZjYxTepC/Va8nhyMCJ7AVXlThZzRQ
	 TEjRBECpysLjRaNjOnbCl9FNZEmy7KsqxXhnM2Zn4ZDpS3xQVz/BbvUv2hGspUzNlK
	 vkHlkwXmcwN+1G6BtLqYuS4XqHK7CY+cqgU/ZlGA=
Date: Mon, 13 Jan 2025 22:45:53 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-document-damos-regions-walking.patch removed from -mm tree
Message-Id: <20250114064553.8DA19C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: document DAMOS regions walking
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-document-damos-regions-walking.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: document DAMOS regions walking
Date: Fri, 3 Jan 2025 09:43:58 -0800

DAMOS' regions walking is a feature for efficiently retrieving monitoring
results or DAMOS-internal behavior.  It can be useful for multiple
purposes including investigations and tuning.  Add a section for it on the
design document.

Link: https://lkml.kernel.org/r/20250103174400.54890-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-damos-regions-walking
+++ a/Documentation/mm/damon/design.rst
@@ -540,6 +540,17 @@ To know how user-space can set the water
 documentation.
 
 
+Regions Walking
+~~~~~~~~~~~~~~~
+
+DAMOS feature allowing users access each region that a DAMOS action has just
+applied.  Using this feature, DAMON :ref:`API <damon_design_api>` allows users
+access full properties of the regions including the access monitoring results.
+:ref:`DAMON sysfs interface <sysfs_interface>` also allows users read the data
+via special :ref:`files <sysfs_schemes_tried_regions>`.
+
+.. _damon_design_api:
+
 Application Programming Interface
 ---------------------------------
 
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

