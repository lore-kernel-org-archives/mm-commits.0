Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE5242A82
	for <mm-commits@vger.kernel.org>; Sat,  3 Aug 2024 05:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722663227; cv=none; b=cJogowSVAufrefov23qz55W5+EM54VViHADsgMLe8D1MkB3mP9hdKr1lqtiVEwLOowj3GtQgZcfVoMG58x4d37cymzt+Fq6QU7CL5F8jcRM9kvJwCy9naBauKTXh+1uKdepwNoZUd/ewc+ry67woZgtnevY66xmuvNYkizGL2ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722663227; c=relaxed/simple;
	bh=QlFJc8JD9rwnSsbkcZwQsxzpRqEIGoQvlTLs0an7JpY=;
	h=Date:To:From:Subject:Message-Id; b=OIZwOpVt+Nl9N2ZDD/yRUVbe1POr7anWg4f90qMr3zqRwli1kTAdUiVBzZ54ji6lfc5xwfGLpHy0+oqOTzlyZSLSf/0MJu/2ylWa2TQFOD/g1UXfcCReiqQaSpGQ3fxdI9kNbGpivNRvwBbe3nZI204d0ec33p73dZftQB/ENf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xh0iOyBp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xh0iOyBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EAABC116B1;
	Sat,  3 Aug 2024 05:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722663227;
	bh=QlFJc8JD9rwnSsbkcZwQsxzpRqEIGoQvlTLs0an7JpY=;
	h=Date:To:From:Subject:From;
	b=Xh0iOyBptTPfpAs5hdjfFn1evbITGmHIPtJG9TyTPCTVgmX+lUyp7tSkgYMQq+SJo
	 n3sslmL0raZaw5P9lwcyKyDVqh1Co73A7z6UVbY3xqu+JwYKKUPu1AXIn99rDCLN4e
	 2gI/IBpIfxEfULpBgCe2QzOi5hh2nhzBY4xPfkuo=
Date: Fri, 02 Aug 2024 22:33:47 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,svens@linux.ibm.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,corbet@lwn.net,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-uv-convert-gmap_destroy_page-from-follow_page-to-folio_walk.patch added to mm-unstable branch
Message-Id: <20240803053347.9EAABC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390/uv: convert gmap_destroy_page() from follow_page() to folio_walk
has been added to the -mm mm-unstable branch.  Its filename is
     s390-uv-convert-gmap_destroy_page-from-follow_page-to-folio_walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-uv-convert-gmap_destroy_page-from-follow_page-to-folio_walk.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: s390/uv: convert gmap_destroy_page() from follow_page() to folio_walk
Date: Fri, 2 Aug 2024 17:55:21 +0200

Let's get rid of another follow_page() user and perform the UV calls under
PTL -- which likely should be fine.

No need for an additional reference while holding the PTL:
uv_destroy_folio() and uv_convert_from_secure_folio() raise the refcount,
so any concurrent make_folio_secure() would see an unexpted reference and
cannot set PG_arch_1 concurrently.

Do we really need a writable PTE?  Likely yes, because the "destroy" part
is, in comparison to the export, a destructive operation.  So we'll keep
the writability check for now.

We'll lose the secretmem check from follow_page().  Likely we don't care
about that here.

Link: https://lkml.kernel.org/r/20240802155524.517137-9-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/uv.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/arch/s390/kernel/uv.c~s390-uv-convert-gmap_destroy_page-from-follow_page-to-folio_walk
+++ a/arch/s390/kernel/uv.c
@@ -14,6 +14,7 @@
 #include <linux/memblock.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
+#include <linux/pagewalk.h>
 #include <asm/facility.h>
 #include <asm/sections.h>
 #include <asm/uv.h>
@@ -462,9 +463,9 @@ EXPORT_SYMBOL_GPL(gmap_convert_to_secure
 int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr)
 {
 	struct vm_area_struct *vma;
+	struct folio_walk fw;
 	unsigned long uaddr;
 	struct folio *folio;
-	struct page *page;
 	int rc;
 
 	rc = -EFAULT;
@@ -483,11 +484,15 @@ int gmap_destroy_page(struct gmap *gmap,
 		goto out;
 
 	rc = 0;
-	/* we take an extra reference here */
-	page = follow_page(vma, uaddr, FOLL_WRITE | FOLL_GET);
-	if (IS_ERR_OR_NULL(page))
+	folio = folio_walk_start(&fw, vma, uaddr, 0);
+	if (!folio)
 		goto out;
-	folio = page_folio(page);
+	/*
+	 * See gmap_make_secure(): large folios cannot be secure. Small
+	 * folio implies FW_LEVEL_PTE.
+	 */
+	if (folio_test_large(folio) || !pte_write(fw.pte))
+		goto out_walk_end;
 	rc = uv_destroy_folio(folio);
 	/*
 	 * Fault handlers can race; it is possible that two CPUs will fault
@@ -500,7 +505,8 @@ int gmap_destroy_page(struct gmap *gmap,
 	 */
 	if (rc)
 		rc = uv_convert_from_secure_folio(folio);
-	folio_put(folio);
+out_walk_end:
+	folio_walk_end(&fw, vma);
 out:
 	mmap_read_unlock(gmap->mm);
 	return rc;
_

Patches currently in -mm which might be from david@redhat.com are

mm-turn-use_split_pte_ptlocks-use_split_pte_ptlocks-into-kconfig-options.patch
mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks.patch
powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used.patch
mm-simplify-arch_make_folio_accessible.patch
mm-gup-convert-to-arch_make_folio_accessible.patch
s390-uv-drop-arch_make_page_accessible.patch
mm-hugetlb-remove-hugetlb_follow_page_mask-leftover.patch
mm-rmap-cleanup-partially-mapped-handling-in-__folio_remove_rmap.patch
mm-clarify-folio_likely_mapped_shared-documentation-for-ksm-folios.patch
mm-provide-vm_normal_pagefolio_pmd-with-config_pgtable_has_huge_leaves.patch
mm-pagewalk-introduce-folio_walk_start-folio_walk_end.patch
mm-migrate-convert-do_pages_stat_array-from-follow_page-to-folio_walk.patch
mm-migrate-convert-add_page_for_migration-from-follow_page-to-folio_walk.patch
mm-ksm-convert-get_mergeable_page-from-follow_page-to-folio_walk.patch
mm-ksm-convert-scan_get_next_rmap_item-from-follow_page-to-folio_walk.patch
mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk.patch
s390-uv-convert-gmap_destroy_page-from-follow_page-to-folio_walk.patch
s390-mm-fault-convert-do_secure_storage_access-from-follow_page-to-folio_walk.patch
mm-remove-follow_page.patch
mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch

