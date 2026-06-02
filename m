Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEA73C1985
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439122; cv=none; b=IrPh2HYGOc57iI0ZxJuZndv275r1kZ9f3HEHn72lXpNNi53IzWfSQOLELhBuK35o1zMFvJvL6ANyp7GFLZnZBhH8n5lYT+SxyvCNfAHfU5zzU5pHMPaFdQHVvWy2J1zugwHGPK/HubGg9R4Xgx5vq3wi2Fh9O22Y+J8WfGWK9/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439122; c=relaxed/simple;
	bh=N+VdTKz+T/B/BJaz6y5zE9XqWNtBiSQUbmI/nZgu2xs=;
	h=Date:To:From:Subject:Message-Id; b=hmDrEzM3TJKFieG6KeKuMOJc0k+TPGz9euT2rMH5CFoItwA2Yy1VAco9nO2TNVknE1RmuaUuy1THJWeTwQBufIzvRtYfLTUwcXVK/6YhrJsF5x9X7q0dRg1v1vXNDGeMZ4V3FtNsUyfHip0O0g66boaLU7RDmDJwcrvTZIp2ATE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tp3oX5m7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tp3oX5m7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9A71F00898;
	Tue,  2 Jun 2026 22:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439121;
	bh=mCINI1xhkRcFqp16J73iB5Lr1E57NnGPyJ6DnmvckL8=;
	h=Date:To:From:Subject;
	b=Tp3oX5m7dGaDVcYcYBQ1nw2umQ2zeKyIshnudMSQvV1yIsxmixx7D35qg8pjYGlqv
	 wIGgaSzWtVZXuzt8DfdW3SNkxZdJl5eLKpceofTPahjpbd0HUmHpj7yY/cUEGnt2yH
	 DJ/qu3iBXlInSgC2UcwPHV2GISSH/OeYvEMaFvzg=
Date: Tue, 02 Jun 2026 15:25:20 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,dakr@kernel.org,aliceryhl@google.com,shivamkalra98@zohomail.in,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-use-physical-page-count-for-vrealloc-grow-in-place-check.patch removed from -mm tree
Message-Id: <20260602222521.2F9A71F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: use physical page count for vrealloc() grow-in-place check
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-use-physical-page-count-for-vrealloc-grow-in-place-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shivam Kalra <shivamkalra98@zohomail.in>
Subject: mm/vmalloc: use physical page count for vrealloc() grow-in-place check
Date: Tue, 19 May 2026 17:42:15 +0530

Update the grow-in-place check in vrealloc() to compare the requested size
against the actual physical page count (vm->nr_pages) rather than the
virtual area size (alloced_size, derived from get_vm_area_size()).

Currently both values are equivalent, but the upcoming vrealloc() shrink
functionality will free pages without reducing the virtual reservation
size.  After such a shrink, the old alloced_size-based comparison would
incorrectly allow a grow-in-place operation to succeed and attempt to
access freed pages.  Switch to vm->nr_pages now so the check remains
correct once shrink support is added.

Link: https://lore.kernel.org/20260519-vmalloc-shrink-v14-2-70b96ee3e9c9@zohomail.in
Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-use-physical-page-count-for-vrealloc-grow-in-place-check
+++ a/mm/vmalloc.c
@@ -4343,6 +4343,12 @@ void *vrealloc_node_align_noprof(const v
 		if (unlikely(flags & __GFP_THISNODE) && nid != NUMA_NO_NODE &&
 			     nid != page_to_nid(vmalloc_to_page(p)))
 			goto need_realloc;
+	} else {
+		/*
+		 * If p is NULL, vrealloc behaves exactly like vmalloc.
+		 * Skip the shrink and in-place grow paths.
+		 */
+		goto need_realloc;
 	}
 
 	/*
@@ -4361,7 +4367,7 @@ void *vrealloc_node_align_noprof(const v
 	/*
 	 * We already have the bytes available in the allocation; use them.
 	 */
-	if (size <= alloced_size) {
+	if (size <= vm->nr_pages << PAGE_SHIFT) {
 		/*
 		 * No need to zero memory here, as unused memory will have
 		 * already been zeroed at initial allocation time or during
_

Patches currently in -mm which might be from shivamkalra98@zohomail.in are


