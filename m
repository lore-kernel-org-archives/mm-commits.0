Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678067D06E
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104001; cv=none; b=VXu4pLt1KSEUhy2UmlroMvMO8axm8/P47yeQP0pCxMGDY5C7yC3e5hFEx13sduTBgJilLsimFvNAeZEQ6cpRoOrwx+Gm6JqUnaMkRmeir5az1HFs+azOV8K2KaWA4Eo8VOZ5vs+enVU6fbuxCPwrzj6XIzfddEhtG+w6J/lvzJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104001; c=relaxed/simple;
	bh=RD9pWS/vAkF+38G2zMt9qFDpBIzdUwQ8ScYOsxNtqxI=;
	h=Date:To:From:Subject:Message-Id; b=oxpnZ2P5IWu77TEe3HtEp5ivTVTnoYFayHDDvWgC8vN+fN3K+t1B4sP8bqrc9mRSeWV/Kk7az/pF9cwCyRoholSvckXZfrDshhckuxRmzjB9oHeOUgQY0NeVKQ8g1YDp3JAxMYdORpJz3RO9quq+y9Zt1gQ6aqBFEk8UUKeb+nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fmI8Gsj1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fmI8Gsj1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A812C113CD;
	Fri, 26 Apr 2024 04:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104001;
	bh=RD9pWS/vAkF+38G2zMt9qFDpBIzdUwQ8ScYOsxNtqxI=;
	h=Date:To:From:Subject:From;
	b=fmI8Gsj1GkkIWfYFDE+JLz1c0M//Q4wLDivEThaS8t5WcwhXCVrt6P+hKEzXH2mlW
	 THdySxPojGu6+U9S4HbDi+nF9e2P24NmzaVx4wvKmiEdG74zgdGto1gnKo19URLicz
	 gtFEAnIMtId+O6fWxQqhEYq9ef7VGtjBKhzk6phg=
Date: Thu, 25 Apr 2024 21:00:00 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_initc-remove-unneeded-calc_memmap_size.patch removed from -mm tree
Message-Id: <20240426040001.3A812C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init.c: remove unneeded calc_memmap_size()
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-remove-unneeded-calc_memmap_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/mm_init.c: remove unneeded calc_memmap_size()
Date: Mon, 25 Mar 2024 22:56:45 +0800

Nobody calls calc_memmap_size() now.

Link: https://lkml.kernel.org/r/20240325145646.1044760-6-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
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

documentation-kdump-clean-up-the-outdated-description.patch
kexec-fix-the-unexpected-kexec_dprintk-macro.patch
crash-add-prefix-for-crash-dumping-messages.patch

