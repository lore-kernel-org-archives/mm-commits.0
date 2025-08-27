Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A811F4191
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 22:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756333578; cv=none; b=F3ePa+1KY0MQNmvP0effkYL/dOI2bsTs76PXBM8JfI+kIcl1Gkck3CZkCIBaZZp9Bb8cUXl33Hh8pZN8PiYfcCPaG/+hI+AI31udJzmoCDpnXRYQHFz2xxO8wDSVKZF9YUvKR+IbPDDUo6GNq4oc1mvjd8GCzDuB9ie5rpYNNzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756333578; c=relaxed/simple;
	bh=Ey46oYr4a0E1lX3mlThVx4ozuQ2z6BpzQ9g8kUD1YCc=;
	h=Date:To:From:Subject:Message-Id; b=aDYjx+2pDzEszkZ4d+foWGytB3zW381gLH1LyOG+qgfDlrXF8TaqjS1U7tP5MyM4gOEubUfdw+okY2GHIYJfhZd40+s+KYhZj0ctm30vcfOol4qS0vpfz+fV2b1YuEaPIjfXEcJwSERJ7fRw7rF+s95W2rTS6eRfjOlJ6vm1gHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GT3/M8iJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GT3/M8iJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A82C4CEEB;
	Wed, 27 Aug 2025 22:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756333578;
	bh=Ey46oYr4a0E1lX3mlThVx4ozuQ2z6BpzQ9g8kUD1YCc=;
	h=Date:To:From:Subject:From;
	b=GT3/M8iJLCUHhFdCTHgqgBo80U1GvSHjYTg1vqKTaigx6NJnCF7Nyjv9FZZvGAw1S
	 b8q99c3H4BdUoJf0KobRe3vLwPMOuP9yaeKbkwwWvc9npnyN0LKGLXRcyNOzlKBLVh
	 4GSoP2U3Oh1BpDzA4ARqkULdRq2Pij+Xe52O8G6U=
Date: Wed, 27 Aug 2025 15:26:17 -0700
To: mm-commits@vger.kernel.org,wqu@suse.com,willy@infradead.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,boris@bur.io,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-add-as_kernel_file.patch added to mm-new branch
Message-Id: <20250827222618.01A82C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/filemap: add AS_KERNEL_FILE
has been added to the -mm mm-new branch.  Its filename is
     mm-filemap-add-as_kernel_file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-add-as_kernel_file.patch

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
From: Boris Burkov <boris@bur.io>
Subject: mm/filemap: add AS_KERNEL_FILE
Date: Thu, 21 Aug 2025 14:55:35 -0700

Patch series "introduce kernel file mapped folios", v4.

Btrfs currently tracks its metadata pages in the page cache, using a fake
inode (fs_info->btree_inode) with offsets corresponding to where the
metadata is stored in the filesystem's full logical address space.

A consequence of this is that when btrfs uses filemap_add_folio(), this
usage is charged to the cgroup of whichever task happens to be running at
the time.  These folios don't belong to any particular user cgroup, so I
don't think it makes much sense for them to be charged in that way.  Some
negative consequences as a result:

- A task can be holding some important btrfs locks, then need to lookup
  some metadata and go into reclaim, extending the duration it holds
  that lock for, and unfairly pushing its own reclaim pain onto other
  cgroups.

- If that cgroup goes into reclaim, it might reclaim these folios a
  different non-reclaiming cgroup might need soon. This is naturally
  offset by LRU reclaim, but still.

We have two options for how to manage such file pages:
1. charge them to the root cgroup.
2. don't charge them to any cgroup at all.

2. breaks the invariant that every mapped page has a cgroup.  This is
   workable, but unnecessarily risky.  Therefore, go with 1.

A very similar proposal to use the root cgroup was previously made by Qu,
where he eventually proposed the idea of setting it per address_space. 
This makes good sense for the btrfs use case, as the behavior should apply
to all use of the address_space, not select allocations.  I.e., if someone
adds another filemap_add_folio() call using btrfs's btree_inode, we would
almost certainly want to account that to the root cgroup as well.


This patch (of 3):

Add the flag AS_KERNEL_FILE to the address_space to indicate that this
mapping's memory is exempt from the usual memcg accounting.  

Link: https://lore.kernel.org/linux-mm/b5fef5372ae454a7b6da4f2f75c427aeab6a07d6.1727498749.git.wqu@suse.com/
Link: https://lkml.kernel.org/r/f09c4e2c90351d4cb30a1969f7a863b9238bd291.1755812945.git.boris@bur.io
Signed-off-by: Boris Burkov <boris@bur.io>
Suggested-by: Qu Wenruo <wqu@suse.com>
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 ++
 mm/filemap.c            |    6 ++++++
 2 files changed, 8 insertions(+)

--- a/include/linux/pagemap.h~mm-filemap-add-as_kernel_file
+++ a/include/linux/pagemap.h
@@ -211,6 +211,8 @@ enum mapping_flags {
 				   folio contents */
 	AS_INACCESSIBLE = 8,	/* Do not attempt direct R/W access to the mapping */
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
+	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
+				   account usage to user cgroups */
 	/* Bits 16-25 are used for FOLIO_ORDER */
 	AS_FOLIO_ORDER_BITS = 5,
 	AS_FOLIO_ORDER_MIN = 16,
--- a/mm/filemap.c~mm-filemap-add-as_kernel_file
+++ a/mm/filemap.c
@@ -960,8 +960,14 @@ int filemap_add_folio(struct address_spa
 {
 	void *shadow = NULL;
 	int ret;
+	struct mem_cgroup *tmp;
+	bool kernel_file = test_bit(AS_KERNEL_FILE, &mapping->flags);
 
+	if (kernel_file)
+		tmp = set_active_memcg(root_mem_cgroup);
 	ret = mem_cgroup_charge(folio, NULL, gfp);
+	if (kernel_file)
+		set_active_memcg(tmp);
 	if (ret)
 		return ret;
 
_

Patches currently in -mm which might be from boris@bur.io are

mm-filemap-add-as_kernel_file.patch
mm-filemap-add-as_kernel_file-fix.patch
mm-add-vmstat-for-kernel_file-pages.patch
btrfs-set-as_kernel_file-on-the-btree_inode.patch

