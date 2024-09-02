Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B2E5466B
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247751; cv=none; b=ruVGwMAOktJjB4GhxFIn6IYKuv+tyPh/iTiHnktUn/l8EVn+MvwtbqA7lK8K+YolpQs6h8krQPAU5foW/Ta9U0cAQP/jGQ/+WGLFLykyZzyYunqlI7AyYw5W3qeBEmpcO9+6nYJkf8Kr5PG4afakBLkD3Mb1Sn0Jr7ls1lyDz5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247751; c=relaxed/simple;
	bh=29/LedsTup7HDx1bvf/YTVptQJVuTeVzaSFTA79QYTI=;
	h=Date:To:From:Subject:Message-Id; b=PcuHmwKtR86nadlBcFOX3/uPkQMP+6sGtS0mfPxuZMYSDzFY5kpI31hV99aPAk55YkNMi99+c1dBIfYnI7+sUB6fWIaxEDmn1N6ys9OnfRBHUt3gEaLlUHn4ctqaRi+EL43zIb3ZAQuuzg27utdhas3AL6y3yZZUakTsgFjfFMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RYgSKN00; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RYgSKN00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186DCC4CEC2;
	Mon,  2 Sep 2024 03:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247751;
	bh=29/LedsTup7HDx1bvf/YTVptQJVuTeVzaSFTA79QYTI=;
	h=Date:To:From:Subject:From;
	b=RYgSKN009ZriP6HwBlNb9y57Zmd+CN+ouo9aFQzx2xx//A6285Tv5D6sfe1p9Q3su
	 ARD+Q66yHRLKmTvV2aOB7AVw0BERb7LXfMHkEk8vuM87kI/9AP3t3rS7W+q1Gk351z
	 1Pn/2+05lphj1c0bDbfLQvzI3Tyn5w+o7BEO7UMc=
Date: Sun, 01 Sep 2024 20:29:10 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,svens@linux.ibm.com,ryan.roberts@arm.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,corbet@lwn.net,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-uv-convert-gmap_destroy_page-from-follow_page-to-folio_walk.patch removed from -mm tree
Message-Id: <20240902032911.186DCC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/uv: convert gmap_destroy_page() from follow_page() to folio_walk
has been removed from the -mm tree.  Its filename was
     s390-uv-convert-gmap_destroy_page-from-follow_page-to-folio_walk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
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

mm-rmap-use-folio-_mapcount-for-small-folios.patch
mm-always-inline-_compound_head-with-config_hugetlb_page_optimize_vmemmap=y.patch
selftests-mm-fix-charge_reserved_hugetlbsh-test.patch

