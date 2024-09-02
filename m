Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C7443AB4
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247704; cv=none; b=mqpHy0VMmvEvJKbEuUO36dFoXJIiQswajYU4WwNE8veQXY+C0JUcC5qGrJ9R1qrn5BtX0+Uf8oO5ALItgaApOISM5xeKqN1xyK1XtA4D2yyZuiwX4CovGhIjg5PxdpGAzmprTCmBVaAuz4O9pkSG3r5lsHr5wuvaB7mq1Ct6Esw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247704; c=relaxed/simple;
	bh=m5YObLt/FDdOvQ5f+oCsOSGgs9dqXqKruMWoBnWTNZk=;
	h=Date:To:From:Subject:Message-Id; b=IdvYQ1DMaRy5mxMYwYAvBcD9EUITwnCxP0rKLPSYVxUviXgyS0mStF1MuCgUt/bhgPXFLH5cSrg+7Jp3FkZRKiWHdiTE0PVmPiqJDT0z335hI9PagfhgOIlWITT7X7mrMPuiRZDuSYpOoW1QaCQnejnMIBsI3psYnTYecU+GiJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p0y8yCvZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p0y8yCvZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB16C4CEC2;
	Mon,  2 Sep 2024 03:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247704;
	bh=m5YObLt/FDdOvQ5f+oCsOSGgs9dqXqKruMWoBnWTNZk=;
	h=Date:To:From:Subject:From;
	b=p0y8yCvZ1VpjLFQSycFRZGFENhVgl+p2s74g/p72VGWIH/dFH2pk1p7tNnDvMmd9y
	 NrogXwnAyAFcoIv9rsDinGMR7xr/U2Fu3iggd3PzjgGd4XC3BTb7d5ACL3jcH1BpZc
	 Gv0jt2gsfnO7AAecFT8KRNS99mEltEKFABBTRzqM=
Date: Sun, 01 Sep 2024 20:28:23 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,svens@linux.ibm.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,frankja@linux.ibm.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-uv-drop-arch_make_page_accessible.patch removed from -mm tree
Message-Id: <20240902032824.5CB16C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/uv: drop arch_make_page_accessible()
has been removed from the -mm tree.  Its filename was
     s390-uv-drop-arch_make_page_accessible.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: s390/uv: drop arch_make_page_accessible()
Date: Mon, 29 Jul 2024 20:38:44 +0200

All code was converted to using arch_make_folio_accessible(), let's drop
arch_make_page_accessible().

Link: https://lkml.kernel.org/r/20240729183844.388481-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/page.h |    2 --
 arch/s390/kernel/uv.c        |    5 -----
 include/linux/mm.h           |    7 -------
 3 files changed, 14 deletions(-)

--- a/arch/s390/include/asm/page.h~s390-uv-drop-arch_make_page_accessible
+++ a/arch/s390/include/asm/page.h
@@ -176,8 +176,6 @@ static inline int devmem_is_allowed(unsi
 
 int arch_make_folio_accessible(struct folio *folio);
 #define HAVE_ARCH_MAKE_FOLIO_ACCESSIBLE
-int arch_make_page_accessible(struct page *page);
-#define HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
 
 struct vm_layout {
 	unsigned long kaslr_offset;
--- a/arch/s390/kernel/uv.c~s390-uv-drop-arch_make_page_accessible
+++ a/arch/s390/kernel/uv.c
@@ -548,11 +548,6 @@ int arch_make_folio_accessible(struct fo
 }
 EXPORT_SYMBOL_GPL(arch_make_folio_accessible);
 
-int arch_make_page_accessible(struct page *page)
-{
-	return arch_make_folio_accessible(page_folio(page));
-}
-EXPORT_SYMBOL_GPL(arch_make_page_accessible);
 static ssize_t uv_query_facilities(struct kobject *kobj,
 				   struct kobj_attribute *attr, char *buf)
 {
--- a/include/linux/mm.h~s390-uv-drop-arch_make_page_accessible
+++ a/include/linux/mm.h
@@ -2205,13 +2205,6 @@ static inline bool folio_likely_mapped_s
 	return atomic_read(&folio->_mapcount) > 0;
 }
 
-#ifndef HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
-static inline int arch_make_page_accessible(struct page *page)
-{
-	return 0;
-}
-#endif
-
 #ifndef HAVE_ARCH_MAKE_FOLIO_ACCESSIBLE
 static inline int arch_make_folio_accessible(struct folio *folio)
 {
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-use-folio-_mapcount-for-small-folios.patch
mm-always-inline-_compound_head-with-config_hugetlb_page_optimize_vmemmap=y.patch
selftests-mm-fix-charge_reserved_hugetlbsh-test.patch

