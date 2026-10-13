Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B199F429825
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865936; cv=none; b=K27uk1+JEnqgkQKaoqD8tcgdTdq4qaAylf4z5Ge0cSBS0XdV1DZV5TBY+WRGTIx3Pb4XgyPxFGZYyq3tJW9wW384rmqgVsc2tyOX2l0jF/L9cZi1MaHOmR/+1MH1toj65GHOpY6bPGnVcxc71rNLCjl/lNwSEs2RdIQhl31ra5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865936; c=relaxed/simple;
	bh=IK7O9ONUEqJUHVHKuYH+oiuewfy+xamnW6idN2PUGNo=;
	h=Date:To:From:Subject:Message-Id; b=bk0sVoRToj8lTPlJmpweprhrV4/tC5mavtEEgJIt/abcyLDGuB6FsJH7LZBxHi5V38wr4WvqG4M0pPsHxEIqsp+db3q8c3HD6aZB5XsnfxRClpyp0F254KGIcrQq9x2MLTSiBFEUolXWxKvh/TjKm9iSt4OMwOUgXI3LK/7I8g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O1mnL0x0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O1mnL0x0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8759C1F000FF;
	Tue, 13 Oct 2026 04:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865935;
	bh=0e+TsGSIDeh/m9GWPN61Au2EMBXx9IWZOXYuWgpysiM=;
	h=Date:To:From:Subject;
	b=O1mnL0x0P5Msjw33M1Yi0uiblXaO4lAMaKjljoC6gA94U+BEDqRkxY+FxqJKVUXA9
	 QLzcfhFRbDhNa/wjKUMGYQOLCH32r8mDiW86nFZEjLdsQzwJIqgixzPFu/W2/gWEmj
	 Wq7lqqhKFvjPTuihd3HwhrWlINmZoSGiJ7HlVIF4=
Date: Mon, 12 Oct 2026 21:32:15 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-damon-update-for-hugepage_size-probe-filter.patch removed from -mm tree
Message-Id: <20261013043215.8759C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/ABI/damon: update for hugepage_size probe filter
has been removed from the -mm tree.  Its filename was
     docs-abi-damon-update-for-hugepage_size-probe-filter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: Docs/ABI/damon: update for hugepage_size probe filter
Date: Tue, 15 Sep 2026 07:33:57 -0700

For the newly added hugepage_size data attribute probe filter, two new
sysfs files are added for the size range.  Update DAMON ABI document for
the new files.

Link: https://lore.kernel.org/20260915143359.91472-9-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-update-for-hugepage_size-probe-filter
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -206,6 +206,20 @@ Description:	If 'memcg' is written to th
 		reading from this file sets and gets the path to the memory
 		cgroup of the interest.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/min
+Date:		Sep 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	If 'hugepage_size' is written to the 'type' file, writing to and
+		reading from this file sets and gets the minimum size of the
+		huge page of the interest.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/max
+Date:		Sep 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	If 'hugepage_size' is written to the 'type' file, writing to and
+		reading from this file sets and gets the maximum size of the
+		huge page of the interest.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/matching
 Date:		May 2026
 Contact:	SJ Park <sj@kernel.org>
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damos_quota_goal-complement.patch
mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch
mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch
mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch
selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch
docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch
docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch
docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch

