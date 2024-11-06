Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09625184527
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854836; cv=none; b=csDq9YwLrGLvZa8umtyln5NMKt6qaYfdU5qjFnHwExrqziCCdYJ3CuVu4X0udo0qbSZqlgEql9DX0AvwdNorRYcgEGsFF0xjVJEp2OsBTzDE6he1s9Bownz66Rv8hTBB4y2YqIf1fEeLxK0k6aa659OecDRRddtcRl/v4mkmf0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854836; c=relaxed/simple;
	bh=hGglJVTScNHUBOwkagpxzSQG5wVnKd48pAT6I36Ye60=;
	h=Date:To:From:Subject:Message-Id; b=cSlYvXdNeZpR9nbw/DRFVQ1RTGLxG3+OhM/wVcQ3IsiyI7QqHqGnGzCwx1oKxHM8gSCQx9Y9oD6JH8/6TYWPc0An2zBN85SaiR25vKB9b+AdEssLqXesqAiYEnjf1sdAxShmAiWpXsqRp+q0G6nuXEVzuQ5Qu52e+almHvCrMpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mKCuKVP3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mKCuKVP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3363C4CED1;
	Wed,  6 Nov 2024 01:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854835;
	bh=hGglJVTScNHUBOwkagpxzSQG5wVnKd48pAT6I36Ye60=;
	h=Date:To:From:Subject:From;
	b=mKCuKVP34sH6R/+eqBJKQXgK1wjKnayZH8ca3iLT5a9p7ZtPz424WQImh90VB8VMH
	 MA/8aP3tz/7sWSbf1iAhVBrj4jZpfNfnKRZLk9sNcFcwDm1OHZweUqROoRoNggcqcz
	 X85eBqMVw5xqtfFAtK3ohMD8LTeqE45rI8c/gq5k=
Date: Tue, 05 Nov 2024 17:00:35 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,weixugc@google.com,surenb@google.com,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,anshuman.khandual@arm.com,souravpanda@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-codetag-fix-arg-in-pgalloc_tag_copy-alloc_tag_sub.patch removed from -mm tree
Message-Id: <20241106010035.D3363C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/codetag: fix arg in pgalloc_tag_copy alloc_tag_sub
has been removed from the -mm tree.  Its filename was
     mm-codetag-fix-arg-in-pgalloc_tag_copy-alloc_tag_sub.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sourav Panda <souravpanda@google.com>
Subject: mm/codetag: fix arg in pgalloc_tag_copy alloc_tag_sub
Date: Tue, 22 Oct 2024 23:24:40 +0000

alloc_tag_sub() takes bytes as opposed to number of pages as argument.

Currently pgalloc_tag_copy() passes the number of pages.  This fix passes
the correct unit, which is the number of bytes allocated.

Link: https://lkml.kernel.org/r/20241022232440.334820-1-souravpanda@google.com
Fixes: e0a955bf7f61 ("mm/codetag: add pgalloc_tag_copy()")
Signed-off-by: Sourav Panda <souravpanda@google.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-codetag-fix-arg-in-pgalloc_tag_copy-alloc_tag_sub
+++ a/include/linux/mm.h
@@ -4207,7 +4207,7 @@ static inline void pgalloc_tag_copy(stru
 	/* Clear the old ref to the original allocation tag. */
 	clear_page_tag_ref(&old->page);
 	/* Decrement the counters of the tag on get_new_folio. */
-	alloc_tag_sub(ref, folio_nr_pages(new));
+	alloc_tag_sub(ref, folio_size(new));
 
 	__alloc_tag_ref_set(ref, tag);
 
_

Patches currently in -mm which might be from souravpanda@google.com are


