Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3C21E1A3D
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 22:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788042660; cv=none; b=iFAjgYD3XknrvoHXzW97i0yxnoOikhlwnu3VVC5cWDQqMnQFVeNRg3Vw8/rG6SMmGu90eUI7G0JFBbMkYUMaP3Q9D3eKc5hj1qxwSuwvE/XWHVMtyyhQEDeALC3lyX/ti6I8y1jBtN1WAcvWpzCq7pCI0IslxU5+4oEvPtpQC5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788042660; c=relaxed/simple;
	bh=2Q2yroQ5UC0bKcuZ0q8HWp9n4+GdnCFxMPYqBOSpPos=;
	h=Date:To:From:Subject:Message-Id; b=XZV60doX6MTpkSHunfnrA9QZnF7c5bsK7NQZ7hFMzjBDuy9vS149hm/1KKPena5zL2gMiutMomCAVcN40llWqfmtVz8AatljwBQ9Gpd6nkMtIGl67ppc9la3R+X97faG75riWnhREfiW8Tq/g5DdkB30Vqc05CBJO0KEmHZxaQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x1bJY0Zq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x1bJY0Zq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DD51F000E9;
	Sat, 29 Aug 2026 22:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788042659;
	bh=9IfjLa+oFrQ3nZGblElipfv1nGW0vu6w+hCpgJRStrE=;
	h=Date:To:From:Subject;
	b=x1bJY0ZqyYXPPaBrerg2xqmiCpfOXx5/m/iM7u0qUymlEX4B4Gonbf2Gu6iXjWl2d
	 ZyYOoWxZn+Pr9VCndaDclg4g6rHzf19UFO2rd4wEOHtk8qEWEvpbUO3qjAwCcHGX5w
	 Iln6Ji+mstKiA0AlDc0muxLNDZqYtNyvdfjX54b4=
Date: Sat, 29 Aug 2026 15:30:58 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,thnkslprpt@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-return-enomem-for-page-table-allocation-failure-in-insert_pages.patch added to mm-new branch
Message-Id: <20260829223059.20DD51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: return -ENOMEM for page-table allocation failure in insert_pages()
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-return-enomem-for-page-table-allocation-failure-in-insert_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-return-enomem-for-page-table-allocation-failure-in-insert_pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Avi Weiss <thnkslprpt@gmail.com>
Subject: mm/memory: return -ENOMEM for page-table allocation failure in insert_pages()
Date: Sat, 29 Aug 2026 20:11:13 +0300

walk_to_pmd() returns NULL only when p4d_alloc(), pud_alloc(), or
pmd_alloc() fails.  These are page-table allocation failures, but
insert_pages() currently reports them as -EFAULT.

Return -ENOMEM instead, consistent with the subsequent pte_alloc() failure
and with the single-page insert_page() path, which reports failure of the
same page-table allocation chain as -ENOMEM.

Address and range validation failures in vm_insert_pages() continue to
return -EFAULT.  Keep the later -EFAULT return for pte_offset_map_lock(),
which is not an allocation failure.

Link: https://lore.kernel.org/9d990c3ed43608e674d4b12a8c221a09fd200f49.1788022178.git.thnkslprpt@gmail.com
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-return-enomem-for-page-table-allocation-failure-in-insert_pages
+++ a/mm/memory.c
@@ -2569,7 +2569,7 @@ static int insert_pages(struct vm_area_s
 more:
 	pmd = walk_to_pmd(mm, addr);
 	if (!pmd) {
-		err = -EFAULT;
+		err = -ENOMEM;
 		goto out;
 	}
 
_

Patches currently in -mm which might be from thnkslprpt@gmail.com are

mm-memory-simplify-error-handling-in-insert_pages.patch
mm-memory-return-enomem-for-page-table-allocation-failure-in-insert_pages.patch

