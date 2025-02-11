Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2BB26BDB0
	for <mm-commits@vger.kernel.org>; Tue, 11 Feb 2025 02:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739239366; cv=none; b=dTnOiATTTpj1ON8UMagxu5GIZ85p/3emnA7hSbyXqyyuy3Y6Dn0hNfQrdPx3lOYQxdLEpKh4OJIbM6ZeeHNLDSi7Rx7AWDjnS+swyMPYjf4HsL5n/adDh2G2rA6JPehKivOaaQZhKYL1Ogtm+jkdm7aWVNOCL0hpP4VlOr56LBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739239366; c=relaxed/simple;
	bh=Km+kFPWZ17bQQ+WRooIUiaftYEoppP1WSufCPp37kE0=;
	h=Date:To:From:Subject:Message-Id; b=clowYeHLwauUZX5tc9Stf26zLTpWtdpN+fSWdYnEkvnvb6mpKBRYZCHVvHhO0+ZuaniDP5AegeU4U6U3AB0gPs/lHVZr042Ti5z4ee7dYGJgx66ghjKFDHIYse/qcnjlH59hTnF2le+ejcpqTJjIw9DTDJrYQvLEoALBjUUfLVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZCOgLtIy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZCOgLtIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B843C4CED1;
	Tue, 11 Feb 2025 02:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739239364;
	bh=Km+kFPWZ17bQQ+WRooIUiaftYEoppP1WSufCPp37kE0=;
	h=Date:To:From:Subject:From;
	b=ZCOgLtIycQ5J2ToHBnk/d/WwibamUu/ZzX3wqt9zJ9tTxHa2JoXxtWfqdijhhBgH5
	 4fN70NaH2FtVcBllDXUXQg3vzcaY4yv3L8qbt14L5UoiBJZygf8ltf3VY54kjfIL/k
	 nXuTV/8yuMqLdmpi+QtIduP4WhjAd2JK21SEFL9U=
Date: Mon, 10 Feb 2025 18:02:43 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tzimmermann@suse.de,soci@c64.rulez.org,simona.vetter@ffwll.ch,mcanal@igalia.com,jayakumar.lkml@gmail.com,deller@gmx.de,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix.patch added to mm-unstable branch
Message-Id: <20250211020244.0B843C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fixup unused variable warnings
has been added to the -mm mm-unstable branch.  Its filename is
     fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: fixup unused variable warnings
Date: Sun, 9 Feb 2025 06:29:25 +0000

Unfortunately fb_defio being enabled by nommu devices seems enormously
ingrained in the kernel to the point that it's not feasible to address
that in this series, so we use an ifdef to workaround.

However this workaround unfortunately missed some unused variables -
correct this.

This has been tested locally with W=1 and confirmed to resolve the issue.

Link: https://lkml.kernel.org/r/d4018405-2762-4385-a816-e54cc23839ac@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Kajtar Zsolt <soci@c64.rulez.org>
Cc: Maíra Canal <mcanal@igalia.com>
Cc: Mattew Wilcox <willy@infradead.org>
Cc: Simona Vetter <simona.vetter@ffwll.ch>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbdev/core/fb_defio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/core/fb_defio.c~fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix
+++ a/drivers/video/fbdev/core/fb_defio.c
@@ -265,15 +265,15 @@ static void fb_deferred_io_work(struct w
 
 	/* here we wrprotect the page's mappings, then do all deferred IO. */
 	mutex_lock(&fbdefio->lock);
+#ifdef CONFIG_MMU
 	list_for_each_entry(pageref, &fbdefio->pagereflist, list) {
 		struct page *page = pageref->page;
 		pgoff_t pgoff = pageref->offset >> PAGE_SHIFT;
 
-#ifdef CONFIG_MMU
 		mapping_wrprotect_range(fbdefio->mapping, pgoff,
 					page_to_pfn(page), 1);
-#endif
 	}
+#endif
 
 	/* driver's callback with pagereflist */
 	fbdefio->deferred_io(info, &fbdefio->pagereflist);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-simplify-vma-merge-structure-and-expand-comments.patch
mm-further-refactor-commit_merge.patch
mm-eliminate-adj_start-parameter-from-commit_merge.patch
mm-make-vmg-target-consistent-and-further-simplify-commit_merge.patch
mm-completely-abstract-unnecessary-adj_start-calculation.patch
mm-use-read-write_once-for-vma-vm_flags-on-migrate-mprotect.patch
mm-refactor-rmap_walk_file-to-separate-out-traversal-logic.patch
mm-provide-mapping_wrprotect_range-function.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix.patch

