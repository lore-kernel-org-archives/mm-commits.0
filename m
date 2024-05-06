Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B12A38FB9
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957146; cv=none; b=cnXc10J18a3EAZZEaWoWMx12mp5CiCKlU4UR1RmrU5fTXQJ2xEGzO0kmgd/3cIJK7z16XRUg84+5mGTKLWjNRXGSyvxeCYU5lt/oT6A6ZECK1PI4XCyEtPPAls7UD6U+eP54eLZ+Bz/vgnSrGT0Vh4suy4JkL1xAFcQZvf4LGJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957146; c=relaxed/simple;
	bh=iSTkSxSZ3c3zDL9x3WVHiv/MNBysRyGlExSxRhRP668=;
	h=Date:To:From:Subject:Message-Id; b=uXRfUwLiGYKjKqTgTW8mW4WDWSSBiath1sLYTFKCvYxtvDMKaKpU+YbiPuSUVnY9R7WY+HofUkyCNz1Y6Va0eAYIgVX/UTZljh491TiuJ6/h6O//uYisnFq/wBNx8EDBVu6/QRAQnhRnoapTLXPj0utyXDgOzhvMZDQjuw9ULZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iXtvZ6Z2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iXtvZ6Z2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC186C113CC;
	Mon,  6 May 2024 00:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957146;
	bh=iSTkSxSZ3c3zDL9x3WVHiv/MNBysRyGlExSxRhRP668=;
	h=Date:To:From:Subject:From;
	b=iXtvZ6Z2mGo/7qzxRFhbUWg2XnYqqAm01IKe+ULWAiXWAmyckSW7KjNFKrInZ4Gzg
	 +rFkycO4sWwxzdgP3eGTMBuifvsd9mi804wPxJOe/ewemXHS+E/j5LsIYjZ1erbjPq
	 MQ31gESr0iowNx6+dMz48UZt0Nu+Ncnl65OQOhIQ=
Date: Sun, 05 May 2024 17:59:05 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,peterx@redhat.com,muchun.song@linux.dev,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-document-why-hugetlb-uses-folio_mapcount-for-cow-reuse-decisions.patch removed from -mm tree
Message-Id: <20240506005905.EC186C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: document why hugetlb uses folio_mapcount() for COW reuse decisions
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-document-why-hugetlb-uses-folio_mapcount-for-cow-reuse-decisions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/hugetlb: document why hugetlb uses folio_mapcount() for COW reuse decisions
Date: Thu, 2 May 2024 10:52:59 +0200

Let's document why hugetlb still uses folio_mapcount() and is prone to
leaking memory between processes, for example using vmsplice() that still
uses FOLL_GET.

More details can be found in [1], especially around how hugetlb pages
cannot really be overcommitted, and why we don't particularly care about
these vmsplice() leaks for hugetlb -- in contrast to ordinary memory.

[1] https://lore.kernel.org/all/8b42a24d-caf0-46ef-9e15-0f88d47d2f21@redhat.com/

Link: https://lkml.kernel.org/r/20240502085259.103784-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Suggested-by: Peter Xu <peterx@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-document-why-hugetlb-uses-folio_mapcount-for-cow-reuse-decisions
+++ a/mm/hugetlb.c
@@ -5963,6 +5963,13 @@ retry_avoidcopy:
 	/*
 	 * If no-one else is actually using this page, we're the exclusive
 	 * owner and can reuse this page.
+	 *
+	 * Note that we don't rely on the (safer) folio refcount here, because
+	 * copying the hugetlb folio when there are unexpected (temporary)
+	 * folio references could harm simple fork()+exit() users when
+	 * we run out of free hugetlb folios: we would have to kill processes
+	 * in scenarios that used to work. As a side effect, there can still
+	 * be leaks between processes, for example, with FOLL_GET users.
 	 */
 	if (folio_mapcount(old_folio) == 1 && folio_test_anon(old_folio)) {
 		if (!PageAnonExclusive(&old_folio->page)) {
_

Patches currently in -mm which might be from david@redhat.com are


