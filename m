Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3286D239085
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 22:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782945509; cv=none; b=EcEu2E0ljZ1YojHtPfExa2jL7doHWAZiisB5FG2GOH6Bzk0NKmEYjCLif5crrtTp89HdiAUjYpmyUKxsmFXdChc0qbsZ4Yglbd0uXGAN6xDH9PKpcdw1CxYoZ9aq+FRvqMWDtatNndYdsDae+zhgEjm6tb3Yi77F/a+k5m7L+3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782945509; c=relaxed/simple;
	bh=OumXBrlhpspaKhVOWALY/JtM2UvvPXTpLN5QjdFu0O8=;
	h=Date:To:From:Subject:Message-Id; b=DVwEQ4c9Siv8MHD65IZ9r+Lwu4KViYIUs8uZAjGQLn8hO5FYGzR6c1lJsgLge/0O+NQ7O5mMJeE3ghvvnl+COTJuKE0rmIuAQArJ4aan7p0IA7kAKxUrq7mwtSbOOt2nbgeY+CHPoaCVKYQC8YYCHwjYBSNISqYMWJgEJlY3gPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HAam/kTl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HAam/kTl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3EE61F000E9;
	Wed,  1 Jul 2026 22:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782945507;
	bh=a1p57i5HUk/DXyD4we4rcaG+kjIet1a5r4wwY4U1Ci4=;
	h=Date:To:From:Subject;
	b=HAam/kTl7l/10yDStQlCqfbobKYQ6F7+z/AJAqDci6IzhI2aAXQ9LHvLyvq8arQZT
	 ILa4gFVs3APxlIZ7tSnHQXP8n9wsvhP1PDxVaiqhytZtwrTxWoJ7NAAdeBJM5ok05N
	 pHQDHvvN8EZjgmfjBJvy2aZgfzhkmg8RNDMao5mQ=
Date: Wed, 01 Jul 2026 15:38:27 -0700
To: mm-commits@vger.kernel.org,rcampbell@nvidia.com,leon@kernel.org,jgg@ziepe.ca,skinsburskii@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_hmm-fail-dmirror_fault-when-the-mirrored-mm-is-gone.patch added to mm-new branch
Message-Id: <20260701223827.B3EE61F000E9@smtp.kernel.org>
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
From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
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

Patches currently in -mm which might be from skinsburskii@linux.microsoft.com are

lib-test_hmm-fail-dmirror_fault-when-the-mirrored-mm-is-gone.patch

