Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8F5320E
	for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 17:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709054492; cv=none; b=jQaXD0PDH9cvEiMc1Du/WcP/6P66+8JjJ7JYyLt5tD202Ysu0A8Ncr+mLX4VNhpmuNt1zShp43P4MLS6lFhyhjkloE/TutcIoAz5MkmtY5nJNZ65iz0O7ab9gN95AFGlLn3iQVRoNK4K4a3q8w4EItw2sRhpNH3uMDjprNa6r+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709054492; c=relaxed/simple;
	bh=yP7H82swOzCGBHzs+DbnKuFgPNZ7K/aaADyHm6weGmY=;
	h=Date:To:From:Subject:Message-Id; b=XgY8wWXrPP1DAXFSL5cBTrwO798O3ncAllsdx9aIfhkER+rPYIIg74raUxEmaBZMiKHlfp4hUGpXCe1ArLLmxxdCbrQ53KmP3oTYsRcRK6qXD/0uyjzIupyWkI+HFr/Gh9IYAwo2Rynb/75z6GCPQ55h4AaeEUS/NjDxHerZVrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ocoCELde; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ocoCELde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E50C433C7;
	Tue, 27 Feb 2024 17:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709054492;
	bh=yP7H82swOzCGBHzs+DbnKuFgPNZ7K/aaADyHm6weGmY=;
	h=Date:To:From:Subject:From;
	b=ocoCELdeztXmsxuj5LAQIDy5Z4wBSRyAWD3ecL3nqKNAb9zCZX/pVb+1UyH7apvnb
	 n7Q/6mqC0pOjX67zNTqc+twAgJ9nthb9rEcI7hAmwm5GMfi+YIJKbtFPAlf2Qbt4EH
	 yaId5nwc6guLMa8T0P4SqZGBQutjikI5mrDkXEZo=
Date: Tue, 27 Feb 2024 09:21:31 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-total_mapcount.patch added to mm-unstable branch
Message-Id: <20240227172131.D4E50C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove total_mapcount()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-total_mapcount.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-total_mapcount.patch

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
Subject: mm: remove total_mapcount()
Date: Mon, 26 Feb 2024 15:13:24 +0100

All users of total_mapcount() are gone, let's remove it.

Link: https://lkml.kernel.org/r/20240226141324.278526-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/include/linux/mm.h~mm-remove-total_mapcount
+++ a/include/linux/mm.h
@@ -1183,7 +1183,7 @@ static inline int is_vmalloc_or_module_a
  * How many times the entire folio is mapped as a single unit (eg by a
  * PMD or PUD entry).  This is probably not what you want, except for
  * debugging purposes - it does not include PTE-mapped sub-pages; look
- * at folio_mapcount() or page_mapcount() or total_mapcount() instead.
+ * at folio_mapcount() or page_mapcount() instead.
  */
 static inline int folio_entire_mapcount(struct folio *folio)
 {
@@ -1243,13 +1243,6 @@ static inline int folio_mapcount(struct
 	return folio_total_mapcount(folio);
 }
 
-static inline int total_mapcount(struct page *page)
-{
-	if (likely(!PageCompound(page)))
-		return atomic_read(&page->_mapcount) + 1;
-	return folio_total_mapcount(page_folio(page));
-}
-
 static inline bool folio_large_is_mapped(struct folio *folio)
 {
 	/*
_

Patches currently in -mm which might be from david@redhat.com are

mm-memfd-refactor-memfd_tag_pins-and-memfd_wait_for_pins.patch
mm-remove-total_mapcount.patch

