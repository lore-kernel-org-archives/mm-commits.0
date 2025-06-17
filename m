Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909082F5326;
	Tue, 17 Jun 2025 23:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750203312; cv=none; b=BlcNRm5MUd0ACaEYvS9rZgffugzcdHC/yP2sbNQBi2pJKgT4SakEFfxIZotn3YW0dTGmXHkCvY3/bFPcGWe6Ku/O8zTqEHKIau2WgVu5XBUamqPajNBFRSWLe7KlBuzy7Gl9coma/BA2rTHkL5JwpLrvhCjhC3cNYKvHzX9MUFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750203312; c=relaxed/simple;
	bh=PUPjQNDrmsYKaFmvg9pcRbtb48JtmiMkyLI/rVjh8mc=;
	h=Date:To:From:Subject:Message-Id; b=W+tlaB0d4pB4Y8zsr/gNyxJF47qHLrNhxAbiau2hrmMW0MdyHxU4t4g5ctKWAPVv6+S3sMOljY9xSlMjAMbxW+WUns9pao1QZv34bp9HmJuGyg59vrseWN1uTodAcUepAbOJBsc03gezghM+M45FAUpLdNN6819mG0bhPYnsrr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JTRiHMYY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JTRiHMYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BA1C4CEE3;
	Tue, 17 Jun 2025 23:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750203312;
	bh=PUPjQNDrmsYKaFmvg9pcRbtb48JtmiMkyLI/rVjh8mc=;
	h=Date:To:From:Subject:From;
	b=JTRiHMYY0+zSpFWKD+aD70lQWUx+qCccZceZrq2iUf7+AarIHlLl70udTBWnuUAhe
	 oG95v14a6I9Hfc6lzH6pIls+uyCw5Up/YB7mnRXmfD1HCDAjTs4pmV8umcCIR6YmKe
	 s00GMNr/iNiPi0DUmkmD41qfWYkOZYGD+v0ikjcs=
Date: Tue, 17 Jun 2025 16:35:11 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,stable@vger.kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-fix-page_is_pfnzero-detection-for-the-huge-zero-folio.patch added to mm-hotfixes-unstable branch
Message-Id: <20250617233512.51BA1C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: fix PAGE_IS_PFNZERO detection for the huge zero folio
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-proc-task_mmu-fix-page_is_pfnzero-detection-for-the-huge-zero-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-fix-page_is_pfnzero-detection-for-the-huge-zero-folio.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: fs/proc/task_mmu: fix PAGE_IS_PFNZERO detection for the huge zero folio
Date: Tue, 17 Jun 2025 16:35:32 +0200

is_zero_pfn() does not work for the huge zero folio. Fix it by using
is_huge_zero_pmd().

This can cause the PAGEMAP_SCAN ioctl against /proc/pid/pagemap to omit
pages.

Found by code inspection.

Link: https://lkml.kernel.org/r/20250617143532.2375383-1-david@redhat.com
Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-fix-page_is_pfnzero-detection-for-the-huge-zero-folio
+++ a/fs/proc/task_mmu.c
@@ -2182,7 +2182,7 @@ static unsigned long pagemap_thp_categor
 				categories |= PAGE_IS_FILE;
 		}
 
-		if (is_zero_pfn(pmd_pfn(pmd)))
+		if (is_huge_zero_pmd(pmd))
 			categories |= PAGE_IS_PFNZERO;
 		if (pmd_soft_dirty(pmd))
 			categories |= PAGE_IS_SOFT_DIRTY;
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-revert-mm-gup-fix-infinite-loop-within-__get_longterm_locked.patch
fs-proc-task_mmu-fix-page_is_pfnzero-detection-for-the-huge-zero-folio.patch
mm-gup-remove-vm_bug_ons.patch
mm-gup-remove-vm_bug_ons-fix.patch
mm-huge_memory-dont-ignore-queried-cachemode-in-vmf_insert_pfn_pud.patch
mm-huge_memory-dont-mark-refcounted-folios-special-in-vmf_insert_folio_pmd.patch
mm-huge_memory-dont-mark-refcounted-folios-special-in-vmf_insert_folio_pud.patch

