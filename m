Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221C413E02C
	for <mm-commits@vger.kernel.org>; Sat,  3 Aug 2024 05:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722663221; cv=none; b=nis7oFQCEtfu4Gp7F87Miq/mUGxZQgIHy6o6A7lXArj5aqmFNzD47cpbW6yRU1916+s7PHeLS1NlmQAb15DmgR8YlWKYc+ey5xcjp5j2AhPOLoyWxCJ/m0XffMwwYpTSE/gEDHzBHxZxvps3n+kKWMYR8raOsClWMU23DKfngyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722663221; c=relaxed/simple;
	bh=8uE1YV6mVi+bCXKiBRNfpip8ZiJDNHm+QxxIOOBF8YM=;
	h=Date:To:From:Subject:Message-Id; b=hpT/zOznc7SB45kVUEpATiAXv8RlW+pb//vTzPz49VnMNVRlWp0WkP9RGu0kZUovYancZkgL4rYp1TbNN2c0YhAFC4rZIHURhAcEPdTMahWDoK5/LcRqO9//CqPCyf0GgMPVHlxVyYyTmYP3iB0rGpGzlrGGYRmdY4BdhlQFeA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qGynk5yY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qGynk5yY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8A0C116B1;
	Sat,  3 Aug 2024 05:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722663220;
	bh=8uE1YV6mVi+bCXKiBRNfpip8ZiJDNHm+QxxIOOBF8YM=;
	h=Date:To:From:Subject:From;
	b=qGynk5yYG5pgohz6HcNVJ1zUjwkN+/DNJseaG2r4WnXyaGH0+/XFU6sOBMbVEnsK6
	 ON8BW83isYyJX024BybiQI7hCMSHW2FsN1uAa0uYRNr3w7UGEqPfO3tXdo6qA9vusy
	 wNijy5RHDvS7pgLqR9SczqSVw/aQ9zszfSSnXi8I=
Date: Fri, 02 Aug 2024 22:33:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,svens@linux.ibm.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,corbet@lwn.net,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-convert-add_page_for_migration-from-follow_page-to-folio_walk.patch added to mm-unstable branch
Message-Id: <20240803053340.AD8A0C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: convert add_page_for_migration() from follow_page() to folio_walk
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-convert-add_page_for_migration-from-follow_page-to-folio_walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-convert-add_page_for_migration-from-follow_page-to-folio_walk.patch

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
Subject: mm/migrate: convert add_page_for_migration() from follow_page() to folio_walk
Date: Fri, 2 Aug 2024 17:55:17 +0200

Let's use folio_walk instead, so we can avoid taking a folio reference
when we won't even be trying to migrate the folio and to get rid of
another follow_page()/FOLL_DUMP user.  Use FW_ZEROPAGE so we can return
"-EFAULT" for it as documented.

We now perform the folio_likely_mapped_shared() check under PTL, which is
what we want: relying on the mapcount and friends after dropping the PTL
does not make too much sense, as the page can get unmapped concurrently
from this process.

Further, we perform the folio isolation under PTL, similar to how we
handle it for MADV_PAGEOUT.

The possible return values for follow_page() were confusing, especially
with FOLL_DUMP set. We'll handle it like documented in the man page:
 * -EFAULT: This is a zero page or the memory area is not mapped by the
    process.
 * -ENOENT: The page is not present.

We'll keep setting -ENOENT for ZONE_DEVICE.  Maybe not the right thing to
do, but it likely doesn't really matter (just like for weird devmap,
whereby we fake "not present").

The other errros are left as is, and match the documentation in the man
page.

While at it, rename add_page_for_migration() to add_folio_for_migration().

We'll lose the "secretmem" check, but that shouldn't really matter because
these folios cannot ever be migrated.  Should vma_migratable() refuse
these VMAs?  Maybe.

Link: https://lkml.kernel.org/r/20240802155524.517137-5-david@redhat.com
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

 mm/migrate.c |  100 ++++++++++++++++++++++---------------------------
 1 file changed, 45 insertions(+), 55 deletions(-)

--- a/mm/migrate.c~mm-migrate-convert-add_page_for_migration-from-follow_page-to-folio_walk
+++ a/mm/migrate.c
@@ -2112,76 +2112,66 @@ static int do_move_pages_to_node(struct
 	return err;
 }
 
+static int __add_folio_for_migration(struct folio *folio, int node,
+		struct list_head *pagelist, bool migrate_all)
+{
+	if (is_zero_folio(folio) || is_huge_zero_folio(folio))
+		return -EFAULT;
+
+	if (folio_is_zone_device(folio))
+		return -ENOENT;
+
+	if (folio_nid(folio) == node)
+		return 0;
+
+	if (folio_likely_mapped_shared(folio) && !migrate_all)
+		return -EACCES;
+
+	if (folio_test_hugetlb(folio)) {
+		if (isolate_hugetlb(folio, pagelist))
+			return 1;
+	} else if (folio_isolate_lru(folio)) {
+		list_add_tail(&folio->lru, pagelist);
+		node_stat_mod_folio(folio,
+			NR_ISOLATED_ANON + folio_is_file_lru(folio),
+			folio_nr_pages(folio));
+		return 1;
+	}
+	return -EBUSY;
+}
+
 /*
- * Resolves the given address to a struct page, isolates it from the LRU and
+ * Resolves the given address to a struct folio, isolates it from the LRU and
  * puts it to the given pagelist.
  * Returns:
- *     errno - if the page cannot be found/isolated
+ *     errno - if the folio cannot be found/isolated
  *     0 - when it doesn't have to be migrated because it is already on the
  *         target node
  *     1 - when it has been queued
  */
-static int add_page_for_migration(struct mm_struct *mm, const void __user *p,
+static int add_folio_for_migration(struct mm_struct *mm, const void __user *p,
 		int node, struct list_head *pagelist, bool migrate_all)
 {
 	struct vm_area_struct *vma;
-	unsigned long addr;
-	struct page *page;
+	struct folio_walk fw;
 	struct folio *folio;
-	int err;
+	unsigned long addr;
+	int err = -EFAULT;
 
 	mmap_read_lock(mm);
 	addr = (unsigned long)untagged_addr_remote(mm, p);
 
-	err = -EFAULT;
 	vma = vma_lookup(mm, addr);
-	if (!vma || !vma_migratable(vma))
-		goto out;
-
-	/* FOLL_DUMP to ignore special (like zero) pages */
-	page = follow_page(vma, addr, FOLL_GET | FOLL_DUMP);
-
-	err = PTR_ERR(page);
-	if (IS_ERR(page))
-		goto out;
-
-	err = -ENOENT;
-	if (!page)
-		goto out;
-
-	folio = page_folio(page);
-	if (folio_is_zone_device(folio))
-		goto out_putfolio;
-
-	err = 0;
-	if (folio_nid(folio) == node)
-		goto out_putfolio;
-
-	err = -EACCES;
-	if (folio_likely_mapped_shared(folio) && !migrate_all)
-		goto out_putfolio;
-
-	err = -EBUSY;
-	if (folio_test_hugetlb(folio)) {
-		if (isolate_hugetlb(folio, pagelist))
-			err = 1;
-	} else {
-		if (!folio_isolate_lru(folio))
-			goto out_putfolio;
-
-		err = 1;
-		list_add_tail(&folio->lru, pagelist);
-		node_stat_mod_folio(folio,
-			NR_ISOLATED_ANON + folio_is_file_lru(folio),
-			folio_nr_pages(folio));
+	if (vma && vma_migratable(vma)) {
+		folio = folio_walk_start(&fw, vma, addr, FW_ZEROPAGE);
+		if (folio) {
+			err = __add_folio_for_migration(folio, node, pagelist,
+							migrate_all);
+			folio_walk_end(&fw, vma);
+		} else {
+			err = -ENOENT;
+		}
 	}
-out_putfolio:
-	/*
-	 * Either remove the duplicate refcount from folio_isolate_lru()
-	 * or drop the folio ref if it was not isolated.
-	 */
-	folio_put(folio);
-out:
 	mmap_read_unlock(mm);
 	return err;
 }
@@ -2275,8 +2265,8 @@ static int do_pages_move(struct mm_struc
 		 * Errors in the page lookup or isolation are not fatal and we simply
 		 * report them via status
 		 */
-		err = add_page_for_migration(mm, p, current_node, &pagelist,
-					     flags & MPOL_MF_MOVE_ALL);
+		err = add_folio_for_migration(mm, p, current_node, &pagelist,
+					      flags & MPOL_MF_MOVE_ALL);
 
 		if (err > 0) {
 			/* The page is successfully queued for migration */
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

