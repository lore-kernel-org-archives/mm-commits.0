Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CD317B432
	for <mm-commits@vger.kernel.org>; Tue, 28 May 2024 21:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716931710; cv=none; b=ofELA1sOLorXz+t2y1N336bC9qpbYxyMk7GJtDiWz1zX2hWZsLpmEdX0bKtGY9lb0TcK45Ngy/+b5UhRcWORWbW3NuYF8/VG3rvhRHVYBE6/kVGZWRFldnDR899nAyX3tiqxRgsNAKMzrkcG7UJ5iHNwMYZlCGWl1GZqAXTVq8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716931710; c=relaxed/simple;
	bh=uwZM+TplzI9ksL3M2dgmCCWFb/0/AZC46YEVqedQ8Gc=;
	h=Date:To:From:Subject:Message-Id; b=rZzLyd3UCvsIJPaYUvvf6twiZoieomaRCOaMN6j6vuK8AqiK3EpQJAY+gZqb4s/WaAgrwmAg7+GFsKRK+OlK0ddEedaGGV50BalPAjuPoOyMa6o7zOkOPQZcbRwt7u1XLNEB+azRPeNFD4BVgHqSTXm4ksfSFfJTAsjE2jZg8tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=urcgpcOG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="urcgpcOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE4EC3277B;
	Tue, 28 May 2024 21:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716931710;
	bh=uwZM+TplzI9ksL3M2dgmCCWFb/0/AZC46YEVqedQ8Gc=;
	h=Date:To:From:Subject:From;
	b=urcgpcOGxygzSGlosiXfIGsQB4uUOVBuvUcwc17ziNH5SfcswJGp1IM0USVW65ZhX
	 MHYE0HOiEF/lJMD6gZgK3LglUWo2wwNyA9kUIsXq31BEU+bUwpqGC2G69IXfmB/G5T
	 LQXy/vb8aQ4FTCCAjIqdh2wPtIKDMZERdPeOGPkg=
Date: Tue, 28 May 2024 14:28:29 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,dave.hansen@intel.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-x86-do-not-explicitly-clear-reserved-flag-in-free_pagetable.patch added to mm-unstable branch
Message-Id: <20240528212830.3CE4EC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch/x86: do not explicitly clear Reserved flag in free_pagetable
has been added to the -mm mm-unstable branch.  Its filename is
     arch-x86-do-not-explicitly-clear-reserved-flag-in-free_pagetable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch-x86-do-not-explicitly-clear-reserved-flag-in-free_pagetable.patch

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
From: Oscar Salvador <osalvador@suse.de>
Subject: arch/x86: do not explicitly clear Reserved flag in free_pagetable
Date: Mon, 27 May 2024 06:45:23 +0200

In free_pagetable() we use the non-atomic version for clearing the
PageReserved bit from the page.  free_pagetable() will either call
free_reserved_page() or put_page_bootmem(), which will eventually end up
calling free_reserved_page(), and in there we already clear the
PageReserved flag.

Link: https://lkml.kernel.org/r/20240527044523.29207-1-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/x86/mm/init_64.c~arch-x86-do-not-explicitly-clear-reserved-flag-in-free_pagetable
+++ a/arch/x86/mm/init_64.c
@@ -980,8 +980,6 @@ static void __meminit free_pagetable(str
 
 	/* bootmem page has reserved flag */
 	if (PageReserved(page)) {
-		__ClearPageReserved(page);
-
 		magic = page->index;
 		if (magic == SECTION_INFO || magic == MIX_SECTION_INFO) {
 			while (nr_pages--)
_

Patches currently in -mm which might be from osalvador@suse.de are

mm-hugetlb-do-not-call-vma_add_reservation-upon-enomem.patch
mm-hugetlb-drop-node_alloc_noretry-from-alloc_fresh_hugetlb_folio.patch
arch-x86-do-not-explicitly-clear-reserved-flag-in-free_pagetable.patch

