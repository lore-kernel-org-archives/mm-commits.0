Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22B942A82
	for <mm-commits@vger.kernel.org>; Sat,  3 Aug 2024 05:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722663219; cv=none; b=mE4THLajTWQDIKNa2xwBj8Ism2ybwjwJUc3NWXVP8Vp9VU+AZ+botjvJFOOPL/xUjw/dyQTUja5OoAbNLyeoF7pASPvkiZYgNQbU1GZGGaUR38ZeH1jEa9t0cjEuWyFZip6X6hEdmevEhc7EdSdTKf2JcfLiO/KPAQiSUKnhxoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722663219; c=relaxed/simple;
	bh=4MDmwm12we8nEGijOAzOxkuDEI8MjmyyUNlokmwee/E=;
	h=Date:To:From:Subject:Message-Id; b=ndesM2MktI1ueh+1oyAAe2yDMqjaKAg0tiwOZEOsdTtQ3FS+UFQEALvKV0+Lwy5ucxgKKk41Bu3dAi5rOMMqi8DyPbZRwuOFcG2BFT7MOwMV8pf8OIkSqlcvgkvkjtcwrNYZJDxJMZIyMWswzmJt/br+szjGV9aRhhEXk1tEGTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OIR4ZKlv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OIR4ZKlv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EEEBC116B1;
	Sat,  3 Aug 2024 05:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722663219;
	bh=4MDmwm12we8nEGijOAzOxkuDEI8MjmyyUNlokmwee/E=;
	h=Date:To:From:Subject:From;
	b=OIR4ZKlvxa2Bd9nb3CgRhzq4epgX+RZCLxHO4orMDm+mfeqPYXr4R6lY0L8TNtY7o
	 IfEHFQW1EqVx6wFEiBrA2q31kAS1FWU6LAd5Mqxia4AVDNp3ZQnw5Bm9jo213DJ3/d
	 gU/UJCEspDBtdlambEzsm2t7hgEqk9K0COb3sZyg=
Date: Fri, 02 Aug 2024 22:33:38 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,svens@linux.ibm.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,corbet@lwn.net,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-convert-do_pages_stat_array-from-follow_page-to-folio_walk.patch added to mm-unstable branch
Message-Id: <20240803053339.1EEEBC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: convert do_pages_stat_array() from follow_page() to folio_walk
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-convert-do_pages_stat_array-from-follow_page-to-folio_walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-convert-do_pages_stat_array-from-follow_page-to-folio_walk.patch

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
Subject: mm/migrate: convert do_pages_stat_array() from follow_page() to folio_walk
Date: Fri, 2 Aug 2024 17:55:16 +0200

Let's use folio_walk instead, so we can avoid taking a folio reference
just to read the nid and get rid of another follow_page()/FOLL_DUMP user. 
Use FW_ZEROPAGE so we can return "-EFAULT" for it as documented.

The possible return values for follow_page() were confusing, especially
with FOLL_DUMP set.  We'll handle it like documented in the man page:

* -EFAULT: This is a zero page or the memory area is not mapped by the
   process.
* -ENOENT: The page is not present.

We'll keep setting -ENOENT for ZONE_DEVICE.  Maybe not the right thing to
do, but it likely doesn't really matter (just like for weird devmap,
whereby we fake "not present").

Note that the other errors (-EACCESS, -EBUSY, -EIO, -EINVAL, -ENOMEM) so
far only applied when actually moving pages, not when only querying stats.

We'll effectively drop the "secretmem" check we had in follow_page(), but
that shouldn't really matter here, we're not accessing folio/page content
after all.

Link: https://lkml.kernel.org/r/20240802155524.517137-4-david@redhat.com
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

 mm/migrate.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

--- a/mm/migrate.c~mm-migrate-convert-do_pages_stat_array-from-follow_page-to-folio_walk
+++ a/mm/migrate.c
@@ -50,6 +50,7 @@
 #include <linux/random.h>
 #include <linux/sched/sysctl.h>
 #include <linux/memory-tiers.h>
+#include <linux/pagewalk.h>
 
 #include <asm/tlbflush.h>
 
@@ -2331,28 +2332,26 @@ static void do_pages_stat_array(struct m
 	for (i = 0; i < nr_pages; i++) {
 		unsigned long addr = (unsigned long)(*pages);
 		struct vm_area_struct *vma;
-		struct page *page;
+		struct folio_walk fw;
+		struct folio *folio;
 		int err = -EFAULT;
 
 		vma = vma_lookup(mm, addr);
 		if (!vma)
 			goto set_status;
 
-		/* FOLL_DUMP to ignore special (like zero) pages */
-		page = follow_page(vma, addr, FOLL_GET | FOLL_DUMP);
-
-		err = PTR_ERR(page);
-		if (IS_ERR(page))
-			goto set_status;
-
-		err = -ENOENT;
-		if (!page)
-			goto set_status;
-
-		if (!is_zone_device_page(page))
-			err = page_to_nid(page);
-
-		put_page(page);
+		folio = folio_walk_start(&fw, vma, addr, FW_ZEROPAGE);
+		if (folio) {
+			if (is_zero_folio(folio) || is_huge_zero_folio(folio))
+				err = -EFAULT;
+			else if (folio_is_zone_device(folio))
+				err = -ENOENT;
+			else
+				err = folio_nid(folio);
+			folio_walk_end(&fw, vma);
+		} else {
+			err = -ENOENT;
+		}
 set_status:
 		*status = err;
 
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

