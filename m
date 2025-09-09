Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6337622422A
	for <mm-commits@vger.kernel.org>; Tue,  9 Sep 2025 23:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757461940; cv=none; b=kCNOOh142aldfvImScCQzJgI7e1+BuUL05FntEsos5RRz65eZwUsWa+S2SDvjwCvnZbtChSbmbbEqDaFuaM5xIjMYXH4ATx/gEnpd+f3lw+dAfjdmZs86db0uVss0qdJVfpGYFWvzGy42FMGRzyoaI4WqcLLFzOV0iHBwhnNUKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757461940; c=relaxed/simple;
	bh=0CfHpUGqKmQOhmb/xKWUGMG7c1e2+WtAMntObNuc4BI=;
	h=Date:To:From:Subject:Message-Id; b=um7q/6fezgC/wQycAw2dtc5L1H8BC2FjeYxkZzrzrWbNwr59bMZyMNasRLQRFnWvQfYyN+e1Sr3lwHpwZSxMg9FojQN7Y5ANQkyuI3xu81P0HK5Yv0+hV0o8iZLsjEzE7VQ8fziQzn6p0lQK8CZH+BdhzzH3KuYMCkavT2rwOwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mfi+JOlO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mfi+JOlO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D755DC4CEF4;
	Tue,  9 Sep 2025 23:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757461939;
	bh=0CfHpUGqKmQOhmb/xKWUGMG7c1e2+WtAMntObNuc4BI=;
	h=Date:To:From:Subject:From;
	b=Mfi+JOlOZ2gQV+CTygm/xAyxgj7xNc9hQ5HKwdkMJo6bDkt01fHBRq5AcX0EnDTAl
	 /JGiuAk5SnWKy69ZYHXD14KWlBttpcQBpqegvS2gzP/CC7/MhJgIqA3JZHDU1qBgb7
	 1nXfJ568bfVhjVO4gs1jsPoqPP04fT9EcIvU3BnM=
Date: Tue, 09 Sep 2025 16:52:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,usamaarif642@gmail.com,souravpanda@google.com,shakeel.butt@linux.dev,pasha.tatashin@soleen.com,mhocko@suse.com,kent.overstreet@linux.dev,jackmanb@google.com,hannes@cmpxchg.org,akpm@linux-foundation.org,00107082@163.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-use-release_pages-in-the-cleanup-path.patch added to mm-new branch
Message-Id: <20250909235219.D755DC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: use release_pages() in the cleanup path
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-use-release_pages-in-the-cleanup-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-use-release_pages-in-the-cleanup-path.patch

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
Subject: alloc_tag: use release_pages() in the cleanup path
Date: Tue, 9 Sep 2025 16:34:07 -0700

Patch series "Minor fixes for memory allocation profiling".

Over the last couple months I gathered a few reports of minor issues in
memory allocation profiling which are addressed in this patchset.


This patch (of 3):

When bulk-freeing an array of pages use release_pages() instead of freeing
them page-by-page:

Link: https://lkml.kernel.org/r/20250909233409.1013367-1-surenb@google.com
Link: https://lkml.kernel.org/r/20250909233409.1013367-2-surenb@google.com
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Wang <00107082@163.com>
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

 lib/alloc_tag.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/lib/alloc_tag.c~alloc_tag-use-release_pages-in-the-cleanup-path
+++ a/lib/alloc_tag.c
@@ -438,9 +438,10 @@ static int vm_module_tags_populate(void)
 		if (nr < more_pages ||
 		    vmap_pages_range(phys_end, phys_end + (nr << PAGE_SHIFT), PAGE_KERNEL,
 				     next_page, PAGE_SHIFT) < 0) {
+			release_pages_arg arg = { .pages = next_page };
+
 			/* Clean up and error out */
-			for (int i = 0; i < nr; i++)
-				__free_page(next_page[i]);
+			release_pages(arg, nr);
 			return -ENOMEM;
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

