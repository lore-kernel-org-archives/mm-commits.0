Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7401E5714
	for <mm-commits@vger.kernel.org>; Tue, 28 Apr 2026 14:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777387219; cv=none; b=WiQRV68ahm85GCgRK5QUcEno/hGSRKGa1GyxKSbK5sR7F6uKcZF8Q+Cze2dEc1jfvAadC6fAGm6sgj5VORXhjJi+nz9aP6ViqepONEYguDmKf1pyZgjEk+h/YwiHtSVqCqJteWbpDyVh9EruWQ79G2RfIFcxKKy98Aa57cD+ZGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777387219; c=relaxed/simple;
	bh=i2n9beKOfvlEFTVzaIuQMCrOkM3Wb1GH33+/BeGUESI=;
	h=Date:To:From:Subject:Message-Id; b=WouIGTMaFTZjPh0Hm0PzLzSvkEgUN/vaZEQ5QLswJUcCGJvvof7zjvnX4PwZ7n/VxTjluiqjOvBkusaS4pAFILCinAPCWLzB+aO+wAbASHGB7f5leFTbA704OHSsNj2qiFZ3qxYmNZTwsJEMTdevAP9VsYdzl1Q22WbdeiCTMbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CD6Uso7h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CD6Uso7h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7E9C2BCAF;
	Tue, 28 Apr 2026 14:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777387218;
	bh=i2n9beKOfvlEFTVzaIuQMCrOkM3Wb1GH33+/BeGUESI=;
	h=Date:To:From:Subject:From;
	b=CD6Uso7hDdd3beXv0GuvNJ54CGTk46MSPs4TPWJ/8j213Q2sP683y0AnvhV9tRQA5
	 1SK2jFhmPdIrPiYUed3U40/RlN5XlcPA4AKxV2o8U2R9Vs648eNrrIbRj95IKAgZ2T
	 q4Lo5IqsIkFLWG6RoIrp92VyHgFBnVDQSIUu0ols=
Date: Tue, 28 Apr 2026 07:40:17 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,roman.gushchin@linux.dev,jack@suse.cz,fujunjie1@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-do-not-count-fault_flag_tried-retries-as-mmap-hits.patch added to mm-new branch
Message-Id: <20260428144018.8F7E9C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/filemap: do not count FAULT_FLAG_TRIED retries as mmap hits
has been added to the -mm mm-new branch.  Its filename is
     mm-filemap-do-not-count-fault_flag_tried-retries-as-mmap-hits.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-do-not-count-fault_flag_tried-retries-as-mmap-hits.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: fujunjie <fujunjie1@qq.com>
Subject: mm/filemap: do not count FAULT_FLAG_TRIED retries as mmap hits
Date: Tue, 28 Apr 2026 01:59:44 +0000

A fault that starts synchronous mmap readahead can return VM_FAULT_RETRY
after dropping mmap_lock.  The retry may then map the folio brought in by
that same miss.

Do not let this retry decrement mmap_miss.  The retry still maps the folio
from the page cache; it just does not count as a useful mmap readahead
hit.

Link: https://lore.kernel.org/tencent_22E6B8849EC1141FE7773C64467E6F1E2C09@qq.com
Signed-off-by: fujunjie <fujunjie1@qq.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/filemap.c~mm-filemap-do-not-count-fault_flag_tried-retries-as-mmap-hits
+++ a/mm/filemap.c
@@ -3937,6 +3937,7 @@ vm_fault_t filemap_map_pages(struct vm_f
 		 * we can stop read-ahead.
 		 */
 		if ((map_ret & VM_FAULT_NOPAGE) &&
+		    !(vmf->flags & FAULT_FLAG_TRIED) &&
 		    !folio_test_workingset(folio)) {
 			unsigned short mmap_miss;
 
_

Patches currently in -mm which might be from fujunjie1@qq.com are

mm-madvise-reject-invalid-process_madvise-advice-for-zero-length-vectors.patch
mm-filemap-count-only-the-faulting-address-as-a-mmap-hit.patch
mm-filemap-do-not-count-fault_flag_tried-retries-as-mmap-hits.patch

