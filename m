Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232AAEEA6
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 01:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747099096; cv=none; b=T3HAZ09coVXrDwry5cqHbXGgpWI2+fswxajt+uLY83dey0uhYEZ0JpQDM9RWgK845VbHIfAjWIEiGBteTHzGBsLdp1kIpgItnau1As6OClW5BdK+UpOxZ+j9Mb6RCGSvPNhDTUJ2awPErxJwVIwpkx4eK/q3d1KyRdVlNFgjf+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747099096; c=relaxed/simple;
	bh=WmGQvtVyKfm/Kta4CMv8zRqlFqPx8aVcllrg7ukacsE=;
	h=Date:To:From:Subject:Message-Id; b=Ip1JMQy2YAKODKjmEpU1eFZkXFbf+BzBmAbl5b3X1fptz2F7WR2+vqWgXudo4JxDfbk0qezgqIQNuB7re/JX4YZNUUWVQitYJAdu8lXj0eMDqjsipW1IcIuyWQozyLc7vT1JNb6Au6Phg1TheAxK6xpsOuzH2a270AsJwB0iSGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nlW0fIL9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nlW0fIL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB55C4CEE7;
	Tue, 13 May 2025 01:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747099094;
	bh=WmGQvtVyKfm/Kta4CMv8zRqlFqPx8aVcllrg7ukacsE=;
	h=Date:To:From:Subject:From;
	b=nlW0fIL9gHo6dlXKkv5yIxpC53Dl++aP7EPPVjk7GAXXcRM3L8QTt7eJJ/o+S54ZP
	 sUkuRIusljEsq/Ti1dpA+WVFIQvlIsSOIoAh4TLTw27oz/gQOgFmDPQ3/ML/WiUjwM
	 52RhRi7iwru1KzHS8TTpR2F1QBtjBazotYEXz0bA=
Date: Mon, 12 May 2025 18:18:13 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-damon-update-titles-and-brief-introductions-to-explain-damos.patch added to mm-new branch
Message-Id: <20250513011814.7EB55C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/damon: update titles and brief introductions to explain DAMOS
has been added to the -mm mm-new branch.  Its filename is
     docs-damon-update-titles-and-brief-introductions-to-explain-damos.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-damon-update-titles-and-brief-introductions-to-explain-damos.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: Docs/damon: update titles and brief introductions to explain DAMOS
Date: Mon, 12 May 2025 17:27:15 -0700

DAMON was initially developed only for data access monitoring, and then
extended for not only access monitoring but also access-aware system
operations (DAMOS).  But the documents have old titles and brief
introductions for only the monitoring part.  Update the titles and the
brief introductions to explain DAMOS part together.

Link: https://lkml.kernel.org/r/20250513002715.40126-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/index.rst |   11 +++++------
 Documentation/mm/damon/index.rst             |    6 +++---
 2 files changed, 8 insertions(+), 9 deletions(-)

--- a/Documentation/admin-guide/mm/damon/index.rst~docs-damon-update-titles-and-brief-introductions-to-explain-damos
+++ a/Documentation/admin-guide/mm/damon/index.rst
@@ -1,12 +1,11 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-==========================
-DAMON: Data Access MONitor
-==========================
+================================================================
+DAMON: Data Access MONitoring and Access-aware System Operations
+================================================================
 
-:doc:`DAMON </mm/damon/index>` allows light-weight data access monitoring.
-Using DAMON, users can analyze the memory access patterns of their systems and
-optimize those.
+:doc:`DAMON </mm/damon/index>` is a Linux kernel subsystem for efficient data
+access monitoring and access-aware system operations.
 
 .. toctree::
    :maxdepth: 2
--- a/Documentation/mm/damon/index.rst~docs-damon-update-titles-and-brief-introductions-to-explain-damos
+++ a/Documentation/mm/damon/index.rst
@@ -1,8 +1,8 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-==========================
-DAMON: Data Access MONitor
-==========================
+================================================================
+DAMON: Data Access MONitoring and Access-aware System Operations
+================================================================
 
 DAMON is a Linux kernel subsystem that provides a framework for data access
 monitoring and the monitoring results based system operations.  The core
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damos-quota-goal-metrics-for-memory-node-utilization.patch
mm-damon-sysfs-schemes-implement-file-for-quota-goal-nid-parameter.patch
mm-damon-sysfs-schemes-connect-damos_quota_goal-nid-with-core-layer.patch
docs-mm-damon-design-document-node_mem_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-nid-file.patch
docs-abi-damon-document-nid-file.patch
samples-damon-implement-a-damon-module-for-memory-tiering.patch
samples-damon-implement-a-damon-module-for-memory-tiering-fix.patch
mm-damon-core-warn-and-fix-nr_accesses-corruption.patch
mm-damon-sysfs-schemes-fix-wrong-comment-on-damons_sysfs_quota_goal_metric_strs.patch
mm-damon-paddr-remove-unused-variable-folio_list-in-damon_pa_stat.patch
mm-damon-tests-core-kunit-add-a-test-for-damos_set_filters_default_reject.patch
selftests-damon-_damon_sysfs-read-tried-regions-directories-in-order.patch
docs-damon-update-titles-and-brief-introductions-to-explain-damos.patch

