Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBCD4B04B3
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068074; cv=none; b=Uso7o4L9wt6i+SjfvcpS5NVdkuVbowQ1Pj2WWoKSZzgPec5xaURjgZPDg54i4ErvfZdyV9L+nW56sMosVEiprbKYxSW1KYpUB/742/nokGTg7ps81lHP9PPZfiY4ILOE0ApcoFh9HvKb3bv4N1a1L0q3JruEudzGflY7Mv7/7+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068074; c=relaxed/simple;
	bh=5rrnYcwu5Ezs6IEJGFA8db5aTeMKvlzbDqmzm+ZR6pM=;
	h=Date:To:From:Subject:Message-Id; b=Tqkx3TPPji9SyPDUAMXrsSwogitOD4RK3Pe4rGwECPJqs37+nnHA4k/+kqv6bYsIzJ8Gk4hRx3aUj9Fk6ilw1O9/OUDwVyj/BcFSnn49n8Uz4OzFg5sWImP/g16NUsOeq0VdPmbsWedqva8ThG+ZBAHtt0D7idux2LQtdOtpSqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lPXc4uyD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lPXc4uyD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE97A1F000E9;
	Fri,  7 Aug 2026 02:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068070;
	bh=OiZVaPRp/b6FMM5EWTHKvCGsJ+vU0eSURd6T+iYDZqE=;
	h=Date:To:From:Subject;
	b=lPXc4uyDLBOPmF2TN3M08czOVyoAt0CdeO5InLHkpULnyfwVoPsEPgpdtdYCFnXN0
	 9aTxtJPD13TiLrFhrx3lB+P4crDy69JnwxTX4JfnVUrkU7980CuT6mgxYsgADJ8Ntx
	 y1TUtv62hmQvLE8BgEULJ/HOSzQB87z6Wxu6XY3g=
Date: Thu, 06 Aug 2026 19:01:09 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-hide-private-damon_probe-fields.patch removed from -mm tree
Message-Id: <20260807020109.EE97A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: hide private damon_probe fields
has been removed from the -mm tree.  Its filename was
     mm-damon-core-hide-private-damon_probe-fields.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: hide private damon_probe fields
Date: Tue, 14 Jul 2026 07:35:41 -0700

'filters' and 'list' fields of damon_probe are intended to be used by only
the DAMON core layer.  However, those are mistakenly not marked as
private.  Mark as private.

Link: https://lore.kernel.org/20260714143544.101305-9-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-hide-private-damon_probe-fields
+++ a/include/linux/damon.h
@@ -775,12 +775,13 @@ struct damon_filter {
  * struct damon_probe - Data region attribute probe.
  *
  * @weight:	Relative priority of the attribute for this probe.
- * @filters:	Filters for assessing if a given region is for this probe.
- * @list:	Siblings list.
  */
 struct damon_probe {
 	unsigned int weight;
+/* private: */
+	/* Filters for assessing if a given region is for this probe. */
 	struct list_head filters;
+	/* Siblings list. */
 	struct list_head list;
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are


