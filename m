Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6EA28DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489834; cv=none; b=eHpgbY9s9ZtUEGPk1LnN1rXomzKyzy3CGF9iuc7iHQ88f+yUeiDIxfJXt/bzFt9KifhQI6jxspgdbzgTOVjQ9sMZa9516gfG22ALP3V04NqG992IwBrFGxeviuyYpcQOQvq8XGS/gxC23yXrCyFWrrtejS5/a1GMx5/MLGY9Ygo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489834; c=relaxed/simple;
	bh=XAMl3KKi2vrJWDgbPhLq49NO9Dsu/ZEUOOEsygWSVNc=;
	h=Date:To:From:Subject:Message-Id; b=c2NFtW9aj95V+X7ZMyIr4RqEX2NZR4K6mum7nybt6iNv5Urw61usEJ7Za2GqXYn5YAYLvZtr/HUGGjIAYbj7Hl+e8W8QnOCMA1aQ20z4AmEqLNJ+5WDwgeWkmQ7kht//j2538uhlDeG9RXLRUkPC+lr4pfmEyIJZrFZP65uzHJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AzbNEy1u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AzbNEy1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C91C4CEE7;
	Sun, 21 Sep 2025 21:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489834;
	bh=XAMl3KKi2vrJWDgbPhLq49NO9Dsu/ZEUOOEsygWSVNc=;
	h=Date:To:From:Subject:From;
	b=AzbNEy1u4YwxmvUxP3s/bfXqe6hVcsnWjYcA5kTYZvTvAyRfTcbHZpSaXtSrECFQQ
	 erlLzkArhegdKwjYFEVT0kO+CFYFcFpj4oT8IqLU+dHUp5SSzrr3m1cQh2OS/S0HZV
	 plcM6F/Yx883K1SKgN//637gzHZgmeK3JwKsToSU=
Date: Sun, 21 Sep 2025 14:23:53 -0700
To: mm-commits@vger.kernel.org,robin.murphy@arm.com,m.szyprowski@samsung.com,lorenzo.stoakes@oracle.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dma-remap-drop-nth_page-in-dma_common_contiguous_remap.patch removed from -mm tree
Message-Id: <20250921212354.63C91C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dma-remap: drop nth_page() in dma_common_contiguous_remap()
has been removed from the -mm tree.  Its filename was
     dma-remap-drop-nth_page-in-dma_common_contiguous_remap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: dma-remap: drop nth_page() in dma_common_contiguous_remap()
Date: Mon, 1 Sep 2025 17:03:44 +0200

dma_common_contiguous_remap() is used to remap an "allocated contiguous
region".  Within a single allocation, there is no need to use nth_page()
anymore.

Neither the buddy, nor hugetlb, nor CMA will hand out problematic page
ranges.

Link: https://lkml.kernel.org/r/20250901150359.867252-24-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/dma/remap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/dma/remap.c~dma-remap-drop-nth_page-in-dma_common_contiguous_remap
+++ a/kernel/dma/remap.c
@@ -49,7 +49,7 @@ void *dma_common_contiguous_remap(struct
 	if (!pages)
 		return NULL;
 	for (i = 0; i < count; i++)
-		pages[i] = nth_page(page, i);
+		pages[i] = page++;
 	vaddr = vmap(pages, count, VM_DMA_COHERENT, prot);
 	kvfree(pages);
 
_

Patches currently in -mm which might be from david@redhat.com are


