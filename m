Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50FC33556D
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465756; cv=none; b=g57Ddd03X1QzXVQ7U3wRRnMBAg0KRC2S74w3eJqQMAv+gnjbUmuW1lYIeZzYxZ33xoFp40o3pS443ip0pBMdtLiBJitSwAALxYlfMkx8Bxb7BTxubLouf2F+UWTnclWtPvk25IlkQ7PDbe/Zc43AGoS/egQGoHdHxL5ZTwsaV9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465756; c=relaxed/simple;
	bh=gdf14sqYg3mg+LmnyxRDxeXgKtWjvV4EnveFSqnOuy4=;
	h=Date:To:From:Subject:Message-Id; b=etAZcIGfU0dk/UMVjoYmW+T0yzIBeIW06xafUA/GHrRxgLgWKfGFHxH/VZbDfPGz516tSa9YyRISnv55KGwgM1kFCC0eiLcUA0Y9gkkWYPuvwt1/3sny7flyvqPIUY2K7mbDxQzdilqqXW6+JOndGDMu3fa3/BNzAmI01AXz5qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lZSVIdMN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lZSVIdMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3730D1F000E9;
	Fri, 31 Jul 2026 02:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465754;
	bh=al2pJ73hKfWT+JsV3EOv+YxNb1YIbL7RIJwX5dxKDw0=;
	h=Date:To:From:Subject;
	b=lZSVIdMN0gh04P19YvISmL68eew839noXJucxuU6rkIL5tKD2FyCHXWsePt94mpRb
	 xhfletUp08qFHdakF9ZMvJU7Ab65gzVODavgFY3k4awoETTTPaMmv4531Lq4mUvI3E
	 c9NE2A7N20arO4sPmO3iS6zO6CYqF12JYNWvKwcE=
Date: Thu, 30 Jul 2026 19:42:33 -0700
To: mm-commits@vger.kernel.org,rcampbell@nvidia.com,leon@kernel.org,jgg@ziepe.ca,skinsburskii@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_hmm-fail-dmirror_fault-when-the-mirrored-mm-is-gone.patch removed from -mm tree
Message-Id: <20260731024234.3730D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_hmm: fail dmirror_fault() when the mirrored mm is gone
has been removed from the -mm tree.  Its filename was
     lib-test_hmm-fail-dmirror_fault-when-the-mirrored-mm-is-gone.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


