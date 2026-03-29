Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BA521B905
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744823; cv=none; b=TR/9+eaZEycFWZKrhKl16K0UQSpyi+FGobCq1LRWI1YGfMaCvUHECofDb1AhaQVQuWMDWNTyoZVNqLQ4tttwzKvsKrTIg3kSldsuz7Pu6fn8FXBXm28QQ6jQ/HEBSedyGWcjYJJqtfGYj71ynkvRsR0A7MlUZuSzhry/XxwD8EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744823; c=relaxed/simple;
	bh=+BL/eVcW08yQgeQ5fF1Rt1P8ILio9fOhB4gZ/O15JxA=;
	h=Date:To:From:Subject:Message-Id; b=aj5EtjwrOAz8VwMmQFSiotMgtgf1z6kw1EqDn4T2vfo3xWCPBFxMaCU271nsDASKWcrgYUcws19/MBmY5YwsSekWDldeH5SFKCCP855mShZR0jSJpcpAsZt8SjMNxGLEf217rQf7fmm+FeOs/Bj7biyLVu/m/aH+K55aodaePxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EySEw51+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EySEw51+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34357C4CEF7;
	Sun, 29 Mar 2026 00:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744823;
	bh=+BL/eVcW08yQgeQ5fF1Rt1P8ILio9fOhB4gZ/O15JxA=;
	h=Date:To:From:Subject:From;
	b=EySEw51+J/J9SBDhza85e3V5CF5NsWlHCtAXDFFwfVCOhmFl+r1t6flY19sWErQPg
	 4bHA9WCOX8GhISq52xAtrid9r2tFaE7ZeXUBDS97LaADiBmtxkJHW+QqeyPvBzOVr2
	 u8/CqrejfTJCtnHn8yEYg1T4XIY5CwnWB1XC/BRM=
Date: Sat, 28 Mar 2026 17:40:22 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-add-damon_merge_regions_of-debug_sanity-check.patch removed from -mm tree
Message-Id: <20260329004023.34357C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: add damon_merge_regions_of() debug_sanity check
has been removed from the -mm tree.  Its filename was
     mm-damon-core-add-damon_merge_regions_of-debug_sanity-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: add damon_merge_regions_of() debug_sanity check
Date: Fri, 6 Mar 2026 07:29:09 -0800

damon_merge_regions_of() should be called only after aggregation is
finished and therefore each region's nr_accesses and nr_accesses_bp match.
There were bugs that broke the assumption, during development of online
DAMON parameter updates and monitoring results handling changes.  Add a
sanity check for that under CONFIG_DAMON_DEBUG_SANITY.

Link: https://lkml.kernel.org/r/20260306152914.86303-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-add-damon_merge_regions_of-debug_sanity-check
+++ a/mm/damon/core.c
@@ -2507,6 +2507,20 @@ static void damon_merge_two_regions(stru
 	damon_destroy_region(r, t);
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_merge_regions_of(struct damon_region *r)
+{
+	WARN_ONCE(r->nr_accesses != r->nr_accesses_bp / 10000,
+			"nr_accesses (%u) != nr_accesses_bp (%u)\n",
+			r->nr_accesses, r->nr_accesses_bp);
+}
+#else
+static void damon_verify_merge_regions_of(struct damon_region *r)
+{
+}
+#endif
+
+
 /*
  * Merge adjacent regions having similar access frequencies
  *
@@ -2520,6 +2534,7 @@ static void damon_merge_regions_of(struc
 	struct damon_region *r, *prev = NULL, *next;
 
 	damon_for_each_region_safe(r, next, t) {
+		damon_verify_merge_regions_of(r);
 		if (abs(r->nr_accesses - r->last_nr_accesses) > thres)
 			r->age = 0;
 		else if ((r->nr_accesses == 0) != (r->last_nr_accesses == 0))
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

