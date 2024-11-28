Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4648F126BF9
	for <mm-commits@vger.kernel.org>; Thu, 28 Nov 2024 01:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732758565; cv=none; b=dFLXFwvDk49JdidzsrczoqWdWbP/hM6CxNaBZjDAyl3RARTT/NfN9SfsCNaEe92qTqYg3QX9JIql2ffWozL/8IxWm9qKvrQ/G+VJProGt5AnVF3WZcTelEENbezcyDIBEpBNUnNJW5UI3LQrSnKHDJGrn4ewFk7IjDsS21lriNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732758565; c=relaxed/simple;
	bh=JIEfs6wBgtKxySebdSxmXTf4k5YZfeUoAcCHytDAtzs=;
	h=Date:To:From:Subject:Message-Id; b=PRYIQhDqEQKd5XRGhpEU3/Mt+tlAosjK84c/GjEILsZ65UdeooRKzZWVSilbemHeB74onOlPf3uQVl69pViJIr4yDZ7gHR9Jje/ByK6BwJR2nvhAsoXUEJWACHeckHotX3h3BPK23Obm8f5mrR5ExwYs3j3lGzJFfAVEZ6wf5d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G1SxEoBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G1SxEoBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3164C4CECC;
	Thu, 28 Nov 2024 01:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732758564;
	bh=JIEfs6wBgtKxySebdSxmXTf4k5YZfeUoAcCHytDAtzs=;
	h=Date:To:From:Subject:From;
	b=G1SxEoBkmKuDHo746NfKuhn0lYRAAb+X45Apoic8Blgrte3Yb7QCLoCVXELFBOAkB
	 J8AKilXbYwEm33KPMmRx+pSFVKxWITHrIEYUex9FGJ7WUek7PpiRN+tWhutQ2fCs8c
	 ZSrPWCRFoh3CF09KCWlH6lWK/x95soKXuzSUlJmo=
Date: Wed, 27 Nov 2024 17:49:24 -0800
To: mm-commits@vger.kernel.org,yikming2222@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-fix-a-comment-typo-in-lock_mm_and_find_vma.patch added to mm-unstable branch
Message-Id: <20241128014924.B3164C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: fix a comment typo in lock_mm_and_find_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-fix-a-comment-typo-in-lock_mm_and_find_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-fix-a-comment-typo-in-lock_mm_and_find_vma.patch

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
From: Chin Yik Ming <yikming2222@gmail.com>
Subject: mm/memory: fix a comment typo in lock_mm_and_find_vma()
Date: Wed, 20 Nov 2024 18:50:41 +0800

s/equivalend/equivalent/

Link: https://lkml.kernel.org/r/20241120105041.2394283-1-yikming2222@gmail.com
Signed-off-by: Chin Yik Ming <yikming2222@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-fix-a-comment-typo-in-lock_mm_and_find_vma
+++ a/mm/memory.c
@@ -6185,7 +6185,7 @@ static inline bool upgrade_mmap_lock_car
 /*
  * Helper for page fault handling.
  *
- * This is kind of equivalend to "mmap_read_lock()" followed
+ * This is kind of equivalent to "mmap_read_lock()" followed
  * by "find_extend_vma()", except it's a lot more careful about
  * the locking (and will drop the lock on failure).
  *
_

Patches currently in -mm which might be from yikming2222@gmail.com are

mm-memory-fix-a-comment-typo-in-lock_mm_and_find_vma.patch

