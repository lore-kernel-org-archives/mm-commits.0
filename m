Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16891388
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 01:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725238978; cv=none; b=NhIJowtZIVndn7aiuxMlV3yrfH+PHjWtYFwc0dFPboEMgd7KesSdQFEsVsOga7b73GIZ+KiLJjZWjV8+q3p7YlFj7f0G8vXtxliWD0BMnnsG3Ee3ei7kOrSzIa/+ggmH6IcVTGayduLaHPQyiERT9u3SXy1mW0gQQ3opDXwBbFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725238978; c=relaxed/simple;
	bh=oclbzcoLeWcopyzVnbyTHyOhZmd5u3iCyegpblOaDiY=;
	h=Date:To:From:Subject:Message-Id; b=dB71ulUCozv5BZ/XBdIoHaOzn6gpfP6hYTpQ7FqSNJFddsHPkrsRm3TcormRDsengVmhYhNUbZjZ4wR3EdcOManwChzEBQdIresHqKm3Q0ez5n8rtNnLVOjLBwKw/46egYqY/6tyCO4LfKjNikus3KnITy5S2UdyVXSiJOaivG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GDV0doJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GDV0doJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A79DC4CEC3;
	Mon,  2 Sep 2024 01:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725238977;
	bh=oclbzcoLeWcopyzVnbyTHyOhZmd5u3iCyegpblOaDiY=;
	h=Date:To:From:Subject:From;
	b=GDV0doJA8P8rn2Rsvey1ATKXHVBVD6iGn/77z/I6D6h1/N7X7V3RTwPtK1fgOVH/M
	 EYGv1+Fkt3xZB81g8yCd9RBzoQ/NvfcggR8WENdwTAClhmiXUkvyW8JZjg7D5svitr
	 NqM+3OkXrVv3RNoKgKVVcDAGAnlosBVY1iAuwVCY=
Date: Sun, 01 Sep 2024 18:02:56 -0700
To: mm-commits@vger.kernel.org,dakr@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-kvmalloc-align-kvrealloc-with-krealloc-fix-2.patch removed from -mm tree
Message-Id: <20240902010257.6A79DC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: kvrealloc: disable KASAN when switching to vmalloc
has been removed from the -mm tree.  Its filename was
     mm-kvmalloc-align-kvrealloc-with-krealloc-fix-2.patch

This patch was dropped because it was folded into mm-kvmalloc-align-kvrealloc-with-krealloc.patch

------------------------------------------------------
From: Danilo Krummrich <dakr@kernel.org>
Subject: mm: kvrealloc: disable KASAN when switching to vmalloc
Date: Tue, 30 Jul 2024 20:49:41 +0200

Disable KASAN accessibility checks when switching from a kmalloc buffer
to a vmalloc buffer.

Link: https://lkml.kernel.org/r/20240730185049.6244-2-dakr@kernel.org
Fixes: 923a26b4c679 ("mm: kvmalloc: align kvrealloc() with krealloc()")
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/util.c~mm-kvmalloc-align-kvrealloc-with-krealloc-fix-2
+++ a/mm/util.c
@@ -753,7 +753,10 @@ void *kvrealloc_noprof(const void *p, si
 
 		if (p) {
 			/* We already know that `p` is not a vmalloc address. */
-			memcpy(n, p, ksize(p));
+			kasan_disable_current();
+			memcpy(n, kasan_reset_tag(p), ksize(p));
+			kasan_enable_current();
+
 			kfree(p);
 		}
 	}
_

Patches currently in -mm which might be from dakr@kernel.org are

mm-vmalloc-implement-vrealloc.patch
mm-kvmalloc-align-kvrealloc-with-krealloc.patch
mm-kvmalloc-align-kvrealloc-with-krealloc-fix-3.patch
mm-krealloc-consider-spare-memory-for-__gfp_zero.patch
mm-krealloc-clarify-valid-usage-of-__gfp_zero.patch

