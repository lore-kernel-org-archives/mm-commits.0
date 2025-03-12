Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33ED31422DD
	for <mm-commits@vger.kernel.org>; Wed, 12 Mar 2025 15:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741793221; cv=none; b=C3GIOjZcPLwH0J2+hKxblDQDOmCYGpa0zB5pZ8s1dl7iwthVvbyaRtF6ngiDLNfDhCFEIsBbQieAR9Giv/c4x/rZ2x9U7dYNEeSBOWZhAu3KrBrin2eT0s8SwmpvhZ9IX9TCY5cHcErfUR3CMEWGxJLbtXB+gUSjom9R3zbqWtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741793221; c=relaxed/simple;
	bh=DUFVowzzCrbs7Q9tMhn8gd0auJ2wz+ro0yr2+Wwly+0=;
	h=Date:To:From:Subject:Message-Id; b=OVFcGH13g4Opocs/X+Za/DZ789DR3DeWwltPhQgDWLN/UvGBaaz3GPelY4Qxy0yduZfK6VGgdlnOFfZA4CPJEwLP6zVNy0oYdI77xCrcgo+0/2nZmq3Dt1Y1paXcU6VsiHCevBYP+T1w39nFLW/dAmoH5meI602D0lpF8uhiGtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FucLsjAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FucLsjAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94931C4CEDD;
	Wed, 12 Mar 2025 15:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741793220;
	bh=DUFVowzzCrbs7Q9tMhn8gd0auJ2wz+ro0yr2+Wwly+0=;
	h=Date:To:From:Subject:From;
	b=FucLsjAgoUS/AzFUsvWopjD7LLmeDZXSOAgKmYQNu+zMIIxCRxcqIzp/CEBNDQwI/
	 D6Hb9DoX1dVQ0sieqPoJcFzGePWAX4JwspOTAZAe633gPfzO2poxGpxZE7oJpuPSwq
	 wpbXoN9HXpPFXTS4wouyZZJSS3ma6rn4VbjSHo9s=
Date: Wed, 12 Mar 2025 08:26:59 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,sfr@canb.auug.org.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-interval_tree-add-test-case-for-interval_tree_iter_xxx-helpers-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250312152700.94931C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Date: Wed, 12 Mar 2025 11:03:37 +1100
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-interval_tree-add-test-case-for-interval_tree_iter_xxx-helpers-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-interval_tree-add-test-case-for-interval_tree_iter_xxx-helpers-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 12 Mar 2025 11:03:37 +1100
Subject: hack for "lib/interval_tree: add test case for interval_tree_iter_xxx() helpers"

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

mm-swap-simplify-folio-swap-allocation-fix.patch
lib-interval_tree-add-test-case-for-interval_tree_iter_xxx-helpers-fix.patch

