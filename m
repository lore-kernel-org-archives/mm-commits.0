Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E728C22539E
	for <mm-commits@vger.kernel.org>; Wed,  9 Jul 2025 22:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752099457; cv=none; b=HysyX+GXGUvhasDUQ6gwuOWc2wiDgqQeJKj9pkb+JcuMAu/aQiNJp5OhlYNDcUoILBfxllXRatgKsY/sGcKS0ylN24kMPuL/J295NZYdZ7RjCeK+3ZIX/OBdvQfGGznyxRYiK4rPJR2/G4MFTESMS4lZXly50IDrRdu3YxtuKe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752099457; c=relaxed/simple;
	bh=3V1Ty3jguTTEuS7Jb0fxil/w1JYOw06+BSZU83PbK3A=;
	h=Date:To:From:Subject:Message-Id; b=lhx/EBUZJA5I6+RJizNHKbpOOi0DrhsEm4+EET147Y0ZtNYIfSaPgdigPlKdiIxBiypO2IEOlDnioWHiOCZsj1xq8dbAdVCFbhSzKaf2J3YML7wFqsPenyC7x8Qzmnu1Bg2q4JZGmcJdNHclLP+3Q5fdM5cXBf01+l8X+QAttAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BkkxcZvu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BkkxcZvu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE10C4CEF5;
	Wed,  9 Jul 2025 22:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752099456;
	bh=3V1Ty3jguTTEuS7Jb0fxil/w1JYOw06+BSZU83PbK3A=;
	h=Date:To:From:Subject:From;
	b=BkkxcZvuuQAJWe1uUlGjCrhuBp3cErOGiUy9KdlkIL4fbs/MBFZUDhgo2xcRILSLA
	 EHc6BOsdzLOe+HbLs+Vz+aWXGwaYxDgf9/mW/EXpiYD6ROFsCpis9NAOngtGYJvREG
	 WQjqmF7S20jtcKL02a1Pod0Pj0eA385RG2hQdxqg=
Date: Wed, 09 Jul 2025 15:17:35 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,linux@jordanrome.com,david@redhat.com,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memoryc-use-folios-in-__access_remote_vm.patch added to mm-new branch
Message-Id: <20250709221736.5CE10C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory.c: use folios in __access_remote_vm()
has been added to the -mm mm-new branch.  Its filename is
     mm-memoryc-use-folios-in-__access_remote_vm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memoryc-use-folios-in-__access_remote_vm.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm/memory.c: use folios in __access_remote_vm()
Date: Wed, 9 Jul 2025 12:40:17 -0700

Use kmap_local_folio() instead of kmap_local_page().  Replaces 2 calls to
compound_head() with one.

This prepares us for the removal of unmap_and_put_page().

Link: https://lkml.kernel.org/r/20250709194017.927978-5-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jordan Rome <linux@jordanrome.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/memory.c~mm-memoryc-use-folios-in-__access_remote_vm
+++ a/mm/memory.c
@@ -6691,6 +6691,7 @@ static int __access_remote_vm(struct mm_
 	while (len) {
 		int bytes, offset;
 		void *maddr;
+		struct folio *folio;
 		struct vm_area_struct *vma = NULL;
 		struct page *page = get_user_page_vma_remote(mm, addr,
 							     gup_flags, &vma);
@@ -6722,21 +6723,22 @@ static int __access_remote_vm(struct mm_
 			if (bytes <= 0)
 				break;
 		} else {
+			folio = page_folio(page);
 			bytes = len;
 			offset = addr & (PAGE_SIZE-1);
 			if (bytes > PAGE_SIZE-offset)
 				bytes = PAGE_SIZE-offset;
 
-			maddr = kmap_local_page(page);
+			maddr = kmap_local_folio(folio, folio_page_idx(folio, page) * PAGE_SIZE);
 			if (write) {
 				copy_to_user_page(vma, page, addr,
 						  maddr + offset, buf, bytes);
-				set_page_dirty_lock(page);
+				folio_mark_dirty_lock(folio);
 			} else {
 				copy_from_user_page(vma, page, addr,
 						    buf, maddr + offset, bytes);
 			}
-			unmap_and_put_page(page, maddr);
+			folio_release_kmap(folio, maddr);
 		}
 		len -= bytes;
 		buf += bytes;
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-memoryc-use-folios-in-__copy_remote_vm_str.patch
mm-memoryc-use-folios-in-__access_remote_vm.patch
mm-remove-unmap_and_put_page.patch

