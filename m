Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD99283FD9
	for <mm-commits@vger.kernel.org>; Sat, 18 Jul 2026 03:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784343921; cv=none; b=u4uPoxUkFASAB5WeDGyrrFjvkaspBATLYL7lWTGPPCqr4X4N4Q2lpoHJGebJEtQ+GWCS6HPl6q9rEN9C+2j857Zc81R9mTlJuIRCPRtLVPR/9D4HPYNMO7bYjUP8rk51+fm+cxOXMI2rMcNDWRgqr1f4wmltAMKj9HmIDzwkWxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784343921; c=relaxed/simple;
	bh=OlmNYz0L0GzdlSqk4H2YlNj31vbi0uMDfXxqseQdncc=;
	h=Date:To:From:Subject:Message-Id; b=JWh8hVHkN0zM2BR8HbeHXCMX5FpmowSCz3/kUmmCksPt/66HXjr1DiQk97j9gjrD/e9MosVyBjcW2jgXG/4lxkBMbCTJ9mQVkqjFUzGUonHR9KU7GZJy1450py4R3AvjrnPgtd8gp5O4YAT4L+BRmIZd15MTx961YqT4Mt0/hBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wUpI0GW4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wUpI0GW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8321F000E9;
	Sat, 18 Jul 2026 03:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784343919;
	bh=ntGrwRk0gmlix86OYe5cDTyIzTke8wiTqYOPmwKErYM=;
	h=Date:To:From:Subject;
	b=wUpI0GW4n844m8DhW/ePEsJ9798PsS3UxZn/4JCVJpZ5SdyCeadRTb2i65vHTnWYz
	 xe2f787+zR9DpYMf897+zfoTbUVIuptxyY/7glqeC3fRh9yLMhRwPe2OAWsC37E+jA
	 xMDuU2uEYnMzkYQ4MYeSvnfcy1V4jSIdjof2qPrU=
Date: Fri, 17 Jul 2026 20:05:18 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,tzimmermann@suse.de,sj@kernel.org,pfalcato@suse.de,m.szyprowski@samsung.com,ljs@kernel.org,liam@infradead.org,kai.huang@intel.com,gourry@gourry.net,david@kernel.org,ackerleytng@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-add-and-use-vma__pgoff-fix.patch added to mm-unstable branch
Message-Id: <20260718030519.4A8321F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-vma-add-and-use-vma__pgoff-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-add-and-use-vma__pgoff-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-add-and-use-vma__pgoff-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vma-add-and-use-vma__pgoff-fix
Date: Fri Jul 17 08:03:43 PM PDT 2026

use linear_page_delta() in __split_vma(), per Vlastimal & Lorenzo

Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vma.c~mm-vma-add-and-use-vma__pgoff-fix
+++ a/mm/vma.c
@@ -556,7 +556,7 @@ __split_vma(struct vma_iterator *vmi, st
 
 	if (new_below) {
 		vma->vm_start = addr;
-		vma_add_pgoff(vma, (addr - new->vm_start) >> PAGE_SHIFT);
+		vma_add_pgoff(vma, linear_page_delta(new, addr));
 	} else {
 		vma->vm_end = addr;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch
csky-implement-flush_cache_vmap-in-c.patch
mm-annotate-data-race-in-cpu_needs_drain-fix.patch
mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb-fix.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
mm-vma-add-and-use-vma__pgoff-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

