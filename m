Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42416F06A
	for <mm-commits@vger.kernel.org>; Fri,  6 Jun 2025 01:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749172441; cv=none; b=Mm98EjIhuCE5rH4ByX+KpzQWkII+UlZ7wT2sFr1OEhXOA0TlhPBBwiegbpMR2Cm5wC+JX5EWMTKlV2DGEXx8pitIBvd7vs03Wq4Yu/fTFLa+26xPuOTIV+jDlyBey1hRkOMEW2ophGsA+ipI4vW7N2ljsOg2X/8ZOUzANVio3mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749172441; c=relaxed/simple;
	bh=Nx1tnZTfFWmewoc8Ke6nHReD04qGVTrU2JW3FMBDOz8=;
	h=Date:To:From:Subject:Message-Id; b=O5svpndNM1zc445v/RjqaZDmZ1YF6sLyi9S93e1OhipgWwuiyXn7noq4nXUAaIVkytAkFalNa0MRk3AIrDmaudN502QaOadX3Jp5YGvxNQ7OkaJRbonPmwwCvIvSbZPv4R4F1uCfh58bEfXaLfPMbZmIU/CyH/YCs4gvLfdEM4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EjZ45qtA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EjZ45qtA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44564C4CEE7;
	Fri,  6 Jun 2025 01:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749172441;
	bh=Nx1tnZTfFWmewoc8Ke6nHReD04qGVTrU2JW3FMBDOz8=;
	h=Date:To:From:Subject:From;
	b=EjZ45qtAv3qrP8+dvCkiQasUMLssZ1F5E09R2Ju94sC3wmpXZ4ghQFi6aXs3DXVm0
	 3W5AgaYoiBLP2UaUybwqieSDYJgHbUGe+UeySyHQzcCvrRO0+RC5QLcBSIoSIc8fFk
	 NtNhlfcgXfgor8fJRvIHYzF4muKMZg4g78sxyPv8=
Date: Thu, 05 Jun 2025 18:14:00 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scatterlist-fix-extraneous-sign-kernel-doc-notation.patch added to mm-hotfixes-unstable branch
Message-Id: <20250606011401.44564C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scatterlist: fix extraneous '@'-sign kernel-doc notation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     scatterlist-fix-extraneous-sign-kernel-doc-notation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scatterlist-fix-extraneous-sign-kernel-doc-notation.patch

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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: scatterlist: fix extraneous '@'-sign kernel-doc notation
Date: Wed, 4 Jun 2025 17:23:37 -0700

Using "@argname@" in kernel-doc produces "argname****" (with "argname" in
bold) in the generated html output, so use the expected kernel-doc
notation of just "@argname" instead.

"Fixes:" lines are added in case Matthew's patch [1] is backported.

Link: https://lkml.kernel.org/r/20250605002337.2842659-1-rdunlap@infradead.org
Link: https://lore.kernel.org/linux-doc/3bc4e779-7a79-42c1-8867-024f643a22fc@infradead.org/T/#m5d2bd9d21fb34f297aa4e7db069f09bc27b89007 [1]
Fixes: 0db9299f48eb ("SG: Move functions to lib/scatterlist.c and add sg chaining allocator helpers")
Fixes: 8d1d4b538bb1 ("scatterlist: inline sg_next()")
Fixes: 18dabf473e15 ("Change table chaining layout")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/scatterlist.h |    4 ++--
 lib/scatterlist.c           |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/scatterlist.h~scatterlist-fix-extraneous-sign-kernel-doc-notation
+++ a/include/linux/scatterlist.h
@@ -99,7 +99,7 @@ static inline bool sg_is_last(struct sca
  * @sg:		The current sg entry
  *
  * Description:
- *   Usually the next entry will be @sg@ + 1, but if this sg element is part
+ *   Usually the next entry will be @sg + 1, but if this sg element is part
  *   of a chained scatterlist, it could jump to the start of a new
  *   scatterlist array.
  *
@@ -254,7 +254,7 @@ static inline void __sg_chain(struct sca
  * @sgl:	Second scatterlist
  *
  * Description:
- *   Links @prv@ and @sgl@ together, to form a longer scatterlist.
+ *   Links @prv and @sgl together, to form a longer scatterlist.
  *
  **/
 static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
--- a/lib/scatterlist.c~scatterlist-fix-extraneous-sign-kernel-doc-notation
+++ a/lib/scatterlist.c
@@ -73,9 +73,9 @@ EXPORT_SYMBOL(sg_nents_for_len);
  *   Should only be used casually, it (currently) scans the entire list
  *   to get the last entry.
  *
- *   Note that the @sgl@ pointer passed in need not be the first one,
- *   the important bit is that @nents@ denotes the number of entries that
- *   exist from @sgl@.
+ *   Note that the @sgl pointer passed in need not be the first one,
+ *   the important bit is that @nents denotes the number of entries that
+ *   exist from @sgl.
  *
  **/
 struct scatterlist *sg_last(struct scatterlist *sgl, unsigned int nents)
@@ -345,7 +345,7 @@ EXPORT_SYMBOL(__sg_alloc_table);
  * @gfp_mask:	GFP allocation mask
  *
  *  Description:
- *    Allocate and initialize an sg table. If @nents@ is larger than
+ *    Allocate and initialize an sg table. If @nents is larger than
  *    SG_MAX_SINGLE_ALLOC a chained sg table will be setup.
  *
  **/
_

Patches currently in -mm which might be from rdunlap@infradead.org are

scatterlist-fix-extraneous-sign-kernel-doc-notation.patch

