Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6540718C324
	for <mm-commits@vger.kernel.org>; Mon, 29 Jul 2024 21:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722287269; cv=none; b=LREaXyu0uoWUH/gurYeMMwzQ9zHr6SmNOrEpjmiDZ3vhvl6C+Q2PSaRxa/EkJQGnW6cmnuyQOdg+aAtb6C9Ffkkonm46mW1a8/EpNSnhYeTGkuidlW5pSFYdQdnw5rMuWCOwMCWwupCFHaGC8+EnNIkpVSiuh7ae54YlMiIszLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722287269; c=relaxed/simple;
	bh=a3o/czEG8CznXm2KIO0lB5qVOvdqZ2ZaFmvzcH4mj5M=;
	h=Date:To:From:Subject:Message-Id; b=Lu+nW4IvVMLNsZP5LvMYwSKyzMo/ifL7iXnTjfE7gMlWX5lhZDi83ZKaqDsBnetLHjZHrzDm/f54bwhrslPqPsyR4Hjw9zg19sqMWD7pb60z/QXi9ucAMBBOdUfNMSC5+dVNSmkhNCk0KJA8sTNRLT/ljZulG4AtrqMWyTMfrmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ObD76PHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ObD76PHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB305C32786;
	Mon, 29 Jul 2024 21:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722287268;
	bh=a3o/czEG8CznXm2KIO0lB5qVOvdqZ2ZaFmvzcH4mj5M=;
	h=Date:To:From:Subject:From;
	b=ObD76PHBHw+lYiKDhF5PWobtwjH3WsRq1gal9uF/PEcYxmKWhqyFPC17BqrLiUcAW
	 aB9PulBdGz29t85jAc+OecrifsrLZ4F8i7lU7keme9Ew94G9yt+WFq2iAy9tp5Gqhf
	 XwSCrOlvtvY/k40jqZeUUP0XUa2sI6mPutFQWTLU=
Date: Mon, 29 Jul 2024 14:07:48 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,svens@linux.ibm.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,frankja@linux.ibm.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-simplify-arch_make_folio_accessible.patch added to mm-unstable branch
Message-Id: <20240729210748.DB305C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: simplify arch_make_folio_accessible()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-simplify-arch_make_folio_accessible.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-simplify-arch_make_folio_accessible.patch

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
Subject: mm: simplify arch_make_folio_accessible()
Date: Mon, 29 Jul 2024 20:38:42 +0200

Patch series "mm: remove arch_make_page_accessible()".

Now that s390x implements arch_make_folio_accessible(), let's convert
remaining users to use arch_make_folio_accessible() instead so we can
remove arch_make_page_accessible().


This patch (of 3):

Now that s390x implements HAVE_ARCH_MAKE_FOLIO_ACCESSIBLE, let's turn
generic arch_make_folio_accessible() into a NOP: there are no other
targets that implement HAVE_ARCH_MAKE_PAGE_ACCESSIBLE but not
HAVE_ARCH_MAKE_FOLIO_ACCESSIBLE.

Link: https://lkml.kernel.org/r/20240729183844.388481-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240729183844.388481-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/include/linux/mm.h~mm-simplify-arch_make_folio_accessible
+++ a/include/linux/mm.h
@@ -2215,16 +2215,7 @@ static inline int arch_make_page_accessi
 #ifndef HAVE_ARCH_MAKE_FOLIO_ACCESSIBLE
 static inline int arch_make_folio_accessible(struct folio *folio)
 {
-	int ret;
-	long i, nr = folio_nr_pages(folio);
-
-	for (i = 0; i < nr; i++) {
-		ret = arch_make_page_accessible(folio_page(folio, i));
-		if (ret)
-			break;
-	}
-
-	return ret;
+	return 0;
 }
 #endif
 
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

