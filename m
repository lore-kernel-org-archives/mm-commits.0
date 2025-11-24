Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207D532F74B
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025861; cv=none; b=ZKCUsrpTHkQRjD2tbXFvVhOQlxqU21lPqpAskU0SoXTf5w7UGGg1ZU2w7JBPPGP3hrOD89LE/9yJCTNW51uuzEnqFgR83xJ99hM+3/Pc/L74IuSnF8iNxbp1VkmmcT4kGy4LVU1dwIH9Q+PlcgM6ILa9y+P3fvQ/EWPVWSA25Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025861; c=relaxed/simple;
	bh=SiqUT9WnM9vQvJNf44GNXb1qsNMbsM7p7+pA5nvG09c=;
	h=Date:To:From:Subject:Message-Id; b=Xr6QQ0Sb84BJTroioqbj8LjHqCmeMPyZPI56Q5gIskoHPyOKGIkiX59vHyDu7I2KS4JMjKXb3R1OeXvzn1ABbGykLoZy/yyWSUrw+vaSjfoikZLF3BLOTAebFOZXMrhR7IvzwBip3qfZDSB7VDCkoGmkO68d+usVDr1jVxy3sto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bhSrd8OT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bhSrd8OT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E3BC4CEF1;
	Mon, 24 Nov 2025 23:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025861;
	bh=SiqUT9WnM9vQvJNf44GNXb1qsNMbsM7p7+pA5nvG09c=;
	h=Date:To:From:Subject:From;
	b=bhSrd8OTNcyQ6Qe3j6lfIlMojlLUiw4bX9sCnR0lFc82xYbq03SBbBZqaDt5tQaEz
	 NBX6dHWrsXmW4cjoVEt5j01rnzC6xu71VOVrAk026WVegpa25H1k2hWrB3uCAbGeqO
	 F6q/oGJP4YAcAwNpYypZshS/mMAq5rcX4fHRoRYc=
Date: Mon, 24 Nov 2025 15:11:00 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,sj@kernel.org,hch@infradead.org,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch removed from -mm tree
Message-Id: <20251124231100.E8E3BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
Date: Fri, 21 Nov 2025 01:44:04 -0800

Now that we have already checked for unsupported flags, we can use the
helper function to set the necessary gfp flags for the large order
allocation optimization.

Link: https://lkml.kernel.org/r/20251121094405.40628-4-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Acked-by: SeongJae Park <sj@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
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


