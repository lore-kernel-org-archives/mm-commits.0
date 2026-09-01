Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A8A25228C
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 00:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788221551; cv=none; b=HAtVNCCRqbbkJxbkzeLtoutXC/eGRC9sv4liOshLjKCKRekB6xb2lJBNJqGGgqy0Nnygtwq2PB+FSgszdw4HBN0UQQau7J5wTunmAFoVd3UKkOrUkOGhtgmZsVlaapndsjGC3hTWuMp/4TQvgiRt0NmKkcQU4i0+11cpg97BkFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788221551; c=relaxed/simple;
	bh=tP1hlR9crrSYnnaNE08sHhWqgTiO7YJ3mbMcQqNeUsE=;
	h=Date:To:From:Subject:Message-Id; b=fuXkza6Pczx9cfSd3NgUcOuOMYI2n8tYqmef2P7NB5eK+haLxdFIkG3LeW7Eghd5ASlzPz3ltxutLsBlAheK+BZjScIeHmPMWY0OVE32D6ZcjdmwCfxduY1zMjzEb8vOxKrTH33ws5AhUNDIwl2wg3JQQXR/a6hrniLvjIDpcOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eBdfGoaS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eBdfGoaS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003A31F000E9;
	Tue,  1 Sep 2026 00:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788221549;
	bh=vOReLjcuy7wKuj9yBawxv/P6ZqLeOZvcnx/s75U4eis=;
	h=Date:To:From:Subject;
	b=eBdfGoaSgNictucTkZKTzZHlRon6WwFs1wlaJwEJnga7crFML/iJM61EUP+qtEU41
	 jP6zF9iCd+Rv5oMvbsdK/YOvW/ZJVW8FS7x3B7MwrhtyAH1cEYcNOq1Vf/8e56Y/sA
	 U3x8F8jKfanJ6k+h+yMa+xHPbZHmbArLgeWW5tdE=
Date: Mon, 31 Aug 2026 17:12:28 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,kas@kernel.org,jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,sarthak.sharma@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup_test-report-actual-pinned-bytes.patch added to mm-new branch
Message-Id: <20260901001229.003A31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup_test: report actual pinned bytes
has been added to the -mm mm-new branch.  Its filename is
     mm-gup_test-report-actual-pinned-bytes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup_test-report-actual-pinned-bytes.patch

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
From: Sarthak Sharma <sarthak.sharma@arm.com>
Subject: mm/gup_test: report actual pinned bytes
Date: Mon, 31 Aug 2026 15:43:04 +0530

__gup_test_ioctl() advances addr to the end of the current batch before
checking if GUP pinned the entire requested batch.  If GUP pins more than
0 pages but less than the requested batch size, addr still advances by the
requested batch size.

The next iteration detects the partial pinning and breaks out of the loop.
Again gup->size is calculated using addr - gup->addr, so it also includes
the unpinned pages of the requested batch.

Calculate gup->size using the actual number of pages pinned multiplied
by PAGE_SIZE.

Link: https://lore.kernel.org/20260831101304.162867-1-sarthak.sharma@arm.com
Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup_test.c~mm-gup_test-report-actual-pinned-bytes
+++ a/mm/gup_test.c
@@ -188,7 +188,7 @@ static int __gup_test_ioctl(unsigned int
 	nr_pages = i;
 
 	gup->get_delta_usec = ktime_us_delta(end_time, start_time);
-	gup->size = addr - gup->addr;
+	gup->size = nr_pages * PAGE_SIZE;
 
 	/*
 	 * Take an un-benchmark-timed moment to verify DMA pinned
_

Patches currently in -mm which might be from sarthak.sharma@arm.com are

mm-gup_test-report-actual-pinned-bytes.patch

