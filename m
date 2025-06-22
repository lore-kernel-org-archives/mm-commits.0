Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DA21F542E
	for <mm-commits@vger.kernel.org>; Sun, 22 Jun 2025 18:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750617819; cv=none; b=EXZLavzYNndax60gK7G2403rakVn8Ws3M6EdgBwDmL5pqYDOzyPifhDHY4rX4K60ha7DgcmFKRBLzX6NqkeJ7YyTHGi0pyaZlWI2JdUj/CFpce2/l0IToCMxcATtDRvvW5AUGqly7XtDLQnbqTM97NkPhHPBHqrLSg12pAZoJrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750617819; c=relaxed/simple;
	bh=DejTXmPqS99xMaChI7LHIPVZ7QYXaWUOafRq0hF61Mg=;
	h=Date:To:From:Subject:Message-Id; b=VxHS1tpusL7J5MufQU+AIiAoup1NWT0sEazWH1Dyh5p3Tj8QZH4dje+hL4xdbOVX0FqC/DkUMarXE6ZgcJtvO5DI9PNmiSnerAqNgYdaSyrps4NMBUGKetM0z300d9a3wpKKICIwREATY1s4bgsXaZ+oRwFTL0jPmqjIrcEWmhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uGzqHM+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uGzqHM+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB16FC4CEE3;
	Sun, 22 Jun 2025 18:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750617818;
	bh=DejTXmPqS99xMaChI7LHIPVZ7QYXaWUOafRq0hF61Mg=;
	h=Date:To:From:Subject:From;
	b=uGzqHM+Vb7OljDtRctghDUCBecwjKtFpkYEYQdmALNhsRDVL+BZTZnhR16oqTdLxV
	 cDbzxVRNAHijzcp+3Zqkor3ke8WiO/DZTDNVRcyUbKif25S/t0wqgn0XC4FqBCqlmR
	 xSt8HVnEjr0OcL3PdFAl8H7HZq36Z1PDjZV4So0g=
Date: Sun, 22 Jun 2025 11:43:38 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-add-__filemap_get_folio_mpol-fix.patch added to mm-new branch
Message-Id: <20250622184338.BB16FC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: filemap-add-__filemap_get_folio_mpol-fix
has been added to the -mm mm-new branch.  Its filename is
     filemap-add-__filemap_get_folio_mpol-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-add-__filemap_get_folio_mpol-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: filemap-add-__filemap_get_folio_mpol-fix
Date: Sun Jun 22 11:41:13 AM PDT 2025

fix EXPORT_SYMBOL()

Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~filemap-add-__filemap_get_folio_mpol-fix
+++ a/mm/filemap.c
@@ -2032,7 +2032,7 @@ no_page:
 		folio_clear_dropbehind(folio);
 	return folio;
 }
-EXPORT_SYMBOL(__filemap_get_folio);
+EXPORT_SYMBOL(__filemap_get_folio_mpol);
 
 static inline struct folio *find_get_entry(struct xa_state *xas, pgoff_t max,
 		xa_mark_t mark)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-oom-killer-maintainer-structure-fix.patch
mm-add-oom-killer-maintainer-structure-fix-checkpatch-fixes.patch
filemap-add-__filemap_get_folio_mpol-fix.patch
maintainers-add-lib-raid6-to-software-raid.patch

