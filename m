Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909441C6889
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274559; cv=none; b=QYAXJgvp2Y9+f+N315bpELizTCV227VmiLGGdiF7QHjBtNqlqxbXOPfBbWEOfTyaTmWPFBqsaLQ5UofOkFyEdqGKrVhPewCnTcYNeBJzFFcq0bNwV7PZPICqxkUXfn93w+svar/vhtfCwjkJAnPPMdYh6+VdkdIEwN/efbXOpIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274559; c=relaxed/simple;
	bh=eF8zxacwuv311tNQ1XR4n55ueTOH0MqiRQPF1hrFx30=;
	h=Date:To:From:Subject:Message-Id; b=VZ4d/6DeigKofpXjc1y+vXOVSy17ge2TSEfo+WO3Q1oJLZvEH48YNKLzDSp10YeDu/nXQD5XqYR7M9+ffwwYqmgIEQ0/nRBi8QMZigolL+OBkbkEiAG47iSmPt37uSwY7x/0qTIwgTbKTsqY3zoNvkrQDiaO9kdIf46aYwYOgvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tc/Kzk7C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tc/Kzk7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655CEC4CEEE;
	Tue, 18 Mar 2025 05:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274559;
	bh=eF8zxacwuv311tNQ1XR4n55ueTOH0MqiRQPF1hrFx30=;
	h=Date:To:From:Subject:From;
	b=Tc/Kzk7CVTXaxpIUQFq60Pp94GUHqJ3DWlkzfqWczgh9k5Pp5Ut9zKmm6FhaK/RwE
	 i73mxFjQ30XSo4PIPrIVYmhDBEw/rjduhj250EQyiKbMnn3XUDXqHsiBPXbs82RAYS
	 ROsuNWevdeKXWVx6UVn8a0+cHaONfw4GhzRS9mj4=
Date: Mon, 17 Mar 2025 22:09:18 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-commit-filters-in-coreops_filters-directories.patch removed from -mm tree
Message-Id: <20250318050919.655CEC4CEEE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: commit filters in {core,ops}_filters directories
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-commit-filters-in-coreops_filters-directories.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: commit filters in {core,ops}_filters directories
Date: Wed, 5 Mar 2025 14:27:28 -0800

Connect user inputs for files under core_filters and ops_filters with
DAMON, so that the files can really function.  Becasuse {core,ops}_filters
are easier to be managed in terms of expecting filters evaluation order,
add filters in {core,ops}_filters before 'filters' directory.

Link: https://lkml.kernel.org/r/20250305222733.59089-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-commit-filters-in-coreops_filters-directories
+++ a/mm/damon/sysfs-schemes.c
@@ -2143,8 +2143,6 @@ static struct damos *damon_sysfs_mk_sche
 	struct damon_sysfs_quotas *sysfs_quotas = sysfs_scheme->quotas;
 	struct damon_sysfs_weights *sysfs_weights = sysfs_quotas->weights;
 	struct damon_sysfs_watermarks *sysfs_wmarks = sysfs_scheme->watermarks;
-	struct damon_sysfs_scheme_filters *sysfs_filters =
-		sysfs_scheme->filters;
 	struct damos *scheme;
 	int err;
 
@@ -2184,7 +2182,17 @@ static struct damos *damon_sysfs_mk_sche
 		return NULL;
 	}
 
-	err = damon_sysfs_add_scheme_filters(scheme, sysfs_filters);
+	err = damon_sysfs_add_scheme_filters(scheme, sysfs_scheme->core_filters);
+	if (err) {
+		damon_destroy_scheme(scheme);
+		return NULL;
+	}
+	err = damon_sysfs_add_scheme_filters(scheme, sysfs_scheme->ops_filters);
+	if (err) {
+		damon_destroy_scheme(scheme);
+		return NULL;
+	}
+	err = damon_sysfs_add_scheme_filters(scheme, sysfs_scheme->filters);
 	if (err) {
 		damon_destroy_scheme(scheme);
 		return NULL;
_

Patches currently in -mm which might be from sj@kernel.org are


