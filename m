Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794268965;
	b=Q4QNx0qLypMQitw37XYNq0p0buODfdQXDibWWcJWCnYNiqJfY59k2Dmgg4Wl5Xgm3LF1
	 HhOPfOBoaeZUZPkB0KgjdCp0mHrkM2izNGcLmukowUMJahtBa8UFH1mBCid+HwvPcqQO9
	 9REpEed3WkXfsMt5GeGENv8E1Nw9jINkXe9CqyiN/XN1BktPO1zE6jx/Y63GsIw/UVV9U
	 irgNGPV1RJRU6sP6UzDluwlZLhcUuLYva4LnSnvkty40f+Gvhao6l1jyaQ7syXbSK0SZh
	 Ohz9NCj1jv1iFo+aYu2igV2wn8FzaO07rzuSubLwbO7DqxLDyJrGeA4GT+vp/qjydUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794268965;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=JzGZndN7+ezPEbLpvpUAMIU+A/uxXSSY/M5gMLpHZy4=;
	b=Fm/l+iQVri07ftnLU6bNQSndPdLwfgGIGwzkr+NFsMpFix9NjNNGATWvuIA8GI0ZsimN
	 nXfyX5pnwOwZPZP9afolqHfyc/0DTA9zfmoSOR730/g2AUtO30HyVK9jC2xGi48QtEo/9
	 BoY51P5oU+b26CS5uezSsKzL02tPP2CWeC1Lp6CRRFkoRnI0zuuNAheznb2D12yTszSqu
	 856NOO/0vmpkDd3yaDkruzy3LkEsfPC3u3/rj3V+n6WeM/YL/PugCsEqR/sLRGthStUYo
	 9QMPjGGcJ491uilml/2EZYaHxWqEdTtBI4fiRjyb6FDnDvAwyJ0871cESlfvAThqgdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Y0ebXSPQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEBB606A334
	for <mm-commits@vger.kernel.org>; Tue, 10 Nov 2026 00:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Y0ebXSPQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF531F008A1;
	Tue, 10 Nov 2026 00:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794268964;
	bh=JzGZndN7+ezPEbLpvpUAMIU+A/uxXSSY/M5gMLpHZy4=;
	h=Date:To:From:Subject;
	b=Y0ebXSPQ6QnA75MOX+ZaIawSSr3gTtFmME8paCvdbL+1HYWZgqp38dUIqd2dDJx/H
	 5EgxvxeH+9813VXCRBdEOfpaHcyLJjRSZfnypznSP0FrnAT+/hg04nSqeCsdM1JwfE
	 6E7IaPGFXwxlHrGgzQ43dEGUrmK9+osNJMG/QDa8=
Date: Mon, 09 Nov 2026 16:02:44 -0800
To: mm-commits@vger.kernel.org,raemoar63@gmail.com,noring@nocrew.org,
	hch@lst.de,fredrik.noring@gmail.com,david@davidgow.net,
	brendan.higgins@linux.dev,amit.patole@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-genalloc-dont-dereference-a-null-pool-in-gen_pool_dma_alloc.patch added to mm-nonmm-unstable branch
Message-Id: <20261110000244.CFF531F008A1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: lib/genalloc: don't dereference a NULL pool in gen_pool_dma_[z]alloc()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-genalloc-dont-dereference-a-null-pool-in-gen_pool_dma_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-genalloc-dont-dereference-a-null-pool-in-gen_pool_dma_alloc.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Amit Patole <amit.patole@gmail.com>
Subject: lib/genalloc: don't dereference a NULL pool in gen_pool_dma_[z]alloc()
Date: Fri, 06 Nov 2026 09:02:32 -0500

Patch series "lib/genalloc: fix a NULL pool check and add KUnit tests".

genalloc has no unit tests, so patch 2 adds a KUnit suite.  Writing it
turned up that gen_pool_dma_alloc() and gen_pool_dma_zalloc() crash on a
NULL pool, while the other DMA helpers return NULL as gen_pool_dma_alloc()
originally did.  Patch 1 restores the check; no in-tree caller passes a
NULL pool, so it is not marked for stable.

Tested on UML with a kunitconfig of CONFIG_KUNIT=y and
CONFIG_GENALLOC_KUNIT_TEST=y: 12/12 pass with patch 1, and
genalloc_dma_test crashes without it.


This patch (of 2):

gen_pool_dma_alloc() returned NULL for a NULL pool since it was added. 
Commit cf394fc5f715 ("lib/genalloc.c: Add algorithm, align and zeroed
family of DMA allocators") moved that check into
gen_pool_dma_alloc_algo(), but gen_pool_dma_alloc() now reads pool->algo
and pool->data before calling it, so a NULL pool is dereferenced instead. 
gen_pool_dma_zalloc(), added by the same commit, has the same problem. 
The _algo() and _align() variants still return NULL.

All in-tree callers check the pool before calling, so this is not known to
be reachable today, but the four entry points disagree and the original
behaviour is easy to restore.  Check for a NULL pool before dereferencing
it.

Found by a KUnit test for lib/genalloc.c, which crashed in
gen_pool_dma_alloc(NULL, ...) on UML.  An AI coding assistant (Claude Opus
5.5) was used to write that test and this change; with it the test passes.

Link: https://lore.kernel.org/20261106-kunit-genalloc-v1-0-ba1ea397dfd8@gmail.com
Link: https://lore.kernel.org/20261106-kunit-genalloc-v1-1-ba1ea397dfd8@gmail.com
Fixes: cf394fc5f715 ("lib/genalloc.c: Add algorithm, align and zeroed family of DMA allocators")
Signed-off-by: Amit Patole <amit.patole@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Fredrik Noring <noring@nocrew.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <david@davidgow.net>
Cc: Rae Moar <raemoar63@gmail.com>
Cc: Fredrik Noring <fredrik.noring@gmail.com>
---

 lib/genalloc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/lib/genalloc.c~lib-genalloc-dont-dereference-a-null-pool-in-gen_pool_dma_alloc
+++ a/lib/genalloc.c
@@ -340,6 +340,9 @@ EXPORT_SYMBOL(gen_pool_alloc_algo_owner)
  */
 void *gen_pool_dma_alloc(struct gen_pool *pool, size_t size, dma_addr_t *dma)
 {
+	if (!pool)
+		return NULL;
+
 	return gen_pool_dma_alloc_algo(pool, size, dma, pool->algo, pool->data);
 }
 EXPORT_SYMBOL(gen_pool_dma_alloc);
@@ -418,6 +421,9 @@ EXPORT_SYMBOL(gen_pool_dma_alloc_align);
  */
 void *gen_pool_dma_zalloc(struct gen_pool *pool, size_t size, dma_addr_t *dma)
 {
+	if (!pool)
+		return NULL;
+
 	return gen_pool_dma_zalloc_algo(pool, size, dma, pool->algo, pool->data);
 }
 EXPORT_SYMBOL(gen_pool_dma_zalloc);
_

Patches currently in -mm which might be from amit.patole@gmail.com are

lib-genalloc-dont-dereference-a-null-pool-in-gen_pool_dma_alloc.patch
lib-tests-add-kunit-tests-for-genalloc.patch

