Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8344184E
	for <mm-commits@vger.kernel.org>; Tue,  8 Jul 2025 00:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751933004; cv=none; b=lr70Y1cgAsVf6varUiCw0B6TDeNUTVo1sR1RHRQb4ryf+aoI5IlFnNyN2ZPOzNWlGcqGe7ESN4QWERFUmjuHcGRXwHjQEyoHaQJ/idxs6ehqNo/TOU1+jM1HEs5/Wazho3Xs5vERZ8jg6lVHcBxd00xuEcyq2qgSbz/COMtpC4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751933004; c=relaxed/simple;
	bh=NKKY9zBnIGSRA+5TGFUQ8Enw4ZIUfaZrS/TXhiaRPDQ=;
	h=Date:To:From:Subject:Message-Id; b=LKCgGU7o6JvNW/qcnQfaNuVU4Rtiyr1YJtBe3r99boUnmyJLosPBphNSrss1SDdw9uEcQOMtB9AjN2GZZQq1DglsE8CnoAme7fZ6rb2Hvl/g4Ewmu9336F47uH7MG8LEgxpgN4VHbVsp7VnR1apFXPHymMhG7/CirjLN/LxCWWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n16A4wlk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n16A4wlk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F20DC4CEE3;
	Tue,  8 Jul 2025 00:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751933004;
	bh=NKKY9zBnIGSRA+5TGFUQ8Enw4ZIUfaZrS/TXhiaRPDQ=;
	h=Date:To:From:Subject:From;
	b=n16A4wlkvJaJOhXyyvd1R1VUWDMyqcoZ+Kj8llnOviUkP9AXX6IS+QxJPoJDGU5Qy
	 KxIOJkb84gODXCOWN70Y8eQOG+BDCFholKmIdDDJqGLNBoHhOO7YiCPBu6c3PeKj+S
	 LlU1lBmTPgqavWHacFmy4nu4MJaRA6hwxNxdcsNo=
Date: Mon, 07 Jul 2025 17:03:23 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,julia.lawall@inria.fr,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-allow-arch-to-request-folio-size-for-exec-memory-fix-2.patch added to mm-unstable branch
Message-Id: <20250708000324.5F20DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-filemap-allow-arch-to-request-folio-size-for-exec-memory-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-filemap-allow-arch-to-request-folio-size-for-exec-memory-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-allow-arch-to-request-folio-size-for-exec-memory-fix-2.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm-filemap-allow-arch-to-request-folio-size-for-exec-memory-fix-2
Date: Mon, 7 Jul 2025 10:08:09 +0100

use the vma_pages() helper instead of open-coding

Link: https://lkml.kernel.org/r/0e0f674b-3b7e-494f-ae7a-fc9dbb98dad4@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@inria.fr>
Closes: https://lore.kernel.org/r/202507071459.lLPSj5Bd-lkp@intel.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-allow-arch-to-request-folio-size-for-exec-memory-fix-2
+++ a/mm/filemap.c
@@ -3279,7 +3279,7 @@ static struct file *do_sync_mmap_readahe
 		 */
 		struct vm_area_struct *vma = vmf->vma;
 		unsigned long start = vma->vm_pgoff;
-		unsigned long end = start + ((vma->vm_end - vma->vm_start) >> PAGE_SHIFT);
+		unsigned long end = start + vma_pages(vma);
 		unsigned long ra_end;
 
 		ra->order = exec_folio_order();
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-readahead-honour-new_order-in-page_cache_ra_order.patch
mm-readahead-terminate-async-readahead-on-natural-boundary.patch
mm-readahead-make-space-in-struct-file_ra_state.patch
mm-readahead-store-folio-order-in-struct-file_ra_state.patch
mm-filemap-allow-arch-to-request-folio-size-for-exec-memory.patch
mm-filemap-allow-arch-to-request-folio-size-for-exec-memory-fix.patch
mm-filemap-allow-arch-to-request-folio-size-for-exec-memory-fix-2.patch
mm-remove-arch_flush_tlb_batched_pending-arch-helper.patch

