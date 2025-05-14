Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8211CFBC
	for <mm-commits@vger.kernel.org>; Wed, 14 May 2025 00:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747182412; cv=none; b=bdlqA2bQ8CaRin3m+Uvi8t/xH1yy5RKPrtZU96cXo5ESATS2yY8pcfiF/b5k+GLM+ROXuzvUXCimP3iWbX6lT659Z6jI7P1Q41/PWxI5+7SfErf8OruMcHKfK6qO15YStoJJ6Th1CAdsVbHpbbJhVJFyzKapuEQ3tMtiwV6GJJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747182412; c=relaxed/simple;
	bh=dCuyHCf2KQwgdfO+i1Jd5r8RZErOMerlXO/tNf/KOec=;
	h=Date:To:From:Subject:Message-Id; b=vGqaaxeOyIeDVBt1sZVljk9ckfZSKN3I0ZpgLi5LeFb7E9yG1MovloLM5nNYDCQrGvMIGzUGDL23Vb8kAHMa6s/LwOVgpYoEthTAnUgHys3edrLL3RJtf/BS9rTeo3UM7HsqdnMYnZLLUe4TXmYnNID/f6m36rV8JYceQe4o9XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j+aTjkrx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j+aTjkrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F6AC4CEE4;
	Wed, 14 May 2025 00:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747182411;
	bh=dCuyHCf2KQwgdfO+i1Jd5r8RZErOMerlXO/tNf/KOec=;
	h=Date:To:From:Subject:From;
	b=j+aTjkrxM3cD+Mefr2Ii0gzl++8uNu+uMSQ8qvBccL9XVX4VvQllmwLOQhMeEVlpe
	 UZMFdrAowFWzkuDw9GnxyaYdynaCnIgS4+8AR6vgu7UGPWQk4qlsTqVPEyn6hoHJ7Z
	 w5WIzaOPEzm3AagvlfGyKBM6W/osfHhcelYO/wqE=
Date: Tue, 13 May 2025 17:26:50 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,kbusch@kernel.org,brauner@kernel.org,axboe@kernel.dk,anuj20.g@samsung.com,nj.shetty@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + iov_iter-use-iov_offset-for-length-calculation-in-iov_iter_aligned_bvec.patch added to mm-hotfixes-unstable branch
Message-Id: <20250514002651.93F6AC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: iov_iter: use iov_offset for length calculation in iov_iter_aligned_bvec
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     iov_iter-use-iov_offset-for-length-calculation-in-iov_iter_aligned_bvec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/iov_iter-use-iov_offset-for-length-calculation-in-iov_iter_aligned_bvec.patch

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
From: Nitesh Shetty <nj.shetty@samsung.com>
Subject: iov_iter: use iov_offset for length calculation in iov_iter_aligned_bvec
Date: Mon, 28 Apr 2025 15:28:48 +0530

If iov_offset is non-zero, then we need to consider iov_offset in length
calculation, otherwise we might pass smaller IOs such as 512 bytes, in
below scenario [1].

This issue is reproducible using lib-uring test/fixed-seg.c application
with fixed buffer on a 512 LBA formatted device.

[1]
At present we pass the alignment check,
for 512 LBA formatted devices, len_mask = 511
when IO is smaller, i->count = 512
has an offset, i->io_offset = 3584
with bvec values, bvec->bv_offset = 256, bvec->bv_len = 3840.
In short, the first 256 bytes are in the current page,
next 256 bytes are in the another page.
Ideally we expect to fail the IO.

Link: https://lkml.kernel.org/r/20250428095849.11709-1-nj.shetty@samsung.com
Fixes: 2263639f96f2 ("iov_iter: streamline iovec/bvec alignment iteration")
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Keith Busch <kbusch@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/iov_iter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/iov_iter.c~iov_iter-use-iov_offset-for-length-calculation-in-iov_iter_aligned_bvec
+++ a/lib/iov_iter.c
@@ -820,7 +820,7 @@ static bool iov_iter_aligned_bvec(const
 	size_t size = i->count;
 
 	do {
-		size_t len = bvec->bv_len;
+		size_t len = bvec->bv_len - skip;
 
 		if (len > size)
 			len = size;
_

Patches currently in -mm which might be from nj.shetty@samsung.com are

iov_iter-use-iov_offset-for-length-calculation-in-iov_iter_aligned_bvec.patch

