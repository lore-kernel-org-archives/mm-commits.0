Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8273121CA13
	for <mm-commits@vger.kernel.org>; Tue,  3 Feb 2026 19:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770148596; cv=none; b=T3HB2zpkeO9FC+L5S03xpzeUN+kWf4xY5aBi/dai6e1Mil04sWCdnIi97av1OoSe9+6P2jG8DHwfuaK2FOSC/BzqrsD3zBg1MiJE0qXLwkBzpxwOXL6IYdZe2EgddWOnZwFCb56disimQ00mySuibQE25+62bJx2Gp2Fk4AY1UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770148596; c=relaxed/simple;
	bh=7vfALXnu1PlkRFe2AMRScSEdJzEW+yKHDKT/SdlZhvk=;
	h=Date:To:From:Subject:Message-Id; b=GMVUqcHvNiwBtUZjvde/9y0WCKQQ77YqNiBPDtZn4JGlCnWyy9of8VjKp34Vst3WNhI3UrEg7h649FFyF4ttDh6CPto+VinDE+k4PdHs67dvq26iAzBiTHWMyfY9j5QxhFGou+ig+mQVidD5xiSMfjttqsq4J76dg1FbcZdGsuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jxo67cSl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jxo67cSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15193C116D0;
	Tue,  3 Feb 2026 19:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770148596;
	bh=7vfALXnu1PlkRFe2AMRScSEdJzEW+yKHDKT/SdlZhvk=;
	h=Date:To:From:Subject:From;
	b=Jxo67cSlT42eMXsNQkAe4KH72/AG3tK1Mdw3tGIw1q0JAhxYgPF55Bo0JX1wL+ibl
	 YTSNh8iGtmRdBsZfSVzZhO5ohpXwh5pMGJuMj9sSwphpMAZERJK6/kdD1PKrlddZJ/
	 ElTb3I/8VjGlAbmzglB4aOCC2yeHDm41sctGjUBw=
Date: Tue, 03 Feb 2026 11:56:35 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,cheng20011202@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-readahead-fix-typo-in-comment.patch added to mm-unstable branch
Message-Id: <20260203195636.15193C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/readahead: fix typo in comment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-readahead-fix-typo-in-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-readahead-fix-typo-in-comment.patch

This patch will later appear in the mm-unstable branch at
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
From: Wilson Zeng <cheng20011202@gmail.com>
Subject: mm/readahead: fix typo in comment
Date: Tue, 27 Jan 2026 23:25:35 +0800

Fix a typo in a comment: max_readhead -> max_readahead.

Link: https://lkml.kernel.org/r/20260127152535.321951-1-cheng20011202@gmail.com
Signed-off-by: Wilson Zeng <cheng20011202@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/readahead.c~mm-readahead-fix-typo-in-comment
+++ a/mm/readahead.c
@@ -436,7 +436,7 @@ static unsigned long get_next_ra_size(st
  * based on I/O request size and the max_readahead.
  *
  * The code ramps up the readahead size aggressively at first, but slow down as
- * it approaches max_readhead.
+ * it approaches max_readahead.
  */
 
 static inline int ra_alloc_folio(struct readahead_control *ractl, pgoff_t index,
_

Patches currently in -mm which might be from cheng20011202@gmail.com are

mm-readahead-fix-typo-in-comment.patch

