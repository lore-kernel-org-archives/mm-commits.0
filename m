Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8919B3BBCC;
	Tue, 28 May 2024 21:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716930946; cv=none; b=F6VW4ycAF8hdJmtXAJRRVtMBRkz7r/qhkQ5P2H1CirxRNUBnIjcVIvNaVTFetHN3GKvNY6KUgoJOc6FGBtadPwKGHM/pezCnwwtjS1zDu7whIy07M3AAP78hHqSj9lBqHh6GuIX5e4AcscUc9u13Xxv6w1lC0TGh0aJuATIhCvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716930946; c=relaxed/simple;
	bh=z4saqk+1IZ7fcFkc3bM0Mnn1oDQodMj7hf0CiZFJqfg=;
	h=Date:To:From:Subject:Message-Id; b=HsBZKfwCeOa7uM6LsaoC2I5qq5KGdEIWjvXkRHyjB65nQEq7E7g0NVNHnWvkI0QT5tdTB1pPKo1WGSUEyT+Z4cGJOjKqXsXrLUXEOBpBGhITh19YpYQlb/LJ2AaQ56rMyr+siUgxuGgp/oG+slc1NSMaTrnxtG9yTZW7jXlnQY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FGTClnPP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FGTClnPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071C0C3277B;
	Tue, 28 May 2024 21:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716930946;
	bh=z4saqk+1IZ7fcFkc3bM0Mnn1oDQodMj7hf0CiZFJqfg=;
	h=Date:To:From:Subject:From;
	b=FGTClnPPQ21W/86i6xinjp0FKsildsXzxSXc5Rul6OWEnS1wpBQzLA3jLNKFwtSYX
	 /XriRl7Bt+h1GjnYMPYVlcI3tXFqPF4nqPV4aNLiL6DVIoOCXvsK+KrAfiWwXSdT+/
	 GBX6w0jj2k+Fg4ty3J7gGv7hdggrgKWQVFMpZ0hU=
Date: Tue, 28 May 2024 14:15:44 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,muchun.song@linux.dev,leitao@debian.org,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-do-not-call-vma_add_reservation-upon-enomem.patch added to mm-hotfixes-unstable branch
Message-Id: <20240528211546.071C0C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: do not call vma_add_reservation upon ENOMEM
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-do-not-call-vma_add_reservation-upon-enomem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-do-not-call-vma_add_reservation-upon-enomem.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/hugetlb: do not call vma_add_reservation upon ENOMEM
Date: Tue, 28 May 2024 22:53:23 +0200

sysbot reported a splat [1] on __unmap_hugepage_range().  This is because
vma_needs_reservation() can return -ENOMEM if
allocate_file_region_entries() fails to allocate the file_region struct
for the reservation.

Check for that and do not call vma_add_reservation() if that is the case,
otherwise region_abort() and region_del() will see that we do not have any
file_regions.

If we detect that vma_needs_reservation() returned -ENOMEM, we clear the
hugetlb_restore_reserve flag as if this reservation was still consumed, so
free_huge_folio() will not increment the resv count.

[1] https://lore.kernel.org/linux-mm/0000000000004096100617c58d54@google.com/T/#ma5983bc1ab18a54910da83416b3f89f3c7ee43aa

Link: https://lkml.kernel.org/r/20240528205323.20439-1-osalvador@suse.de
Fixes: df7a6d1f6405 ("mm/hugetlb: restore the reservation if needed")
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reported-and-tested-by: syzbot+d3fe2dc5ffe9380b714b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/0000000000004096100617c58d54@google.com/
Cc: Breno Leitao <leitao@debian.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-do-not-call-vma_add_reservation-upon-enomem
+++ a/mm/hugetlb.c
@@ -5768,8 +5768,20 @@ void __unmap_hugepage_range(struct mmu_g
 		 * do_exit() will not see it, and will keep the reservation
 		 * forever.
 		 */
-		if (adjust_reservation && vma_needs_reservation(h, vma, address))
-			vma_add_reservation(h, vma, address);
+		if (adjust_reservation) {
+			int rc = vma_needs_reservation(h, vma, address);
+
+			if (rc < 0)
+				/* Pressumably allocate_file_region_entries failed
+				 * to allocate a file_region struct. Clear
+				 * hugetlb_restore_reserve so that global reserve
+				 * count will not be incremented by free_huge_folio.
+				 * Act as if we consumed the reservation.
+				 */
+				folio_clear_hugetlb_restore_reserve(page_folio(page));
+			else if (rc)
+				vma_add_reservation(h, vma, address);
+		}
 
 		tlb_remove_page_size(tlb, page, huge_page_size(h));
 		/*
_

Patches currently in -mm which might be from osalvador@suse.de are

mm-hugetlb-do-not-call-vma_add_reservation-upon-enomem.patch
mm-hugetlb-drop-node_alloc_noretry-from-alloc_fresh_hugetlb_folio.patch

