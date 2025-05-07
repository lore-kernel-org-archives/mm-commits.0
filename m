Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6926128C034
	for <mm-commits@vger.kernel.org>; Wed,  7 May 2025 18:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746641394; cv=none; b=GJfpWGPT1o4hKq0imsU9PsOQ3xDAwpkByESBOzK6HWqoOVmzCP5JKX7RaM1Iqp8VP0V4tikLRia2yFZ2vTytu7cPDzyEhOKOuP6dvGX2JuAHad7Sy7lpyGsO/mUbK5nxH61lfr4ISspCSCdXWq5Dst0ZOPO9bcbVbg7wrWFouKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746641394; c=relaxed/simple;
	bh=a+TPC+ysw1n5JFiEVJHgbvZWYxvgUNq5x6SJlK3C4Tw=;
	h=Date:To:From:Subject:Message-Id; b=MCnFQ9RyCuIb5wpDuOaixXFd5VSvbXbspISR1shmifQ6DIC9d5FTQl71xup/y0/9FsKT/heJazuWMwqXN/9n5VxnhpXPHa3An5Cyeei8epLCdhnPxZ4LGCYXm6Jeh7rVh+y182KhIQureefvIP8gCKH/2YNUJLBd09IC1CftNNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZX2Nd8Lb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZX2Nd8Lb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE045C4CEE2;
	Wed,  7 May 2025 18:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746641394;
	bh=a+TPC+ysw1n5JFiEVJHgbvZWYxvgUNq5x6SJlK3C4Tw=;
	h=Date:To:From:Subject:From;
	b=ZX2Nd8LboF9GC6By5686urFuEkvP4t3AsdqUQaAAnQEUgHYoEniXY5cgCg+nbrFV5
	 MxHAsE70Y67O0yojpheH/EbU4OmPDt7fh7fM807nOF7F0DUobAGnqNpzEGpMdRZim7
	 Nj2xF6nput8uD8GXYDMVNjfroE6RhZoMJiIFalSk=
Date: Wed, 07 May 2025 11:09:53 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-fix-kerneldoc-for-__xa_cmpxchg.patch added to mm-unstable branch
Message-Id: <20250507180953.DE045C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xarray: fix kerneldoc for __xa_cmpxchg
has been added to the -mm mm-unstable branch.  Its filename is
     xarray-fix-kerneldoc-for-__xa_cmpxchg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-fix-kerneldoc-for-__xa_cmpxchg.patch

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
From: Christoph Hellwig <hch@lst.de>
Subject: xarray: fix kerneldoc for __xa_cmpxchg
Date: Wed, 7 May 2025 07:16:20 +0200

Fix the documentation for __xa_cmpxchg to actually describe the
cmpxch-like semantics correctly, based on the version for xa_cmpxchg.

Link: https://lkml.kernel.org/r/20250507051656.3900864-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/lib/xarray.c~xarray-fix-kerneldoc-for-__xa_cmpxchg
+++ a/lib/xarray.c
@@ -1742,20 +1742,23 @@ static inline void *__xa_cmpxchg_raw(str
 			void *old, void *entry, gfp_t gfp);
 
 /**
- * __xa_cmpxchg() - Store this entry in the XArray.
+ * __xa_cmpxchg() - Conditionally replace an entry in the XArray.
  * @xa: XArray.
  * @index: Index into array.
  * @old: Old value to test against.
- * @entry: New entry.
+ * @entry: New value to place in array.
  * @gfp: Memory allocation flags.
  *
  * You must already be holding the xa_lock when calling this function.
  * It will drop the lock if needed to allocate memory, and then reacquire
  * it afterwards.
  *
+ * If the entry at @index is the same as @old, replace it with @entry.
+ * If the return value is equal to @old, then the exchange was successful.
+ *
  * Context: Any context.  Expects xa_lock to be held on entry.  May
  * release and reacquire xa_lock if @gfp flags permit.
- * Return: The old entry at this index or xa_err() if an error happened.
+ * Return: The old value at this index or xa_err() if an error happened.
  */
 void *__xa_cmpxchg(struct xarray *xa, unsigned long index,
 			void *old, void *entry, gfp_t gfp)
_

Patches currently in -mm which might be from hch@lst.de are

xarray-fix-kerneldoc-for-__xa_cmpxchg.patch

