Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44153672BA
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 22:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782945408; cv=none; b=cKDRx1TfVD1aKSCeqNQDfRyOiD4Sl9SyoN4usMD6incP2OS8yjTlJ4ASCgb1IpIgSQhrqqNx5TPzzHcKg1JVwqJVq8YKXjMJ2X2/KSe4hCiwDAvZKorgfoBUpc7ZR2q6UPHGh8utXCFYQCsjnvEUOORxxCWuqMHyvicAdsYzuLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782945408; c=relaxed/simple;
	bh=r+jGuYRd4srR2VcQXvyUq6ylLeC5ExdZFdK3nhqG68w=;
	h=Date:To:From:Subject:Message-Id; b=OoUV1bbBzP2zpn3vfxZxOeSYE4PK2SX71m4t76a6oZFQA9eaH2NortrUM9of5dAPVCylk2ZcxmwTGwJqTRfd1CsDL/Hke08vBb18yf3LqMSLWvaFURuudRToWw3lwLwLUxIUxavmo1VEHTXfiPZ3zXDMSk0WbCvZYFdGmQ6WOis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N56kFGWU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N56kFGWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4ED1F000E9;
	Wed,  1 Jul 2026 22:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782945406;
	bh=4PhioU1/tAoPLg6BJ+SBPGPftABdO5HgxeTTgCrZvlg=;
	h=Date:To:From:Subject;
	b=N56kFGWUKGpY9nw0gcAU8dES2B6DzFwCFvbATiNIzGfjxX6es/ZxaSaGyf7cMPfD/
	 I2UtkV9STneApfsMYWabLG0DOdoByU2KAmV47HdlOgs+C4vPrNnpEjwqdk0HnjwCoM
	 4Jif5KobyNCtB7Arxq5p+dP66dWRNDvlkg/6/ic4=
Date: Wed, 01 Jul 2026 15:36:46 -0700
To: mm-commits@vger.kernel.org,skinsburskii@linux.microsoft.com,rcampbell@nvidia.com,leon@kernel.org,jgg@ziepe.ca,skinsburskii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_hmm-fail-dmirror_fault-when-the-mirrored-mm-is-gone.patch added to mm-new branch
Message-Id: <20260701223646.6D4ED1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_hmm: fail dmirror_fault() when the mirrored mm is gone
has been added to the -mm mm-new branch.  Its filename is
     lib-test_hmm-fail-dmirror_fault-when-the-mirrored-mm-is-gone.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_hmm-fail-dmirror_fault-when-the-mirrored-mm-is-gone.patch

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
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Subject: lib/test_hmm: fail dmirror_fault() when the mirrored mm is gone
Date: Wed, 01 Jul 2026 15:02:20 -0700

dmirror_fault() is called from the dmirror_read() and dmirror_write()
retry loops after dmirror_do_read() or dmirror_do_write() finds a missing
device page table entry.

If the mirrored mm has already exited, mmget_not_zero() fails.  The
current code returns 0 in that case, which tells the caller that faulting
succeeded even though no page was faulted and no device page table entry
was installed.  The caller then retries the same address, hits -ENOENT
again, and can loop forever without making progress.

Return -EFAULT instead, so the ioctl fails when the mirrored mm is no
longer faultable.

Link: https://lore.kernel.org/178294308408.327222.3319445682023999403.stgit@skinsburskii
Fixes: b2ef9f5a5cb37 ("mm/hmm/test: add selftest driver for HMM")
Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_hmm.c~lib-test_hmm-fail-dmirror_fault-when-the-mirrored-mm-is-gone
+++ a/lib/test_hmm.c
@@ -407,7 +407,7 @@ static int dmirror_fault(struct dmirror
 
 	/* Since the mm is for the mirrored process, get a reference first. */
 	if (!mmget_not_zero(mm))
-		return 0;
+		return -EFAULT;
 
 	for (addr = start; addr < end; addr = range.end) {
 		range.start = addr;
_

Patches currently in -mm which might be from skinsburskii@gmail.com are

lib-test_hmm-use-device-devt-for-coherent-device-range-selection.patch
lib-test_hmm-fail-dmirror_fault-when-the-mirrored-mm-is-gone.patch

