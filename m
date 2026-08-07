Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294AE3B05BC
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068072; cv=none; b=Ighk4wuYLtBnEjuxpTOT0+88jjB9Mq524//m5zhZmy2fHjIZgewc4qshUrRhTYe7DI0KOshVrNenxxeKpBMGrkyGSnRzw1rMvyfNmnzlojpXD+exy1cOaa+d9BO+ajUzeZFrkc6RQQH2CGzikPtxZG7d1edrAMQ+wD4bG7R8ulI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068072; c=relaxed/simple;
	bh=Hn6TOTrW8kiXltzsg3oX2KCI8ShEmeiGUIoMCuHrsQ8=;
	h=Date:To:From:Subject:Message-Id; b=oQM1Ey4Rs2/hPdjkOKiFpNQ3T+lC4RSYRnhBUMUY3BzwRGpp8WAaC4B+uxuPvFZBLaD036eoaLRpFZCiF6quVnhj4pu0IMHiLPXVJcQ+p7GfCkU4inf4H3BtbXuBW5TJDB7UINPMrqYDJK7HjbBToreW9j5Zfx8C5DtfaUCwqqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O9PUm21/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O9PUm21/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96791F00A3D;
	Fri,  7 Aug 2026 02:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068066;
	bh=55V838aT+fiKwShpoQ5D09f2gV/M2UqRR0zABxTjYIY=;
	h=Date:To:From:Subject;
	b=O9PUm21/ofFuL/V/11vqMqJfFpQX0zp3DAhQwTfnPMwSvdQ2ShGVBzfMrUhUNwQpQ
	 VLrA+ScanSdWxxGvEjN0HM6zkzyW+UrXuEw/Kj+juIz0ccQjjmD0gVdJwNwXgH8cSq
	 7Tj47cVVAMwk6FlwkoP1iGetDO0KqoZ8PZ0Ekby4=
Date: Thu, 06 Aug 2026 19:01:06 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-hide-private-damos_filter-fields.patch removed from -mm tree
Message-Id: <20260807020106.C96791F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: hide private damos_filter fields
has been removed from the -mm tree.  Its filename was
     mm-damon-core-hide-private-damos_filter-fields.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: hide private damos_filter fields
Date: Tue, 14 Jul 2026 07:35:38 -0700

damos_filter->list is intended to be used by only the DAMON core layer. 
However, it is mistakenly not marked as private.  Mark as private.

Link: https://lore.kernel.org/20260714143544.101305-6-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-core-hide-private-damos_filter-fields
+++ a/include/linux/damon.h
@@ -432,7 +432,6 @@ enum damos_filter_type {
  *		&damon_ctx->adaptive_targets if @type is
  *		DAMOS_FILTER_TYPE_TARGET.
  * @sz_range:	Size range if @type is DAMOS_FILTER_TYPE_HUGEPAGE_SIZE.
- * @list:	List head for siblings.
  *
  * Before applying the &damos->action to a memory region, DAMOS checks if each
  * byte of the region matches to this given condition and avoid applying the
@@ -450,6 +449,8 @@ struct damos_filter {
 		int target_idx;
 		struct damon_size_range sz_range;
 	};
+/* private: */
+	/* List head for siblings. */
 	struct list_head list;
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are


