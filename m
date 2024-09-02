Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC26433C9
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247702; cv=none; b=uf7N+LB4D4DsnwOMtb3q90VgoRapzJs3opEutC+rKp0nGS2QpPBF9gaaThVzBAx5XWROjQ/yIbneBWD0yCLTWgIWjT4fCljzun/yc3RE31jbBdjwcvREz3XyWeopXDTpZNLLQEO2w0Nxz0ylyTEePl9g1OWM6jPvgbakwynvQ2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247702; c=relaxed/simple;
	bh=a4UHgEzUebc+cgFYqLiX6wPldgpTOPNgTHnMBl74HL0=;
	h=Date:To:From:Subject:Message-Id; b=ly5+kBDU+6rtDVXKoTtgXGc5uAud5+L/jeiPZwlwhrf7YJYRLaRpGUHHkhViNKS7YQ8roD6aTfEFHtMUb50L6eDPq9EY3Vy/y/pC+yBdj0jE3MbVyTOLMTTfMwcb7Zr2IpNdNZE0Yl4JBZ74YtoPIAlftIaBPQGb7VP37K4ufVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kRAZBRsz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kRAZBRsz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D45C4CEC2;
	Mon,  2 Sep 2024 03:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247702;
	bh=a4UHgEzUebc+cgFYqLiX6wPldgpTOPNgTHnMBl74HL0=;
	h=Date:To:From:Subject:From;
	b=kRAZBRszja2kHuTZkxT7mnHmnsKXbk8zqI8tBmNrL1M3cHPIIXuVQj8HYctWrOhNE
	 5BzCO4ExuJ1IUjpQi2qycqHvvcyh21Mh2QPv9UlPXLhUsN4ZYx678t3Qb4e3hOLyHr
	 2B40bWFBtlats+TJSXTnDBoHWu3S0EHELXhV/CIA=
Date: Sun, 01 Sep 2024 20:28:21 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,svens@linux.ibm.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,frankja@linux.ibm.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-simplify-arch_make_folio_accessible.patch removed from -mm tree
Message-Id: <20240902032822.20D45C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: simplify arch_make_folio_accessible()
has been removed from the -mm tree.  Its filename was
     mm-simplify-arch_make_folio_accessible.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
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

mm-rmap-use-folio-_mapcount-for-small-folios.patch
mm-always-inline-_compound_head-with-config_hugetlb_page_optimize_vmemmap=y.patch
selftests-mm-fix-charge_reserved_hugetlbsh-test.patch

