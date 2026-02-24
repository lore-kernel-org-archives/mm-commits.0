Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98B83644DE;
	Tue, 24 Feb 2026 19:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771960448; cv=none; b=Aud4YcOk9cP8UuYYc6urIAlhhD5oVImIao6BIxaARbQjI6JFbQslQ6t0HGqWo7tsEyO83DTKxbFAw326M44zEvDYM83oigOlJaOJAA2MDiDrx+JLgwwpHNu01eNsRfTMaS1uTQchBQ4FmWQ/gLj1vWw89EmZleAXu18ujXlOu6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771960448; c=relaxed/simple;
	bh=ZgJ2dlkfLh/+6VtXb+KC44kX++NnsA253Uvtimq+nmo=;
	h=Date:To:From:Subject:Message-Id; b=XlNuu5zrgMs0kfN/0YPhme6UsWnMzMesQZng2NXgnDLHEjnWo/9yY/X3/jSh0/V6UcXA7L8DxXL7OEEg+SEcv2VNwTSJTcDe7sDwoMRWaZruzMEbQVvQgMKv8uohy7bfa3K1GG8kCOCUcM0t8YEp9AfgNxHjC1TokPTybS5r6PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W4Usxi0Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W4Usxi0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7982CC116D0;
	Tue, 24 Feb 2026 19:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771960447;
	bh=ZgJ2dlkfLh/+6VtXb+KC44kX++NnsA253Uvtimq+nmo=;
	h=Date:To:From:Subject:From;
	b=W4Usxi0Y5y9+/4soOf2s+01HpIyZGNAbTFPHEx+1y20B/y94PsaNEtP0laCTmXK2M
	 ECLjdhZJyDbGgeQNUMmic1JymITW3xulFdDklLSis9Cc+AgtuEigxnQupO7wGncz4D
	 cMgn5nHFz6l/WBwONGZnLGY8treWU7/bGF2A3iL4=
Date: Tue, 24 Feb 2026 11:14:06 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ryabinin.a.a@gmail.com,kees@kernel.org,gregkh@linuxfoundation.org,ernesto.martinezgarcia@tugraz.at,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-kfence-fix-kasan-hardware-tag-faults-during-late-enablement.patch removed from -mm tree
Message-Id: <20260224191407.7982CC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kfence: fix KASAN hardware tag faults during late enablement
has been removed from the -mm tree.  Its filename was
     mm-kfence-fix-kasan-hardware-tag-faults-during-late-enablement.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: mm/kfence: fix KASAN hardware tag faults during late enablement
Date: Fri, 20 Feb 2026 15:49:40 +0100

When KASAN hardware tags are enabled, re-enabling KFENCE late (via
/sys/module/kfence/parameters/sample_interval) causes KASAN faults.

This happens because the KFENCE pool and metadata are allocated via the
page allocator, which tags the memory, while KFENCE continues to access it
using untagged pointers during initialization.

Use __GFP_SKIP_KASAN for late KFENCE pool and metadata allocations to
ensure the memory remains untagged, consistent with early allocations from
memblock.  To support this, add __GFP_SKIP_KASAN to the allowlist in
__alloc_contig_verify_gfp_mask().

Link: https://lkml.kernel.org/r/20260220144940.2779209-1-glider@google.com
Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
Signed-off-by: Alexander Potapenko <glider@google.com>
Suggested-by: Ernesto Martinez Garcia <ernesto.martinezgarcia@tugraz.at>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |   14 ++++++++------
 mm/page_alloc.c  |    3 ++-
 2 files changed, 10 insertions(+), 7 deletions(-)

--- a/mm/kfence/core.c~mm-kfence-fix-kasan-hardware-tag-faults-during-late-enablement
+++ a/mm/kfence/core.c
@@ -1004,14 +1004,14 @@ static int kfence_init_late(void)
 #ifdef CONFIG_CONTIG_ALLOC
 	struct page *pages;
 
-	pages = alloc_contig_pages(nr_pages_pool, GFP_KERNEL, first_online_node,
-				   NULL);
+	pages = alloc_contig_pages(nr_pages_pool, GFP_KERNEL | __GFP_SKIP_KASAN,
+				   first_online_node, NULL);
 	if (!pages)
 		return -ENOMEM;
 
 	__kfence_pool = page_to_virt(pages);
-	pages = alloc_contig_pages(nr_pages_meta, GFP_KERNEL, first_online_node,
-				   NULL);
+	pages = alloc_contig_pages(nr_pages_meta, GFP_KERNEL | __GFP_SKIP_KASAN,
+				   first_online_node, NULL);
 	if (pages)
 		kfence_metadata_init = page_to_virt(pages);
 #else
@@ -1021,11 +1021,13 @@ static int kfence_init_late(void)
 		return -EINVAL;
 	}
 
-	__kfence_pool = alloc_pages_exact(KFENCE_POOL_SIZE, GFP_KERNEL);
+	__kfence_pool = alloc_pages_exact(KFENCE_POOL_SIZE,
+					  GFP_KERNEL | __GFP_SKIP_KASAN);
 	if (!__kfence_pool)
 		return -ENOMEM;
 
-	kfence_metadata_init = alloc_pages_exact(KFENCE_METADATA_SIZE, GFP_KERNEL);
+	kfence_metadata_init = alloc_pages_exact(KFENCE_METADATA_SIZE,
+						 GFP_KERNEL | __GFP_SKIP_KASAN);
 #endif
 
 	if (!kfence_metadata_init)
--- a/mm/page_alloc.c~mm-kfence-fix-kasan-hardware-tag-faults-during-late-enablement
+++ a/mm/page_alloc.c
@@ -6928,7 +6928,8 @@ static int __alloc_contig_verify_gfp_mas
 {
 	const gfp_t reclaim_mask = __GFP_IO | __GFP_FS | __GFP_RECLAIM;
 	const gfp_t action_mask = __GFP_COMP | __GFP_RETRY_MAYFAIL | __GFP_NOWARN |
-				  __GFP_ZERO | __GFP_ZEROTAGS | __GFP_SKIP_ZERO;
+				  __GFP_ZERO | __GFP_ZEROTAGS | __GFP_SKIP_ZERO |
+				  __GFP_SKIP_KASAN;
 	const gfp_t cc_action_mask = __GFP_RETRY_MAYFAIL | __GFP_NOWARN;
 
 	/*
_

Patches currently in -mm which might be from glider@google.com are


