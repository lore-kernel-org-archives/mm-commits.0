Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35AC1494A8
	for <mm-commits@vger.kernel.org>; Sun, 28 Jun 2026 01:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782611522; cv=none; b=fnQh+bEOCry5iJ5rVXJMANU3u1CCQa9hrK1qKgGEg1aOP/Vp5TIrE41Z4Zo8LQsSRPo/DYaHfO+jsU32Co7t7aMfznnhAEKeh9y6bwpW7p+gHgYHQicoh3U91ekN3Jv4XHg+yUwF7/Ntzv40BjE8gyLbnvPS1OlVYxdFUPiTDSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782611522; c=relaxed/simple;
	bh=bF4gtq0T/hhyvkDPeUDq08/kSP+yOoAtgxd0tXikXcY=;
	h=Date:To:From:Subject:Message-Id; b=kNStrk3xDUxECcUtRVRI4nfp05U/5ROH4SiEsMd/+ZhH7g5QL6V4deuYYTF81lCOigPbid/09c5s9CcSSUGyBfncz7q7BDLGMAYlJHwNdD8HsULDbfbfZbKY3c4MRUB76op/TmGx65ZzP2ZH96cgqZrLFl9rMF3xD/4MorvBAV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n7W2ZnWX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n7W2ZnWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD261F000E9;
	Sun, 28 Jun 2026 01:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782611521;
	bh=jcX9EL5tBcVvwY3q4EDw9PExlZPUv77HZTetCGlQodI=;
	h=Date:To:From:Subject;
	b=n7W2ZnWXIFSLNenkOVNURmzfaVjJw6sZqpzYrzuEeoGedD6n+wJTHRrPc6DGZYcce
	 KpbyptRtoB9dNzQSLjeT80Da8l1MJZeSGD0qJxDkYZWZwDP9dShfcGzKUlffIM5tVU
	 TmCuUdPFHFjk+G+WBEl11OzD4RSnpZWyKFTmyMFs=
Date: Sat, 27 Jun 2026 18:52:00 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] docs-pagemap-fix-flags-location-member-name-and-sample-code.patch removed from -mm tree
Message-Id: <20260628015201.4CD261F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: pagemap: fix flags location, member name and sample code
has been removed from the -mm tree.  Its filename was
     docs-pagemap-fix-flags-location-member-name-and-sample-code.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zenghui Yu <zenghui.yu@linux.dev>
Subject: docs: pagemap: fix flags location, member name and sample code
Date: Fri, 26 Jun 2026 01:44:47 +0800

The userland visible page flags (KPF_*) were initially moved to
include/linux/kernel-page-flags.h in commit 1a9b5b7fe0c5 ("mm: export
stable page flags"), and later moved to
include/uapi/linux/kernel-page-flags.h in commit 607ca46e97a1 ("UAPI:
(Scripted) Disintegrate include/linux").  Update the doc to reflect the
current location of these flags.

The member @walk_end of struct pm_scan_arg {} was wrongly written as
"end_walk".

The first sample code of the PAGEMAP_SCAN ioctl wrongly used the
PM_SCAN_CHECK_WPASYNC flag twice, instead of the PM_SCAN_WP_MATCHING flag.
The second one missed PAGE_IS_FILE in the required mask.

Fix them all together.

Link: https://lore.kernel.org/20260625174447.24292-1-zenghui.yu@linux.dev
Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/pagemap.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/mm/pagemap.rst~docs-pagemap-fix-flags-location-member-name-and-sample-code
+++ a/Documentation/admin-guide/mm/pagemap.rst
@@ -67,7 +67,7 @@ number of times a page is mapped.
  * ``/proc/kpageflags``.  This file contains a 64-bit set of flags for each
    page, indexed by PFN.
 
-   The flags are (from ``fs/proc/page.c``, above kpageflags_read):
+   The flags are (from ``include/uapi/linux/kernel-page-flags.h``):
 
     0. LOCKED
     1. ERROR
@@ -264,7 +264,7 @@ The ``struct pm_scan_arg`` is used as th
     provided or not.
  3. The range is specified through ``start`` and ``end``.
  4. The walk can abort before visiting the complete range such as the user buffer
-    can get full etc. The walk ending address is specified in``end_walk``.
+    can get full etc. The walk ending address is specified in ``walk_end``.
  5. The output buffer of ``struct page_region`` array and size is specified in
     ``vec`` and ``vec_len``.
  6. The optional maximum requested pages are specified in the ``max_pages``.
@@ -275,7 +275,7 @@ Find pages which have been written and W
 
    struct pm_scan_arg arg = {
    .size = sizeof(arg),
-   .flags = PM_SCAN_CHECK_WPASYNC | PM_SCAN_CHECK_WPASYNC,
+   .flags = PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
    ..
    .category_mask = PAGE_IS_WRITTEN,
    .return_mask = PAGE_IS_WRITTEN,
@@ -288,7 +288,7 @@ present or huge::
    .size = sizeof(arg),
    .flags = 0,
    ..
-   .category_mask = PAGE_IS_WRITTEN | PAGE_IS_SWAPPED,
+   .category_mask = PAGE_IS_WRITTEN | PAGE_IS_FILE | PAGE_IS_SWAPPED,
    .category_inverted = PAGE_IS_SWAPPED,
    .category_anyof_mask = PAGE_IS_PRESENT | PAGE_IS_HUGE,
    .return_mask = PAGE_IS_WRITTEN | PAGE_IS_SWAPPED |
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

tools-mm-add-thp_swap_allocator_test-binary-to-gitignore.patch

