Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD824317B
	for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2024 18:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711390278; cv=none; b=NEsHGNL6j3VoxL9dB3xLs5HD2T9tAnZqp/GcAveYSLqX1AqFenwhYv4sVOZfYclfTMicr+8se+dXt9fdflGj/yN8vTN5ozZPQganMlTHND5wkVKNV30fEBtkR5lIPsksVJTQm4gizvkDgm90XFLEPZT5wFStOGGxMF6BYcRrLOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711390278; c=relaxed/simple;
	bh=RxTdwgo/QJVRo1CD9XG/JEcsAREpMpenS2XB/F1wc+g=;
	h=Date:To:From:Subject:Message-Id; b=uQPVXGbOtvkoYRdCiF6YVTf2utGM42aqx5YjMKNMyAYm66tD74HcykFfLQ9iPgx9FRTPHgyqCYX91VdUK5WHpJlSupPMkre8y0mAeChmmONXU9abd+zjCoMZgNTUKZjLny/dU9ScFJ17bKJWi+CcXyGKyLUIRtrK5XTEBHRgczs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pziyTM+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pziyTM+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DB6C433F1;
	Mon, 25 Mar 2024 18:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711390278;
	bh=RxTdwgo/QJVRo1CD9XG/JEcsAREpMpenS2XB/F1wc+g=;
	h=Date:To:From:Subject:From;
	b=pziyTM+NUeBZDzCjGnY+Vx8aCyi7tjshqSfSgRSWqjKKEFZvYjzH/vA6UdMitU87/
	 /p454ZjHDHvW/24bzl3l6BvH0rBFYyeHyIG5q39eXfrz28xKSxBAeGc6zogdRhCOsw
	 M/kg19NEoYrDL9pMBT4jMobASeDh/vDem/khD83A=
Date: Mon, 25 Mar 2024 11:11:17 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-remove-unneeded-calc_memmap_size.patch added to mm-unstable branch
Message-Id: <20240325181118.79DB6C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init.c: remove unneeded calc_memmap_size()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-remove-unneeded-calc_memmap_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-remove-unneeded-calc_memmap_size.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: mm/mm_init.c: remove unneeded calc_memmap_size()
Date: Mon, 25 Mar 2024 22:56:45 +0800

Nobody calls calc_memmap_size() now.

Link: https://lkml.kernel.org/r/20240325145646.1044760-6-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   20 --------------------
 1 file changed, 20 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-remove-unneeded-calc_memmap_size
+++ a/mm/mm_init.c
@@ -1332,26 +1332,6 @@ static void __init calculate_node_totalp
 	pr_debug("On node %d totalpages: %lu\n", pgdat->node_id, realtotalpages);
 }
 
-static unsigned long __init calc_memmap_size(unsigned long spanned_pages,
-						unsigned long present_pages)
-{
-	unsigned long pages = spanned_pages;
-
-	/*
-	 * Provide a more accurate estimation if there are holes within
-	 * the zone and SPARSEMEM is in use. If there are holes within the
-	 * zone, each populated memory region may cost us one or two extra
-	 * memmap pages due to alignment because memmap pages for each
-	 * populated regions may not be naturally aligned on page boundary.
-	 * So the (present_pages >> 4) heuristic is a tradeoff for that.
-	 */
-	if (spanned_pages > present_pages + (present_pages >> 4) &&
-	    IS_ENABLED(CONFIG_SPARSEMEM))
-		pages = present_pages;
-
-	return PAGE_ALIGN(pages * sizeof(struct page)) >> PAGE_SHIFT;
-}
-
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static void pgdat_init_split_queue(struct pglist_data *pgdat)
 {
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmallocc-optimize-to-reduce-arguments-of-alloc_vmap_area.patch
x86-remove-unneeded-memblock_find_dma_reserve.patch
mm-mm_initc-remove-the-useless-dma_reserve.patch
mm-mm_initc-add-new-function-calc_nr_all_pages.patch
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch
mm-mm_initc-remove-unneeded-calc_memmap_size.patch
mm-mm_initc-remove-arch_reserved_kernel_pages.patch

