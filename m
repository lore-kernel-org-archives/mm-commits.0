Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DFB145355
	for <mm-commits@vger.kernel.org>; Wed, 12 Mar 2025 21:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741816165; cv=none; b=Xn+0TvrL1VkejmVpuuNxkGtDQSMMsmEZJN4LGNPD0aw67JHEz8IXYcB4Ksi8s2Y47ww0YWKrs3/dIk2fWwoyed17CHc6dH8+S6a8Y1vD4IVcneCMeRoIdZuqgMltw5b3ZgKQ19GA/e+pS8q5JnrIptDrXhWchl+siMVEDcRwJz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741816165; c=relaxed/simple;
	bh=0lF0uVAVf7rjqXLhx2B6lupYr7ljsLLbN9hO9Hvo7lY=;
	h=Date:To:From:Subject:Message-Id; b=oD2xR/teXTj8mMZ2vFVJsO8st7RD58Y5eQ7AfFUr8akQ7i7tRlQTCaD+vlIqqrp8QfKIjZtp+LRG+vNOAxIrZbo/F5A8hbQNySZMEHY0sdOgd3rXV8EENRq1fKdCKkvwyXNR6pTQb1Ctorc1oqDVEcYp3eC8rd4IYo6W0Mr2h+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rtUXq5Iy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rtUXq5Iy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4A9C4CEEA;
	Wed, 12 Mar 2025 21:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741816164;
	bh=0lF0uVAVf7rjqXLhx2B6lupYr7ljsLLbN9hO9Hvo7lY=;
	h=Date:To:From:Subject:From;
	b=rtUXq5IyvtTsr2v9NhKm66wfSMCX2N42DblDh4Tz1OEd1DxVCJUIO5OvvZdW/4P4M
	 uVPmsu814pE2GNTBHGHzYBYMhq5XggZG6L5EC/Yr1HltToD+i6IusXiCeNJw10xXlJ
	 0lajdfIZ9jYDgeHI+YQGgx09UdzY534ot5YKkIho=
Date: Wed, 12 Mar 2025 14:49:23 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,hca@linux.ibm.com,ardb@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-make-setup_zero_pages-use-memblock-fix-fix.patch added to mm-unstable branch
Message-Id: <20250312214924.5B4A9C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390-make-setup_zero_pages-use-memblock-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     s390-make-setup_zero_pages-use-memblock-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-make-setup_zero_pages-use-memblock-fix-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: s390-make-setup_zero_pages-use-memblock-fix-fix
Date: Wed Mar 12 02:47:42 PM PDT 2025

fix memblock_alloc_or_panic() alignment, per Ard

Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/mm/init.c~s390-make-setup_zero_pages-use-memblock-fix-fix
+++ a/arch/s390/mm/init.c
@@ -81,7 +81,7 @@ static void __init setup_zero_pages(void
 	while (order > 2 && (total_pages >> 10) < (1UL << order))
 		order--;
 
-	empty_zero_page = (unsigned long)memblock_alloc_or_panic(PAGE_SIZE << order, order);
+	empty_zero_page = (unsigned long)memblock_alloc_or_panic(PAGE_SIZE << order, PAGE_SIZE);
 
 	zero_page_mask = ((PAGE_SIZE << order) - 1) & PAGE_MASK;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch
mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option-fix.patch
s390-make-setup_zero_pages-use-memblock-fix-fix.patch
mm-filemap-use-xas_try_split-in-__filemap_add_folio-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch
scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix.patch
signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix.patch

