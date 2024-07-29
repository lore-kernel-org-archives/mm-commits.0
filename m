Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D6818E741
	for <mm-commits@vger.kernel.org>; Mon, 29 Jul 2024 21:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722287273; cv=none; b=W82rvul9zCsl1ZD1FZD8HBhhMlemO4yiUOnl9e3jFTc9jqSteCDlFctTB8TlX6shlzK5Poi/0JpUvIuZ3vGl7BKah4WUYw8V6zfZiiJwkhSO/8JmK1vMDvJkFkdxn7M3cUHg0DAVikQzA8ZCqhI3QhcterXNrhgdI4vh8/H4Gzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722287273; c=relaxed/simple;
	bh=ql0gifWscHY7Of9fzoahfolqjVVMz2wpoI/u1C/XaSM=;
	h=Date:To:From:Subject:Message-Id; b=jA2PqDTWtSdziZV6vV34qkSXeQBS8d4WD8YGn/81Rx200Jd3v/OSxjOI2IbUtTgtyxjC8fKuLaFdsEL5JNmPsIGDZ5ZIqT7fGAI/hqJQj3cQjAXOz9HuNap5JBePdqtUPO5PTSGhzWqXjvmaatcAZFEQnRJlsj02KrlI0OAGWtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gTezwB43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gTezwB43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D335FC32786;
	Mon, 29 Jul 2024 21:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722287272;
	bh=ql0gifWscHY7Of9fzoahfolqjVVMz2wpoI/u1C/XaSM=;
	h=Date:To:From:Subject:From;
	b=gTezwB43Tzomh0rifeP10UP1Qo9lRM3sfrkWM4cmCCRFHIlEgmqYNSlzbrZimB3Ib
	 C21D1UsCZ1cxWTOZpVZGMP87RXSc9n1CRDEILjJPLR60InL2SEpzzZnlqclp5lXMtn
	 8EXjFETz7L99joQHKpa16lcy4pbNdv2hHZw4UM/Q=
Date: Mon, 29 Jul 2024 14:07:52 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,svens@linux.ibm.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,frankja@linux.ibm.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-uv-drop-arch_make_page_accessible.patch added to mm-unstable branch
Message-Id: <20240729210752.D335FC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390/uv: drop arch_make_page_accessible()
has been added to the -mm mm-unstable branch.  Its filename is
     s390-uv-drop-arch_make_page_accessible.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-uv-drop-arch_make_page_accessible.patch

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
Subject: s390/uv: drop arch_make_page_accessible()
Date: Mon, 29 Jul 2024 20:38:44 +0200

All code was converted to using arch_make_folio_accessible(), let's drop
arch_make_page_accessible().

Link: https://lkml.kernel.org/r/20240729183844.388481-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
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

mm-let-pte_lockptr-consume-a-pte_t-pointer.patch
mm-hugetlb-fix-hugetlb-vs-core-mm-pt-locking.patch
mm-turn-use_split_pte_ptlocks-use_split_pte_ptlocks-into-kconfig-options.patch
mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks.patch
powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used.patch
mm-simplify-arch_make_folio_accessible.patch
mm-gup-convert-to-arch_make_folio_accessible.patch
s390-uv-drop-arch_make_page_accessible.patch

