Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008A1484222;
	Tue, 13 Oct 2026 04:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865990; cv=none; b=IsdeNXXbQm9eaydGtAwFqsbsa1wElwmwvZmd5JJOeKpE8er0eVsp+4fAz2FYErTa5e3bGvYjYj/KD+iSCQrVRbTGpHLKv1bFBgVotj46dtQzP9YIc1bBgS3NYOy4k9Jm6PSs9h5DipDH1BRext71LF7+GJY2ZEe7VFAllNoiULk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865990; c=relaxed/simple;
	bh=Km12nEYM4voutnoiIq9ZxNNCTKZHTz6z396oyE+vNok=;
	h=Date:To:From:Subject:Message-Id; b=On76KQ0p5UXVKl6kTwWEe/Ndstbnc2mVWkRDchR3IP+i6bRWddwdKDlbRnutc1HkSFEJ9GRo/3L4SWGeay76WHOZ/NH2CR0V7ci/rSAjm2EY7hqwM25GORd4nR9PhK1HSCaR0uVvWyjaGBK+SVebT3K4tjYcW3siGt0Rnl1uPt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gdMY3FXp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gdMY3FXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B641F00893;
	Tue, 13 Oct 2026 04:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865988;
	bh=87COmUTPCIpGpkgi1vaUqWPNPsrfYfKn4NsRWqds6rg=;
	h=Date:To:From:Subject;
	b=gdMY3FXpnOgVQ9PvIngJry2Pu6pU65M2qVCRMBX9VTJY6uaVm5aOAS49dun7Kkbdb
	 3X/6vChkg0mLVSMxZ8DUzE1xy0vIQeU3mBhyzcZsIXClDRafyZopjsC6bXM3PErs2Q
	 hqYrZ37BkuOOZI/nQd/rtOYvyWqV2SctOWAWXUeg=
Date: Mon, 12 Oct 2026 21:33:08 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,osalvador@suse.de,muchun.song@linux.dev,kees@kernel.org,david@kernel.org,colin.i.king@gmail.com,almasrymina@google.com,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_cgroup-move-per-node-usage-on-cgroup-reparenting.patch removed from -mm tree
Message-Id: <20261013043308.C5B641F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb_cgroup: move per-node usage on cgroup reparenting
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_cgroup-move-per-node-usage-on-cgroup-reparenting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: mm/hugetlb_cgroup: move per-node usage on cgroup reparenting
Date: Fri, 18 Sep 2026 10:56:11 +0800

hugetlb_cgroup_css_offline() hands the folios of a dying cgroup over to
its parent with hugetlb_cgroup_move_parent(), which moves the page_counter
charges and the hugetlb_cgroup pointer of the folio but not its per-node
usage.  The parent's hugetlb.<size>.numa_stat is short by that usage while
they are charged, and underflows once they are freed, exposing incorrect
per-node usage values to userspace.

Move the per-node usage to the parent as well.  The folios keep their node
here, so only the cgroup which holds the usage changes.

Link: https://lore.kernel.org/20260918-for-hugetlb-charge-v2-2-2b6d8c2bdc36@kylinos.cn
Fixes: f47761999052 ("hugetlb: add hugetlb.*.numa_stat file")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
---

 mm/hugetlb_cgroup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/hugetlb_cgroup.c~mm-hugetlb_cgroup-move-per-node-usage-on-cgroup-reparenting
+++ a/mm/hugetlb_cgroup.c
@@ -241,6 +241,8 @@ static void hugetlb_cgroup_move_parent(i
 	/* Take the pages off the local counter */
 	page_counter_cancel(counter, nr_pages);
 
+	hugetlb_cgroup_move_usage(h_cg, parent, folio, folio);
+
 	set_hugetlb_cgroup(folio, parent);
 out:
 	return;
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

mm-hugetlb-account-migration-target-folio-in-per-node-nr_hugetlb-vmstat.patch
mm-memcg-migrate-per-node-hugetlb-lruvec-stat-together-with-hugetlb-folio.patch
mm-memfd-fix-hugetlb-reservation-accounting-in-error-paths.patch

