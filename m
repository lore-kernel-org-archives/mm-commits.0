Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16A98632B;
	Fri, 20 Feb 2026 21:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771621695; cv=none; b=eisd71/shm+K9JdLQ9hgMtYAdLhQhHv0Jnm8LZQEjFGQVYk+GqCk/dF8PowQvj7oMa7qMlBFoYiSBc+1K/bKbks1RZCBvNvpR7DnGPTy0cTXXoQ7l5dyFN2Ay/8+rJTU4a1LakLnN6Dk/fw0J7KK1YayVwOQpsCeu1GyESJbM9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771621695; c=relaxed/simple;
	bh=fo9J7Kh5LXZ4sAfujsd/dDL1VGh9hmHvsbJR1d7LZ34=;
	h=Date:To:From:Subject:Message-Id; b=txJQAegi0M+K2wAQPuC5J65mJi5kI+kSnh/u6z9bx9XMB5fq1d4IXIHiSEFv4BKuSEVgZrrxOWbGmPLvN93KWuyh9yCcnuiWLNDbIy0hbuVCw4UNtK5mBikdmgl051off9JqMgZmL22pLkeQZpbpii/XtT8rZ/z+1mA+UkpQlOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r012pDis; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r012pDis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077E5C116C6;
	Fri, 20 Feb 2026 21:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771621695;
	bh=fo9J7Kh5LXZ4sAfujsd/dDL1VGh9hmHvsbJR1d7LZ34=;
	h=Date:To:From:Subject:From;
	b=r012pDis/MIiENZFG9rf40avsWS7hqKdXMBeLa6OIxXB4sCXt/df/kw2WQKpdIm3r
	 5lMUDVF0heobob39mWSgZ54b/uCKIacJwmjeSoIy9IUN67zEb0iKuCvIpyMZADQq2F
	 wFPJKly13kd8o3+XC9OEUtdpTHdjCVYyjusRgASU=
Date: Fri, 20 Feb 2026 13:08:14 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ryabinin.a.a@gmail.com,kees@kernel.org,gregkh@linuxfoundation.org,ernesto.martinezgarcia@tugraz.at,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kfence-fix-kasan-hardware-tag-faults-during-late-enablement.patch added to mm-hotfixes-unstable branch
Message-Id: <20260220210815.077E5C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kfence: fix KASAN hardware tag faults during late enablement
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kfence-fix-kasan-hardware-tag-faults-during-late-enablement.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kfence-fix-kasan-hardware-tag-faults-during-late-enablement.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-kfence-disable-kfence-upon-kasan-hw-tags-enablement.patch
mm-kfence-fix-kasan-hardware-tag-faults-during-late-enablement.patch

