Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CE622422A
	for <mm-commits@vger.kernel.org>; Tue,  9 Sep 2025 23:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757461944; cv=none; b=j7qrMDyExOZI3rgKFpp8ShXasYC+CWsEEkxr1ILJMVaJAEeXXx70mGQ77fmChmMG7kYQVGUGeEyDfoV6wBofrzga8fdZBK1rC/kuwOuQ9jLPwwnKb06oAxGM7h23JSsxQkl95m+9U9V0P3DDdo/9ISGfH2w6wvN4CgVCA+gc18s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757461944; c=relaxed/simple;
	bh=JVVmxrrcOHkw4z9kJ6bdCA4rtVZaiSwdfAOwtnTwzoM=;
	h=Date:To:From:Subject:Message-Id; b=Ix9xBhiMebSYSa1CMbtTTdlOFDOE4gIFHXH9vYXW52mu3zRv/M+wfB2oKWSHBYiYrzdvWEAwUV46d6YUSLOTjJ0KTQ0PClt84FUT/HA8S9fiDpyysl0T57amJt0wAFZVhwPFqkhLUJcB9p1laET93yTU4ryG8/Wy3O8HsTzp67g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WmwZj4pj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WmwZj4pj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CAC2C4CEF4;
	Tue,  9 Sep 2025 23:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757461944;
	bh=JVVmxrrcOHkw4z9kJ6bdCA4rtVZaiSwdfAOwtnTwzoM=;
	h=Date:To:From:Subject:From;
	b=WmwZj4pjLDux/iuP7ER4ip1NPWhihAIiTVxLBPSgrWzb5pzABaLMQx0L0bJJV0ra0
	 sHYw/9nKdJA5+ovQKdofPgxabNqgfIxbgzLu3YbqwC0GMrp6gW0QcS+6ToqgfibTko
	 TWBa8rpaFEo41K1aG06gGNA4ONV4G0P+E28bDhkA=
Date: Tue, 09 Sep 2025 16:52:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,usamaarif642@gmail.com,souravpanda@google.com,shakeel.butt@linux.dev,pasha.tatashin@soleen.com,mhocko@suse.com,kent.overstreet@linux.dev,jackmanb@google.com,hannes@cmpxchg.org,00107082@163.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-avoid-warnings-when-freeing-non-compound-tail-pages.patch added to mm-new branch
Message-Id: <20250909235224.2CAC2C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: avoid warnings when freeing non-compound "tail" pages
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-avoid-warnings-when-freeing-non-compound-tail-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-avoid-warnings-when-freeing-non-compound-tail-pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: avoid warnings when freeing non-compound "tail" pages
Date: Tue, 9 Sep 2025 16:34:09 -0700

When freeing "tail" pages of a non-compount high-order page, we properly
subtract the allocation tag counters, however later when these pages are
released, alloc_tag_sub() will issue warnings because tags for these pages
are NULL.

This issue was originally anticipated by Vlastimil in his review [1] and
then recently reported by David.  Prevent warnings by marking the tags
empty.

Link: https://lkml.kernel.org/r/20250909233409.1013367-4-surenb@google.com
Link: https://lore.kernel.org/all/6db0f0c8-81cb-4d04-9560-ba73d63db4b8@suse.cz/ [1]
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: David Wang <00107082@163.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~alloc_tag-avoid-warnings-when-freeing-non-compound-tail-pages
+++ a/mm/page_alloc.c
@@ -5240,9 +5240,16 @@ static void ___free_pages(struct page *p
 		__free_frozen_pages(page, order, fpi_flags);
 	else if (!head) {
 		pgalloc_tag_sub_pages(tag, (1 << order) - 1);
-		while (order-- > 0)
+		while (order-- > 0) {
+			/*
+			 * The "tail" pages of this non-compound high-order
+			 * page will have no code tags, so to avoid warnings
+			 * mark them as empty.
+			 */
+			clear_page_tag_ref(page + (1 << order));
 			__free_frozen_pages(page + (1 << order), order,
 					    fpi_flags);
+		}
 	}
 }
 
_

Patches currently in -mm which might be from surenb@google.com are

mm-limit-the-scope-of-vma_start_read.patch
mm-change-vma_start_read-to-drop-rcu-lock-on-failure.patch
selftests-proc-test-procmap_query-ioctl-while-vma-is-concurrently-modified.patch
fs-proc-task_mmu-factor-out-proc_maps_private-fields-used-by-procmap_query.patch
fs-proc-task_mmu-execute-procmap_query-ioctl-under-per-vma-locks.patch
alloc_tag-use-release_pages-in-the-cleanup-path.patch
alloc_tag-prevent-enabling-memory-profiling-if-it-was-shut-down.patch
alloc_tag-avoid-warnings-when-freeing-non-compound-tail-pages.patch

