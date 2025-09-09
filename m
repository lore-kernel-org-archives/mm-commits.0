Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1F470830
	for <mm-commits@vger.kernel.org>; Tue,  9 Sep 2025 01:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757383005; cv=none; b=Jfl1fV/48UmPkVaWk5rESusZgQn0GjxFl5WRzBf0C6ZYZTLFIckhZ0pl3s5DWlDnJaeYNiPJ7qWNnJmz2MoqFgR5s0STRIX2bWaaVhv/qqVMDD+v41sCuhiu/nOFo/1Uzj7FbfaDWA86wLyX2ipgCi7kegMYCLmT+NDLERZeh/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757383005; c=relaxed/simple;
	bh=A4iR3+DPobsL0DgDSfiqbVcGrPVDZltlfp1FD4QkiPQ=;
	h=Date:To:From:Subject:Message-Id; b=dfi7sqThgYpQWa59dJWd6MvTXaZpnQGyt5gmH5S0tr8PpY62ixSFXiCR7TKilSaYBMncbrSnJTKSoqWSwuQ4zGfEJsl/KVv0bnzSQ0MZWWFY4B6o3Rib5as94JoBHSjvtrc+aldrIJmuZS76pPnB2ymLe8t336+rvZn1k5uGNBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yb1jCRJC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yb1jCRJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAB2C4CEF1;
	Tue,  9 Sep 2025 01:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757383004;
	bh=A4iR3+DPobsL0DgDSfiqbVcGrPVDZltlfp1FD4QkiPQ=;
	h=Date:To:From:Subject:From;
	b=yb1jCRJCWcmfPN1pMOkUv79TXdwnOk/C0dGUmvXdpBn2VTilNW7gW0APo32iDPLvO
	 NjeMv+Ms9ssUW3iq3fZkpC2b3DEF6W1VbDC41ZY8nziwxJM/gWSJwNjZYL7wdpq8AT
	 OIlm0zO26pFNacqsE2C/6bRqs8fR2NcJRCthsVqk=
Date: Mon, 08 Sep 2025 18:56:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usamaarif642@gmail.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kirill@shutemov.name,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-skip-mlocked-thps-that-are-underused-early-in-deferred_split_scan.patch added to mm-new branch
Message-Id: <20250909015644.6AAB2C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: skip mlocked THPs that are underused early in deferred_split_scan()
has been added to the -mm mm-new branch.  Its filename is
     mm-skip-mlocked-thps-that-are-underused-early-in-deferred_split_scan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-skip-mlocked-thps-that-are-underused-early-in-deferred_split_scan.patch

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
From: Lance Yang <lance.yang@linux.dev>
Subject: mm: skip mlocked THPs that are underused early in deferred_split_scan()
Date: Mon, 8 Sep 2025 17:07:41 +0800

When we stumble over a fully-mapped mlocked THP in the deferred shrinker,
it does not make sense to try to detect whether it is underused, because
try_to_map_unused_to_zeropage(), called while splitting the folio, will
not actually replace any zeroed pages by the shared zeropage.

Splitting the folio in that case does not make any sense, so let's not
even scan to check if the folio is underused.

Link: https://lkml.kernel.org/r/20250908090741.61519-1-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/huge_memory.c~mm-skip-mlocked-thps-that-are-underused-early-in-deferred_split_scan
+++ a/mm/huge_memory.c
@@ -4176,6 +4176,13 @@ static unsigned long deferred_split_scan
 		bool underused = false;
 
 		if (!folio_test_partially_mapped(folio)) {
+			/*
+			 * See try_to_map_unused_to_zeropage(): we cannot
+			 * optimize zero-filled pages after splitting an
+			 * mlocked folio.
+			 */
+			if (folio_test_mlocked(folio))
+				goto next;
 			underused = thp_underused(folio);
 			if (!underused)
 				goto next;
_

Patches currently in -mm which might be from lance.yang@linux.dev are

maintainers-add-lance-yang-as-a-thp-reviewer.patch
mm-skip-mlocked-thps-that-are-underused-early-in-deferred_split_scan.patch

