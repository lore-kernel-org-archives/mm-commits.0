Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9B430B53E
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334277; cv=none; b=NTf6ZSc9H7VxlKQ0OFQZTWkrb0XnzXYzpWqeLNDKlBlNeTNgnq2SJyjdGGJEW+QtzeHG5AOEkpjJzaQJ6Rw8muV/5jkzLgqmUUiYU7V4xpKPZa0ihmL4rw2Y2bb9h1ITtfDhmrBe5CPYbDhzabmbM4vNLPluXKD6w2oqdPG/Kpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334277; c=relaxed/simple;
	bh=B3KzTuYN7tjPquc9ziVwLSpiYbHU59eL0sRYaH/jrgI=;
	h=Date:To:From:Subject:Message-Id; b=OdzaFsz9X4cnSWfqupi6NOkXLwhl7Z7p9VGAJhy1DuTzru8utsn4acfMUUYAlkGrpWB9DWxVOzZOAFUxQOfwZw57GbhC1xnGOanCUUG1ZcqpVJue2sTHm2yzpVKk+ODqYAXw4Mq3fDmjJpsxOca5iT7VS8HQxgrxfXt9Wu0u55o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hHd7WhOY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hHd7WhOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949CA1F0089B;
	Wed,  7 Oct 2026 00:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334276;
	bh=Qy7i6NK0lIfnidiYBsFv8VgBjxybUKLp12Nk7gD/OCk=;
	h=Date:To:From:Subject;
	b=hHd7WhOYZam5wmrJD4Y9V3zM6x02CfGkzCafQMvveQjOPZ3tONku4MA6tX1C+JLE0
	 6U4FF7wri4tTESNmTmT3TGe3U64Qu7xNV2Dt1oZCHfgq6AuAudIJVHjUt28s+y5uq7
	 UxzUd0FVnFUiWhZb6a+JZP1zvDPq18z4KYfTm0kk=
Date: Tue, 06 Oct 2026 17:51:16 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,aethernet65535@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-difference-between-watermarks-and-nr_snapshots.patch removed from -mm tree
Message-Id: <20261007005116.949CA1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs/mm/damon/design: difference between watermarks and nr_snapshots
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-difference-between-watermarks-and-nr_snapshots.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liew Rui Yan <aethernet65535@gmail.com>
Subject: docs/mm/damon/design: difference between watermarks and nr_snapshots
Date: Mon, 31 Aug 2026 08:02:25 -0700

Explain the difference between nr_snapshots reaches max_nr_snapshots and
watermarks.

Link: https://lore.kernel.org/20260831150227.83416-3-sj@kernel.org
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 Documentation/mm/damon/design.rst |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-difference-between-watermarks-and-nr_snapshots
+++ a/Documentation/mm/damon/design.rst
@@ -872,7 +872,8 @@ the action to the region will fail.
 
 Unlike normal stats, ``max_nr_snapshots`` is set by users.  If it is set as
 non-zero and ``nr_snapshots`` be same to or greater than ``nr_snapshots``, the
-scheme is deactivated.
+scheme is deactivated.  Note that, unlike watermarks, even if a scheme's
+``nr_snapshots`` reaches ``max_nr_snapshots``, monitoring will not stop.
 
 To know how user-space can read the stats via :ref:`DAMON sysfs interface
 <sysfs_interface>`, refer to :ref:s`stats <sysfs_stats>` part of the
_

Patches currently in -mm which might be from aethernet65535@gmail.com are

docs-mm-damon-design-clarify-when-qt_exceeds-increases.patch
docs-mm-damon-design-fix-typos-in-temporal-auto-tuning-algorithm-section.patch
mm-damon-core-skip-quota-score-setup-when-the-quota-is-full.patch

