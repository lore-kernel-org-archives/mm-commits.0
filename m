Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0A2322A
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 00:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763599000; cv=none; b=BGsduuWAMad2I3/eho5gQv+/7UelQnZfPfQXFmSPXm5FEWCfxKULo7WDnWd4ktsMQs2qHEcuor7vR5/Z16D8W6+O+12Seid16A4QCnyN6JaMJ4bI8q2wtcF35sy8OrvFQ8zjXkzD8mv1fi/WMpPpUPcqwTiNKIej7UkoO8AIEtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763599000; c=relaxed/simple;
	bh=pHJMhrLYluuapGcxid6FxWYNXh9cCcO22oDz4sKLUfI=;
	h=Date:To:From:Subject:Message-Id; b=s8CAzJO0vsX2mnAoPHGDsFQ+HFc75LyhrzoBSD+2JdWjBfrMcTd8cpkxMFmurhmlHueGE3b6dq5J8E837g9mFGQa5Acbk/OQsZpO13cCHjrzFq5dDp3gFrvlAhIMTAPYzNyQdG7TRiVFS59pHhj2PU5cF/PgF+3uVft3fJRQmDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A1Ewmwlr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A1Ewmwlr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0D1C4CEF5;
	Thu, 20 Nov 2025 00:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763598999;
	bh=pHJMhrLYluuapGcxid6FxWYNXh9cCcO22oDz4sKLUfI=;
	h=Date:To:From:Subject:From;
	b=A1Ewmwlrfz/TdfTeCL4cKa6GTiZE6hxbepVzFT2G7+3jlyOM0egnXpF5G3LFDx8o1
	 crSvFExn7Z/zGoJ9/EjGVYf8hvNutHOvNDpIqoCk2pdZkybf6MoIJZrys+tM19Wqnk
	 JtnxwOcI/ckGu/bGnDxXAX/gAP2Lzn0z/+20tGm0=
Date: Wed, 19 Nov 2025 16:36:38 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@lst.de,hch@infradead.org,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch removed from -mm tree
Message-Id: <20251120003639.6F0D1C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
Date: Mon, 17 Nov 2025 09:35:29 -0800

Now that we have already checked for unsupported flags, we can use the
helper function to set the necessary gfp flags for the large order
allocation optimization.

Link: https://lkml.kernel.org/r/20251117173530.43293-4-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages
+++ a/mm/vmalloc.c
@@ -3634,10 +3634,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	unsigned int max_attempt_order = MAX_PAGE_ORDER;
 	struct page *page;
 	int i;
-	gfp_t large_gfp = (gfp &
-		~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL | __GFP_COMP))
-		| __GFP_NOWARN;
 	unsigned int large_order = ilog2(nr_remaining);
+	gfp_t large_gfp = vmalloc_gfp_adjust(gfp, large_order) & ~__GFP_DIRECT_RECLAIM;
 
 	large_order = min(max_attempt_order, large_order);
 
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-madvise-allow-guard-page-install-remove-under-vma-lock.patch
mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block.patch

