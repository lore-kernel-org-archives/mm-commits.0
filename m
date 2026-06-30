Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41642405E1
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 22:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782857801; cv=none; b=BfmYScVordtFXlx8dS/u5RQD0RBsD16AKpWDH9ex5lbrH7ae6NAR60rECz+ch9pnpUC98Q7EApqZSXaGPb8nGGbXo/CMc/ypotbeihtcRDpqBHIsDnI0LN8hWOfUsLyeq+zZgSuh01xv7HPICO5f/T6dVf2noyQloat13QHuvf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782857801; c=relaxed/simple;
	bh=aoOxBk6FI+i507Q93C9dmarGeggY/Zz3OlREVySNaZk=;
	h=Date:To:From:Subject:Message-Id; b=TaYOsIx10d1nlU4TCZPjwxigPPmRVI6CU2u18C5jw2EIoi0epdemw6HZ53budszQmUW5/XWGO2KazQEkz+dksHQHm81q60xZsBK2rEw2ZzhqazkK2S5JzKHFj90o7CfRfywhFESUhYm7lS1mw3inLgkC0bP8EXtvEXHAkhTEQLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1LEIVYXT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1LEIVYXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE7D1F000E9;
	Tue, 30 Jun 2026 22:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782857799;
	bh=wxQSFz/5n597Xk1i2VaGvrN9QDyt0F+rhB2C8I2SANE=;
	h=Date:To:From:Subject;
	b=1LEIVYXT4VoC0N5KTX3K/YMkDtO4Ta6CaIcoekhZy9Jmv4hF/BNvsw6PqLiRmBoQO
	 /N8s1eVv7oDKI2VzcU1gRg+KUPcbBsH835ZvtmdZ+mAdwOSpTQ/zBb4iITA4VbGy7k
	 sghC3H3wVNJm+DbUQRJr6/rfS8HkzRS19ISjvndU=
Date: Tue, 30 Jun 2026 15:16:39 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] docs-pagemap-fix-flags-location-member-name-and-sample-code.patch removed from -mm tree
Message-Id: <20260630221639.7DE7D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: pagemap: fix flags location, member name and sample code
has been removed from the -mm tree.  Its filename was
     docs-pagemap-fix-flags-location-member-name-and-sample-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zenghui Yu <zenghui.yu@linux.dev>
Subject: docs: pagemap: fix flags location, member name and sample code
Date: Sat, 27 Jun 2026 00:27:10 +0800

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
The second one included the wrong category in the required mask -
PAGE_IS_FILE should be used instead of PAGE_IS_SWAPPED as per the
intention.

Fix them all together.

Link: https://lore.kernel.org/20260626162710.25844-1-zenghui.yu@linux.dev
Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
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
+   .category_mask = PAGE_IS_WRITTEN | PAGE_IS_FILE,
    .category_inverted = PAGE_IS_SWAPPED,
    .category_anyof_mask = PAGE_IS_PRESENT | PAGE_IS_HUGE,
    .return_mask = PAGE_IS_WRITTEN | PAGE_IS_SWAPPED |
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

selftests-mm-pagemap_ioctl-use-the-correct-page-size-for-transact_test.patch
selftests-mm-hmm-tests-include-linux-mmanh-to-access-madv_collapse.patch
tools-mm-add-thp_swap_allocator_test-binary-to-gitignore.patch

