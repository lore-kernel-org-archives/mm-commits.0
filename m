Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493072A1B8
	for <mm-commits@vger.kernel.org>; Sun,  1 Sep 2024 22:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725230520; cv=none; b=BJ/vqJkozc8mwee7hTw+ivxHFL9aFfv1jv6n4hzVrO0ANGWF1Z4YDNMhOtX85WBQ3PR8Xx4wZxdfkCxXNws9l2Jxubpp4dyARP62P4OmFaZVfK+NCcU+VB2Uo7VSrmBO7rXNEqq2vFMj5aJNf+I0z0jreHoFEPsiT68m2igZYKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725230520; c=relaxed/simple;
	bh=n5I/ie6PWNaqB4zoV6e9wPp1MWI+nlN1RuCQJK5rFKQ=;
	h=Date:To:From:Subject:Message-Id; b=IYM92CtwRsL6hCLay7LQ/W/T4SVpoXuZRi078Bn1KB0vpSmgk9H6wts3zkaqy3fnpHPamgaWfLeO3f7J7AhSzKHZfWRq1RmEJDl18gNfWvKaEke85RFTpEHHyW05G/aJAEalOuMp+ER8Xr1y1A787xuXKLQ2wv1CBZx8WS09gvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JExSd5Ln; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JExSd5Ln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34F8C4CEC3;
	Sun,  1 Sep 2024 22:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725230519;
	bh=n5I/ie6PWNaqB4zoV6e9wPp1MWI+nlN1RuCQJK5rFKQ=;
	h=Date:To:From:Subject:From;
	b=JExSd5LnDMzyeWowevnAiRjM1nT9r3P/PC5PhuvXgbYe/SxB4Htgo89m5GBXp0VAf
	 yQzot9m5JXRht8hZBJfysm6+Ex30l7VNJZVwz9uEEbd3U6A9hJOC2K+wPl7TpPMuZX
	 YGT7c3pqMsnj3qJovRaKvPWulrDGorub+eQWG0R4=
Date: Sun, 01 Sep 2024 15:41:59 -0700
To: mm-commits@vger.kernel.org,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-folio_alloc_noprof.patch added to mm-unstable branch
Message-Id: <20240901224159.A34F8C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix folio_alloc_noprof()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-folio_alloc_noprof.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-folio_alloc_noprof.patch

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
From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: mm: fix folio_alloc_noprof()
Date: Sun, 1 Sep 2024 16:24:59 -0400

folio_alloc_noprof) wasn't calling the _noprof version, causing
allocations to be accounted here instead of to the caller

Link: https://lkml.kernel.org/r/20240901202459.4867-1-kent.overstreet@linux.dev
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/gfp.h~mm-fix-folio_alloc_noprof
+++ a/include/linux/gfp.h
@@ -319,7 +319,7 @@ static inline struct page *alloc_pages_m
 }
 static inline struct folio *folio_alloc_noprof(gfp_t gfp, unsigned int order)
 {
-	return __folio_alloc_node(gfp, order, numa_node_id());
+	return __folio_alloc_node_noprof(gfp, order, numa_node_id());
 }
 static inline struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
 		struct mempolicy *mpol, pgoff_t ilx, int nid)
_

Patches currently in -mm which might be from kent.overstreet@linux.dev are

mm-fix-folio_alloc_noprof.patch
scripts-decode_stacktracesh-nix-ify.patch

