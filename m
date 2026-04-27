Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D1D3090F5
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 12:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777292308; cv=none; b=PcO8Ws1NkK5fRjg/xn13WS2ZCZ6l/scCC3ujjJwk2G5/kRslRwiAPBkoBP2p6qkOqEzXBjFf1eWpHXyHVxLWNtaryb9OtsiRcCajSVICu4ui7lST8qQyfdFbdGbq+mPQLv89267ZWuO7AVPc62YqHy6J6gmBufqv1/oSqyfnoek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777292308; c=relaxed/simple;
	bh=AZmcyH8oUVI+k1D5QsxMWfO0JYy5AYPcVuigxZXsVss=;
	h=Date:To:From:Subject:Message-Id; b=VrXrAK4xK1mpv1xsugDgrVcOlZLtg/BiUovV+WQVNyUpHAXU180KHJA+tUlTpR1XTXJZYVlB4axGiIAvjHarfi2lapFLb6Usmz3r+bVIjMEdLXtYPZC080SVaGjQNLT6QfF4j/ORUL9Z3/emF3yZJ3SMsxjytUpVltr1JrzEXfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rU6Nz0Bn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rU6Nz0Bn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC3BC19425;
	Mon, 27 Apr 2026 12:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777292308;
	bh=AZmcyH8oUVI+k1D5QsxMWfO0JYy5AYPcVuigxZXsVss=;
	h=Date:To:From:Subject:From;
	b=rU6Nz0BnBEWUX1Ec5VpoXR3LSc+AS4EJK2u6l/6ap4rfVi7Gp900ZBqckFaeWN6Wx
	 uwcuhlVFlQZiaw7j2SLMi9dvEnFiNTWL7J+6o6HfvzQzVY79BQvXFpMG2+X7FEKBMy
	 8bt0ot92gYKWmyRDC/0y7aQOmRy0Doe0RawGVVJM=
Date: Mon, 27 Apr 2026 05:18:27 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,yonghong.song@linux.dev,willy@infradead.org,vbabka@kernel.org,surenb@google.com,song@kernel.org,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,memxor@gmail.com,martin.lau@linux.dev,ljs@kernel.org,liam@infradead.org,jolsa@kernel.org,jannh@google.com,harry@kernel.org,glaubitz@physik.fu-berlin.de,eddyz87@gmail.com,dalias@libc.org,ast@kernel.org,andrii@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bpf-arena-use-page_ref_count-instead-of-page_mapped-in-arena_free_pages.patch added to mm-new branch
Message-Id: <20260427121828.2FC3BC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bpf: arena: use page_ref_count() instead of page_mapped() in arena_free_pages()
has been added to the -mm mm-new branch.  Its filename is
     bpf-arena-use-page_ref_count-instead-of-page_mapped-in-arena_free_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bpf-arena-use-page_ref_count-instead-of-page_mapped-in-arena_free_pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: bpf: arena: use page_ref_count() instead of page_mapped() in arena_free_pages()
Date: Mon, 27 Apr 2026 13:43:15 +0200

Pages that BPF arena code maps are allocated through
bpf_map_alloc_pages(), which does not allocate folios but pages.

In the future, pages will not have a mapcount, only folios will. 
Converting the code to use folios and rely on folio_mapped() sounds like
the wrong approach.

Should BPF arena code allocate folios and use folio_mapped() here?  But
likely we would not want to use folios here longterm, as we don't really
need folio information.

Hard to tell.  But in the meantime, we can simply use the page refcount
instead, as a heuristic whether the page might be mapped to user space and
we would want to try zapping it, so we can get rid of page_mapped().

Page allocation will give us a page with a refcount of 1.  Any user space
mapping adds a page reference.  While there can be references from other
subsystems (e.g., GUP), in the common case for this test here relying on
the page count is good enough.

Link: https://lore.kernel.org/20260427-page_mapped-v1-2-e89c3592c74c@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Song Liu <song@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yonghong Song <yonghong.song@linux.dev>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/bpf/arena.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/bpf/arena.c~bpf-arena-use-page_ref_count-instead-of-page_mapped-in-arena_free_pages
+++ a/kernel/bpf/arena.c
@@ -729,7 +729,7 @@ static void arena_free_pages(struct bpf_
 
 	llist_for_each_safe(pos, t, __llist_del_all(&free_pages)) {
 		page = llist_entry(pos, struct page, pcp_llist);
-		if (page_cnt == 1 && page_mapped(page)) /* mapped by some user process */
+		if (page_cnt == 1 && page_ref_count(page) > 1) /* maybe mapped by user space */
 			/* Optimization for the common case of page_cnt==1:
 			 * If page wasn't mapped into some user vma there
 			 * is no need to call zap_pages which is slow. When
_

Patches currently in -mm which might be from david@kernel.org are

mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free.patch
sh-use-folio_mapped-instead-of-page_mapped-in-sh4_flush_cache_page.patch
bpf-arena-use-page_ref_count-instead-of-page_mapped-in-arena_free_pages.patch
mm-remove-page_mapped.patch

