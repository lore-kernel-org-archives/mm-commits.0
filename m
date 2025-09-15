Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D008242D66
	for <mm-commits@vger.kernel.org>; Mon, 15 Sep 2025 22:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757974667; cv=none; b=Qgb4c1xZA/S3LPxRZnXpX9+AI6dUeb9jnSyVJkp3aIcAFzYWKDKw5KDZlxcxqBk2A5aqCYFDbs2iW4SUO49m2+gnGJwXi2k2eq/s4nF5x7f+BiCAWDSf6014Z3SGEn17vR5AyUqbxVPeZMmFDfSfsDeOJDal9WiLA9tEaborDQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757974667; c=relaxed/simple;
	bh=AIhATb2Ra3V3NBy7Y0g2VhS4ND6JtefBJ84EUzKQT2k=;
	h=Date:To:From:Subject:Message-Id; b=RrEoCSbMSbLGiBsvhltM1rcc0e5NS4R7tsfIkS4GT9e81KkZUHYxdVmhMuvmVyM9hX63cF5rGDW3NZKJZpBjobb4tiiV/E0vklZtZvdRJZQH6h1QXXn7hESuDZhAqeV4RyXJPP84mAqHkYjYEKZmiE6eCWNAcJ04pHn3NASQsuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bxkj7QrZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bxkj7QrZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9FDC4CEF1;
	Mon, 15 Sep 2025 22:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757974666;
	bh=AIhATb2Ra3V3NBy7Y0g2VhS4ND6JtefBJ84EUzKQT2k=;
	h=Date:To:From:Subject:From;
	b=Bxkj7QrZC0G3zbEAWmjHqZfYe2NAuh+tul7LvUUbw5LKAIS7IXfPlfnM6BHfmbKIn
	 KVTzxIjj1d8rpWxc5o3NZoh7B+K3zz+U+cCc3mAbuhA/cbcifW4ydCFLHExu9rRR7F
	 NkT8fHnfyvQSv7aTkFSQ56+HyIJBUN6X1BeAE8fE=
Date: Mon, 15 Sep 2025 15:17:45 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,usamaarif642@gmail.com,souravpanda@google.com,shakeel.butt@linux.dev,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,hannes@cmpxchg.org,akpm@linux-foundation.org,00107082@163.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-use-release_pages-in-the-cleanup-path.patch added to mm-unstable branch
Message-Id: <20250915221746.5B9FDC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: use release_pages() in the cleanup path
has been added to the -mm mm-unstable branch.  Its filename is
     alloc_tag-use-release_pages-in-the-cleanup-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-use-release_pages-in-the-cleanup-path.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Date: Mon, 15 Sep 2025 14:27:54 -0700

Patch series "Minor fixes for memory allocation profiling", v2.

Over the last couple months I gathered a few reports of minor issues in
memory allocation profiling which are addressed in this patchset.


This patch (of 2):

When bulk-freeing an array of pages use release_pages() instead of freeing
them page-by-page.

Link: https://lkml.kernel.org/r/20250915212756.3998938-1-surenb@google.com
Link: https://lkml.kernel.org/r/20250915212756.3998938-2-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Usama Arif <usamaarif642@gmail.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Cc: David Wang <00107082@163.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

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
 
@@ -682,11 +683,10 @@ static int __init alloc_mod_tags_mem(voi
 
 static void __init free_mod_tags_mem(void)
 {
-	int i;
+	release_pages_arg arg = { .pages = vm_module_tags->pages };
 
 	module_tags.start_addr = 0;
-	for (i = 0; i < vm_module_tags->nr_pages; i++)
-		__free_page(vm_module_tags->pages[i]);
+	release_pages(arg, vm_module_tags->nr_pages);
 	kfree(vm_module_tags->pages);
 	free_vm_area(vm_module_tags);
 }
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-use-release_pages-in-the-cleanup-path.patch
alloc_tag-prevent-enabling-memory-profiling-if-it-was-shut-down.patch
alloc_tag-avoid-warnings-when-freeing-non-compound-tail-pages.patch

