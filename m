Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14E94AEF7
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247744; cv=none; b=SC/8/s9dkVl8RaFh+ep38tJegLLPwdBds/GtckxRxzZGtz9QwYrKMIDvSc9GpfDO+mwhgiD9RfxuEtXyOUfCeUlsd7NzPoA27xuSGHEN06RuNkJ6rwQLGeNRp1Ub12eX85zHoVMw2kktFEjSBlBG4OBgIlPt/KbatOYjYZQ8r2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247744; c=relaxed/simple;
	bh=iBGWNBhGKKhpbIUoS2yGBInn4+Bu9Bx9TA5/9C5obsY=;
	h=Date:To:From:Subject:Message-Id; b=nz0jUCUyVCEmjP1tf4nLVtjnUr9myfUwNLPl5EEBPzgF8X+MUDncTjy1SNX0Fqe/VHTjX4lhzZntDd4HpUsAAFoH2O0xgDh2XyRnUTHP1Y3tOMh8hOpaCnR2TM547kJiWsBrmoxfG5P8qFiv3Fv0o1h4lP9DLWPdop+B3tg6L3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M+zMwtD5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M+zMwtD5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD0DC4CEC2;
	Mon,  2 Sep 2024 03:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247743;
	bh=iBGWNBhGKKhpbIUoS2yGBInn4+Bu9Bx9TA5/9C5obsY=;
	h=Date:To:From:Subject:From;
	b=M+zMwtD56lUELItke3u94V8VpeLIL6QAbKGuIEzprgKYMB5ngQgGzvrh0U1CHpLDl
	 uszDfbJHLMMbLKBXtiZQT8x2HH9uqkuXmBRtMQlml86rUiwVetbLm+mMzGkKibOOxF
	 Y2V0c15Kr8kVnjf2uBmCl27EWZqH33zpa4sXH8DQ=
Date: Sun, 01 Sep 2024 20:29:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,svens@linux.ibm.com,ryan.roberts@arm.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,corbet@lwn.net,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-convert-do_pages_stat_array-from-follow_page-to-folio_walk.patch removed from -mm tree
Message-Id: <20240902032903.BDD0DC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: convert do_pages_stat_array() from follow_page() to folio_walk
has been removed from the -mm tree.  Its filename was
     mm-migrate-convert-do_pages_stat_array-from-follow_page-to-folio_walk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
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

mm-rmap-use-folio-_mapcount-for-small-folios.patch
mm-always-inline-_compound_head-with-config_hugetlb_page_optimize_vmemmap=y.patch
selftests-mm-fix-charge_reserved_hugetlbsh-test.patch

