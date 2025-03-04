Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA423A8C1
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 00:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741049268; cv=none; b=QRugOrMyUoyRdlqCnseGGakrkpdSmqhGOqu4972wMSlalPPHSSSba8R22CS4sJMYa/0msZQ2whAUSDUc09HZ3iqkoT29nguixmMxpmbLTimAKR/sPov53XAvZ/yCDB6uZCPCWTQNndxNkZnJ/1131NBQerSHCfZwpJ4loeIoOXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741049268; c=relaxed/simple;
	bh=cYgpl2YwAMp00dSK3lhX7Bps1jyfLdA6vITOQ8zsAak=;
	h=Date:To:From:Subject:Message-Id; b=m9HxcR0MstS2QB77NLcWuPRzCr9Vu82RpBOhi1t9YxQ/21pOGkHnuWiBx/jPXnJ5KnkO07zjF/BCbuNKbvUmZrGAHIrnFcoaERu1ejVf0j6QxZJjCqWrnBQL/0XsKwz/NihKyYh+NKjQ2vBbuNdZENy2MhfxFbLEi/iiTKEIbYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pRLdcGba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pRLdcGba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840E4C4CEEB;
	Tue,  4 Mar 2025 00:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741049267;
	bh=cYgpl2YwAMp00dSK3lhX7Bps1jyfLdA6vITOQ8zsAak=;
	h=Date:To:From:Subject:From;
	b=pRLdcGbaKXjVQWfpUNcwUiS+foiM2zT4/zMED+vKHBlgtO2+7rDIxL2jzMz/SQNWS
	 dExpg2bwrVu7AamddBg5Uam12YFKBmj6HExc9rPi2FBBwMpQ0ppW/UCLr2lLfNdtD3
	 67eKqerRUpRwOObu0/LSKJ6GLpPn+JO1j4TYEyTk=
Date: Mon, 03 Mar 2025 16:47:46 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@infradead.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-move-free_vm_areaarea-from-the-__vmalloc_area_node-function-to-the-__vmalloc_node_range_noprof-function.patch added to mm-unstable branch
Message-Id: <20250304004747.840E4C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: move free_vm_area(area) from the __vmalloc_area_node function to the __vmalloc_node_range_noprof function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-move-free_vm_areaarea-from-the-__vmalloc_area_node-function-to-the-__vmalloc_node_range_noprof-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-move-free_vm_areaarea-from-the-__vmalloc_area_node-function-to-the-__vmalloc_node_range_noprof-function.patch

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
From: Liu Ye <liuye@kylinos.cn>
Subject: mm/vmalloc: move free_vm_area(area) from the __vmalloc_area_node function to the __vmalloc_node_range_noprof function
Date: Mon, 3 Mar 2025 09:57:02 +0800

Moved free_vm_area from the __vmalloc_area_node function to the
__vmalloc_node_range_noprof function so that allocation and freeing of the
area can be paired in one function for better readability.

Link: https://lkml.kernel.org/r/20250303015702.319416-1-liuye@kylinos.cn
Signed-off-by: Liu Ye <liuye@kylinos.cn>
Cc: Christop Hellwig <hch@infradead.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-move-free_vm_areaarea-from-the-__vmalloc_area_node-function-to-the-__vmalloc_node_range_noprof-function
+++ a/mm/vmalloc.c
@@ -3651,7 +3651,6 @@ static void *__vmalloc_area_node(struct
 		warn_alloc(gfp_mask, NULL,
 			"vmalloc error: size %lu, failed to allocated page array size %lu",
 			nr_small_pages * PAGE_SIZE, array_size);
-		free_vm_area(area);
 		return NULL;
 	}
 
@@ -3844,8 +3843,10 @@ again:
 
 	/* Allocate physical pages and map them into vmalloc space. */
 	ret = __vmalloc_area_node(area, gfp_mask, prot, shift, node);
-	if (!ret)
+	if (!ret) {
+		free_vm_area(area);
 		goto fail;
+	}
 
 	/*
 	 * Mark the pages as accessible, now that they are mapped.
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-memfd-fix-spelling-and-grammatical-issues.patch
mm-folio_queue-delete-__folio_order-and-use-folio_order-directly.patch
mm-vmalloc-move-free_vm_areaarea-from-the-__vmalloc_area_node-function-to-the-__vmalloc_node_range_noprof-function.patch

