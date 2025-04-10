Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECD4182D7;
	Thu, 10 Apr 2025 00:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744243974; cv=none; b=QwxC/oxxAijcYLXZmSaCNqMMI7mEj0KJ427MghQH5JWSIyxf+4mLr7AX/6J/nG9WMeXc5Ea1xtXkJ2oYAlGnzW6BAAfzRc2xo8Uq0kjIsLk1MyCIyno7Xr86rYO00VOaMa/KhBCTIuqXsSTVTMIu6ULtbfqXifdskM9DyzCiz4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744243974; c=relaxed/simple;
	bh=brzMxkokl/A2yuvVweg7zwMj9kSt8pinLnzqSYL7HVc=;
	h=Date:To:From:Subject:Message-Id; b=j0pUStBKG0tk9b/k94ZzAodsx9bEGqnhy5xM5M8ipLOg0KHhEW0DkOJx8rxBqoGeoW5zV1ItCY9z7FDQLNnPXUnd0bpVVZNKPVatm/s7CdhuiKwsUqLO9EIOTu5zIqJlDsCak8me1AwTNR5mI8mzaaemdYMtprda35Ul4AG8bk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2pFmiQBn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2pFmiQBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B68C4CEE2;
	Thu, 10 Apr 2025 00:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744243973;
	bh=brzMxkokl/A2yuvVweg7zwMj9kSt8pinLnzqSYL7HVc=;
	h=Date:To:From:Subject:From;
	b=2pFmiQBnYPeXpYPTD51T7rh3ZtbxoBqNJxkSatQ7y5e77lORllVtUYuMgUZLAB/2O
	 8/gc4vFgOfD49MUC5x6n8ZFT9ZUqIoZUYsO4BG94tlhBtgrJIe9wmaGiFk1ukSG5ZO
	 0GxGh1/35lBDTrwV19gzN5tyyiMuFFoncfZvUWys=
Date: Wed, 09 Apr 2025 17:12:52 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,kent.overstreet@linux.dev,janghyuck.kim@samsung.com,tjmercier@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-handle-incomplete-bulk-allocations-in-vm_module_tags_populate.patch added to mm-hotfixes-unstable branch
Message-Id: <20250410001253.B0B68C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: handle incomplete bulk allocations in vm_module_tags_populate
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     alloc_tag-handle-incomplete-bulk-allocations-in-vm_module_tags_populate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-handle-incomplete-bulk-allocations-in-vm_module_tags_populate.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "T.J. Mercier" <tjmercier@google.com>
Subject: alloc_tag: handle incomplete bulk allocations in vm_module_tags_populate
Date: Wed, 9 Apr 2025 22:51:11 +0000

alloc_pages_bulk_node() may partially succeed and allocate fewer than the
requested nr_pages.  There are several conditions under which this can
occur, but we have encountered the case where CONFIG_PAGE_OWNER is enabled
causing all bulk allocations to always fallback to single page allocations
due to commit 187ad460b841 ("mm/page_alloc: avoid page allocator recursion
with pagesets.lock held").

Currently vm_module_tags_populate() immediately fails when
alloc_pages_bulk_node() returns fewer than the requested number of pages. 
When this happens memory allocation profiling gets disabled, for example

[   14.297583] [9:       modprobe:  465] Failed to allocate memory for allocation tags in the module scsc_wlan. Memory allocation profiling is disabled!
[   14.299339] [9:       modprobe:  465] modprobe: Failed to insmod '/vendor/lib/modules/scsc_wlan.ko' with args '': Out of memory

This patch causes vm_module_tags_populate() to retry bulk allocations for
the remaining memory instead of failing immediately which will avoid the
disablement of memory allocation profiling.

Link: https://lkml.kernel.org/r/20250409225111.3770347-1-tjmercier@google.com
Fixes: 0f9b685626da ("alloc_tag: populate memory for module tags as needed")
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Reported-by: Janghyuck Kim <janghyuck.kim@samsung.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/lib/alloc_tag.c~alloc_tag-handle-incomplete-bulk-allocations-in-vm_module_tags_populate
+++ a/lib/alloc_tag.c
@@ -422,11 +422,20 @@ static int vm_module_tags_populate(void)
 		unsigned long old_shadow_end = ALIGN(phys_end, MODULE_ALIGN);
 		unsigned long new_shadow_end = ALIGN(new_end, MODULE_ALIGN);
 		unsigned long more_pages;
-		unsigned long nr;
+		unsigned long nr = 0;
 
 		more_pages = ALIGN(new_end - phys_end, PAGE_SIZE) >> PAGE_SHIFT;
-		nr = alloc_pages_bulk_node(GFP_KERNEL | __GFP_NOWARN,
-					   NUMA_NO_NODE, more_pages, next_page);
+		while (nr < more_pages) {
+			unsigned long allocated;
+
+			allocated = alloc_pages_bulk_node(GFP_KERNEL | __GFP_NOWARN,
+				NUMA_NO_NODE, more_pages - nr, next_page + nr);
+
+			if (!allocated)
+				break;
+			nr += allocated;
+		}
+
 		if (nr < more_pages ||
 		    vmap_pages_range(phys_end, phys_end + (nr << PAGE_SHIFT), PAGE_KERNEL,
 				     next_page, PAGE_SHIFT) < 0) {
_

Patches currently in -mm which might be from tjmercier@google.com are

alloc_tag-handle-incomplete-bulk-allocations-in-vm_module_tags_populate.patch

