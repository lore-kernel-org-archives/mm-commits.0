Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B13C8634E
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189264; cv=none; b=Fwvg6ZR2bLifmH7rtZaqBeO/+WTFS8SM32uufBEa6MGNKB/wjxV3t/EriC0BraVuRCPSSoFlOjMDIZMQLpqFM7MZ/T7vGTg8s4wSldCQcBzR1qFaZPrTfqgCLW1ctivfl+gJdgWsFS+juFpWVszg5EcFGpwTQzdECl/F0jzi/Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189264; c=relaxed/simple;
	bh=yYOISunnX0aOwLK8byDweAH6mDrcu4kBMlXtDWgQm+M=;
	h=Date:To:From:Subject:Message-Id; b=B6ZCh9cKTykDbOne7uZLpEFhhS6jB7O9KmgItk/wzzzmGQ/BHesrb0tg4b+x8WNeCARfZERofNwY0KxI2t594ZIQX2CUVj1eOlK4XTB3agvGmqyTWY88KVhnTZ39DDLLc5Dh7suHqA4X7YLcmqwoib0E8hjb+5oEF4DLf6hcYHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qr5B7Soj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qr5B7Soj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFEEC4CEEC;
	Mon, 17 Mar 2025 05:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189263;
	bh=yYOISunnX0aOwLK8byDweAH6mDrcu4kBMlXtDWgQm+M=;
	h=Date:To:From:Subject:From;
	b=qr5B7SojvKpueNcDRERzxUeHhtyy8KiIhvBeok3ZdcjyQxzF+dAufsOG+70bUfmq2
	 utv/uAmICC50YSVhn7K9DHEUl2IWAV5cLTVcrz1uOhxi8+Vb/zgs5XKdmoQBDejNcB
	 jDLdSoQDIPcuxcE5BAInzxTA8l7wJwOKBFQIpaSc=
Date: Sun, 16 Mar 2025 22:27:43 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,sfr@canb.auug.org.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-interval_tree-add-test-case-for-interval_tree_iter_xxx-helpers-fix.patch removed from -mm tree
Message-Id: <20250317052743.9FFEEC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hack for "lib/interval_tree: add test case for interval_tree_iter_xxx() helpers"
has been removed from the -mm tree.  Its filename was
     lib-interval_tree-add-test-case-for-interval_tree_iter_xxx-helpers-fix.patch

This patch was dropped because it was folded into lib-interval_tree-add-test-case-for-interval_tree_iter_xxx-helpers.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: hack for "lib/interval_tree: add test case for interval_tree_iter_xxx() helpers"
Date: Wed, 12 Mar 2025 11:03:37 +1100

some of tools/ uses -Wno-unused-parameter

Link: https://lkml.kernel.org/r/20250312113612.31ac808e@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/linux/bitmap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/include/linux/bitmap.h~lib-interval_tree-add-test-case-for-interval_tree_iter_xxx-helpers-fix
+++ a/tools/include/linux/bitmap.h
@@ -80,7 +80,7 @@ static inline void bitmap_or(unsigned lo
 		__bitmap_or(dst, src1, src2, nbits);
 }
 
-static inline unsigned long *bitmap_alloc(unsigned int nbits, gfp_t flags)
+static inline unsigned long *bitmap_alloc(unsigned int nbits, gfp_t flags __maybe_unused)
 {
 	return malloc(bitmap_size(nbits));
 }
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

lib-interval_tree-add-test-case-for-interval_tree_iter_xxx-helpers.patch

