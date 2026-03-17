Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAAF343D66
	for <mm-commits@vger.kernel.org>; Tue, 17 Mar 2026 19:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773776534; cv=none; b=GnA02jQzucVh2J+t3hpkZVsOrK7waf1eTXq1UAeaW+g5xojmkA25xgsb+BLy+lCRr+TiUuwm27ET82fgf1RjYSMbgHjrlYXgUSeM6O8JLDJktmPMSYvb1frZv1TmEtf1vz7mgpsQ9FbhGR3iL6R3Osdx5IY5YLYy2vS4zCl+oyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773776534; c=relaxed/simple;
	bh=NaiUslxx5iAT7QUoePpVs2HnxDDtSrQGwonXSk1+CxM=;
	h=Date:To:From:Subject:Message-Id; b=loBQgZHr4nBclFekR+U7jDMLL7AR/Zb9rerL6bHLGIfDbbpTftDffkO5c7gKUIWO85/DcmLXL4UGEW6dj+f++Yfl45D/zL555RU3/QwulYdz2cPrzwbKV52pmigP3hKb/645PXYVowdgd8ytTue+XDjanehfg4cFZBqoXh4y+I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h44pyU2g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h44pyU2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E015EC2BC86;
	Tue, 17 Mar 2026 19:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773776534;
	bh=NaiUslxx5iAT7QUoePpVs2HnxDDtSrQGwonXSk1+CxM=;
	h=Date:To:From:Subject:From;
	b=h44pyU2gdtY1DUjsp3ENBiMaV0+V85Sxa5H+daC7VlpZByYyYH1bwlEstQdc9rZlS
	 9JlnqiEKeXZ5hQECVIdGb4IgYQ+Np/FAwTLSD0Uo5IcC3NH45fHi0cVADOj1X1wRdI
	 x925dqC1XXp9dILtDPEhnBbB+aOWORkx8FJVErw4=
Date: Tue, 17 Mar 2026 12:42:13 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,senozhatsky@chromium.org,nphamcs@gmail.com,kanchana.p.sridhar@intel.com,herbert@gondor.apana.org.au,hannes@cmpxchg.org,chengming.zhou@linux.dev,kanchanapsridhar2026@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-remove-redundant-checks-in-zswap_cpu_comp_dead.patch added to mm-new branch
Message-Id: <20260317194213.E015EC2BC86@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: remove redundant checks in zswap_cpu_comp_dead()
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-remove-redundant-checks-in-zswap_cpu_comp_dead.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-remove-redundant-checks-in-zswap_cpu_comp_dead.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Subject: mm: zswap: remove redundant checks in zswap_cpu_comp_dead()
Date: Mon, 16 Mar 2026 18:48:01 -0700

Patch series "zswap pool per-CPU acomp_ctx simplifications".

This patchset persists the zswap pool's per-CPU acomp_ctx resources to
last until the pool is destroyed. It then simplifies the per-CPU
acomp_ctx mutex locking in zswap_compress()/zswap_decompress().

Further, it consistently uses the same checks for valid
acomp_ctx->acomp/req in zswap procedures that allocate/deallocate
acomp_ctx members.

These are independent submissions of patches 23 and 24 from [1], to
facilitate merging. The Acks are preserved from [1].


This patch (of 2):

There are presently redundant checks on the per-CPU acomp_ctx and it's
"req" member in zswap_cpu_comp_dead(): redundant because they are
inconsistent with zswap_pool_create() handling of failure in allocating
the acomp_ctx, and with the expected NULL return value from the
acomp_request_alloc() API when it fails to allocate an acomp_req.

Fix these by converting them to be NULL checks.

Add comments in zswap_cpu_comp_prepare() clarifying the expected return
values of the crypto_alloc_acomp_node() and acomp_request_alloc() API.

Link: https://lkml.kernel.org/r/20260314051632.17931-1-kanchanapsridhar2026@gmail.com
Link: https://lkml.kernel.org/r/20260317014802.27591-2-kanchanapsridhar2026@gmail.com
Link: https://patchwork.kernel.org/project/linux-mm/list/?series=1046677 [1]
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-remove-redundant-checks-in-zswap_cpu_comp_dead
+++ a/mm/zswap.c
@@ -749,6 +749,10 @@ static int zswap_cpu_comp_prepare(unsign
 		goto fail;
 	}
 
+	/*
+	 * In case of an error, crypto_alloc_acomp_node() returns an
+	 * error pointer, never NULL.
+	 */
 	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
 	if (IS_ERR(acomp)) {
 		pr_err("could not alloc crypto acomp %s : %pe\n",
@@ -757,6 +761,7 @@ static int zswap_cpu_comp_prepare(unsign
 		goto fail;
 	}
 
+	/* acomp_request_alloc() returns NULL in case of an error. */
 	req = acomp_request_alloc(acomp);
 	if (!req) {
 		pr_err("could not alloc crypto acomp_request %s\n",
@@ -802,7 +807,7 @@ static int zswap_cpu_comp_dead(unsigned
 	struct crypto_acomp *acomp;
 	u8 *buffer;
 
-	if (IS_ERR_OR_NULL(acomp_ctx))
+	if (!acomp_ctx)
 		return 0;
 
 	mutex_lock(&acomp_ctx->mutex);
@@ -817,8 +822,11 @@ static int zswap_cpu_comp_dead(unsigned
 	/*
 	 * Do the actual freeing after releasing the mutex to avoid subtle
 	 * locking dependencies causing deadlocks.
+	 *
+	 * If there was an error in allocating @acomp_ctx->req, it
+	 * would be set to NULL.
 	 */
-	if (!IS_ERR_OR_NULL(req))
+	if (req)
 		acomp_request_free(req);
 	if (!IS_ERR_OR_NULL(acomp))
 		crypto_free_acomp(acomp);
_

Patches currently in -mm which might be from kanchanapsridhar2026@gmail.com are

mm-zswap-remove-redundant-checks-in-zswap_cpu_comp_dead.patch
mm-zswap-tie-per-cpu-acomp_ctx-lifetime-to-the-pool.patch

