Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B082F2575F
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957068; cv=none; b=Jgp7g77boJCKjgOnIs0x8c00WtEaxgshyMw+zVf3Zi6rRChVvBSoBKGc2Bv0YwHbBRWxg/yNPISLO2LgVXALoLCijUo83DwM3RmUl9XJ0n4XUFKHXkLiRo4SxvSK7MbMztpiWpZazUnAuRCOuW7MJ8gVpB+gLIg9te+u78yKqno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957068; c=relaxed/simple;
	bh=tSh62n60zlD3jhxfyrV81ktvXFt9zxuJtK7p7fDrJnQ=;
	h=Date:To:From:Subject:Message-Id; b=smEfCGO0DjET9NTwwTp1ea0rPHng/SGL4e0BzStO4+d/K/wlUYz+25nV4PL59syCx5ta5X/wyGiHdnrfvxWgdxUhCTkJSdVBtkrS6IN9Lsufj3RmCmXe3rCgXuE8dpfBN5daj/SZyddYMZR/Xw9i4FkGbgOWeYS95KxTv2FZ7S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hNDJ844V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hNDJ844V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811EFC113CC;
	Mon,  6 May 2024 00:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957068;
	bh=tSh62n60zlD3jhxfyrV81ktvXFt9zxuJtK7p7fDrJnQ=;
	h=Date:To:From:Subject:From;
	b=hNDJ844VP+/HoNgRAPapyc05qonGeGZeB81VuBuJZ3M46tvmEVpbKVof7/pEu0+PB
	 r2WkDUC4OM2iRG3ALMhINSpUBQ8Ny3zm9QJBKog8moV4P07jWq1CG0tN6RZneFQL9h
	 iU2KA92/E22ktIh0q2nZ+XOfwME0nPD8+OXUYlpI=
Date: Sun, 05 May 2024 17:57:48 -0700
To: mm-commits@vger.kernel.org,rientjes@google.com,muchun.song@linux.dev,david@redhat.com,almasrymina@google.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch removed from -mm tree
Message-Id: <20240506005748.811EFC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: assert hugetlb_lock in __hugetlb_cgroup_commit_charge
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: assert hugetlb_lock in __hugetlb_cgroup_commit_charge
Date: Wed, 17 Apr 2024 17:18:36 -0400

This is similar to __hugetlb_cgroup_uncharge_folio() where it relies on
holding hugetlb_lock.  Add the similar assertion like the other one, since
it looks like such things may help some day.

Link: https://lkml.kernel.org/r/20240417211836.2742593-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb_cgroup.c~mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge
+++ a/mm/hugetlb_cgroup.c
@@ -308,7 +308,7 @@ static void __hugetlb_cgroup_commit_char
 {
 	if (hugetlb_cgroup_disabled() || !h_cg)
 		return;
-
+	lockdep_assert_held(&hugetlb_lock);
 	__set_hugetlb_cgroup(folio, h_cg, rsvd);
 	if (!rsvd) {
 		unsigned long usage =
_

Patches currently in -mm which might be from peterx@redhat.com are


