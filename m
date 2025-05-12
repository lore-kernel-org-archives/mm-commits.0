Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C2D14830F
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747010998; cv=none; b=egdsV7fX9gfk7HcbOKeACQrhc3aPHVJyoOM/o3s4LpuMmd47maW12gcUO1kg29brhZ9jn5kuU+/VaVeYAxV4O0qYGuV1qj+jJ6xYZhwgkMrqq4YWgKJDJZ5lpXt1vIQN7DMeKQHfpGozQinKJ73tlv6V4IN05i5lpK8QzsXDrqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747010998; c=relaxed/simple;
	bh=v75hbwTQZ5UihIbL8sXP8gn2+BSmFagfyp4BJXFJyJ8=;
	h=Date:To:From:Subject:Message-Id; b=Xs5RYVkGCK6KcKFzzYxRNJdPuUVh8ClhPQ91J84/u5i9sc7KvBfeO7sH+Zcc9vZ682xu4+VeC+Jwv5rOY3MSromTnXtwt1HC9HGaDMNDve+Sen4xj551Gjxlj6OG86onhBu5FVk/08szaYOs6dWjLquZ2GajgLiTCMJ0ejvwfEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RrWiM64U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RrWiM64U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6E0C4CEE4;
	Mon, 12 May 2025 00:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747010998;
	bh=v75hbwTQZ5UihIbL8sXP8gn2+BSmFagfyp4BJXFJyJ8=;
	h=Date:To:From:Subject:From;
	b=RrWiM64U20++MARGOZVxk4HgAhPl+Zziv5eKEFBFyjin8mna17WjhwTVcIZABvjvQ
	 njiC/CLfQvvRppTPhDfT3Aw1HDkuFT1S96Yihx03TyKG/Pb/5BF8ZuU3cAvdr3mkY9
	 FRpvJQHj7NesmYPlZTiB44yEu0+SweZophlkXyL8=
Date: Sun, 11 May 2025 17:49:57 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-delete-thp_nr_pages.patch removed from -mm tree
Message-Id: <20250512004958.7C6E0C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: delete thp_nr_pages()
has been removed from the -mm tree.  Its filename was
     mm-delete-thp_nr_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: delete thp_nr_pages()
Date: Wed, 2 Apr 2025 22:06:10 +0100

All callers now use folio_nr_pages().  Delete this wrapper.

Link: https://lkml.kernel.org/r/20250402210612.2444135-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    9 ---------
 1 file changed, 9 deletions(-)

--- a/include/linux/mm.h~mm-delete-thp_nr_pages
+++ a/include/linux/mm.h
@@ -2224,15 +2224,6 @@ static inline long compound_nr(struct pa
 }
 
 /**
- * thp_nr_pages - The number of regular pages in this huge page.
- * @page: The head page of a huge page.
- */
-static inline long thp_nr_pages(struct page *page)
-{
-	return folio_nr_pages((struct folio *)page);
-}
-
-/**
  * folio_next - Move to the next physical folio.
  * @folio: The folio we're currently operating on.
  *
_

Patches currently in -mm which might be from willy@infradead.org are


