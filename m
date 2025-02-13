Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FED2266B49
	for <mm-commits@vger.kernel.org>; Thu, 13 Feb 2025 22:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739485586; cv=none; b=lxFamomGEsX+4k6BkcpECGyXTzC7ZqK0wl9DI1ZUdMxLtT8fN2owVhVzepUog5KhoDyI5z0R6Ljasus2o0M7a3W1BPxnq+DtXNoliqD9uepGjrTOtUYSSuW9i0h6qH+eqVTU9xZfbcwffalI8vzeWFrqi57wl3D859nBLI3sGvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739485586; c=relaxed/simple;
	bh=2i4HtMIR2L6pYE7mmWToEf462lhlqdh94mEzmD9t27s=;
	h=Date:To:From:Subject:Message-Id; b=nA1fNeywIMCaE/VMCFGdULrN0bn7NAklkToYZC5k4/ExUkffLzRos6bYHfJekEapg0BoUdbgHOcNtfHN59cHP0y8yKSozVcv5WdMk7si2fZQe0p8d48BJEK5fYWpxxV+vyev4V6WNUh/27FW3pRfC2PPWMye5i6gwacouunRUng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s028dOuy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s028dOuy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3676C4CEE2;
	Thu, 13 Feb 2025 22:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739485585;
	bh=2i4HtMIR2L6pYE7mmWToEf462lhlqdh94mEzmD9t27s=;
	h=Date:To:From:Subject:From;
	b=s028dOuys8T4DJ7l7LQpVrh8tXj30EIxrRLJEd1eynHah/TOFHMJP8/CLM3m2yNkf
	 bMrl8yHgXCeekI22E7uCtI2FWyqq+6bJNx+ckotNsGvHA0VUV7wCm6oZtT1LOokT24
	 NlFJG4gKamLld6PI4In0yFzLHeImYdM1xV8PKv+Q=
Date: Thu, 13 Feb 2025 14:26:25 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,guanjun@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-remove-redundant-folio_test_large-check-in-filemap_free_folio.patch added to mm-unstable branch
Message-Id: <20250213222625.C3676C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: filemap: remove redundant folio_test_large check in filemap_free_folio
has been added to the -mm mm-unstable branch.  Its filename is
     filemap-remove-redundant-folio_test_large-check-in-filemap_free_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-remove-redundant-folio_test_large-check-in-filemap_free_folio.patch

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
From: Guanjun <guanjun@linux.alibaba.com>
Subject: filemap: remove redundant folio_test_large check in filemap_free_folio
Date: Thu, 13 Feb 2025 13:56:12 +0800

The folio_test_large() check in filemap_free_folio() is unnecessary
because folio_nr_pages(), which is called internally already performs this
check.  Removing the redundant condition simplifies the code and avoids
double validation.

This change improves code readability and reduces unnecessary operations
in the folio freeing path.

Link: https://lkml.kernel.org/r/20250213055612.490993-1-guanjun@linux.alibaba.com
Signed-off-by: Guanjun <guanjun@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/filemap.c~filemap-remove-redundant-folio_test_large-check-in-filemap_free_folio
+++ a/mm/filemap.c
@@ -227,15 +227,12 @@ void __filemap_remove_folio(struct folio
 void filemap_free_folio(struct address_space *mapping, struct folio *folio)
 {
 	void (*free_folio)(struct folio *);
-	int refs = 1;
 
 	free_folio = mapping->a_ops->free_folio;
 	if (free_folio)
 		free_folio(folio);
 
-	if (folio_test_large(folio))
-		refs = folio_nr_pages(folio);
-	folio_put_refs(folio, refs);
+	folio_put_refs(folio, folio_nr_pages(folio));
 }
 
 /**
_

Patches currently in -mm which might be from guanjun@linux.alibaba.com are

filemap-remove-redundant-folio_test_large-check-in-filemap_free_folio.patch

