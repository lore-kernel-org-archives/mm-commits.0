Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100D44AEE2;
	Thu, 26 Mar 2026 22:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774564804; cv=none; b=ptcgwP3lqjU7T2rlDry/xT4GSP8RWQb9d8Q8186MIZFduzIJgQJ+QiX9RkhmmxSxy48jx4c3OR4J0rygvkCGS8zKriNZcVgKitDy+WssSVxhmpPkrDhjRWuh0huR8AO+UgZfmb1EwwwWudzrb7vLPnXcra8snvfOj2acPMsBUp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774564804; c=relaxed/simple;
	bh=iAtnxxCAUCkZUia1OWke1EBuVKK5bzRRupk8WbbWY34=;
	h=Date:To:From:Subject:Message-Id; b=vDyNftPKbGav8wBRmiBmswq6YcY18a+q0irAqRjIF8fyURRY/QhYVR9SvApqBX3SoFbcNjt8rLbn/yCqO8tzIluG6jciFaRvFX8W0dw7pcHRztSh7gjVNj9Cxwkt9LGICT7em2zeV2iwpzCrLh9UaHIDah904bv5BSAwVpHpLXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UXQkIYxP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UXQkIYxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD77CC19424;
	Thu, 26 Mar 2026 22:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774564803;
	bh=iAtnxxCAUCkZUia1OWke1EBuVKK5bzRRupk8WbbWY34=;
	h=Date:To:From:Subject:From;
	b=UXQkIYxPTpGqzb1O64FwypTVaa7eRmzFL4gpssgoNjkLfyMsLwW2ahiOb+kJ8JgU8
	 vz0p2mSlO7jnHiqPOBbKzpk7QlduXSskiDoh3BaAmnYLJi1zzDt+f5xR6uVx318O0/
	 sb75l2OUuwGzzPZfDFRJW9+tIIaHUXMMrITLBYoA=
Date: Thu, 26 Mar 2026 15:40:03 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,pmladek@suse.com,kees@kernel.org,dhowells@redhat.com,davidgow@google.com,lk@c--e.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-scatterlist-fix-temp-buffer-in-extract_user_to_sg.patch added to mm-nonmm-unstable branch
Message-Id: <20260326224003.DD77CC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/scatterlist: fix temp buffer in extract_user_to_sg()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-scatterlist-fix-temp-buffer-in-extract_user_to_sg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-scatterlist-fix-temp-buffer-in-extract_user_to_sg.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Christian A. Ehrhardt" <lk@c--e.de>
Subject: lib/scatterlist: fix temp buffer in extract_user_to_sg()
Date: Thu, 26 Mar 2026 22:49:02 +0100

Instead of allocating a temporary buffer for extracted user pages
extract_user_to_sg() uses the end of the to be filled scatterlist as a
temporary buffer.

Fix the calculation of the start address if the scatterlist already
contains elements.  The unused space starts at sgtable->sgl +
sgtable->nents not directly at sgtable->nents and the temporary buffer is
placed at the end of this unused space.

A subsequent commit will add kunit test cases that demonstrate that the
patch is necessary.

Pointed out by sashiko.dev on a previous iteration of this series.

Link: https://lkml.kernel.org/r/20260326214905.818170-3-lk@c--e.de
Fixes: 018584697533 ("netfs: Add a function to extract an iterator into a scatterlist")
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>	[v6.5+]
Cc: David Gow <davidgow@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/scatterlist.c~lib-scatterlist-fix-temp-buffer-in-extract_user_to_sg
+++ a/lib/scatterlist.c
@@ -1123,8 +1123,7 @@ static ssize_t extract_user_to_sg(struct
 	size_t len, off;
 
 	/* We decant the page list into the tail of the scatterlist */
-	pages = (void *)sgtable->sgl +
-		array_size(sg_max, sizeof(struct scatterlist));
+	pages = (void *)sg + array_size(sg_max, sizeof(struct scatterlist));
 	pages -= sg_max;
 
 	do {
_

Patches currently in -mm which might be from lk@c--e.de are

lib-scatterlist-fix-length-calculations-in-extract_kvec_to_sg.patch
lib-scatterlist-fix-temp-buffer-in-extract_user_to_sg.patch
lib-kunit_iov_iter-fix-memory-leaks.patch
lib-kunit_iov_iter-improve-error-detection.patch
lib-kunit_iov_iter-add-tests-for-extract_iter_to_sg.patch

