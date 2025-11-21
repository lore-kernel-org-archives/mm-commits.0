Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17812DAFDD
	for <mm-commits@vger.kernel.org>; Fri, 21 Nov 2025 16:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763743432; cv=none; b=NbK/nXr26hl5rTB6mVFIBa4YvpMwWd3/gFiOvtDb6EKSwlrHgJF5IsL/QQNnSnhCiKUJU+pKwV6A9nOpXK+WECbYBghqhmhTShVnwRHK6kU/WCE0sLv1aCiSOWQ5gNrORtTbxy57UsHuE3a33c/iefmCxd5qx4pnEZk3cJH9sCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763743432; c=relaxed/simple;
	bh=TsUZqhpCYnNKTcyUtgelFwfHKJ7N+YhT1WXMjBpggbI=;
	h=Date:To:From:Subject:Message-Id; b=WCm/bm2UAWnAq1aQyIq+xF9svT40u/U/KUD8dU9hn1Kj8l4erZhQt1HKgTwjrhEshEtl5bPkOSOiyROxYq8IfXMw5CgbHUKn8/ojWsf095M2bkQ3RZyU6XdWNk8h436q/9Ry4vPozRNnm5bEkLBHuzDi+N6BcBdvkr9PnnRTbIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aindDAQ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aindDAQ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A97C116C6;
	Fri, 21 Nov 2025 16:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763743432;
	bh=TsUZqhpCYnNKTcyUtgelFwfHKJ7N+YhT1WXMjBpggbI=;
	h=Date:To:From:Subject:From;
	b=aindDAQ7VpRfWa5icYyOFXzmyXOysIIrJ0Sov60fUPnt6t4hL2dNuCfCvHodQQ2gc
	 8P4MPjMmoaRsiROaqkJR4mOZxG5nxXHJqj4P2j+o23C5f7hQduixmxDA4EKiDzGc60
	 9B+d1ihPmJ7N7k7KKT9C/ZnuiTAaAU5ZPfg2DS1k=
Date: Fri, 21 Nov 2025 08:43:51 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,sj@kernel.org,hch@infradead.org,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch added to mm-unstable branch
Message-Id: <20251121164352.65A97C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch

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

mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags.patch
mm-vmalloc-add-a-helper-to-optimize-vmalloc-allocation-gfps.patch
mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch
mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block.patch

