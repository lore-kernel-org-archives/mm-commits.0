Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2473D15C158
	for <mm-commits@vger.kernel.org>; Thu, 12 Jun 2025 05:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749706981; cv=none; b=HRQtdXehFebAWJ0ok8jzxCe+CzsHqRFVCedvDGGP4pAXjcyX52QGlsDtO5YYziONLMfmjuftlVohcz2yEyknQRkGDPYDf6DdifaTTOFlty3nDoaFlImPjn7g2OpsLlNQ1N6Fp7iInlGYPsPguOI2z1i07xN2WGUfB3VAqCyg0hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749706981; c=relaxed/simple;
	bh=iNDlnBNExVOmwjsGn10wU+IxyGATO258ndr1wovQnfA=;
	h=Date:To:From:Subject:Message-Id; b=E5pbP+1Ou86Xkdu0WjlqV4hKGor6cb7snbsFhFXr5rc/LTvsZiflI6FgiUHaWAU4sDuKSQ1JftYIKAS238pAUD/juiIJ3F+XjssMzKUIXhGDzKt1pBPVIxgs4lsmJ/OS2fMpNn0ZHi/nhcwbDMTaUg4IaNBnRy6qkWR58FhSdIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OQ7dKwTF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OQ7dKwTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A233DC4CEEA;
	Thu, 12 Jun 2025 05:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749706980;
	bh=iNDlnBNExVOmwjsGn10wU+IxyGATO258ndr1wovQnfA=;
	h=Date:To:From:Subject:From;
	b=OQ7dKwTFwTady7nVVi0TktavBwL7CngmthoqNQjlZwMvzUKcoS30HB7ZFvOCSZvDX
	 6YQ6KMZNTdYH9yw3+eaiApQoORgaBkgfUn18XzYMdoAnr123bWb29Uje5TqbUqd2D/
	 rqq8eXr3xeJodKBP+YZpGNYLK+ph7j75PS2FXTxI=
Date: Wed, 11 Jun 2025 22:42:59 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] scatterlist-fix-extraneous-sign-kernel-doc-notation.patch removed from -mm tree
Message-Id: <20250612054300.A233DC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scatterlist: fix extraneous '@'-sign kernel-doc notation
has been removed from the -mm tree.  Its filename was
     scatterlist-fix-extraneous-sign-kernel-doc-notation.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


