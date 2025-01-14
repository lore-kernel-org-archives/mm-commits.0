Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C4C24633A
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837166; cv=none; b=K6WE1blRRWilVviV6BM6E01tMsopne/ZTQd+cy5+WUQBk5wiVTcld27chGZN4S6btCeUJuhrFEH3AKuPwzg1UfvKZaYe/CPRw0juKq7iNChLUhpVrWtvyUfEKOHmQCQDEH34w683cgB9Urqjl2c8hgCcGv+QCFP2lUhqLK9It0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837166; c=relaxed/simple;
	bh=iv891MGGJQwnB7/6/T0lgQbbnshDsJDcSJ/1lArKfxo=;
	h=Date:To:From:Subject:Message-Id; b=cldKldXxPh25Rqd2V70zwGfZon33hIU79cpYfEbT36YbWzcg9qi7UW5AFZcuY2GUNq7+UOMLTm3raIehkObhrh/99WZo7VxPmKHN5KQgJ/sKXtvxslR3Z/RD8yiME8UY9YuebW6RLGMEAsaUtiK2PoN2bIPUHFxkIz7vc6blEt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AcBJzwFV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AcBJzwFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54335C4CEDD;
	Tue, 14 Jan 2025 06:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837165;
	bh=iv891MGGJQwnB7/6/T0lgQbbnshDsJDcSJ/1lArKfxo=;
	h=Date:To:From:Subject:From;
	b=AcBJzwFVYMmsaOL7Pupv7lcl2UXLcrekFQFxy0cBp5cDnjkO8gME53Cbpsygrs4X4
	 DCZWaupXzVS7yf5UDi6456a3HUGl6tJy5tTGT5swLPjFsmCbWDGnrPuGFhK0LuE9/P
	 E+sJ5Aua76Fbx6CYWnkgtJb9mFB6BA56lnk09HM0=
Date: Mon, 13 Jan 2025 22:46:04 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-document-sz_ops_filter_passed.patch removed from -mm tree
Message-Id: <20250114064605.54335C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: document sz_ops_filter_passed
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-document-sz_ops_filter_passed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: document sz_ops_filter_passed
Date: Mon, 6 Jan 2025 11:33:54 -0800

Document the new per-scheme accumulated stat for total bytes that passed
the operations set layer-handled DAMOS filters on the design document.

Link: https://lkml.kernel.org/r/20250106193401.109161-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-sz_ops_filter_passed
+++ a/Documentation/mm/damon/design.rst
@@ -552,6 +552,8 @@ scheme's execution.
 
 - ``nr_tried``: Total number of regions that the scheme is tried to be applied.
 - ``sz_trtied``: Total size of regions that the scheme is tried to be applied.
+- ``sz_ops_filter_passed``: Total bytes that passed operations set
+  layer-handled DAMOS filters.
 - ``nr_applied``: Total number of regions that the scheme is applied.
 - ``sz_applied``: Total size of regions that the scheme is applied.
 - ``qt_exceeds``: Total number of times the quota of the scheme has exceeded.
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

