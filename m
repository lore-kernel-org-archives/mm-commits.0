Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB923B8BD9
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439027; cv=none; b=fknRdUERFeziP896gNRj7NegN4pctxTrngnK0xqatzt7ck0ir5tUXeSnarVyNh/ScqoLnYMN2yOtsXjG2daX9Dab2ktaJs95r44MejWuYi4G6IT0IxEePskxMZgSs4DuUNdMvIC0h0EVG9OnICvofNodJsAtXmibIRr7dkhyK5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439027; c=relaxed/simple;
	bh=dAMQbOzJ7wj+V7hs+wDz2rjsBQpTiufZsWfUXWg4ccU=;
	h=Date:To:From:Subject:Message-Id; b=iKf8mDriYy4SqLCzcExEyPFnBYXq2J3Gey7MH4apzB0nd25BdyMhl2SQ2dLeurFZgeGTAXFXRPxTxx1oTYMxZCfEKc7O1gWwQbYCk2EdHcGOKRYYQfzCTZNB4Duviavl05Pvk8wbKFgGD4+/X2UVeV6VePmBBDWtmX6JlLg7SOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bSiF62xM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bSiF62xM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0E51F00898;
	Tue,  2 Jun 2026 22:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439026;
	bh=GFj54nFgEon3AhT1kJwIvehQJqre5IfB/Tx+/sYGEBQ=;
	h=Date:To:From:Subject;
	b=bSiF62xM1EkCGicUz6CS2qjY2cJHMjfI2tmvNoy7ty+kGs+GK18CBcdcPt6wWLo3f
	 Bqk79eUaxKk6ekDA81GY4KjoyGJgruWps8C+2c7cZlAPInq2lfMh5zk09di7u0fkD5
	 Vz4z24y7yWfno+PdFXVxeZoLFxAR5M0yKOlU8Sj0=
Date: Tue, 02 Jun 2026 15:23:46 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,agarwal.vineet2006@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-fix-double-increment-of-nr_regions.patch removed from -mm tree
Message-Id: <20260602222346.8E0E51F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: fix double increment of nr_regions
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-fix-double-increment-of-nr_regions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Subject: mm/damon/sysfs-schemes: fix double increment of nr_regions
Date: Tue, 12 May 2026 09:41:57 +0530

damos_sysfs_populate_region_dir() increments sysfs_regions->nr_regions
twice when adding a new region: once explicitly before
kobject_init_and_add(), and once again through the post-increment used for
the kobject name.

As a result, nr_regions no longer matches the actual number of live
regions, and region directory names skip numbers (1, 3, 5, ...).

Use the already incremented value for naming instead of incrementing
nr_regions a second time.

Link: https://lore.kernel.org/20260512041157.109845-1-agarwal.vineet2006@gmail.com
Fixes: 66178e4ec30a ("mm/damon/sysfs: use damos_walk() for update_schemes_tried_{bytes,regions}")
Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-fix-double-increment-of-nr_regions
+++ a/mm/damon/sysfs-schemes.c
@@ -2995,7 +2995,7 @@ void damos_sysfs_populate_region_dir(str
 	if (kobject_init_and_add(&region->kobj,
 				&damon_sysfs_scheme_region_ktype,
 				&sysfs_regions->kobj, "%d",
-				sysfs_regions->nr_regions++)) {
+				sysfs_regions->nr_regions)) {
 		kobject_put(&region->kobj);
 		return;
 	}
_

Patches currently in -mm which might be from agarwal.vineet2006@gmail.com are


